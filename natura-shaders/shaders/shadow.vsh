#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

// ============================================================
//  Passe d'ombres : scène vue depuis le soleil
// ============================================================
varying vec2 texcoord;
varying vec4 glcolor;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    glcolor = gl_Color;
}
