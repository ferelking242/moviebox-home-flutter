---
name: No python3/node by default
description: This repl had neither python3 nor node/npx on PATH out of the box.
---

Do not assume `python3` or `node`/`npx` are available for quick one-off tasks (e.g. serving a static build directory). Check with `which` first.

**How to apply:** if you need a tiny static file server and the project already has a Flutter/Dart SDK on PATH (see flutter-on-replit.md), write a ~30-line `dart:io` `HttpServer` script and run it with `dart run serve.dart` instead of reaching for python/node, which may need a fresh install.
