#ifndef SKY_GLSL
#define SKY_GLSL
#include "/lib/common.glsl"

// ============================================================
//  Natura Shaders — ciel, étoiles, brouillard, éclairage
// ============================================================

// --- Couleur du ciel pour une direction monde donnée ---
vec3 getSkyColor(vec3 dir) {
    float sh   = sunHeight();
    float jour = smoothstep(0.0, 0.25, sh);
    float nuit = 1.0 - smoothstep(-0.25, 0.05, sh);

    float h = clamp(dir.y, 0.0, 1.0);
    float horiz = pow(1.0 - h, 3.0);

    vec3 zenJour = vec3(0.10, 0.28, 0.68);
    vec3 horJour = vec3(0.60, 0.75, 0.92);
    vec3 zenNuit = vec3(0.003, 0.005, 0.012);
    vec3 horNuit = vec3(0.015, 0.020, 0.045);

    vec3 zen = mix(zenNuit, zenJour, jour);
    vec3 hor = mix(horNuit, horJour, jour);
    vec3 ciel = mix(zen, hor, horiz);

    // Lueur chaude du lever / coucher autour du soleil
    float dusk = smoothstep(-0.15, 0.05, sh) * (1.0 - smoothstep(0.05, 0.30, sh));
    float sunDot = max(dot(dir, getSunDirWorld()), 0.0);
    ciel += vec3(1.0, 0.35, 0.12) * dusk * pow(sunDot, 4.0) * (0.5 + 0.5 * horiz);

    // Pluie : ciel gris et terne
    ciel = mix(ciel, vec3(0.30, 0.33, 0.37) * (0.25 + 0.75 * jour), rainStrength * 0.9);
    return ciel;
}

// --- Étoiles + Voie lactée discrète (nuit) ---
vec3 addStars(vec3 color, vec3 dir) {
    float nuit = 1.0 - smoothstep(-0.20, 0.05, sunHeight());
    if (nuit <= 0.001 || dir.y <= 0.0) return color;
    nuit *= 1.0 - rainStrength;

    // Étoiles ponctuelles sur une grille de cellules
    vec3 p = dir * 140.0;
    vec3 cell = floor(p);
    vec3 local = fract(p) - 0.5;
    float rnd = hash13(cell);
    float seuil = 1.0 - 0.0025 * STAR_DENSITY;
    float etoile = smoothstep(0.28, 0.0, length(local)) * step(seuil, rnd);
    float scintillement = 0.6 + 0.4 * sin(frameTimeCounter * 3.0 + rnd * 40.0);

    // Voie lactée : bande diffuse traversant le ciel
    vec3 axeBande = normalize(vec3(0.6, 0.35, 0.7));
    float bande = exp(-pow(abs(dot(dir, axeBande)) * 4.0, 2.0));
    float bruitMW = 0.35 + 0.65 * hash13(floor(dir * 60.0));

    vec3 contribution = vec3(0.9, 0.95, 1.1) * etoile * scintillement * 1.2;
#if MILKY_WAY
    contribution += vec3(0.05, 0.06, 0.10) * bande * bruitMW * 0.8;
#endif
    return color + contribution * nuit;
}

// --- Échantillonnage de la shadow map (ombres douces, disque de Vogel) ---
float getShadow(vec3 worldPos, vec3 worldNormal) {
    vec3 rel = worldPos - cameraPosition;
    vec4 sp = shadowProjection * (shadowModelView * vec4(rel, 1.0));
    vec3 p = sp.xyz * 0.5 + 0.5;
    if (p.z >= 1.0 || p.x < 0.0 || p.x > 1.0 || p.y < 0.0 || p.y > 1.0) return 1.0;

    // Biais dépendant de l'angle pour éviter l'acné d'ombre
    float bias = 0.0006 + 0.0009 * (1.0 - clamp(dot(worldNormal, getLightDirWorld()), 0.0, 1.0));

    // Disque de Vogel tourné aléatoirement par pixel
    float rot = hash12(gl_FragCoord.xy) * 6.28318;
    float rayonUV = 1.5 * SHADOW_SOFTNESS * 4.0 / float(shadowMapResolution);
    float s0 = 0.0; // shadowtex0 : blocs opaques
    float s1 = 0.0; // shadowtex1 : inclut les translucides

    for (int i = 0; i < SHADOW_PCF; i++) {
        float ang = 6.28318 * (float(i) + 0.5) / float(SHADOW_PCF) + rot;
        float rad = sqrt((float(i) + 0.5) / float(SHADOW_PCF)) * rayonUV;
        vec2 o = vec2(cos(ang), sin(ang)) * rad;
        s0 += step(p.z - bias, texture2D(shadowtex0, p.xy + o).z);
        s1 += step(p.z - bias, texture2D(shadowtex1, p.xy + o).z);
    }
    s0 /= float(SHADOW_PCF);
    s1 /= float(SHADOW_PCF);

    // L'eau laisse passer 55 % de la lumière du soleil
    return s0 + (s1 - s0) * 0.55;
}

// --- Éclairage complet d'un fragment ---
vec3 computeLighting(vec3 albedo, vec3 vNormal, vec3 vPos, vec2 lm, float emission) {
    vec3 wNormal = viewToWorldDir(vNormal);
    vec3 worldPos = (gbufferModelViewInverse * vec4(vPos, 1.0)).xyz + cameraPosition;

    // Soleil / lune (shadowLightPosition bascule automatiquement)
    vec3 lightDirW = getLightDirWorld();
    float NdotL = dot(wNormal, lightDirW);
    vec3 direct = vec3(0.0);
    if (NdotL > 0.0) {
        float sh = getShadow(worldPos, wNormal);
        direct = getSunlightColor() * NdotL * sh * (1.0 - rainStrength * 0.8);
    }

    // Lumière ambiante du ciel + lumière de bloc + lumière en main
    vec3 ambient = getSkyAmbientColor() * (lm.y * lm.y) + vec3(0.012);
    vec3 blockL  = getBlockLightColor() * pow(lm.x, 2.0);
    vec3 heldL   = getBlockLightColor() * getHeldLight(vPos) * 1.5;

    vec3 color = albedo * (direct + ambient + blockL + heldL);

    // Blocs émissifs (glowstone, lava, torches...) : ID 10002 dans block.properties
    color += albedo * emission * EMISSIVE_STRENGTH * 2.5;
    return color;
}

// --- Brouillard doux raccordé au ciel ---
vec3 applyFog(vec3 color, vec3 viewPos) {
    float dist = length(viewPos);
    vec3 dir = viewToWorldDir(viewPos);

    if (isEyeInWater == 1) { // sous l'eau
        float f = 1.0 - exp(-dist * 0.06 * FOG_DENSITY);
        return mix(color, vec3(0.02, 0.09, 0.13) * clamp(sunHeight() + 0.4, 0.1, 1.0), f);
    }
    if (isEyeInWater == 2) { // dans la lave
        return mix(color, vec3(0.6, 0.2, 0.05), 1.0 - exp(-dist * 1.5));
    }

    vec3 brume = getSkyColor(dir);
    float f = 1.0 - exp(-pow(dist / (far * 0.75), 2.2) * (FOG_DENSITY * (1.0 + rainStrength * 2.0)));
    return mix(color, brume, clamp(f, 0.0, 1.0));
}

#endif
