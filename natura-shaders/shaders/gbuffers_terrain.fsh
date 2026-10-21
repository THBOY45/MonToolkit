#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Terrain (blocs opaques) — éclairage + brouillard
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vNormal, vPos;
varying float emissionFlag;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;

    vec3 color = computeLighting(albedo.rgb, vNormal, vPos, lmcoord, emissionFlag);
    color = applyFog(color, vPos);

    gl_FragData[0] = vec4(color, 1.0);
    // colortex1 : normale en espace vue + masque (0 = opaque) pour le SSR
    gl_FragData[1] = vec4(vNormal * 0.5 + 0.5, 0.0);
}

/* DRAWBUFFERS:01 */
