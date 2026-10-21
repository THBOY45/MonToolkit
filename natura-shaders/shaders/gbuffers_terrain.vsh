#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

// ============================================================
//  Vertex shader des gbuffers (terrain)
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vNormal, vPos;
varying float emissionFlag;

attribute vec4 mc_Entity;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    glcolor  = gl_Color;
    vNormal  = normalize(gl_NormalMatrix * gl_Normal);
    vPos     = (gl_ModelViewMatrix * gl_Vertex).xyz;
    emissionFlag = (mc_Entity.x == 10002.0) ? 1.0 : 0.0;
}
