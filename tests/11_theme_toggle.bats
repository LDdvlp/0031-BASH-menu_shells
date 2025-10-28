#!/usr/bin/env bats

setup() {
  PROJECT_DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." && pwd )"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "$HOME"
  MENU="${PROJECT_DIR}/scripts/menu.sh"
  INSTALL="${PROJECT_DIR}/install.sh"
}

# Utilitaires bash purs (pas d’outils externes)
read_theme() {
  local cfg="$HOME/.menu-shells/config"
  [[ -r "$cfg" ]] || { echo ""; return 0; }
  # shellcheck disable=SC1090
  . "$cfg"
  echo "${THEME:-}"
}

@test "toggle crée le fichier config si absent et passe de dark -> light" {
  # S’assurer d’un état propre
  rm -rf "$HOME/.menu-shells"
  mkdir -p "$HOME"

  # Pas d’install préalable : menu part de THEME=dark par défaut (load_theme)
  # On simule: 4 (toggle) puis q (quit)
  run bash -c 'printf "4\nq\n" | "'"$MENU"'"'
  [ "$status" -eq 0 ]

  # Le config doit exister et contenir THEME=light
  [ -r "$HOME/.menu-shells/config" ]
  theme="$(read_theme)"
  [ "$theme" = "light" ]
}

@test "toggle repasse de light -> dark si config existe" {
  rm -rf "$HOME/.menu-shells"
  mkdir -p "$HOME/.menu-shells"
  printf 'THEME=light\n' > "$HOME/.menu-shells/config"

  # Simule: 4 (toggle), puis q (quit)
  run bash -c 'printf "4\nq\n" | "'"$MENU"'"'
  [ "$status" -eq 0 ]

  theme="$(read_theme)"
  [ "$theme" = "dark" ]
}
