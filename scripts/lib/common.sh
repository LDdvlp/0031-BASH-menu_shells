#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
# shellcheck disable=SC2034
BLUE=$'\033[34m'
# shellcheck disable=SC2034
BOLD=$'\033[1m'


detect_env() {
  if grep -qi 'microsoft' /proc/version 2>/dev/null; then
    echo "WSL"
  elif [[ -n "${MSYSTEM-}" ]] || [[ "${OSTYPE-}" == msys* || "${OSTYPE-}" == mingw* ]]; then
    echo "MSYS/MINGW"
  else
    echo "Linux/Unix"
  fi
}

ok() { printf "%s✔%s %s\n" "$GREEN" "$RESET" "${1:-}"; }
warn(){ printf "%s!%s %s\n"   "$YELLOW" "$RESET" "${1:-}"; }
err() { printf "%s✘%s %s\n"   "$RED" "$RESET" "${1:-}"; }
