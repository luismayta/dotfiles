## Context

`zsh/modules/apps/config/base.zsh` manages categorized app name lists with cross-platform support via `__DARWIN`/`__LINUX` suffix arrays. At the end of the file, a 41-line OSTYPE resolution block assigns the correct suffix arrays to the non-suffixed `APPS_<CATEGORY>` variables consumed by `APPS_PACKAGES`.

Currently this block repeats the same 12 assignments across 3 branches (darwin/linux/fallback), creating 36 near-identical lines. Adding a new category requires touching 4 locations: the `__DARWIN` array, `__LINUX` array, all 3 branches of the if/elif/else, and the `APPS_PACKAGES` aggregate.

Zsh's `nameref` (`typeset -n`) provides variable indirection without `eval`, enabling a declarative category list + single loop to replace all 36 assignments.

## Goals / Non-Goals

**Goals:**
- Replace the 3-branch × 12-category if/elif/else resolution block with a category list + loop using `nameref`
- Maintain identical runtime behavior for all `APPS_<CATEGORY>` arrays and `APPS_PACKAGES`
- Keep the solution as pure zsh — no external tools, no eval
- Make adding a new category require exactly 2 touch points: the category list + APPS_PACKAGES (instead of current 4+)

**Non-Goals:**
- No change to `__DARWIN`/`__LINUX` array contents or naming convention
- No change to `osx.zsh` or `linux.zsh` OS-specific files
- No change to `APPS_PACKAGES` aggregate structure
- No new features or capabilities

## Decisions

### 1. Use `nameref` instead of `eval`

Use zsh's `nameref` (`typeset -n`) for variable indirection:
```zsh
nameref _src="APPS_${_category}${_APPS_SUFFIX}"
nameref _dst="APPS_${_category}"
_dst=("${_src[@]}")
```

**Why not `eval`**: `nameref` is type-safe, respects scope, and has no risk of code injection from variable content. `eval` would require manual escaping of array expansion syntax and is harder to read.

**Why not a function**: A function would close the scope, but `nameref` at top level with `unset` achieves the same cleanliness. Functions also need to be declared before use in zsh, adding ordering dependency.

### 2. Use a `typeset -a` category list array

```zsh
typeset -a _APPS_CATEGORIES=(
  IDE_TOOLS JETBRAINS COMMUNICATION KNOWLEDGE DEVOPS
  DATABASE_CLIENTS BROWSER ANDROID MOBILE VPN_CLIENTS
  PROJECT_MANAGEMENT WEB_APPS
)
```

The category names omit the `APPS_` prefix and `__DARWIN`/`__LINUX` suffix — these are added by the loop. Adding a new category means adding one entry here.

### 3. `unset` helper variables after resolution

After the loop, `unset` all helper variables (`_category`, _src, `_dst`, `_APPS_SUFFIX`, `_APPS_CATEGORIES`) to avoid polluting the shell namespace. These are internal implementation details with no value after resolution.

### 4. OSTYPE suffix selection unchanged

The suffix selection logic (if/elif/else on OSTYPE) stays as-is — it's already correct and minimal:
```zsh
if [[ "${OSTYPE}" =~ ^darwin ]]; then
  _APPS_SUFFIX="__DARWIN"
elif [[ "${OSTYPE}" =~ ^linux ]]; then
  _APPS_SUFFIX="__LINUX"
else
  _APPS_SUFFIX="__DARWIN"
fi
```

## Risks / Trade-offs

- **[Risk] `nameref` unsupported on older zsh versions** → `nameref` (`typeset -n`) has been available since zsh 4.3.x (released 2014). The dotfiles project targets zsh ≥ 5.x. Low risk. If compatibility becomes an issue, fallback to `eval` with the same loop structure.
- **[Risk] Helper variables visible during sourcing** → The `_APPS_CATEGORIES`, `_APPS_SUFFIX`, and loop variables are prefixed with `_` (convention for internal) and explicitly `unset` after the loop. They exist only transiently during source time.
- **[Risk] Loop obscures control flow** → The current explicit block is verbose but obvious. The loop + nameref is more idiomatic zsh once familiar. A comment above the loop explains the pattern.
