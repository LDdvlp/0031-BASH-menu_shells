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
	  bats -T tests; \
	else \
	  echo "bats non installé"; exit 1; \
	fi

check:
	@echo "── Vérification complète (lint + test) ──"
	@$(MAKE) lint
	@$(MAKE) test
	@echo "✅ OK"
