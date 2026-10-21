#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Nuages vanilla — adoucis et teintés selon l'heure
// ============================================================
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 vPos;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.01) discard;

    float jour = smoothstep(0.0, 0.25, sunHeight());
    vec3 teinte = mix(vec3(0.10, 0.12, 0.20), vec3(1.0, 0.98, 0.95), jour);
    vec3 color = albedo.rgb * teinte * (getSkyAmbientColor() * 2.0 + 0.25);
    color = applyFog(color, vPos);

    gl_FragData[0] = vec4(color, albedo.a * 0.85);
}

/* DRAWBUFFERS:0 */
