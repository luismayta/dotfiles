## Context

El módulo `zsh/modules/apps/` tiene una arquitectura de 3 capas:
- `config/base.zsh` — definiciones de apps comunes (hoy con nombres macOS)
- `config/osx.zsh` — apps exclusivas de macOS (raycast, unite, orbstack, arc, tunnelblick)
- `config/linux.zsh` — placeholder vacío para Linux

El `config/main.zsh` carga `base.zsh` primero, luego el OS-specific via `case $OSTYPE`.
El core de instalación usa `brew` en macOS y `paru` en Linux (CachyOS/Arch).

Actualmente `base.zsh` tiene nombres Homebrew cask que **no funcionan en Linux**. Necesitamos:
1. Nombres macOS (brew) preservados
2. Nombres Linux (Arch packages: official repo + AUR)
3. Resolución automática por OS

## Goals / Non-Goals

**Goals:**
- Reestructurar `base.zsh` al formato goenv (header, secciones, comentarios)
- Renombrar arrays actuales a sufijo `__DARWIN` (APPS_BROWSER → APPS_BROWSER__DARWIN)
- Añadir arrays `__LINUX` con nombres de paquetes Arch Linux
- Bloque de resolución vía `$OSTYPE` al final de `base.zsh`
- Poblar `config/linux.zsh` con apps exclusivas de Linux
- Preservar `config/osx.zsh` y `APPS_PACKAGES` sin cambios

**Non-Goals:**
- No cambiar el mecanismo de instalación (brew/paru según core)
- No añadir nuevas categorías de apps
- No soportar otras distros Linux fuera de Arch/CachyOS
- No soportar Windows

## Decisions

### 1. Nomenclatura: sufijo `__DARWIN` / `__LINUX`

Se usa doble underscore para evitar colisiones con nombres de variable existentes.

```zsh
# Antes (solo macOS)
APPS_BROWSER=(brave-browser)

# Después
APPS_BROWSER__DARWIN=(brave-browser)
APPS_BROWSER__LINUX=(brave-bin)
```

### 2. Resolución vía `$OSTYPE` al final de base.zsh

```zsh
if [[ "${OSTYPE}" =~ ^darwin ]]; then
  APPS_BROWSER=("${APPS_BROWSER__DARWIN[@]}")
elif [[ "${OSTYPE}" =~ ^linux ]]; then
  APPS_BROWSER=("${APPS_BROWSER__LINUX[@]}")
else
  APPS_BROWSER=("${APPS_BROWSER__DARWIN[@]}")
fi
```

### 3. Nombres Linux = Arch Linux packages

Linux usa `paru` (AUR helper de CachyOS/Arch), los nombres deben ser paquetes de Arch:

| macOS (brew cask) | Linux (Arch package) | Repo |
|---|---|---|
| tig | tig | Official (extra) |
| meld | meld | Official (extra) |
| jetbrains-toolbox | jetbrains-toolbox | AUR |
| intellij-idea-ce | intellij-idea-community-edition | Official (extra) |
| discord | discord | AUR |
| obsidian | obsidian-bin | AUR |
| drawio | drawio-desktop | Official (extra) |
| multipass | canonical-multipass | AUR |
| ngrok | ngrok | AUR |
| dbeaver-community | dbeaver | Official (extra) |
| beekeeper-studio | beekeeper-studio-bin | AUR |
| redisinsight | redisinsight-bin | AUR |
| datagrip | datagrip | AUR |
| brave-browser | brave-bin | AUR |
| android-studio | android-studio | AUR |
| android-platform-tools | android-platform-tools | AUR |
| genymotion | genymotion | AUR |
| watchman | watchman-bin | AUR |
| fastlane | *(gem ruby)* | *(sin package)* |
| openvpn | openvpn | Official (extra) |
| wireguard | wireguard-tools | Official (extra) |
| wireguard-tools | wireguard-tools | Official (extra) |
| jira-cli | jira-cli | AUR |
| pake | `core::cargo::install pake` | cargo (vía rust module) |

**Nota**: `pake` es una herramienta CLI de Rust (no una app GUI). En Linux no tiene package en Arch — se instala vía `core::cargo::install pake`, que ejecuta `cargo install pake`. El array `APPS_WEB_APPS__LINUX` queda vacío porque pake se maneja fuera del flujo `APPS_PACKAGES`/paru, mediante el rust module o instalación manual.

### 4. Formato goenv

Se adopta el mismo header que `zsh/modules/goenv/config/base.zsh`:
- `#!/usr/bin/env ksh`
- encoding comment
- bloque File/Description
- `shellcheck shell=bash`
- secciones con `# Section Name`
- inline comments en variables

### 5. OS extras se mantienen separados

- `config/osx.zsh` — sin cambios: raycast, unite, orbstack, arc, tunnelblick (ya funciona)
- `config/linux.zsh` — se puebla con apps exclusivas de Linux cuando aplique

## Risks / Trade-offs

- **[Risk] Algunos paquetes AUR pueden cambiar de nombre** → Mitigation: Usar nombres estables y populares (e.g., `obsidian-bin` en vez de `obsidian` que es un paquete diferente). Los alias en `provides` de AUR ayudan.
- **[Risk] fastlane y pake no tienen system package en Linux** → Mitigation: fastlane se maneja vía RubyGems (gem install). pake se instala vía `core::cargo::install pake` (cargo). Ambos fuera del flujo paru de APPS_PACKAGES. Sus arrays `__LINUX` quedan vacíos.
- **[Risk] Romper APPS_PACKAGES** → Mitigation: El aggregate referencía los arrays resueltos (no los `__DARWIN`/`__LINUX`) porque los `APPS_<CATEGORY>` públicos se setean antes del aggregate.
- **[Risk] Duplicación visual** — Mitigation: Tener ambos OS side-by-side es explícito y mantenible, mejor que archivos separados por categoría.
