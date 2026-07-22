## 1. Guide Structure

- [x] 1.1 Create `docs/guides/implement-tool-in-module.md` file
- [x] 1.2 Add table of contents with links to all sections

## 2. Architecture Overview

- [x] 2.1 Write overview section explaining three-layer architecture for tool integration
- [x] 2.2 Document layer responsibilities (config → internal → pkg)
- [x] 2.3 Add diagram showing the loading sequence

## 3. Config Layer Documentation

- [x] 3.1 Document `config/<tool>.zsh` pattern with atuin example
- [x] 3.2 Explain `DEVOPS_<TOOL>_` naming convention for variables
- [x] 3.3 Document `DEVOPS_TOOLS` registration in `config/base.zsh`

## 4. Internal Layer Documentation

- [x] 4.1 Document `internal/<tool>.zsh` pattern with atuin example (shell hooks) and bruno example (PATH-only)
- [x] 4.2 Explain `core::exists` guard pattern
- [x] 4.3 Document `main::factory` auto-install pattern
- [x] 4.4 Document shell integration decision tree: "Does tool provide shell hooks? → eval pattern (atuin). No? → PATH-only pattern (bruno)"
- [x] 4.5 Document `path::prepend` for custom bin directories

## 5. Public Layer Documentation

- [x] 5.1 Document `pkg/<tool>.zsh` pattern with atuin example
- [x] 5.2 Explain thin wrapper pattern (install, upgrade, post_install)
- [x] 5.3 Document `post_install` guidance pattern

## 6. Naming Conventions

- [x] 6.1 Document function naming: `devops::<tool>::internal::<verb>` and `devops::<tool>::<verb>`
- [x] 6.2 Document variable naming: `DEVOPS_<TOOL>_` prefix
- [x] 6.3 Add examples table showing patterns

## 7. Testing Instructions

- [x] 7.1 Document module load test command
- [x] 7.2 Document function verification commands
- [x] 7.3 Document auto-install verification

## 8. Checklist

- [x] 8.1 Create scaffold checklist (all files exist)
- [x] 8.2 Create quality checklist (naming, guards, messages)
- [x] 8.3 Create "never" checklist (anti-patterns to avoid)

## 9. Reference Links

- [x] 9.1 Link to atuin implementation as reference (shell hooks example)
- [x] 9.2 Link to bruno implementation as reference (PATH-only example)
- [x] 9.3 Link to existing `create-module.md` guide
- [x] 9.4 Link to core utilities documentation
