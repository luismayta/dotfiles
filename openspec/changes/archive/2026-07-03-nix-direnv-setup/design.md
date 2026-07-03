## Context

El módulo nix (`zsh/modules/nix/`) maneja la instalación de Nix single-user y provee API pública (install, channels, gc, flake development). Actualmente no tiene integración con direnv.

El patrón de configuración de los módulos usa `data/sync/` para archivos que se rsyncan a `$HOME`:
- `git/data/sync/.gitconfig` → `~/.gitconfig`
- `core/data/` → `~/` (via `core::sync`)
- La función `module::sync` → `module::internal::config::sync` ejecuta `rsync`

`nix-direnv` es un plugin de direnv que cachea la evaluación del dev shell de Nix. En cache hit, sourcea el entorno cachead en ~0.1s en vez de re-evaluar cada vez.

## Goals / Non-Goals

**Goals:**
- Instalar `nix-direnv` como plugin global de direnv (vía `nix profile install`)
- Colocar `direnvrc` en `zsh/modules/nix/data/sync/.config/direnv/direnvrc`
- Crear función `nix::sync` que rsynce `data/sync/` a `$HOME`
- Agregar `nix` al array `DOTFILES_SYNC_MODULES` para que `dotfiles::sync` lo incluya
- Todos los proyectos flake usan `use flake` con la implementación cacheada automáticamente
- Zero cambios en `.envrc` de proyectos

**Non-Goals:**
- Modificar la API pública existente del módulo nix (`pkg/`) más allá de agregar `nix::sync`
- Cambiar `.envrc` de ningún proyecto
- Instalar direnv (se asume presente)
- Soportar la funcionalidad no-flake de nix-direnv (`use nix`)

## Decisions

| Decisión | Elección | Alternativas |
|----------|----------|-------------|
| **Ubicación del direnvrc** | `data/sync/.config/direnv/direnvrc` | Escribirlo desde script internal (va contra el patrón data/ del módulo) |
| **Mecanismo de deploy** | `rsync -avzh --progress "${NIX_DATA_PATH}/sync/" "${HOME}/"` | `cp` (no preserva estructura de directorios); script ad-hoc (duplica lógica) |
| **Instalación del paquete** | `nix profile install nixpkgs#nix-direnv` en script internal `.zsh` | Homebrew (dependencia no-Nix); git clone (frágil) |
| **Orquestación sync** | Agregar `nix` a `DOTFILES_SYNC_MODULES` en `core/pkg/sync.zsh` | Llamada manual (se olvida); hook separado (sobreingeniería) |

## Risks / Trade-offs

- **[Risk]** `nix profile install` requiere red en primera ejecución — **Mitigación**: operación Nix estándar, consistente con el resto del módulo
- **[Risk]** Si `~/.config/direnv/direnvrc` ya existe con contenido custom, rsync sobreescribe — **Mitigación**: igual que el manejo de git. El usuario es responsable de no editar archivos syncheados. Si necesita customizar, debe hacerlo en `data/`
- **[Trade-off]** nix-direnv global = versión compartida entre proyectos — aceptable porque nix-direnv es estable y backward-compatible
