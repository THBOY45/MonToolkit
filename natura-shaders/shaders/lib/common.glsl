#ifndef COMMON_GLSL
#define COMMON_GLSL

// ============================================================
//  Natura Shaders — bibliothèque commune : uniformes & helpers
// ============================================================

// --- Constantes du pipeline d'ombres ---
const int shadowMapResolution = 2048;   // résolution de la shadow map
const float shadowDistance = 128.0;     // distance de rendu des ombres
const float sunPathRotation = -15.0;    // inclinaison de l'orbite du soleil

// --- Uniformes fournis par Iris / OptiFine ---
uniform mat4 gbufferModelView, gbufferModelViewInverse;
uniform mat4 gbufferProjection, gbufferProjectionInverse;
uniform mat4 shadowModelView, shadowProjection;
uniform vec3 cameraPosition, sunPosition, moonPosition, shadowLightPosition, upPosition;
uniform float frameTimeCounter, rainStrength, viewWidth, viewHeight, far;
uniform int isEyeInWater, heldBlockLightValue, heldBlockLightValue2;
uniform vec3 fogColor;
uniform sampler2D lightmap, normals, specular;
uniform sampler2D shadowtex0, shadowtex1, shadowcolor0;

// --- Conversions espace vue <-> espace monde ---
mat3 mvInv3() {
    return mat3(gbufferModelViewInverse[0].xyz,
                gbufferModelViewInverse[1].xyz,
                gbufferModelViewInverse[2].xyz);
}
vec3 viewToWorldDir(vec3 v) { return normalize(mvInv3() * v); }

vec3 getSunDirWorld()    { return viewToWorldDir(sunPosition); }
vec3 getLightDirWorld() { return viewToWorldDir(shadowLightPosition); }
float sunHeight()       { return getSunDirWorld().y; }

// --- Bruit déterministe ---
float hash12(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}
float hash13(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898, 78.233, 37.719))) * 43758.5453);
}

// --- Couleurs de l'éclairage ---
vec3 getSunlightColor() {
    float sh = sunHeight();
    vec3 jour     = vec3(1.00, 0.97, 0.92) * 1.20;
    vec3 couchant = vec3(1.00, 0.55, 0.28) * 0.90;
    vec3 nuit     = vec3(0.10, 0.13, 0.22) * 0.35; // lumière lunaire
    vec3 c = mix(couchant, jour, smoothstep(0.05, 0.35, sh));
    c = mix(nuit, c, smoothstep(-0.25, 0.0, sh));
    return c * (1.0 - rainStrength * 0.85);
}
vec3 getSkyAmbientColor() {
    float sh = sunHeight();
    vec3 jour = vec3(0.45, 0.56, 0.75) * 0.55;
    vec3 nuit = vec3(0.04, 0.05, 0.09) * 0.6;
    vec3 c = mix(nuit, jour, smoothstep(-0.15, 0.15, sh));
    return c * (1.0 - rainStrength * 0.55);
}
vec3 getBlockLightColor() { return vec3(1.00, 0.60, 0.35) * 1.4; }

// --- Lumière portée par l'objet tenu en main (torche, etc.) ---
float getHeldLight(vec3 viewPos) {
#if DYNAMIC_LIGHT
    float hl = float(max(heldBlockLightValue, heldBlockLightValue2)) / 15.0;
    float d = length(viewPos);
    float rayon = hl * 12.0 + 0.001;
    return pow(clamp(1.0 - d / rayon, 0.0, 1.0), 2.0) * hl;
#else
    return 0.0;
#endif
}

#endif
