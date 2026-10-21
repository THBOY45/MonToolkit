#version 120
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 vPos;
void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    glcolor = gl_Color;
    vPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
