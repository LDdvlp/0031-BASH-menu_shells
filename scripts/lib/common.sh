#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

# --- palette de base (neutre)
RESET=$'\033[0m'
# shellcheck disable=SC2034
BOLD=$'\033[1m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
# shellcheck disable=SC2034
BLUE=$'\033[34m'

CONFIG_DIR="${HOME}/.menu-shells"
CONFIG_FILE="${CONFIG_DIR}/config"

load_theme() {
  local theme="dark"
  if [[ -r "${CONFIG_FILE}" ]]; then
    # shellcheck disable=SC1090
    . "${CONFIG_FILE}"
    theme="${THEME:-dark}"
  fi

  if [[ "${theme}" == "light" ]]; then
    # Couleurs lisibles sur fond clair
    GREEN=$'\033[32m'
    YELLOW=$'\033[33m'
    RED=$'\033[31m'
    # shellcheck disable=SC2034
    BLUE=$'\033[34m'

  else
    # Couleurs pour fond sombre (un peu plus vives ; on garde les mêmes codes simples)
    GREEN=$'\033[32m'
    YELLOW=$'\033[33m'
    RED=$'\033[31m'
    # shellcheck disable=SC2034
    BLUE=$'\033[34m'

  fi
}

save_theme() {
  mkdir -p "${CONFIG_DIR}"
  printf 'THEME=%s\n' "${1}" > "${CONFIG_FILE}"
}

detect_env() {
  # Permet aux tests/CI de forcer l'environnement simulé
  if [[ -n "${MENU_SHELLS_FORCE_ENV-}" ]]; then
    echo "${MENU_SHELLS_FORCE_ENV}"
    return
  fi

  if grep -qi 'microsoft' /proc/version 2>/dev/null; then
    echo "WSL"
  elif [[ -n "${MSYSTEM-}" ]] || [[ "${OSTYPE-}" == msys* || "${OSTYPE-}" == mingw* ]]; then
    echo "MSYS/MINGW"
  else
    echo "Linux/Unix"
  fi
}


ok()   { printf "%s✔%s %s\n" "$GREEN"  "$RESET" "${1:-}"; }
warn() { printf "%s!%s %s\n"  "$YELLOW" "$RESET" "${1:-}"; }
err()  { printf "%s✘%s %s\n"  "$RED"    "$RESET" "${1:-}"; }
