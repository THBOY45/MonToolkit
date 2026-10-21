#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Eau & translucides — éclairage + masque pour les reflets
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vNormal, vPos, wPos;
varying float emissionFlag;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.05) discard;

    // Normale légèrement perturbée par les vagues (pour le SSR)
    float t = frameTimeCounter * WAVE_SPEED;
    vec3 n = vNormal;
    n.x += 0.06 * WAVE_INTENSITY * cos(wPos.x * 0.60 + t * 1.2);
    n.z += 0.06 * WAVE_INTENSITY * cos(wPos.z * 0.50 + t * 0.9);
    n = normalize(n);

    vec3 color = computeLighting(albedo.rgb, n, vPos, lmcoord, emissionFlag);
    color = applyFog(color, vPos);

    gl_FragData[0] = vec4(color, albedo.a * 0.85);
    // colortex1 : normale perturbée + masque 1 = eau (pour le SSR)
    gl_FragData[1] = vec4(n * 0.5 + 0.5, 1.0);
}

/* DRAWBUFFERS:01 */
