#!/usr/bin/env bash
set -euo pipefail
# check_utf8_ci.sh — vérifie silencieusement que l'environnement est en UTF-8.
# Sortie: "✅ UTF-8 OK" ou "❌ UTF-8 NOT CONFIGURED"

if [[ "${LANG-}" == *"UTF-8"* || "${LC_ALL-}" == *"UTF-8"* ]]; then
  echo "✅ UTF-8 OK (LANG=${LANG:-unset} LC_ALL=${LC_ALL:-unset})"
  exit 0
else
  echo "❌ UTF-8 NOT CONFIGURED (LANG=${LANG:-unset} LC_ALL=${LC_ALL:-unset})"
  echo "    Add in your shell init: export LANG=C.UTF-8; export LC_ALL=C.UTF-8"
  exit 1
fi
