#!/usr/bin/env bash
# Claude 앱(claude.ai) 계정 스킬로 올릴 zip을 스킬별로 만든다.
# 사용: ./scripts/package-for-claude-app.sh  → dist/<skill>.zip
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf dist && mkdir -p dist
for dir in skills/*/; do
  name="$(basename "$dir")"
  (cd skills && zip -qr "../dist/${name}.zip" "$name")
  echo "dist/${name}.zip"
done
