#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Entités / blocs animés — même éclairage que le terrain
// ============================================================
varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vNormal, vPos;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;

    vec3 color = computeLighting(albedo.rgb, vNormal, vPos, lmcoord, 0.0);
    color = applyFog(color, vPos);

    gl_FragData[0] = vec4(color, albedo.a);
    gl_FragData[1] = vec4(vNormal * 0.5 + 0.5, 0.0);
}

/* DRAWBUFFERS:01 */
