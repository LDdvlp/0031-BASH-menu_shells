#!/usr/bin/env bats

setup() {
  PROJECT_DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." && pwd )"
  export HOME="${BATS_TEST_TMPDIR}/home_gitbash"
  mkdir -p "$HOME"
}

file_has() { # $1=file $2=needle ; Bash pur
  local f="$1" needle="$2" line
  [ -r "$f" ] || return 1
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      *"$needle"*) return 0;;
    esac
  done < "$f"
  return 1
}

@test "install + run menu on Git Bash (simulé MSYS/MINGW)" {
  run bash -c "cd \"$PROJECT_DIR\" && MENU_SHELLS_FORCE_ENV='MSYS/MINGW' ./install.sh"
  [ "$status" -eq 0 ]
  [ -x "$HOME/.menu-shells/bin/sys_info.sh" ]

  # Les RC doivent exister et contenir le bloc + le script
  [ -f "$HOME/.bashrc" ]
  [ -f "$HOME/.zshrc" ]
  file_has "$HOME/.bashrc" ">>> menu-shells >>>"
  file_has "$HOME/.bashrc" "shell_select.sh"
  file_has "$HOME/.zshrc"  ">>> menu-shells >>>"
  file_has "$HOME/.zshrc"  "shell_select.sh"

  # Exécution non interactive du menu (on quitte avec 'q')
  run bash -c "MENU_SHELLS_FORCE_ENV='MSYS/MINGW' \"$PROJECT_DIR/scripts/menu.sh\" <<<'q'"
  [ "$status" -ge 0 ]
  [[ "$output" == *"1) Bash"* ]]
  [[ "$output" == *"2) Zsh"* ]]
  [[ "$output" == *"q) Quitter"* ]]
}
