#version 120
#include "/settings.glsl"

// ============================================================
//  Soleil, lune et étoiles vanilla (textures) — rehaussés
// ============================================================
varying vec2 texcoord;
varying vec4 glcolor;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    gl_FragData[0] = vec4(albedo.rgb * 1.2, albedo.a);
}

/* DRAWBUFFERS:0 */
