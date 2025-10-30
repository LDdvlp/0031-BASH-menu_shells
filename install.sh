#!/usr/bin/env bash
# Installation du projet Menu Shells
# - Sécurisée: errexit, pipefail, nounset
# - Normalisation LF (compatible Git Bash/WSL)
# - Idempotente: hooks RC créés/ajustés proprement

set -o errexit -o pipefail -o nounset

# ---------------------------
# Utils
# ---------------------------
say()  { printf '%s\n' "${1:-}"; }
ok()   { printf '✔ %s\n' "${1:-}"; }
warn() { printf '! %s\n' "${1:-}"; }
err()  { printf '✘ %s\n' "${1:-}" 1>&2; }

# Normalise les fins de ligne en LF, sans dépendances externes
normalize_unix() {
  # $1 = chemin du fichier
  [ -f "$1" ] || return 0
  # Supprime \r en fin de ligne (CRLF -> LF) et garantit un \n final
  # Implémentation en Bash pur (lecture/écriture)
  tmp="${1}.tmp.$$"
  # shellcheck disable=SC2162
  while IFS= read -r line || [ -n "$line" ]; do
    # retire un CR final éventuel
    case "$line" in
      *$'\r') line="${line%$'\r'}" ;;
    esac
    printf '%s\n' "$line" >> "$tmp"
  done < "$1"
  mv "$tmp" "$1"
}

# Remplace/insère un bloc délimité par des marqueurs dans un fichier RC
# Idempotent, crée le fichier s'il n'existe pas
ensure_hook_in_rc() {
  # $1 = fichier RC (ex: ~/.bashrc)
  # $2 = ligne absolue vers scripts/shell_select.sh
  rc_file="${1}"
  hook_line="${2}"

  begin="# >>> menu-shells >>>"
  end="# <<< menu-shells <<<"

  # Crée le fichier s'il n'existe pas
  [ -f "${rc_file}" ] || : > "${rc_file}"

  # Lit et réécrit le fichier en remplaçant le bloc existant si présent
  tmp="${rc_file}.tmp.$$"
  inblock=0
  seen_block=0

  # shellcheck disable=SC2162
  while IFS= read -r line || [ -n "$line" ]; do
    if [ "$inblock" -eq 1 ]; then
      # On est dans l'ancien bloc: on ignore jusqu'au marqueur de fin
      if [ "$line" = "$end" ]; then
        # Écrit le nouveau bloc puis le marqueur de fin
        printf '%s\n' "$begin" >> "$tmp"
        printf 'if [ -f %q ]; then\n' "$hook_line" >> "$tmp"
        printf '. %q\n' "$hook_line" >> "$tmp"
        printf 'fi\n' >> "$tmp"
        printf '%s\n' "$end" >> "$tmp"
        inblock=0
        seen_block=1
      fi
      continue
    fi

    if [ "$line" = "$begin" ]; then
      # Entrée dans un bloc existant
      inblock=1
      continue
    fi

    # Copie la ligne telle quelle
    printf '%s\n' "$line" >> "$tmp"
  done < "${rc_file}"

  if [ "$seen_block" -eq 0 ]; then
    # Aucun bloc existant: on l'ajoute en fin de fichier
    printf '\n%s\n' "$begin" >> "$tmp"
    printf 'if [ -f %q ]; then\n' "$hook_line" >> "$tmp"
    printf '. %q\n' "$hook_line" >> "$tmp"
    printf 'fi\n' >> "$tmp"
    printf '%s\n' "$end" >> "$tmp"
  fi

  mv "$tmp" "${rc_file}"
  normalize_unix "${rc_file}"
  ok "Hook installé dans ${rc_file}"
}

# Résout le répertoire racine du projet (où se trouve ce script)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Chemin absolu du shell_select.sh (utilisé par les hooks RC)
abs_shell_select() {
  posix_path="${ROOT_DIR}/scripts/shell_select.sh"
  # On normalise au cas où
  normalize_unix "${posix_path}" || true
  printf '%s\n' "${posix_path}"
}

# ---------------------------
# Installation
# ---------------------------
say "Préparation de l'arborescence gérée (~/.menu-shells)"
mkdir -p "$HOME/.menu-shells/bin" "$HOME/.menu-shells/rc"

# Config par défaut (thème)
if [ ! -f "$HOME/.menu-shells/config" ]; then
  printf 'THEME=dark\n' > "$HOME/.menu-shells/config"
fi
normalize_unix "$HOME/.menu-shells/config"

# Installe sys_info
say "Installation du binaire sys_info"
cp -f "${ROOT_DIR}/scripts/bin/sys_info.sh" "$HOME/.menu-shells/bin/sys_info.sh"
normalize_unix "$HOME/.menu-shells/bin/sys_info.sh"
chmod +x "$HOME/.menu-shells/bin/sys_info.sh"
ok  "~/.menu-shells/bin/sys_info.sh installé"

# Installe RC gérés (bash/zsh)
say "Installation des RC gérés (bash_rc / zsh_rc)"
# Templates fournis par le projet
if [ -f "${ROOT_DIR}/scripts/rc_templates/bash_rc" ]; then
  cp -f "${ROOT_DIR}/scripts/rc_templates/bash_rc" "$HOME/.menu-shells/rc/bash_rc"
  normalize_unix "$HOME/.menu-shells/rc/bash_rc"
fi
if [ -f "${ROOT_DIR}/scripts/rc_templates/zsh_rc" ]; then
  cp -f "${ROOT_DIR}/scripts/rc_templates/zsh_rc"  "$HOME/.menu-shells/rc/zsh_rc"
  normalize_unix "$HOME/.menu-shells/rc/zsh_rc"
fi
ok  "~/.menu-shells/rc/* installés (si présents)"

# ---------------------------
# Hooks dans les RC utilisateurs
# ---------------------------
SHELL_SELECT_PATH="$(abs_shell_select)"

# Crée/ajoute le hook dans ces fichiers (créés si absents)
ensure_hook_in_rc "${HOME}/.bashrc"       "${SHELL_SELECT_PATH}"
ensure_hook_in_rc "${HOME}/.bash_profile" "${SHELL_SELECT_PATH}"
ensure_hook_in_rc "${HOME}/.zshrc"        "${SHELL_SELECT_PATH}"

say ""
ok "Installation terminée. Ouvrez un nouveau terminal pour voir le menu."
say "Ou lancez directement : ${ROOT_DIR}/scripts/menu.sh"
