# Task: Implementar journal.nvim para daily notes en Neovim

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Agregar plugin journal.nvim para notas diarias centralizadas en el módulo nvim
- component: Platform Engineering
- labels: [feature, platform-engineering]
- parentEpic: 
- issueKey: PE-641
- jpdSource: 

## Scenario

El usuario necesita un flujo de daily notes tipo Obsidian dentro de Neovim: un archivo Markdown por día (YYYY-MM-DD.md) en una ruta absoluta fija, abrible desde cualquier directorio de trabajo, sin depender de la app Obsidian.

La investigación previa (ver fuentes) determinó que journal.nvim (jakobkhansen, MIT) cumple los tres requisitos: notas diarias con fecha en el nombre, raíz configurable independiente del cwd, y comando global :Journal.

La implementación se realiza en el módulo nvim de este dotfiles: la fuente de verdad es zsh/modules/nvim/data/, sincronizada a ~/.config/nvim mediante nvim::sync (rsync). lazy.nvim auto-descubre las specs en zsh/modules/nvim/data/lua/plugins/*.lua, por lo que basta crear un archivo por plugin.


### Acceptance Tests

1. Crear zsh/modules/nvim/data/lua/plugins/journal.lua con la spec lazy.nvim de jakobkhansen/journal.nvim.
2. Configurar filetype = "md", root a una ruta absoluta fija y journal.entries.day.format = "%Y-%m-%d" (archivos planos tipo Obsidian, no la ruta anidada por defecto).
3. Verificar con task lint (luac -p) que el archivo es válido y respetar .stylua.toml (column_width 120, 2 espacios).
4. Ejecutar nvim::sync para sincronizar data/ a ~/.config/nvim.
5. Abrir nvim desde un directorio cualquiera y ejecutar :Journal day para confirmar que crea/abre <root>/YYYY-MM-DD.md.


### Sources

- .codi/inbox/research/researched/2026-11-19-neovim-daily-notes-plugins.md
- https://github.com/jakobkhansen/journal.nvim
- https://github.com/luismayta/dotfiles

- https://github.com/luismayta/dotfiles.git