## 1. Add missing SCM Breeze aliases to git module

- [x] 1.1 Add `gst`, `gfa`, `gm`, `grm`, `gcp`, `gbl` aliases to `zsh/modules/git/pkg/alias.zsh`
- [x] 1.2 Verify no alias conflicts with existing definitions or scmpuff builtins (`gs`, `ga`, `gd`, `gA`)
- [x] 1.3 Source the git module and test each new alias resolves to the correct git command

## 2. Remove scmbreeze module

- [x] 2.1 Delete `zsh/modules/scmbreeze/` directory and all its contents
- [x] 2.2 Verify no residual references to `scmbreeze`, `scm_breeze`, `SCMBREEZE`, or `ZSH_SCMBREEZE` in any `.zsh` file
- [x] 2.3 Source zshrc and confirm git workflows work without errors

## 3. Cleanup (optional manual)

- [x] 3.1 Optionally remove orphaned `~/.scm_breeze/` directory if present (not found, N/A)
