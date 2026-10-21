#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

// ============================================================
//  Vertex textures simples (particules, pluie...)
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vPos;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    glcolor  = gl_Color;
    vPos     = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
