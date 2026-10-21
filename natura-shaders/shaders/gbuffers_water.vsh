#version 120
#include "/settings.glsl"
#include "/lib/common.glsl"

// ============================================================
//  Eau & translucides — vagues en vertex shader
// ============================================================
attribute vec4 mc_Entity;

varying vec2 texcoord, lmcoord;
varying vec4 glcolor;
varying vec3 vNormal, vPos, wPos;
varying float emissionFlag;

void main() {
    vec4 vp = gl_ModelViewMatrix * gl_Vertex;
    wPos = (gbufferModelViewInverse * vp).xyz + cameraPosition;

    // Vagues : superposition de sinusoïdes (uniquement l'eau, ID 10001)
    if (mc_Entity.x == 10001.0) {
        float t = frameTimeCounter * WAVE_SPEED;
        float vague = sin(wPos.x * 0.60 + t * 1.2) * 0.050
                    + sin(wPos.z * 0.50 + t * 0.9) * 0.050
                    + sin((wPos.x + wPos.z) * 0.30 + t * 0.7) * 0.060;
        wPos.y += vague * WAVE_INTENSITY;
        vp = gbufferModelView * vec4(wPos - cameraPosition, 1.0);
    }

    gl_Position = gl_ProjectionMatrix * vp;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    glcolor  = gl_Color;
    vNormal  = normalize(gl_NormalMatrix * gl_Normal);
    vPos     = vp.xyz;
    emissionFlag = (mc_Entity.x == 10002.0) ? 1.0 : 0.0;
}
