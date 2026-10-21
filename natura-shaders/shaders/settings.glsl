#ifndef SETTINGS_GLSL
#define SETTINGS_GLSL

// ============================================================
//  Natura Shaders 1.0 — Réglages
//  Valeurs ajustables dans le menu "Options des shaders"
// ============================================================

// --- Eau ---
#define WAVE_INTENSITY 1.00  // [0.00 0.25 0.50 0.75 1.00 1.50 2.00]
#define WAVE_SPEED 1.00      // [0.25 0.50 1.00 1.50 2.00]
#define SSR_REFLECT 0.60     // [0.30 0.45 0.60 0.75 0.90]
#define SSR_STEPS 16         // [8 12 16 24 32]

// --- Ombres ---
#define SHADOW_PCF 4         // [1 2 4 8]
#define SHADOW_SOFTNESS 1.00 // [0.50 1.00 1.50 2.00]

// --- Post-traitement ---
#define BLOOM_STRENGTH 0.40 // [0.00 0.15 0.25 0.40 0.60 0.80]
#define BLOOM_RADIUS 4      // [2 4 6 8]
#define VIGNETTE_STRENGTH 0.25 // [0.00 0.15 0.25 0.40 0.60]
#define EXPOSURE 1.00       // [0.60 0.80 1.00 1.20 1.40]

// --- Atmosphère ---
#define FOG_DENSITY 1.00    // [0.50 0.75 1.00 1.25 1.50 2.00]
#define STAR_DENSITY 1.00   // [0.50 1.00 1.50 2.00]
#define MILKY_WAY 1         // [0 1]

// --- Éclairage ---
#define EMISSIVE_STRENGTH 1.00 // [0.00 0.50 1.00 1.50 2.00]
#define DYNAMIC_LIGHT 1     // [0 1]

#endif
