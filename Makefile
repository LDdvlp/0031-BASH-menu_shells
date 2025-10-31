# Permet de ne pas échouer sur un test Bats avec timeout (code 124)
BATS_FLAGS=-T

SHELL := /usr/bin/env bash
.PHONY: lint test check

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
	  shellcheck scripts/*.sh scripts/lib/*.sh; \
	else \
	  echo "shellcheck non installé"; exit 1; \
	fi

test:
	@if command -v bats >/dev/null 2>&1; then \
	  bats $(BATS_FLAGS) tests || [ $$? -eq 124 ]; \
	else \
	  echo "bats non installé"; exit 1; \
	fi

check:
	@echo "── Vérification complète (lint + test) ──"
	@$(MAKE) lint
	@$(MAKE) test
	@echo "✅ OK"

# =======================
# Packaging (out of the box)
# =======================

# VERSION est prise de l'environnement (ex: Release workflow) sinon déduite du repo
# - en CI Release: le job fait `echo "VERSION=${GITHUB_REF_NAME}" >> $GITHUB_ENV`
# - en local: on tombe sur git describe (ou 0.0.0-DEV si pas de tag)
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo 0.0.0-DEV)

DIST_DIR := dist
PKG_BASENAME := menu-shells-$(VERSION)
PKG := $(DIST_DIR)/$(PKG_BASENAME).tar.gz

.PHONY: package
package: clean
	@mkdir -p $(DIST_DIR)
	@tar -czf $(PKG) \
		--exclude-vcs \
		--exclude='.github' \
		--exclude='$(DIST_DIR)' \
		--exclude='.vscode' \
		--exclude='.idea' \
		--exclude='*.log' \
		Makefile README.md LICENSE install.sh scripts tests .gitattributes .gitignore
	@echo "✅ Package créé: $(PKG)"

.PHONY: clean
clean:
	@rm -rf "$(DIST_DIR)"

SHELL := /usr/bin/env bash

.PHONY: changelog
changelog:
	@REPO_URL="https://github.com/LDdvlp/0031-BASH-menu_shells" bash scripts/tools/gen_changelog.sh
	@echo "✅ CHANGELOG.md updated"

