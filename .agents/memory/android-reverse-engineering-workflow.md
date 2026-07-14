---
name: Android APK decompile workflow
description: PATH quirk when using jadx/apktool installed via nix-env for APK reverse engineering.
---

`jadx` and `apktool` installed via `nix-env -iA nixpkgs.<pkg>` land in `~/.nix-profile/bin`, which is NOT on the default PATH for new shell invocations in this environment.

**How to apply:** run `export PATH="$HOME/.nix-profile/bin:$PATH"` at the start of any shell command that needs these tools (each `ShellExec` call is a fresh non-interactive shell, so this must be repeated per call unless chained in one command).
