## Context

The devops module provides a consistent pattern for tool integration: config vars in `config/base.zsh`, internal implementation in `internal/<tool>.zsh`, public functions and aliases in `pkg/<tool>.zsh`. Each tool layer is sourced via the corresponding `main.zsh`. Currently kubectl, helm, tfenv, k9s, komiser, aws, and sync follow this pattern. gcloud is the last major cloud CLI missing from the module.

## Goals / Non-Goals

**Goals:**
- Add `gcloud` to `DEVOPS_TOOLS` so it installs via the standard devops package pipeline
- Provide shell completions (gcloud, gsutil, bq)
- Provide convenience aliases for the most common gcloud workflows (config, auth, compute, container/GKE)
- Manage GKE auth plugin component (`gke-gcloud-auth-plugin`) alongside gcloud itself
- Follow the exact same file/function/naming conventions as existing tools (kubectl, helm, tfenv)

**Non-Goals:**
- Wrap every gcloud command — only the most frequent operations (compute, GKE, config, auth)
- Create OS-specific config files (gcloud is cross-platform via the same SDK)
- Implement complex workflows like CI/CD integration or Terraform credential management

## Decisions

1. **Single internal file for gcloud** — unlike kubectl (which splits into krew, plugin, go), gcloud's internal surface is small enough for one file: `internal/gcloud.zsh`. Completions and component management coexist there.
2. **Component management separate from install** — `core::install` handles the SDK itself. Component management (`gcloud components install`) is a separate function (`devops::gcloud::components::install`) called during `after::install` to avoid slowing down the main install flow.
3. **GKE plugin as a component, not a separate tool** — `gke-gcloud-auth-plugin` is a gcloud component, not a standalone tool. It's installed via `gcloud components install gke-gcloud-auth-plugin` rather than being added to `DEVOPS_TOOLS`.
4. **No platform-specific files** — kubectl and helm have OS-specific files because their install paths differ. gcloud's SDK installs to a standard location via Homebrew on macOS and apt on Linux, and the devops `core::install` abstraction handles this.
5. **Auth helpers as functions, not aliases** — auth flows (`login`, `application-default login`) have conditional behavior (browser vs service-account) that warrants functions rather than simple aliases.

## Risks / Trade-offs

- [Component version drift] → Pin critical components like `gke-gcloud-auth-plugin` alongside the gcloud version requirement
- [Completion loading time] → gcloud completions are demand-loaded (not sourced at shell init) just like kubectl completions
- [GKE plugin not available] → `devops::gcloud::gke::get-credentials` checks for the plugin before calling `gcloud container clusters get-credentials`
