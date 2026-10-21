#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

varying vec3 vPos;
varying vec4 glcolor;

void main() {
    gl_Position = ftransform();
    vPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    glcolor = gl_Color;
}
