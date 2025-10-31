#!/usr/bin/env bash
set -euo pipefail

# Génère CHANGELOG.md (Keep a Changelog) à partir des tags v*
# Classement basé sur Conventional Commits: feat/fix/docs/test/chore/build/ci/refactor/perf/...
# Usage:
#   REPO_URL="https://github.com/LDdvlp/0031-BASH-menu_shells" bash scripts/tools/gen_changelog.sh

REPO_URL="${REPO_URL:-https://github.com/LDdvlp/0031-BASH-menu_shells}"
OUT="CHANGELOG.md"

header() {
  cat <<'H'
# Changelog
All notable changes to this project will be documented in this file.

The format is based on https://keepachangelog.com/en/1.1.0/,
and this project adheres to Semantic Versioning: https://semver.org/spec/v2.0.0.html.

H
}

# Retourne la liste des tags v* triés (ancien -> récent)
get_tags() {
  git tag --list 'v*' --sort=version:refname
}

# Collecte les commits (SHA \t message) entre deux refs
# from vide => depuis l’origine jusqu’à "to"
collect_range() {
  local from="${1:-}" to="${2:-}"
  if [[ -z "$to" ]]; then
    return 0
  fi
  if [[ -z "$from" ]]; then
    git log --pretty=format:'%h%x09%s' "$to" --reverse
  else
    git log --pretty=format:'%h%x09%s' "$from..$to" --reverse
  fi
}

format_section() {
  local title="$1"; shift
  local -a items=("$@")
  [[ ${#items[@]} -eq 0 ]] && return 0
  echo "### ${title}"
  local line sha msg
  for line in "${items[@]}"; do
    sha="${line%%$'\t'*}"
    msg="${line#*$'\t'}"
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
    msg="${l#*$'\t'}"
    type="${msg%%:*}"              # ex: "feat", "feat(scope)", "fix", ...
    [[ "$type" == *"("* ]] && type="${type%%(*}"  # feat(scope) -> feat

    if   [[ "$type" == feat* ]]; then added+=("$l")
    elif [[ "$type" == fix*  ]]; then fixed+=("$l")
    elif [[ "$type" == docs* ]]; then docs+=("$l")
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

main() {
  header

  mapfile -t TAGS < <(get_tags)
  if [[ ${#TAGS[@]} -eq 0 ]]; then
    # Pas de tag: tout en "Unreleased"
    mapfile -t all < <(git log --pretty=format:'%h%x09%s' --reverse || true)
    echo "## Unreleased"
    echo
    format_section "Changes" "${all[@]}"
    return 0
  fi

  # Tags du plus ancien au plus récent
  local i tag prev
  for ((i=0; i<${#TAGS[@]}; i++)); do
    tag="${TAGS[$i]}"
    prev=""
    if (( i>0 )); then prev="${TAGS[$((i-1))]}"; fi

    mapfile -t lines < <(collect_range "$prev" "$tag" || true)
    format_release "$tag" "${lines[@]}"
    echo
  done

  # Unreleased (depuis le dernier tag jusqu'à HEAD)
  mapfile -t unreleased < <(git log --pretty=format:'%h%x09%s' "${TAGS[-1]}..HEAD" --reverse || true)
  if [[ ${#unreleased[@]} -gt 0 ]]; then
    echo "## Unreleased"
    echo
    format_section "Changes" "${unreleased[@]}"
  fi
}

# Écrit dans le fichier
main > "$OUT"
echo "CHANGELOG generated -> $OUT"
