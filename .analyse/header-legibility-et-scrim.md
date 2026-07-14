# Analyse — Écran d'accueil MovieBox

Analyse basée sur la décompilation de l'APK MovieBox (apktool + jadx) et sur 3 captures d'écran de l'accueil (carrousel "Coupe du Monde", carrousel "Rejoignez-nous", carrousel "Anime").

## 1. Pourquoi la barre d'onglets ("FightZone / World Cup / Tendance / Film / TV...") reste lisible sur des bannières très claires

Ce n'est **pas** un motif de petits points ni une texture dédiée : aucun drawable de type "dot pattern / noise" n'existe dans les ressources décompilées à cet endroit (seuls des points liés à des indicateurs d'onboarding et à des badges de notification existent ailleurs, sans rapport).

Le vrai mécanisme, visible sur les captures :

- Un **scrim en dégradé** (noir → transparent, aplati sur les ~120–150dp du haut de l'écran) est posé **au-dessus** du carrousel plein écran et **en dessous** de la barre de statut / barre de recherche / barre d'onglets. Comparez la capture "Rejoignez-nous" (fond blanc quasi pur) : le haut de l'image reste malgré tout légèrement assombri sur la zone de la statusbar/onglets, alors que le reste de la bannière garde ses couleurs vives.
- Ce dégradé est probablement dessiné avec un léger **bruit/dithering** (technique standard pour éviter le banding d'un gradient sur de grandes surfaces) — c'est vraisemblablement ce bruit que vous percevez comme "petits points". Je n'ai pas retrouvé d'asset dédié à ce bruit dans les resources décompilées ; il est possible qu'il soit appliqué au moment du rendu (shader) plutôt que via un PNG statique, ou qu'il soit simplement une caractéristique de compression de la capture d'écran. À prendre avec cette réserve.
- L'onglet actif ("Tendance", "World Cup") a en plus un **fond plein** (pilule vert/jaune) qui garantit sa lisibilité indépendamment du scrim — sécurité supplémentaire pour l'onglet sélectionné.
- Le texte des onglets non sélectionnés est en blanc avec une légère ombre portée (`elevation`/`shadow` sur le TextView), ce qui renforce le contraste sur les zones claires même quand le scrim est fin.

**Reproduction Flutter retenue** (voir `flutter/lib/`) : `Container` avec `LinearGradient` (noir à ~45% d'opacité en haut → transparent) posé en `Stack` par-dessus le `PageView` du carrousel, sous la ligne d'onglets. Pas de texture dédiée : le dégradé + l'ombre de texte + la pilule de l'onglet actif suffisent à reproduire l'effet perçu.

## 2. Le dégradé de couleur qui "déborde" sous la barre de statut

Sur les 3 captures, la couleur dominante de la bannière du moment (orange/rose pour "Rejoignez-nous", blanc pour le carrousel FIFA, brun/rouge sombre pour le carrousel Anime) se retrouve légèrement teintée jusque dans la zone de la statusbar. Il ne s'agit pas d'une couleur dynamique calculée côté client (aucune extraction de couleur dominante trouvée dans le code décompilé à cet endroit) : le plus probable, au vu de la structure des vues (`fragment_home.xml`), est que **l'image de bannière elle-même s'étend en plein écran sous la statusbar** (`fitsSystemWindows=false`, `translucent status bar`), et c'est donc directement le contenu de l'image serveur qui "colore" la zone — combiné au même scrim sombre décrit au point 1, qui s'applique uniformément quelle que soit la couleur de la bannière.

**Reproduction Flutter retenue** : `SafeArea` désactivée en haut (`top: false`) pour le carrousel + `SystemUiOverlayStyle` en `light` (icônes de statusbar blanches) + le même scrim en dégradé qui court derrière la statusbar.

## Limites de cette analyse

- Basée sur l'inspection statique des layouts XML et du code Kotlin décompilé, pas sur une instrumentation à l'exécution (pas de dump de vues live ni de profiling GPU) : impossible de confirmer à 100% si le bruit visuel vient d'un shader, d'un asset, ou de la compression JPEG de la capture.
- Aucune source ni resource brute de MovieBox n'est incluse dans ce dépôt (uniquement cette analyse écrite), pour respecter les droits du code/assets propriétaires de l'application.
