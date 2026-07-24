# HAD-89: Implement GitHub CLI (gh) in devops module with gh-dash extension

## Contenido Fuente

### Scenario

The devops zsh module (`zsh/modules/devops/`) already lists `github-cli` in `DEVOPS_TOOLS` (config/base.zsh:13) but has no actual implementation. The module follows a strict 3-layer architecture:

- **config/** → Environment variables, package names, paths
- **internal/** → Private functions, installation logic (`core::ensure`, `core::install`)
- **pkg/** → Public functions (install, upgrade, sync, post_install, aliases)
- **data/** → Configuration files to sync via rsync

All layers are wired through `main.zsh` files. Each tool follows this pattern (see k9s, helm, bruno as references). The task is to create the full gh CLI integration and install the gh-dash dashboard extension.

### Acceptance Tests

- [ ] `config/gh.zsh` exists with env vars: `DEVOPS_GH_PACKAGE_NAME=gh`, `DEVOPS_GH_CONF_PATH`, `DEVOPS_GH_DASH_CONF_PATH`
- [ ] `pkg/gh.zsh` exposes public functions: `devops::gh::install`, `devops::gh::upgrade`, `devops::gh::post_install`, `devops::gh::sync`
- [ ] `internal/gh.zsh` handles installation via `core::ensure gh`, completions setup, and gh-dash extension install
- [ ] `data/gh/` directory exists with gh-dash config file (`config.yaml`)
- [ ] `config/main.zsh` sources `config/gh.zsh` (add before the `case` block)
- [ ] `pkg/main.zsh` sources `pkg/gh.zsh` (add in the tool package layers section)
- [ ] `internal/main.zsh` sources `internal/gh.zsh` (add in the tool internal layers section)
- [ ] Zsh completions are enabled for gh via `gh completion -s zsh` in `internal/gh.zsh`
- [ ] gh-dash is installed as gh extension via `gh extension install dlvhdr/gh-dash` in `internal/gh.zsh`
- [ ] Alias `ghd` launches gh-dash (defined in `pkg/gh.zsh`)
- [ ] Function `editghdash` opens gh-dash config in `$EDITOR` (defined in `pkg/gh.zsh`)
- [ ] `devops::gh::sync` rsyncs `data/gh/` to `~/.config/gh-dash/`

### Sources

- https://cli.github.com/
- https://github.com/dlvhdr/gh-dash
- Module pattern references: `zsh/modules/devops/pkg/k9s.zsh`, `internal/k9s.zsh`, `config/base.zsh`
- Existing `github-cli` entry: `zsh/modules/devops/config/base.zsh:13`

---

## Enriquecimiento

Status: skipped_no_context_queries

### CodeGraph Enrichment

Status: applied

#### codegraph_explore: `devops::k9s::install devops::helm::internal::main::factory core::ensure`

```zsh
# From pkg/k9s.zsh
function devops::k9s::install {
    devops::k9s::internal::main::factory
}

function devops::k9s::upgrade {
    core::upgrade k9s
}

function devops::k9s::post_install {
    message_info "Post Install ${DEVOPS_K9S_PACKAGE_NAME}"
    devops::k9s::sync
    message_success "Success Install ${DEVOPS_K9S_PACKAGE_NAME}"
}

function devops::k9s::sync {
    message_info "k9s sync conf for ${DEVOPS_K9S_PACKAGE_NAME}"
    rsync -avzh --progress "${DEVOPS_PATH}/data/k9s/" "${DEVOPS_K9S_CONF_PATH}/"
    message_success "sync for ${DEVOPS_K9S_PACKAGE_NAME}"
}

# From internal/k9s.zsh
function devops::k9s::internal::main::factory {
    core::ensure k9s
}
devops::k9s::internal::main::factory

# From internal/helm.zsh
function devops::helm::internal::main::factory {
    core::ensure helm
}
devops::helm::internal::main::factory

# From internal/bruno.zsh — shows pattern for non-homebrew tools
function devops::bruno::internal::bru::install {
    if ! core::exists bun; then
        message_error "bun is required to install ${DEVOPS_BRUNO_PACKAGE_NAME}"
        return 1
    fi
    message_info "Installing ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
    ${DEVOPS_BRUNO_INSTALL_CMD} "${DEVOPS_BRUNO_CLI_PACKAGE}"
    message_success "Installed ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
}

function devops::bruno::internal::sync {
    message_info "Syncing ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avhP --no-perms "${DEVOPS_BRUNO_DATA_PATH}/" "${HOME}/.config/bruno/"
    message_success "Synced ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
}

devops::bruno::internal::load
if ! core::exists bru; then devops::bruno::internal::bru::install; fi
```

#### codegraph_node: `config/base.zsh`

```zsh
# Key excerpt — DEVOPS_TOOLS already includes github-cli:
export DEVOPS_TOOLS=(
  atuin
  github-cli    # <-- already listed, no implementation exists
  glab
  google-cloud-cli
  helm
  k9s
  kubectl
  packer
  sops
  telepresenceio/telepresence/telepresence-oss
  terraform-docs
  terragrunt
  tfenv
  worktrunk
  zoxide
)
```

---

## Instrucciones

Genera una especificación OpenSpec en markdown, en inglés, con trazabilidad a HAD-89.

Rules:
- Usa SOLO la información proporcionada — NO inventes información
- Convierte acceptance tests en requerimientos usando MUST / SHOULD / MAY
- Incluye file paths del enrichment como contexto de código relevante
- Sigue el patrón exacto de 3-capas (config/internal/pkg/data) documentado arriba
- El archivo `data/gh/config.yaml` DEBE contener la configuración default de gh-dash con sections para PRs, issues, y repos
- Las completions de zsh se generan con `gh completion -s zsh` y se cachean en `data/gh/completions.zsh`
