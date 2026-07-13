#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ProjetoEntregador/sophia.git"
APP_DIR="$HOME/sophia"

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
fi

docker network inspect net1 >/dev/null 2>&1 || docker network create net1

[ -d "$APP_DIR/.git" ] || git clone --branch develop --recurse-submodules "$REPO_URL" "$APP_DIR"

chmod 777 "$APP_DIR"/sophia-*/logs 2>/dev/null || true
