# Task: Fix bootstrap macOS: brew formulas/casks, nix-darwin experimental features, colores ANSI

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Corregir 3 bugs del bootstrap en macOS: cask 'ag' inexistente, nix-command deshabilitado y colores ANSI sin renderizar.
- component: DevOps
- labels: [dotfiles, bootstrap]
- parentEpic: 
- issueKey: RD-272
- jpdSource: 

## Scenario

El script `install.sh` de los dotfiles fallaba al ejecutarse en macOS, impidiendo completar el bootstrap. Tres defectos lo bloqueaban:

1. `PACKAGES_MAC` mezclaba formulas y casks, y `brew install --cask ag` fallaba porque `ag` no es un cask (es la formula `the_silver_searcher`), abortando el script por `set -euo pipefail`.
2. `nix run nix-darwin` fallaba con `experimental Nix feature 'nix-command' is disabled`: Nix recién instalado no habilita las features experimentales, y el `nix.settings` del flake solo aplica después del primer `switch` (chicken-and-egg).
3. `common/colors.sh` definía los colores con comillas dobles (`"\033[...]"`), que en bash guardan el backslash literal, y `printf '%s'` no lo interpreta — los mensajes imprimían `\033[0;36m` como texto en vez de renderizar color.


### Acceptance Tests

1. `config/packages.sh` separa `PACKAGES_MAC` en `PACKAGES_MAC_FORMULA` (the_silver_searcher, cmake) y `PACKAGES_MAC_CASK` (font-source-code-pro), con `readonly` actualizado.
2. `install.sh` instala formulas sin `--cask` y casks por separado; ya no falla con `Cask 'ag' is unavailable`.
3. El bootstrap de nix-darwin en `install.sh` pasa `--extra-experimental-features "nix-command flakes"`; ya no falla con `nix-command is disabled`.
4. `common/colors.sh` usa ANSI-C quoting (`$'\033[...'`); `bash -c 'source common/colors.sh; printf %s "$C_BLUE" | od -c'` muestra el byte ESC real (033).
5. `bash -n` y `shellcheck` pasan limpios en `install.sh`, `config/packages.sh` y `common/colors.sh`.


### Sources

- https://github.com/LnL7/nix-darwin
- https://nixos.org/manual/nix/stable/command-ref/experimental-features.html

- https://github.com/luismayta/dotfiles.git