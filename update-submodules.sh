#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ ! -f .gitmodules ]; then
  echo "Erro: .gitmodules nao encontrado em $(pwd)" >&2
  exit 1
fi

echo "==> Sincronizando URLs dos submodules"
git submodule sync --recursive

echo "==> Inicializando e atualizando submodules para o HEAD remoto da branch configurada"
git submodule update --init --remote --recursive

echo "==> Fazendo checkout da branch configurada (evita detached HEAD)"
git submodule foreach --recursive '
  branch=$(git config -f "$toplevel/.gitmodules" "submodule.$name.branch" || echo "main")
  echo "---"
  echo ">> $name (branch: $branch)"
  git fetch --prune origin "$branch"
  git checkout "$branch"
  git pull --ff-only origin "$branch"
'

echo
echo "==> Submodules atualizados. Status atual:"
git submodule status --recursive
