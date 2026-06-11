## ADDED Requirements

### Requirement: Template loader
The Templates module SHALL provide fzf-based template loading and clipboard copy for macOS and Linux.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/templates/plugin.zsh`
- **THEN** the module SHALL set `TEMPLATES_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_TEMPLATES_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads
- **THEN** `TEMPLATES_PACKAGE_NAME` SHALL be `templates`
- **AND** `TEMPLATES_TEMPLATES_PATH` SHALL be `$TEMPLATES_PATH/templates`

#### Scenario: Keybinding is registered
- **WHEN** the module loads
- **THEN** `^Xt` SHALL be bound to `templates::run` via `bindkey '^Xt' templates::run`

#### Scenario: Template run via fzf
- **WHEN** user runs `templates::run` (or presses `^Xt`)
- **THEN** the module SHALL present an fzf list of available templates
- **AND** SHALL load the selected template content
- **AND** SHALL copy the content to clipboard (pbcopy on macOS, xclip on Linux)

#### Scenario: Template directories exist
- **WHEN** the module loads
- **THEN** `$TEMPLATES_TEMPLATES_PATH/common/` SHALL exist with `meet.md` and `workshop.md`
- **AND** `$TEMPLATES_TEMPLATES_PATH/jira/cloud/` SHALL exist with `spike`, `issue`, `release`, `bug`, `story` templates
- **AND** `$TEMPLATES_TEMPLATES_PATH/jira/server/` SHALL exist with `spike`, `issue`, `release`, `bug`, `story` templates
- **AND** `$TEMPLATES_TEMPLATES_PATH/kubernetes/` SHALL exist with `ingress/basic.yml` and `statefulset/basic.yml`

#### Scenario: Internal template listing
- **WHEN** the module calls `templates::internal::list`
- **THEN** it SHALL return a list of all templates under `$TEMPLATES_TEMPLATES_PATH`

#### Scenario: Internal template finding
- **WHEN** the module calls `templates::internal::find` with a search query
- **THEN** it SHALL use `fzf` to filter templates by the query

#### Scenario: Internal template loading
- **WHEN** the module calls `templates::internal::load` with a template path
- **THEN** it SHALL read the template file content and echo it

#### Scenario: Dependency check
- **WHEN** the module loads
- **THEN** it SHALL ensure `rsync`, `most`, `less`, and `fzf` are installed