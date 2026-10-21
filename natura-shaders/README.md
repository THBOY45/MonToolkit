# Natura Shaders 1.0

Shaderpack **Minecraft réaliste et naturel**, conçu pour **Iris (Fabric / NeoForge) sur Minecraft 1.21.x** (compatible OptiFine récent).

> Livré sur la branche `natura-shaders` de ce dépôt, dans le dossier `natura-shaders/`.

## Installation

1. Installer **Iris** (ou OptiFine) sur Minecraft 1.21.x.
2. Télécharger cette branche en **ZIP** (bouton *Code* → onglet branches → `natura-shaders` → *Download ZIP*), ou cloner la branche.
3. Créer un ZIP contenant le contenu du dossier `natura-shaders/` (le dossier `shaders/` doit être à la racine du ZIP) — ou simplement zipper le dossier `natura-shaders` renommé `Natura-Shaders-v1.0.zip`.
4. Placer le fichier ZIP **tel quel** (sans le décompresser) dans `.minecraft/shaderpacks/`.
5. Dans le jeu : *Options → Video Settings → Shader Packs* → sélectionner **Natura Shaders**.

## Caractéristiques

- **Ombres portées douces** (PCF, disque de Vogel), l'eau laisse passer la lumière du soleil.
- **Vagues d'eau** animées en vertex shader + **reflets en espace écran (SSR)** et étincelle spéculaire du soleil/lune.
- **Ciel procédural** : dégradé naturel, lueur chaude au lever/coucher, **voie lactée et étoiles scintillantes discrètes** la nuit.
- **Brouillard doux** raccordé au ciel (plus dense sous la pluie), brume bleutée sous l'eau.
- **Lumière dynamique** de l'objet tenu en main (torches, lanternes...).
- **Blocs émissifs** réalistes (glowstone, lava, torches...).
- **Post-traitement** : bloom doux, tonemapping ACES, vignettage léger.

## Réglages

Tout est ajustable dans le menu des shaders, avec trois profils : **Performant**, **Équilibré** (défaut, calibré GPU GTX/RX milieu de gamme) et **Qualité**.

## Structure

- `shaders/settings.glsl` — réglages (sliders)
- `shaders/lib/common.glsl` — uniformes, helpers, couleurs d'éclairage
- `shaders/lib/sky.glsl` — ciel, étoiles, ombres, brouillard, éclairage
- `shaders/gbuffers_*` — terrain, eau, entités, ciel, nuages...
- `shaders/composite*.glsl` — SSR et bloom
- `shaders/final.glsl` — tonemap + vignettage
- `block.properties` — IDs eau / blocs émissifs

Shaderpack fourni tel quel, à but personnel et éducatif.
