#version 120
#include "/settings.glsl"

// ============================================================
//  Final : bloom + tonemap ACES + vignettage léger
// ============================================================
uniform sampler2D colortex0, colortex2;
varying vec2 uv;

vec3 aces(vec3 x) {
    return clamp((x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14), 0.0, 1.0);
}

void main() {
    vec3 color = texture2D(colortex0, uv).rgb
               + texture2D(colortex2, uv).rgb * BLOOM_STRENGTH;

    color *= EXPOSURE;
    color = aces(color);

    // Vignettage doux
    float d = length(uv - 0.5) * 2.0;
    color *= 1.0 - VIGNETTE_STRENGTH * smoothstep(0.5, 1.4, d);

    gl_FragData[0] = vec4(color, 1.0);
}
