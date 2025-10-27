#!/usr/bin/env bats

setup() {
  PROJECT_DIR="$( cd "$( dirname "${BATS_TEST_FILENAME}" )/.." && pwd )"
  SCRIPTS="${PROJECT_DIR}/scripts"
  LIB="${SCRIPTS}/lib"
}

@test "common.sh se charge et expose detect_env" {
  run bash -c "source \"$LIB/common.sh\"; type detect_env >/dev/null"
  [ "$status" -eq 0 ]
}

@test "menu.sh est exécutable" {
  [ -x "$SCRIPTS/menu.sh" ]
}

