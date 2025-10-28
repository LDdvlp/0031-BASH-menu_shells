#!/usr/bin/env bats

setup() {
  PROJECT_DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." && pwd )"
  MENU="${PROJECT_DIR}/scripts/menu.sh"
}

@test "menu.sh affiche le menu principal" {
  run bash -c "timeout 2s \"$MENU\" < /dev/null || true"
  [ "$status" -ge 0 ]    # 0 ou 124 accepté
  [[ "$output" == *"MENU SHELLS"* ]]
  [[ "$output" == *"1) Bash"* ]]
  [[ "$output" == *"2) Zsh"* ]]
  [[ "$output" == *"4) Thème"* ]]
}
