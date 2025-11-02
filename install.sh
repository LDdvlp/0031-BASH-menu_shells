#!/usr/bin/env bash
set -euo pipefail
# -----------------------------------------------------------------------------
# install.sh — installe le système de menu Menu Shells
# Compatible : Linux, WSL, Git Bash
# -----------------------------------------------------------------------------

# --- Couleurs ---
ESC="$(printf '\033')"
GREEN="${ESC}[0;32m"
YELLOW="${ESC}[1;33m"
RED="${ESC}[0;31m"
RESET="${ESC}[0m"

ok()   { printf "✅ ${GREEN}%s${RESET}\n" "$*"; }
warn() { printf "⚠️  ${YELLOW}%s${RESET}\n" "$*"; }
fail() { printf "❌ ${RED}%s${RESET}\n" "$*"; }

# --- Détection du répertoire d’installation ---
ROOT="$HOME/.menu-shells"
BIN="$ROOT/bin"
RC="$ROOT/rc"

mkdir -p "$BIN" "$RC"

# --- Copie des scripts binaires ---
if [[ -f scripts/bin/sys_info.sh ]]; then
  install -m 755 scripts/bin/sys_info.sh "$BIN/"
  ok "$HOME/.menu-shells/bin/sys_info.sh installé"
else
  warn "scripts/bin/sys_info.sh introuvable, ignoré"
fi

# --- Copie des rc_templates (si présents) ---
if [[ -d scripts/rc_templates ]]; then
  cp -f scripts/rc_templates/* "$RC/" 2>/dev/null || true
  ok "$HOME/.menu-shells/rc/* installés (si présents)"
else
  warn "scripts/rc_templates introuvable, ignoré"
fi

# --- Gestion des fichiers .bashrc / .zshrc ---
update_rc() {
  local rc_file="$1"
  local tmp
  tmp="$(mktemp)"

  # ✨ Marqueurs de gestion du bloc Menu Shells
  local begin=">>> menu-shells >>>"
  local end="<<< menu-shells <<<"

   # 📂 Contenu à insérer dans le bloc (littéral, sans expansion immédiate)
  local include
  read -r -d '' include <<'EOS'
[[ -f "$ROOT/menu.sh" ]] && source "$ROOT/menu.sh"
[[ -f "$ROOT/shell_select.sh" ]] && source "$ROOT/shell_select.sh"
EOS

  # 🔧 Supprime tout ancien bloc déjà présent
  if [[ -f "$rc_file" ]]; then
    awk -v b="$begin" -v e="$end" '
      $0 == b {inblock=1; next}
      $0 == e {inblock=0; next}
      !inblock {print}
    ' "$rc_file" > "$tmp"
  else
    : >"$tmp"
  fi

  # 🧱 Ajoute le nouveau bloc proprement
  {
    printf '%s\n' "$begin"
    printf '%s\n' "$include"
    printf '%s\n' "$end"
  } >>"$tmp"



# --- Mise à jour des rc utilisateurs ---
for f in "$HOME/.bashrc" "$HOME/.zshrc"; do
  update_rc "$f"
done

# --- Installation du sys_info dans le PATH ---
if ! command -v sys_info.sh >/dev/null 2>&1; then
  PATH_UPDATE="export PATH=\"\$PATH:$BIN\""
  if ! grep -q "$PATH_UPDATE" "$HOME/.bashrc" 2>/dev/null; then
    echo "$PATH_UPDATE" >> "$HOME/.bashrc"
  fi
  ok "PATH mis à jour pour inclure $BIN"
fi

ok "Installation terminée avec succès !"
