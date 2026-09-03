# Helix Themes

Place custom `.toml` theme files in this directory. Helix will automatically
discover themes from `$XDG_DATA_HOME/helix/themes/` or `~/.config/helix/themes/`.

To use a custom theme, add it here and it will be synced to the helix config
directory when `helix::sync` is run.

## Theme Format

A minimal Helix theme file (e.g. `mytheme.toml`):

```toml
# UI colors
"ui.normal" = { bg = "1e1e2e", fg = "cdd6f4" }
"ui.text.focus" = { fg = "cdd6f4" }
"ui.selection" = { bg = "45475a" }
"ui.cursor" = { bg = "f5e0dc", fg = "1e1e2e" }
"ui.cursor.primary" = { bg = "f5e0dc", fg = "1e1e2e" }
"ui.linenr" = { fg = "6c7086" }
"ui.linenr.selected" = { fg = "cdd6f4" }
"ui.statusline" = { fg = "cdd6f4", bg = "313244" }
"ui.popup" = { bg = "313244" }
"ui.window" = { fg = "313244" }
"ui.menu" = { fg = "cdd6f4", bg = "313244" }
"ui.menu.selected" = { fg = "1e1e2e", bg = "cdd6f4" }

# Syntax highlighting
"attribute" = { fg = "f9e2af" }
"comment" = { fg = "6c7086", modifiers = ["italic"] }
"constant" = { fg = "fab387" }
"constant.numeric" = { fg = "fab387" }
"constant.character.escape" = { fg = "a6e3a1" }
"function" = { fg = "89b4fa" }
"keyword" = { fg = "cba6f7" }
"keyword.control" = { fg = "cba6f7" }
"label" = { fg = "f9e2af" }
"namespace" = { fg = "f9e2af" }
"operator" = { fg = "89dceb" }
"punctuation" = { fg = "9399b2" }
"storage" = { fg = "cba6f7" }
"string" = { fg = "a6e3a1" }
"type" = { fg = "f9e2af" }
"variable" = { fg = "cdd6f4" }
"variable.other" = { fg = "cdd6f4" }

# Diagnostics
"diagnostic.hint" = { underline = { style = "curl" } }
"diagnostic.info" = { underline = { style = "curl" } }
"diagnostic.warning" = { underline = { style = "curl" } }
"diagnostic.error" = { underline = { style = "curl" } }
```
