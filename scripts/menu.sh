#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh disable=SC1091
. "${SCRIPT_DIR}/lib/common.sh"

print_banner() {
  # Minimal, portable (ASCII) – tu peux la remplacer par la grande bannière Unicode ci-dessus si tu veux
  printf "%s" "$BLUE"
  cat <<'EOF'
╔══════════════════════════════════════════════╗
║              MENU SHELLS (v0.3)             ║
╚══════════════════════════════════════════════╝
EOF
  printf "%s" "$RESET"
}

show_menu() {
  print_banner
  echo "1) Bash"
  echo "2) Zsh"
  echo "3) Infos système"
  # Lire le thème courant
  local theme="dark"
  if [[ -r "${CONFIG_FILE}" ]]; then
    # shellcheck disable=SC1090
    . "${CONFIG_FILE}"
    theme="${THEME:-dark}"
  fi
  echo "4) Thème : ${theme} (basculer clair/sombre)"
  echo "q) Quitter"
}

main() {
  load_theme
  while true; do
    show_menu
    read -r -p "Votre choix: " choice || true
    case "${choice}" in
      1) ok "Lancement de bash..."; exec bash --rcfile "$HOME/.menu-shells/rc/bash_rc" -i ;;
      2)
         env_kind="$(detect_env)"
         if [[ "$env_kind" == "MSYS/MINGW" ]]; then
           ok "Lancement de zsh (propre Git Bash)…"
           exec zsh -f -i -c '[[ -r "$HOME/.menu-shells/rc/zsh_rc" ]] && source "$HOME/.menu-shells/rc/zsh_rc"; exec zsh -i'
         else
           ok "Lancement de zsh…"
           exec zsh -i -c '[[ -r "$HOME/.menu-shells/rc/zsh_rc" ]] && source "$HOME/.menu-shells/rc/zsh_rc"; exec zsh -i'
         fi
         ;;
      3) ok "Environnement: $(detect_env)"; (command -v uname >/dev/null 2>&1 && uname -a) || true ;;
      4)
         # Toggle thème et sauvegarde
         local current="dark"
         if [[ -r "${CONFIG_FILE}" ]]; then
           # shellcheck disable=SC1090
           . "${CONFIG_FILE}"
           current="${THEME:-dark}"
         fi
         if [[ "${current}" == "dark" ]]; then
           save_theme "light"
           ok "Thème basculé sur clair."
         else
           save_theme "dark"
           ok "Thème basculé sur sombre."
         fi
         load_theme
         ;;
      q|Q) ok "Au revoir."; exit 0 ;;
      *) warn "Choix invalide." ;;
    esac
  done
}
main "$@"
