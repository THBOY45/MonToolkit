#version 120
#include "/settings.glsl"
#include "/lib/sky.glsl"

// ============================================================
//  Ciel procédural : dégradé, lueur du couchant, étoiles,
//  Voie lactée discrète. Soleil et lune restent vanilla.
// ============================================================
varying vec3 vPos;
varying vec4 glcolor;

uniform int renderStage;
#ifndef MC_RENDER_STAGE_SKY
#define MC_RENDER_STAGE_SKY 6
#endif

void main() {
    vec3 color;
    if (renderStage == MC_RENDER_STAGE_SKY) {
        vec3 dir = viewToWorldDir(normalize(vPos));
        color = getSkyColor(dir);
        color = addStars(color, dir);
    } else {
        color = glcolor.rgb; // plan du vide, halo d'aube vanilla
    }
    gl_FragData[0] = vec4(color, 1.0);
}

/* DRAWBUFFERS:0 */
