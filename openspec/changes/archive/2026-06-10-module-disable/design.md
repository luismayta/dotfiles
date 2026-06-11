## Context

The `zsh/.zshrc` loads all modules from `zsh/modules/` with a glob loop:

```zsh
for __module_dir in "${DOTFILES_ZSH_DIR}"/modules/*(/N); do
  if [ -e "${__module_dir}/plugin.zsh" ]; then
    source "${__module_dir}/plugin.zsh"
  fi
done
```

There is no mechanism to skip a module. If a module's `plugin.zsh` errors (e.g., tmux calling a function defined later, or a missing dependency), the user cannot source their zshrc without moving the module directory or editing the core loading loop.

The existing codebase already uses `ZSH_*` environment variables for configuration (e.g., `ZSH_TMUX_AUTOSTART`, `ZSH_DEBUG`), making an env-var-based approach consistent with project conventions.

## Goals / Non-Goals

**Goals:**
- Allow users to skip specific modules by setting `ZSH_DISABLED_MODULES`
- Zero-config compatibility: unset/empty variable = load all modules (current behavior)
- Simple UX: space-separated list of directory names (e.g., `export ZSH_DISABLED_MODULES="tmux starship"`)
- Self-documenting: the mechanism should be obvious from the zshrc loop itself

**Non-Goals:**
- Per-module granularity beyond enable/disable (no per-module config inheritance)
- Runtime toggling (requires zshrc reload)
- A separate config file or state directory for module state

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Mechanism | `ZSH_DISABLED_MODULES` env var | Consistent with existing `ZSH_*` conventions; no new files or config formats |
| Separator | Space-delimited | Simplest for env vars; matches shell array conventions |
| Comparison | Exact directory basename match | Users write `tmux`, not path fragments; names are fixed per directory |
| Location | Skip inside existing `for __module_dir` loop | Single point of change; doesn't require loop restructuring |
| User config file | `~/.customrc` | Already sourced by zshrc; natural place for user to set `ZSH_DISABLED_MODULES` without editing core files |
| Bootstrap | Auto-copy `.customrc.example` → `~/.customrc` on first load | If `~/.customrc` doesn't exist, copy the template from the repo. The template lives in the repo as `.customrc.example` so it's version-controlled and users get it on clone |
| Sourcing order | Move `.customrc` source **before** the module loading loop | Currently at line 43, after modules. Must be before line 24 so `ZSH_DISABLED_MODULES` is set when the loop runs |
| Documentation | Update `zsh/modules/README.md` + create `~/.customrc` | README covers module authors; `.customrc` serves as discoverable template for end users |

## Risks / Trade-offs

- **Env var not available in all contexts** (e.g., sudo, GUI terminals) → User is responsible for setting it in their shell profile, same as any other `ZSH_*` variable
- **Module name changes** would break existing disable configs → Module directory names are stable (like package names); a rename would be a breaking change regardless
- **Spaces in module names** not supported → Module directories use single-word kebab-case names; no risk
