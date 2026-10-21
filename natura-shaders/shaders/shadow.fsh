#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

varying vec2 texcoord;
varying vec4 glcolor;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;
    gl_FragData[0] = albedo; // couleurs d'ombre (shadowcolor0)
}
