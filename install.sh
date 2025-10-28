#!/usr/bin/env bash
# Installation du projet Menu Shells

# Stoppe le script à la première erreur et sur pipe échoué
set -o errexit -o pipefail -o nounset

# --- normalisation des fins de lignes ---
normalize_unix() {
  # $1 = chemin du fichier
  if command -v dos2unix >/dev/null 2>&1; then
    dos2unix "$1" >/dev/null 2>&1 || true
  else
    # fallback POSIX : supprime les CR et ajoute un \n final si absent
    sed -i 's/\r$//' "$1" 2>/dev/null || true
    tail -c1 "$1" | od -An -t x1 | grep -qi '0a' || printf '\n' >> "$1"
  fi
}


# --- RC & bin gérés par Menu Shells ---
mkdir -p "$HOME/.menu-shells" "$HOME/.menu-shells/bin" "$HOME/.menu-shells/rc"
if [[ ! -f "$HOME/.menu-shells/config" ]]; then
  printf 'THEME=dark\n' > "$HOME/.menu-shells/config"
fi

# Installe le script d'info système
cp -f "./scripts/bin/sys_info.sh" "$HOME/.menu-shells/bin/sys_info.sh"
chmod +x "$HOME/.menu-shells/bin/sys_info.sh"
normalize_unix "$HOME/.menu-shells/bin/sys_info.sh"

# Installe les RC gérés (Bash/Zsh)
cp -f "./scripts/rc_templates/bash_rc" "$HOME/.menu-shells/rc/bash_rc"
cp -f "./scripts/rc_templates/zsh_rc"  "$HOME/.menu-shells/rc/zsh_rc"
normalize_unix "$HOME/.menu-shells/rc/bash_rc"
normalize_unix "$HOME/.menu-shells/rc/zsh_rc"

