#!/usr/bin/env bash
set -euo pipefail

# Génère CHANGELOG.md depuis les tags (Keep a Changelog style)
# Regroupe par Added/Changed/Fixed/Docs/Test/Chore d'après les prefixes Conventional Commits.

REPO_URL="${REPO_URL:-https://github.com/LDdvlp/0031-BASH-menu_shells}"
OUT="CHANGELOG.md"

header() {
  cat <<EOF
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

EOF
}

# Récupère les tags triés du plus ancien au plus récent
mapfile -t TAGS < <(git tag --list 'v*' --sort=version:refname)

# Si aucun tag, on consigne tout l'historique comme "Unreleased"
last_tag=""
unreleased_commits=""

collect_range() {
  local from="$1" to="$2"
  if [[ -z "$from" ]]; then
    git log --pretty=format:'%h%x09%s' "$to" --reverse
  else
    git log --pretty=format:'%h%x09%s' "$from".."$to" --reverse
  fi
}

format_section() {
  local title="$1"; shift
  local -a items=("$@")
  [[ ${#items[@]} -eq 0 ]] && return 0
  echo "### ${title}"
  for line in "${items[@]}"; do
    local sha msg
    sha="${line%%$'\t'*}"
    msg="${line#*$'\t'}"
    # Lien vers le commit
    echo "- ${msg} ([${sha}](${REPO_URL}/commit/${sha}))"
  done
  echo
}

format_release() {
  local tag="$1"; shift
  local -a lines=("$@")

  local -a added changed fixed docs test chore
  local l msg type

  for l in "${lines[@]}"; do
    msg="${l#*$'\t'}"         # message complet
    type="${msg%%:*}"         # ce qu’il y a avant le premier ':' (ex: feat, feat(scope), fix, etc.)

    # Normalise le type: feat(scope) -> feat ; fix(security) -> fix, etc.
    # (on enlève tout après '(' s'il existe)
    [[ "$type" == *"("* ]] && type="${type%%(*}"

    if   [[ "$type" == feat* ]];      then added+=("$l")
    elif [[ "$type" == fix* ]];       then fixed+=("$l")
    elif [[ "$type" == docs* ]];      then docs+=("$l")
    elif [[ "$type" == test* || "$type" == tests* ]]; then test+=("$l")
    elif [[ "$type" == chore* || "$type" == build* || "$type" == ci* || "$type" == refactor* || "$type" == perf* ]]; then
         chore+=("$l")
    else
         changed+=("$l")
    fi
  done

  echo "## ${tag}"
  echo
  format_section "Added"   "${added[@]}"
  format_section "Changed" "${changed[@]}"
  format_section "Fixed"   "${fixed[@]}"
  format_section "Docs"    "${docs[@]}"
  format_section "Tests"   "${test[@]}"
  format_section "Chore/CI/Build" "${chore[@]}"
}


main > "$OUT"
echo "CHANGELOG generated -> $OUT"
