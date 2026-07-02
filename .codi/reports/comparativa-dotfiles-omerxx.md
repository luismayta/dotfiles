# Reporte Comparativo: dotfiles (luismayta) vs omerxx/dotfiles

**Fecha:** 2026-07-02
**Propósito:** Identificar patrones, herramientas y prácticas valiosas del repo de omerxx que podamos adoptar.

---

## 1. Filosofía de Organización

| Aspecto | Nosotros (luismayta) | omerxx |
|---|---|---|
| **Gestor de symlinks** | `install.sh` + scripts propios | **[Stow](https://www.gnu.org/software/stow/)** — `stow .` con `~/.config` como target |
| **Estructura** | Modular profunda: `zsh/modules/<tool>/` con subcarpetas `config/`, `internal/`, `pkg/`, `data/` | **Plana por tool**: cada carpeta raíz es una tool (`tmux/`, `nvim/`, `wezterm/`, etc.) |
| **Instalación** | Script `install.sh` + `Taskfile.yml` (via includes remotos) | Setup mínimo: `setup.sh` → `stow .` |
| **Multi-plataforma** | Excelente: `config/{base,linux,osx}.zsh` en cada módulo | macOS-only (aerospace, hammerspoon, sketchybar, nix-darwin) |
| **README** | Generado desde template (`provision/generators/README.yaml`) | README mínimo de 1 línea |

**Conclusión:** La organización modular nuestra es más robusta. La de omerxx es drásticamente más simple — cada tool es una carpeta, sin framework overlay. **Ideal para comparar qué tan pesado es nuestro approach.**

---

## 2. Tools Compartidas

| Tool | Nosotros | omerxx |
|---|---|---|
| **Zsh** | Modular: `core/` + `modules/<tool>/plugin.zsh` | Single `.zshrc` plano con aliases, plugins via brew, starship |
| **Tmux** | `zsh/modules/tmux/` con config + pkg | `tmux/tmux.conf` con TPM + 10 plugins (tmux-sessionx, tmux-floax, catppuccin fork, fzf-url, thumbs) |
| **Wezterm** | `zsh/modules/wezterm/` | `wezterm/wezterm.lua` — Catppuccin Mocha, blur 30, JetBrains Mono 16 |
| **Starship** | `zsh/modules/starship/` | `starship/starship.toml` con paleta catppuccin_mocha, prompt minimal |
| **Ghostty** | `zsh/modules/ghostty/` | `ghostty/config` — font-size 19, blur 20, sin decorations |
| **Neovim** | `zsh/modules/nvim/` | `nvim/` — **LazyVim** basado, solo 50 plugins (lazy-lock.json), init.lua minimal |
| **Nix** | `flake.nix` + `nix/versions.nix` | `nix/nix.conf` + **nix-darwin** (`flake.nix` + `home.nix`) |
| **Hammerspoon** | `zsh/modules/hammerspoon/` | `hammerspoon/init.lua` + 4 Spoons (AClock, Calendar, GoMaCal, HCalendar) |

---

## 3. Tools que omerxx tiene y nosotros NO (oportunidades)

| Tool | Archivos | Propuesta |
|---|---|---|
| **[Aerospace](https://github.com/nikitabobko/AeroSpace)** | `aerospace/aerospace.toml` | Tiling WM para macOS. Si usas macOS, considerar. |
| **[Atuin](https://atuin.sh)** | `atuin/config.toml` | Historia de shell con búsqueda sincronizada. Similar a nuestro enfoque de history. |
| **[gh-dash](https://github.com/dlvhdr/gh-dash)** | `gh-dash/config.yml` | Dashboard TUI para GitHub (PRs, issues). Útil para productividad. |
| **[Karabiner-Elements](https://karabiner-elements.pqrs.org)** | `karabiner/karabiner.json` | Remapeo de teclas macOS. Si tienes Mac, considerar. |
| **[KindaVim](https://github.com/godbout/kindaVim.blahblah)** | `kindavim/mo.com.sleeplessmind.kindaVim.plist` | Vim keybindings para macOS nativo. Alternativa ligera. |
| **[Nushell](https://www.nushell.sh)** | `nushell/config.nu`, `env.nu` | Shell moderno basado en datos estructurados. Interesante para explorar. |
| **[SketchyBar](https://github.com/FelixKratz/SketchyBar)** | `sketchybar/` (sketchybarrc, items/, plugins/, helper/) | Barra de estado macOS altamente configurable (reemplazo de iStats). Solo macOS. |
| **[skhd](https://github.com/koekeishiya/skhd)** | `skhd/skhdrc` + applescripts | Hotkey daemon para macOS. Complementa Aerospace. |
| **[Television](https://github.com/alexpasmantier/television)** | `television/` (~50 cables .toml) | Fuzzy finder TUI con "cables" para búsquedas preconfiguradas (Docker, K8s, Git, Brew, pip, npm, ssh, etc.). **MUY interesante.** |
| **[Zellij](https://zellij.dev)** | `zellij/config.kdl` + temas catppuccin | Multiplexer de terminal alternativo a tmux. |
| **OpenCode Agents** | `opencode/agent/*.md` (6 agentes definidos) | Arquitecto, Big Pickle, Implementation Specialist, Requirements Clarifier, Tech Lead, Test Automation Engineer |

---

## 4. Lo que más destaca de omerxx (ideas para adoptar)

### 4.1 Television + Cables
Tiene **~50 archivos de configuración** para Television que convierten cualquier cosa en un fuzzy-finder:

```toml
# cable/docker-containers.toml
[channel]
name = "Docker Containers"
command = "docker ps --format '{{.ID}}\t{{.Image}}\t{{.Status}}'"
```

Este enfoque de "cables" es extremadamente potente. Podríamos adoptar algo similar.

### 4.2 Tmux Plugins (TPM)
Usa **10 plugins de tmux** vía TPM que mejoran drásticamente la experiencia:
- `tmux-sessionx` — switcher de sesiones con fuzzy finder
- `tmux-floax` — ventana flotante tipo popup
- `tmux-fzf-url` — abre URLs desde la historia
- `tmux-thumbs` — navegación tipo "hjkl" en tmux
- `tmux-resurrect` + `continuum` — persistencia de sesiones

### 4.3 OpenCode Agents Organizados
Tiene 6 agentes de OpenCode bien definidos en `opencode/agent/`:
- `architect-designer.md` — para diseño de arquitectura
- `implementation-specialist.md` — para implementación
- `test-automation-engineer.md` — para tests
- `tech-lead.md` — para decisiones técnicas

Cada uno es un markdown con instrucciones específicas.

### 4.4 LazyVim como base de Neovim
Usa LazyVim con solo **~50 plugins** lockeados. El `init.lua` es minimalista:
```lua
require("config.lazy")
```
Esto vs nuestra configuración que tiene más plugins y más customización. **LazyVim da una base sólida con menos mantenimiento.**

### 4.5 Stow como gestor de symlinks
```bash
stow .
```
Simple, predecible, estándar. Nosotros tenemos scripts propios para esto.

### 4.6 Prompts personalizados en sketchybar/skhd
Tiene **applescripts** para menú, calendario, notificaciones y popups — integración con el ecosistema macOS a nivel nativo.

### 4.7 nix-darwin + home-manager
Configuración declarativa del sistema macOS vía Nix. Podríamos integrar si usamos NixOS o darwin.

---

## 5. Lo que nosotros tenemos y omerxx NO

| Aspecto | Nosotros | Beneficio |
|---|---|---|
| **Sistema de módulos** | `zsh/modules/<tool>/` con `config/`, `internal/`, `pkg/` | Separación clara de concerns |
| **Multi-plataforma** | Soporte Linux + macOS + OS architecture | Portabilidad real |
| **CI/CD** | `.github/workflows/` con lint, release, sonarqube | Calidad garantizada |
| **Taskfile.yml** | Automatización vía includes remotos | Reproducibilidad |
| **Pre-commit hooks** | `.pre-commit-config.yaml` | Calidad de código |
| **CHANGELOG generado** | `.chglog/` + `CHANGELOG.md` | Trazabilidad |
| **Docs site (mkdocs)** | `mkdocs.yml` | Documentación navegable |
| **SonarQube** | `sonar-project.properties` | Análisis estático |
| **Vagrant** | `Vagrantfile` + `provision/vagrant/` | Entornos reproducibles |
| **Diagrams** | `provision/diagrams/` con PlantUML | Documentación visual |
| **Bitwarden module** | `zsh/modules/bitwarden/` | Gestión de secrets |
| **AI skills** | `skills/` (30+ skills) + OpenSpec workflow | Automatización con IA |
| **DevOps tools** | `zsh/modules/devops/` (gcloud, helm, k9s, kubectl, komiser, tfenv) | Gestión de infraestructura |
| **Mobile dev** | `zsh/modules/mobile/` (android, flutter) | Desarrollo mobile |
| **Issues workflow** | `zsh/modules/issues/` con provider github/gitlab | Integración con issue trackers |
| **Templates** | `zsh/modules/templates/` | Scaffolding de proyectos |
| **Sección SSH dedicada** | `zsh/modules/ssh/` | Gestión de conexiones |
| **Resources/packages** | `config/packages.sh` + `resources/` | Dependencias declarativas |
| **Security** | `SECURITY.md`, `.gitleaks.toml`, `checkov.yml` | Postura de seguridad |

---

## 6. Recomendaciones de adopción

### Prioridad Alta (fácil + alto impacto)

1. **Television + Cables** — El sistema de fuzzy-finding por canales es excelente. Evaluar si lo integramos como módulo `television` con cables para herramientas cloud (AWS, K8s, Docker) que ya configuramos en nuestros módulos devops.

2. **Tmux plugins vía TPM** — `tmux-sessionx`, `tmux-floax` y `tmux-fzf-url` son plugins que transforman la experiencia tmux. Agregarlos a nuestro módulo tmux.

3. **Stow como gestor de symlinks** — Simplificaría nuestra instalación. Evaluar si reemplazar o complementar `install.sh`.

### Prioridad Media

4. **LazyVim como base** — Si estamos gastando mucho tiempo manteniendo la config de nvim, LazyVim nos da una base moderna con menos esfuerzo.

5. **OpenCode Agents** — Tenemos skills y subagentes; omerxx tiene agentes para OpenCode. Podemos tomar ideas para mejorar nuestros agentes.

6. **Atuin** — Historia de shell sincronizada y buscable. Evaluar si reemplaza o complementa nuestra config de history.

### Prioridad Baja (específico macOS o niche)

7. **Aerospace + skhd** — Si usamos macOS, vale explorar como tiling WM.
8. **SketchyBar** — Solo si queremos una barra de estado macOS más capaz.
9. **Nushell** — Interesante como experimento, pero no reemplaza zsh para nosotros.
10. **Karabiner** — Remapeo de teclas, solo macOS.

---

## 7. Resumen

| Dimensión | Nosotros (luismayta) | omerxx |
|---|---|---|
| **Madurez** | Alta — CI/CD, docs, tests, multi-plataforma | Media — macOS-focused, setup mínimo |
| **Complejidad** | Alta — modular, framework propio | Baja — plano, sin abstracciones |
| **Cobertura** | Amplia — devops, mobile, AI, security | Enfocada — productividad diaria, aesthetics |
| **Mantenibilidad** | Buena — estructurado, pero pesado | Excelente — simple de entender y modificar |
| **Innovación** | Skills AI, OpenSpec, automation stack | Television cables, tmux plugins, Nushell |

**Veredicto:** Nuestro dotfiles es un **framework** — poderoso, portable, professional. El de omerxx es un **toolkit** — ligero, enfocado, estéticamente refinado. Lo mejor que podemos tomar prestado es su simplicidad en ciertas áreas (stow, television, tmux plugins) mientras mantenemos nuestra columna vertebral modular.

---

*Reporte generado por Codi — Orquestador de CodipLab.*
*Construyamos algo grandioso. ⚡*
