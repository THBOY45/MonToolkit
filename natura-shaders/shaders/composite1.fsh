#version 120
#include "/settings.glsl"

// ============================================================
//  Extraction des zones lumineuses (pré-bloom)
// ============================================================
uniform sampler2D colortex0;
varying vec2 uv;

void main() {
    vec3 c = texture2D(colortex0, uv).rgb;
    float l = dot(c, vec3(0.2126, 0.7152, 0.0722));
    vec3 brillant = c * clamp((l - 0.65) / 0.35, 0.0, 1.0);
    gl_FragData[0] = vec4(brillant, 1.0);
}

/* DRAWBUFFERS:2 */
