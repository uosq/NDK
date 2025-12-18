#!/usr/bin/env bash
set -euo pipefail

luabundler bundle "src/main.lua" -p "?.lua" -o "build/ndk.lua"