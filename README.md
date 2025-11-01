# 🐚 Menu Shells  
### Interactive Bash/Zsh menu for multi-environment shells (Git Bash, WSL, Linux)

[![CI](https://github.com/LDdvlp/0031-BASH-menu_shells/actions/workflows/ci.yml/badge.svg)](https://github.com/LDdvlp/0031-BASH-menu_shells/actions/workflows/ci.yml)
[![Release](https://github.com/LDdvlp/0031-BASH-menu_shells/actions/workflows/release.yml/badge.svg)](https://github.com/LDdvlp/0031-BASH-menu_shells/actions/workflows/release.yml)

---

## 🌟 Présentation

**Menu Shells** est un script professionnel en Bash/Zsh permettant de choisir facilement
le shell à exécuter (Bash, Zsh, WSL...) dès l’ouverture du terminal.  
Il intègre :
- ✅ une détection automatique de l’environnement (Git Bash, WSL, Linux)
- 🧭 un menu interactif de sélection du shell
- 💾 une sauvegarde/restauration des fichiers de configuration
- 🔄 un système d’installation automatique dans `.bashrc` / `.zshrc`
- 🧪 des tests automatisés (BATS)
- 🧹 une intégration continue (CI) et livraison continue (CD) via GitHub Actions

---

## 🧩 Structure du projet

```
0031-BASH-menu_shells/
├── install.sh                # Installe le système Menu Shells
├── Makefile                  # Cibles CI/CD (lint, test, package, release)
├── scripts/
│   ├── menu.sh               # Menu principal interactif
│   ├── lib/common.sh         # Fonctions utilitaires et couleurs
│   ├── bin/sys_info.sh       # Affichage d'informations système
│   ├── rc_templates/         # Modèles de fichiers RC
│   └── tools/
│       ├── check_utf8.sh     # Test interactif d'encodage UTF-8
│       └── check_utf8_ci.sh  # Vérification UTF-8 CI/CD (silencieuse)
├── tests/                    # Tests BATS
│   ├── 00_smoke.bats
│   ├── 05_profile_rc.bats
│   ├── 10_menu_ui.bats
│   ├── 11_theme_toggle.bats
│   ├── 15_menu_env_linux.bats
│   ├── 16_menu_env_gitbash.bats
│   └── 17_menu_env_wsl.bats
├── CHANGELOG.md              # Journal des versions
└── .github/workflows/
    ├── ci.yml                # Intégration continue
    └── release.yml           # Livraison continue (releases GitHub)
```

---

## ⚙️ Installation rapide

```bash
git clone https://github.com/LDdvlp/0031-BASH-menu_shells.git
cd 0031-BASH-menu_shells
make install
```

Le script mettra à jour automatiquement :
- `~/.bashrc` et `~/.zshrc`
- ton `$PATH` pour inclure `~/.menu-shells/bin`

---

## 🧪 Commandes Make utiles

| Commande | Description |
|-----------|-------------|
| `make lint` | Vérifie la syntaxe avec ShellCheck |
| `make test` | Exécute tous les tests BATS |
| `make utf8` | Vérifie la compatibilité UTF-8 |
| `make ci-check` | Vérification UTF-8 silencieuse (CI/CD) |
| `make package` | Crée l’archive `.tar.gz` dans `dist/` |
| `make changelog` | Génère le changelog automatiquement |
| `make release` | Crée et pousse un nouveau tag Git |
| `make clean` | Supprime le dossier `dist/` |

---

## 🔄 Pipeline CI/CD

```
┌────────────────────────────┐
│        TON POSTE DEV       │
│ (Git Bash / WSL / VSCode)  │
└─────────────┬──────────────┘
              │
              │ git push
              ▼
┌────────────────────────────┐
│  GitHub Actions – CI 🧪     │
│  (.github/workflows/ci.yml) │
│  ├─ make ci-check (UTF-8)   │
│  ├─ make lint               │
│  └─ make test               │
│  ✅ Valide le code et les tests  │
└─────────────┬──────────────┘
              │
              │ git tag vX.Y.Z-alpha
              ▼
┌────────────────────────────┐
│ GitHub Actions – Release 🚀│
│ (.github/workflows/release.yml) │
│  ├─ make package            │
│  ├─ Création de la Release  │
│  └─ Upload du package tar.gz│
└─────────────┬──────────────┘
              │
              ▼
┌────────────────────────────┐
│  Page GitHub Releases 📦    │
│  changelog + archive dispo  │
│  tag = version publiée      │
└────────────────────────────┘
```

---

## 🧠 Versionnage sémantique

Les versions suivent le format :

```
vMAJEUR.MINEUR.PATCH[-alpha|beta|rc]
```

| Exemple | Signification |
|----------|----------------|
| `v0.4.0-alpha.1` | version de test interne |
| `v0.4.0-beta.1`  | avant la release stable |
| `v0.4.0`         | version stable publique |

---

## 📜 Changelog

Voir [CHANGELOG.md](./CHANGELOG.md)

---

## 🧑‍💻 Auteur

**Loïc Drouet (LDdvlp)**  
🌐 [github.com/LDdvlp](https://github.com/LDdvlp)

---

## 🪪 Licence

Ce projet est distribué sous licence MIT.

```
MIT License © 2025 Loïc Drouet
```
