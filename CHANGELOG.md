# Changelog
All notable changes to this project will be documented in this file.

The format is based on https://keepachangelog.com/en/1.1.0/,
and this project adheres to Semantic Versioning: https://semver.org/spec/v2.0.0.html.

## v0.1.0-alpha.1

### Added
- feat(core): initial minimal menu with common utils and tests ([72a9699](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/72a9699))


## v0.2.0-alpha.1

### Added
- feat(core): add installer, rc templates and system info integration ([b99b621](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/b99b621))


## v0.3.0-alpha.1

### Added
- feat(ui): add banner, theme toggle, and UI test; finalize v0.3.0-alpha.1 ([204c5a0](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/204c5a0))

### Tests
- test(ui): add automated check for menu display output ([c027f9d](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/c027f9d))


## v0.3.0-alpha.2

### Tests
- test(ui): add theme toggle tests (create config and flip light/dark) ([b217d66](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/b217d66))


## v0.4.0-alpha.1

### Chore/CI/Build
- chore(git): add .gitignore to exclude VS Code and system files ([ae92df9](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/ae92df9))
- chore(license): add MIT LICENSE file ([201e11d](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/201e11d))
- chore(package): add packaging target and license ([e95f4e7](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/e95f4e7))
- chore(cd): add GitHub Actions release workflow (auto package on tag) ([6962a24](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/6962a24))


## v0.4.0-alpha.2

### Chore/CI/Build
- chore(ci): add GitHub Actions (linux + windows/git bash) and CI badge ([c8e1a03](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/c8e1a03))
- chore(release): v0.4.0-alpha.1 ([9221d11](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/9221d11))


## v0.4.0-alpha.3

### Added
- feat(install): finalize idempotent RC hooks and add environment tests ([6bfb76e](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/6bfb76e))


## v0.4.0-alpha.4

### Fixed
- fix(install): keep +x on sys_info.sh (normalize then chmod) ([8e4c8d5](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/8e4c8d5))

### Chore/CI/Build
- chore(ci): stabilize CI with MSYS2 on Windows; chore(cd): fix release permissions and fetch tags ([8355300](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/8355300))
- chore(git): enforce LF endings for scripts via .gitattributes ([7302155](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/7302155))
- chore(perms): mark shell scripts executable (+x) ([43e7a3d](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/43e7a3d))
- chore(ci): enforce exec bits and check LF before lint/test/package ([19b6550](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/19b6550))
- chore(ci): retrigger ([968ba79](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/968ba79))
- chore(ci): run lint only on Linux; on Windows use MSYS2 with make+bats and run tests ([46534e4](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/46534e4))
- chore(ci/windows): install bats-core from source under MSYS2 and run tests ([9fe0356](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/9fe0356))


## v0.4.0-alpha.5

### Chore/CI/Build
- chore(cd): add manual + automatic release workflow with validation ([aa6e945](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/aa6e945))


## Unreleased

### Changes
- fix(changelog): remove extglob-like patterns; force bash in Makefile target ([e5dff9e](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/e5dff9e))
- fix(changelog): ensure LF and executable script ([acbdf91](https://github.com/LDdvlp/0031-BASH-menu_shells/commit/acbdf91))

