---
name: android-reverse-engineering
description: Decompile Android APK/XAPK/JAR/AAR files using jadx and/or apktool to inspect real layout XML, resource values (colors, dimens, drawables, anim XML) and decompiled Java/Kotlin source. Use when the user wants to reproduce/clone a UI effect or design seen in an Android app "exactly", extract API endpoints, or understand how a native Android screen/widget is built under the hood. Adapted from https://github.com/SimoneAvogadro/android-reverse-engineering-skill (Apache-2.0) for the Replit shell environment (no Claude Code plugin runtime here).
---

# Android Reverse Engineering (Replit adaptation)

Decompile a native Android APK to get ground-truth design values (exact colors, dp sizes, layout structure, animation curves) instead of guessing from a screenshot. Only works for **native Java/Kotlin** apps — Flutter/React Native/Cordova/Xamarin apps compile their UI away and have no readable layout XML.

## Tooling (already available via nix in this environment)

```bash
nix-env -iA nixpkgs.jadx nixpkgs.apktool   # once per session/container; installs to ~/.nix-profile/bin
export PATH="$HOME/.nix-profile/bin:$PATH" # nix-env installs don't land on PATH automatically
```

## Workflow

1. **Get the APK.** Download from a URL the user provides, or ask for the file. Just fetching/unzipping a static APK for inspection is safe (no code execution); never `adb install` or run untrusted APKs.
2. **Fingerprint first** — `unzip -l app.apk | grep -i libapp.so` (Flutter marker) or check for `assets/flutter_assets/` before spending time decompiling. If it's Flutter/RN, jadx output is useless; there's no layout XML to read.
3. **`apktool d -f -o out_dir app.apk`** → gives real `res/layout/*.xml` (exact ConstraintLayout structure, dp margins/paddings, view IDs), `res/values/*.xml` (colors.xml, dimens.xml hex values), `res/anim/*` and `res/drawable/*` (including `AnimatedVectorDrawable` XML with exact animation curves/durations).
4. **`jadx -d out_dir --no-res -e app.apk`** (`--no-res` avoids apktool-style resource decoding jadx already struggles with; use apktool for resources) → gives decompiled Java/Kotlin source. Use this to find custom View classes referenced from layout XML (e.g. a custom `onDraw` doing a blur/glow effect) — grep the class name from the XML tag, then read its source under `src/main/java/...`.
5. Cross-reference: layout XML tells you *structure and static values*; decompiled source tells you *dynamic/paint effects* (blur radii, colors computed at runtime, animator curves) that XML alone won't show.

## Notes

- Large APKs can take minutes to decompile; `--no-res` on jadx speeds this up when you only need source, not resources.
- jadx frequently reports partial codegen errors on huge multi-dex apps (kotlinx internals, etc.) — this is normal noise; the classes you actually care about (app-specific custom views/screens) usually decompile fine even when the error count is high.
- This is for personal design/API research (matching a UI pattern, understanding an approach) — don't redistribute extracted proprietary assets or source.
