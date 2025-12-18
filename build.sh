#!/usr/bin/env bash
set -euo pipefail

luabundler bundle "src/ndk.lua" -p "?.lua" -o "build/ndk.lua"