#version 120
#include "/settings.glsl"

// ============================================================
//  Flou gaussien du bloom — passe horizontale
// ============================================================
uniform sampler2D colortex2;
uniform float viewWidth;
varying vec2 uv;

void main() {
    vec3 somme = vec3(0.0);
    float sommePoids = 0.0;
    for (int i = -6; i <= 6; i++) {
        float x = float(i) / 6.0 * BLOOM_RADIUS * 2.0;
        float w = exp(-x * x * 0.5);
        somme += texture2D(colortex2, uv + vec2(x / viewWidth, 0.0)).rgb * w;
        sommePoids += w;
    }
    gl_FragData[0] = vec4(somme / sommePoids, 1.0);
}

/* DRAWBUFFERS:3 */
