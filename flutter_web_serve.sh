#!/usr/bin/env bash
cd "$(dirname "$0")/flutter/build/web"
python3 -m http.server 5000 --bind 0.0.0.0
