#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

# Détection OS sans grep/uname : uniquement des builtins
detect_os() {
  # Git Bash (MSYS/MINGW) se signale souvent par MSYSTEM/OSTYPE
  if [[ -n "${MSYSTEM-}" ]] || [[ "${OSTYPE-}" == msys* || "${OSTYPE-}" == mingw* ]]; then
    echo "Git Bash (MSYS/MINGW)"
    return
  fi

  # WSL : on lit /proc/sys/kernel/osrelease (sans cat/grep)
  if [[ -r /proc/sys/kernel/osrelease ]]; then
    local osrel=""
    IFS= read -r osrel < /proc/sys/kernel/osrelease || true
    case "$osrel" in
      *[Mm]icrosoft*) echo "WSL"; return ;;
    esac
  fi

  # Par défaut
  echo "Linux/Unix"
}

# Détection du shell sans $SHELL/ps/awk
shell_name="bash"
shell_ver=""

if [[ -n "${BASH_VERSION-}" ]]; then
  shell_name="bash"
  shell_ver="bash ${BASH_VERSION}"
elif [[ -n "${ZSH_VERSION-}" ]]; then
  shell_name="zsh"
  shell_ver="zsh ${ZSH_VERSION}"
else
  # Fallback neutre (sans exécuter un binaire)
  shell_name="${SHELL##*/}"
  [[ -n "${shell_name}" ]] || shell_name="unknown"
  shell_ver=""
fi

# Host et user via variables d'env uniquement
host="${HOSTNAME-}"
[[ -n "${host}" ]] || host="${COMPUTERNAME-}"
[[ -n "${host}" ]] || host="host"

user="${USER-}"
[[ -n "${user}" ]] || user="user"

# CWD : builtin pwd
cwd="$(pwd)"

# Affichage
printf '%s\n' "────────────────────────────────────────────"
printf '🔎 Système : %s\n' "$(detect_os)"
printf '🖥️  Hôte    : %s\n' "${host}"
printf '👤  Utilisateur : %s\n' "${user}"
printf '🐚 Shell    : %s\n' "${shell_name}"
printf 'ℹ️  Version : %s\n' "${shell_ver}"
printf '📁 CWD      : %s\n' "${cwd}"
printf '%s\n' "────────────────────────────────────────────"
