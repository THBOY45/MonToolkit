#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Composite : reflets en espace écran (SSR) sur l'eau
// ============================================================
uniform sampler2D colortex0, colortex1;
uniform sampler2D depthtex0;
varying vec2 uv;

// Marche le long du rayon réfléchi dans le tampon de profondeur
bool rayTrace(vec3 origine, vec3 dir, out vec2 hitUV) {
    float pas = 0.35;
    vec3 pos = origine + dir * 0.4;
    for (int i = 0; i < SSR_STEPS; i++) {
        pos += dir * pas;
        pas *= 1.15;
        vec4 clip = gbufferProjection * vec4(pos, 1.0);
        vec3 ndc = clip.xyz / clip.w * 0.5 + 0.5;
        if (ndc.x < 0.0 || ndc.x > 1.0 || ndc.y < 0.0 || ndc.y > 1.0 || ndc.z > 1.0) return false;
        float profondeur = texture2D(depthtex0, ndc.xy).x;
        if (profondeur < 0.9999 && ndc.z < profondeur - 0.00012) {
            hitUV = ndc.xy;
            return true;
        }
    }
    return false;
}

void main() {
    vec3 color = texture2D(colortex0, uv).rgb;
    vec4 data = texture2D(colortex1, uv);
    float depth = texture2D(depthtex0, uv).x;

    if (data.a > 0.5 && depth < 1.0) {
        vec3 normale = normalize(data.xyz * 2.0 - 1.0);

        // Reconstruction de la position en espace vue
        vec3 ndc = vec3(uv, depth) * 2.0 - 1.0;
        vec4 vp = gbufferProjectionInverse * vec4(ndc, 1.0);
        vec3 viewPos = vp.xyz / vp.w;

        vec3 rayon = reflect(normalize(viewPos), normale);

        // Par défaut le ciel ; si intersection, la scène
        vec3 reflet = getSkyColor(viewToWorldDir(rayon));
        vec2 hitUV;
        if (rayTrace(viewPos, rayon, hitUV)) reflet = texture2D(colortex0, hitUV).rgb;

        float fresnel = SSR_REFLECT
            + (1.0 - SSR_REFLECT) * pow(clamp(1.0 - dot(normale, -normalize(viewPos)), 0.0, 1.0), 5.0);

        // Étincelle du soleil / de la lune sur l'eau
        vec3 dirRefletW = viewToWorldDir(rayon);
        float spec = pow(max(dot(dirRefletW, getLightDirWorld()), 0.0), 200.0);

        color = mix(color, reflet, fresnel) + getSunlightColor() * spec * (1.0 - rainStrength * 0.9) * 0.8;
    }

    gl_FragData[0] = vec4(color, 1.0);
}

/* DRAWBUFFERS:0 */
