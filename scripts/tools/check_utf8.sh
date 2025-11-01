#!/usr/bin/env bash
set -euo pipefail
# ------------------------------------------------------------
# check_utf8_ci.sh
# Vérifie silencieusement que l'environnement est bien en UTF-8.
# Sortie colorée (✅ vert ou ❌ rouge), compatible CI et Git Bash.
# ------------------------------------------------------------

ESC="$(printf '\033')"
GREEN="${ESC}[0;32m"
RED="${ESC}[0;31m"
RESET="${ESC}[0m"

# Détection UTF-8
if [[ "${LANG-}" == *"UTF-8"* || "${LC_ALL-}" == *"UTF-8"* ]]; then
  printf "✅ ${GREEN}UTF-8 OK${RESET} (LANG=%s LC_ALL=%s)\n" "${LANG:-unset}" "${LC_ALL:-unset}"
  exit 0
else
  printf "❌ ${RED}UTF-8 NOT CONFIGURED${RESET} (LANG=%s LC_ALL=%s)\n" "${LANG:-unset}" "${LC_ALL:-unset}"
  printf "   Add to your shell init file (e.g. ~/.bashrc):\n"
  printf "     export LANG=C.UTF-8\n"
  printf "     export LC_ALL=C.UTF-8\n"
  exit 1
fi
