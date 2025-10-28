#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh disable=SC1091
. "${SCRIPT_DIR}/lib/common.sh"

show_menu() {
  printf "%s──── Menu Shells (v0.1) ────%s\n" "$BOLD" "$RESET"
  cat <<'EOF'
1) Bash
2) Zsh
3) Infos système
q) Quitter
EOF
}


main() {
  while true; do
    show_menu
    read -r -p "Votre choix: " choice
    case "${choice}" in
      1)
        ok "Lancement de bash..."
        exec bash --rcfile "$HOME/.menu-shells/rc/bash_rc" -i
        ;;
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
      3) ok "Environnement: $(detect_env)"; uname -a || true ;;
      q|Q) ok "Au revoir."; exit 0 ;;
      *) warn "Choix invalide." ;;
    esac
  done
}
main "$@"
