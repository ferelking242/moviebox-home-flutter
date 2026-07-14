# MovieBox — Analyse & reproduction Flutter de l'écran d'accueil

Ce dépôt contient :

- **`.analyse/`** — analyse écrite (design/UX) de l'écran d'accueil de l'application MovieBox, basée sur la rétro-ingénierie de son APK (apktool + jadx) et sur des captures d'écran. Aucune ressource ni code source brut de MovieBox n'est inclus — uniquement des notes et conclusions.
- **`flutter/`** — un projet Flutter original qui reproduit cet écran d'accueil (carrousel plein écran, halo flouté, scrim de lisibilité derrière les onglets, barre de recherche, sections FIFA/Catégories/Classements, barre de navigation).

## Lancer le projet Flutter en local

```bash
cd flutter
flutter pub get
flutter run -d chrome
```

## Déploiement

Un workflow GitHub Actions (`.github/workflows/deploy.yml`) construit automatiquement la version web à chaque push sur `main` et la publie sur GitHub Pages.
