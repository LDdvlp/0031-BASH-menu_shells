#!/usr/bin/env bats

setup() {
  PROJECT_DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." && pwd )"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "$HOME"
}

@test "install creates managed rc and sys_info" {
  run bash -c "cd \"$PROJECT_DIR\" && ./install.sh"
  [ "$status" -eq 0 ]
  [ -x "$HOME/.menu-shells/bin/sys_info.sh" ]
  [ -r "$HOME/.menu-shells/rc/bash_rc" ]
  [ -r "$HOME/.menu-shells/rc/zsh_rc" ]
}

@test "sys_info prints something" {
  run bash -c '
    tmp="$HOME/.menu-shells/bin/sys_info.sh"
    cleaned=""
    # Strip CR (\r) en pur Bash (pas d’outils externes)
    while IFS= read -r line || [ -n "$line" ]; do
      line="${line%$'\r'}"
      cleaned="$cleaned$line"$'\n'
    done < "$tmp"
    bash -c "$cleaned"
  '
  [ "$status" -eq 0 ]
  # Le script doit produire quelque chose de non trivial
  [[ -n "$output" ]]
  (( ${#output} > 10 ))
}