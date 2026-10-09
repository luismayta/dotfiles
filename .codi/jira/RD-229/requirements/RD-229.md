# Task: Agregar DuckDB al módulo devops de dotfiles

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Instalar DuckDB como herramienta DevOps del módulo devops vía curl | bash
- component: DevOps
- labels: [devops, duckdb, tooling, dotfiles]
- parentEpic:
- issueKey: RD-229
- jpdSource:

## Scenario

Como developer de CodipLabs, necesito ejecutar consultas analíticas SQL sobre archivos locales (CSV, Parquet, JSON) sin levantar un servidor de base de datos ni agregar dependencias al sistema. Hoy no hay ninguna herramienta de este tipo disponible en el entorno de shell, lo que obliga a instalar binarios manualmente fuera de la gestión declarativa de dotfiles.

DuckDB se integra como una tool del módulo `devops`, instalada mediante el instalador oficial `curl https://install.duckdb.org | bash`, expuesta por el mismo contrato que las demás herramientas del módulo (install / upgrade / post_install) y cargada automáticamente en el PATH al iniciar el shell.


### Acceptance Tests

- existe `zsh/modules/devops/config/duckdb.zsh` con `DEVOPS_DUCKDB_INSTALL_URL` apuntando a `https://install.duckdb.org` y `DEVOPS_DUCKDB_ROOT_BIN` apuntando a `~/.duckdb/bin`
- existe `zsh/modules/devops/internal/duckdb.zsh` con `internal::install`, `internal::upgrade`, `internal::load` y `internal::main::factory`, e invoca `load` y `main::factory` al final del archivo
- existe `zsh/modules/devops/pkg/duckdb.zsh` exponiendo `devops::duckdb::{install,upgrade,is_installed,post_install}`
- `config/main.zsh`, `internal/main.zsh` y `pkg/main.zsh` sourcean el nuevo archivo
- `~/.duckdb/bin` queda en el PATH tras cargar el módulo
- el comando `duckdb` no se reinstala en cada arranque (factory es idempotente)
- `zsh -n` pasa sin errores en los 6 archivos nuevos y editados


### Sources

- instalador oficial: https://install.duckdb.org
- módulo destino: zsh/modules/devops (patrón de referencia: zsh/modules/devops/internal/atuin.zsh)
- https://github.com/luismayta/dotfiles.git