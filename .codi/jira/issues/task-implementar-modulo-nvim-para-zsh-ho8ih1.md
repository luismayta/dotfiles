# Task: Implementar módulo nvim para Zsh

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Crear e implementar el módulo nvim en zsh/modules/ de dotfiles, integrando la configuración de nvimrc (luismayta/nvimrc)
- component:
- labels: [dotfiles, zsh, nvim, module]
- parentEpic:
- issueKey: HAD-83

## Scenario

El módulo nvim debe implementarse siguiendo la arquitectura estándar de módulos Zsh en dotfiles: capa config (variables de entorno), capa internal (lógica de instalación/actualización/limpieza), y capa pkg (API pública, aliases, helpers). Debe integrar el proyecto luismayta/nvimrc como configuración base de Neovim, permitiendo instalación automatizada, actualización vía git pull, y limpieza de cachés.

La configuración de nvimrc es una distribución LazyVim con soporte para LSP, AI (Avante, Sidekick), debugging (nvim-dap), testing (neotest), y múltiples lenguajes (Python, Rust, Go, TypeScript, Java, Terraform, Ansible, etc.).

El módulo debe residir en `zsh/modules/nvim/` y seguir la misma estructura de 3 capas con OS dispatch que los módulos existentes (git, docker, ghq, ai).

### Acceptance Tests

- Configurar variables de entorno con URL del repo nvimrc y paths de configuración
- Implementar función de install que clone nvimrc en ~/.config/nvim
- Implementar función de upgrade con git pull --ff-only desde el repo nvimrc
- Implementar función de clean que remueva cachés de nvim (~/.local/share/nvim, ~/.cache/nvim, ~/.local/state/nvim)
- Proveer alias vim → nvim
- Proveer helper editnvim para editar configuración de nvim
- Seguir patrón OS dispatch (linux/macos) en las 3 capas
- Auto-instalar nvimrc si no existe al cargar el módulo

### Sources:

- https://github.com/luismayta/nvimrc.git
- /home/lucho/Projects/src/github.com/luismayta/nvimrc

- https://github.com/luismayta/dotfiles.git
