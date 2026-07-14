---
name: Flutter on Replit
description: How to get a working Flutter SDK in this environment when the nix package looks broken.
---

`nix-env -iA nixpkgs.flutter` / `flutterPackages.stable` resolves to a very old `flutter-2.2.1` derivation with a broken/missing build path — do not rely on it.

Manually downloading and untarring the official Flutter SDK archive into `/tmp` works as a stopgap, but `/tmp` is not durable — its contents can disappear between shell sessions (observed mid-session).

**What actually worked**: once a real Flutter project (with `pubspec.yaml`) exists in the repo, Replit's environment auto-detects it and installs a proper, current Flutter SDK (observed: 3.32.0) system-wide via nix, available directly as `flutter`/`dart` on PATH — no manual SDK management needed after that point.

**How to apply:** if asked to scaffold a Flutter app, just run `flutter create` (using whatever flutter binary is reachable, even a manually-extracted one) to produce the pubspec, then re-check `which flutter` — the environment will likely have installed its own working copy that supersedes any manual install.
