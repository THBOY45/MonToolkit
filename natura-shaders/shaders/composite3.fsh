#version 120
#include "/settings.glsl"

// ============================================================
//  Flou gaussien du bloom — passe verticale
// ============================================================
uniform sampler2D colortex3;
uniform float viewHeight;
varying vec2 uv;

void main() {
    vec3 somme = vec3(0.0);
    float sommePoids = 0.0;
    for (int i = -6; i <= 6; i++) {
        float y = float(i) / 6.0 * BLOOM_RADIUS * 2.0;
        float w = exp(-y * y * 0.5);
        somme += texture2D(colortex3, uv + vec2(0.0, y / viewHeight)).rgb * w;
        sommePoids += w;
    }
    gl_FragData[0] = vec4(somme / sommePoids, 1.0);
}

/* DRAWBUFFERS:2 */
