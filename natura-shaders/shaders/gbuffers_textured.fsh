#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Textures simples — éclairage doux sans shadow map
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vPos;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;

    vec3 light = getSkyAmbientColor() * (lmcoord.y * lmcoord.y)
               + getBlockLightColor() * pow(lmcoord.x, 2.0)
               + getBlockLightColor() * getHeldLight(vPos) * 1.5
               + vec3(0.02);

    vec3 color = albedo.rgb * light;
    color = applyFog(color, vPos);

    gl_FragData[0] = vec4(color, albedo.a);
}

/* DRAWBUFFERS:0 */
