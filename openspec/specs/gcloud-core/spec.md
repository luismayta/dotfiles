## ADDED Requirements

### Requirement: gcloud SDK is installable via devops toolchain
The devops module SHALL include `google-cloud-sdk` in `DEVOPS_TOOLS` so it gets installed through the standard `core::install` pipeline.

#### Scenario: Default install
- **WHEN** the devops module loads and `gcloud` is not installed
- **THEN** `core::install google-cloud-sdk` SHALL be called to install it

### Requirement: Shell completions are loaded for gcloud, gsutil, and bq
The gcloud SDK bundles its zsh completion as `completion.zsh.inc`. The system SHALL load it via `devops::internal::completion::cached gcloud --source <inc>`, which copies the inc file into the cache and sources the cached completion script at `$DOTFILES_CACHE_PATH/gcloud-completion.zsh` (fallback `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions/`), so that tab-completion works for `gcloud`, `gsutil`, and `bq`.

#### Scenario: Completion loading after install
- **WHEN** `gcloud` is available on the PATH
- **THEN** the cached completion script SHALL be sourced, regenerating the cache when it is missing, older than 30 days, or older than the SDK's `completion.zsh.inc`

#### Scenario: SDK completion file absent
- **WHEN** no `completion.zsh.inc` can be resolved
- **THEN** loading SHALL skip silently without invoking `gcloud`, sourcing the existing cache if present

### Requirement: Core gcloud configuration is available
The devops module SHALL export `DEVOPS_GCLOUD_CONFIG_ROOT` pointing to `$HOME/.config/gcloud` and optionally set `CLOUDSDK_CORE_PROJECT`, `CLOUDSDK_COMPUTE_REGION`, and `CLOUDSDK_COMPUTE_ZONE` from user-defined defaults.

#### Scenario: Config path
- **WHEN** the devops module loads
- **THEN** `DEVOPS_GCLOUD_CONFIG_ROOT` SHALL be set to `$HOME/.config/gcloud`

#### Scenario: Default project (optional)
- **WHEN** `ZSH_DEVOPS_GCLOUD_PROJECT` is set
- **THEN** `CLOUDSDK_CORE_PROJECT` SHALL be exported with that value

### Requirement: Auth helper functions are provided
The module SHALL expose `devops::gcloud::auth::login` and `devops::gcloud::auth::application_default` for interactive and application-default authentication.

#### Scenario: Interactive login
- **WHEN** `devops::gcloud::auth::login` is called
- **THEN** `gcloud auth login` SHALL be executed

#### Scenario: Application-default login
- **WHEN** `devops::gcloud::auth::application_default` is called
- **THEN** `gcloud auth application-default login` SHALL be executed

### Requirement: GKE auth plugin component is installable
The module SHALL provide `devops::gcloud::components::install` that installs `gke-gcloud-auth-plugin` via `gcloud components install`.

#### Scenario: Component install
- **WHEN** `devops::gcloud::components::install` is called
- **THEN** `gcloud components install gke-gcloud-auth-plugin` SHALL be executed (non-interactive)

### Requirement: Convenience aliases for config operations
The following aliases SHALL be defined:
- `gconf` → `gcloud config`
- `gprojects` → `gcloud projects list`

#### Scenario: Config alias
- **WHEN** the module loads
- **THEN** `gconf` SHALL expand to `gcloud config`

#### Scenario: Projects list alias
- **WHEN** the module loads
- **THEN** `gprojects` SHALL expand to `gcloud projects list`
