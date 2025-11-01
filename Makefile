# -----------------------------
# Makefile — Menu Shells (pro)
# -----------------------------

# Always use bash for recipes (portable)
SHELL := /usr/bin/env bash

# -------- Pretty output (portable colors) --------
ESC     := $(shell printf '\033')
GREEN   := $(ESC)[0;32m
RED     := $(ESC)[0;31m
YELLOW  := $(ESC)[1;33m
BLUE    := $(ESC)[1;34m
RESET   := $(ESC)[0m

OK_ICON      := ✅
FAIL_ICON    := ❌
TEST_ICON    := 🧪
LINT_ICON    := 🧹
PKG_ICON     := 📦
INSTALL_ICON := ⚙️
RELEASE_ICON := 🚀

# -------- Project meta --------
PROJECT := menu-shells
# VERSION can be injected by CI (`env.VERSION`); else fallback to git describe
ifdef VERSION
  VERSION := $(VERSION)
else
  VERSION := $(shell git describe --tags --always --dirty)
endif
DIST_DIR := dist
PACKAGE  := $(DIST_DIR)/$(PROJECT)-$(VERSION).tar.gz

# Files to package (only include those that exist)
PKG_SRC := install.sh scripts tests Makefile README.md LICENSE

# -------- Phony targets --------
.PHONY: all check lint test install package clean changelog release utf8 ci-check

# -------- Default pipeline --------
all: check package
check: lint test

# -------- Lint (ShellCheck) --------
lint:
	@echo "$(LINT_ICON) $(YELLOW)Running ShellCheck...$(RESET)"
	@set -e; \
	files=""; \
	{ [ -f install.sh ] && files="$$files install.sh"; } ; \
	{ [ -d scripts ] && files="$$files $$(find scripts -type f -name '*.sh')"; } ; \
	if [ -n "$$files" ]; then \
	  shellcheck $$files && echo "$(OK_ICON) $(GREEN)Lint passed!$(RESET)"; \
	else \
	  echo "$(OK_ICON) $(GREEN)No shell files to lint.$(RESET)"; \
	fi

# -------- Tests (BATS) --------
test:
	@echo "$(TEST_ICON) $(BLUE)Running BATS tests...$(RESET)"
	@bats tests && echo "$(OK_ICON) $(GREEN)All tests passed!$(RESET)"

# -------- Local install --------
install:
	@echo "$(INSTALL_ICON) Installing locally..."
	@bash install.sh
	@echo "$(OK_ICON) $(GREEN)Installed successfully!$(RESET)"

# -------- Package (.tar.gz) --------
$(PACKAGE):
	@echo "$(PKG_ICON) Packaging $(PROJECT) $(VERSION)..."
	@mkdir -p "$(DIST_DIR)"
	@set -e; files=""; \
	for f in $(PKG_SRC); do \
	  if [ -e "$$f" ]; then files="$$files $$f"; fi; \
	done; \
	if [ -z "$$files" ]; then \
	  echo "$(FAIL_ICON) $(RED)No files to package$(RESET)"; exit 1; \
	fi; \
	tar -czf "$@" $$files
	@echo "$(OK_ICON) $(GREEN)Package built: $(PACKAGE)$(RESET)"

package: $(PACKAGE)

# -------- Clean --------
clean:
	@rm -rf "$(DIST_DIR)"
	@echo "$(OK_ICON) $(GREEN)Cleaned $(DIST_DIR)$(RESET)"

# -------- Changelog (Keep a Changelog + Conventional Commits) --------
changelog:
	@echo "🗒️  Generating changelog..."
	@REPO_URL="https://github.com/LDdvlp/0031-BASH-menu_shells" bash scripts/tools/gen_changelog.sh
	@echo "$(OK_ICON) $(GREEN)CHANGELOG.md updated$(RESET)"

# -------- Interactive tagging & push --------
release:
	@echo "$(RELEASE_ICON) Preparing release…"
	@echo "Current latest tag: $$(git describe --tags --abbrev=0 2>/dev/null || echo 'none')"
	@read -p "Enter new version tag (e.g. v0.4.0-beta.1): " tag; \
	[ -n "$$tag" ] || { echo "$(FAIL_ICON) $(RED)Tag cannot be empty$(RESET)"; exit 1; }; \
	git tag -a $$tag -m "$$tag"; \
	git push origin $$tag; \
	echo "$(OK_ICON) $(GREEN)Tag $$tag pushed!$(RESET)"

# -------- UTF-8 checks --------
utf8:
	@bash scripts/tools/check_utf8.sh

ci-check:
	@bash scripts/tools/check_utf8_ci.sh
