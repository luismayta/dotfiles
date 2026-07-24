## 1. Removal & Cleanup

- [x] 1.1 Remove `git-wtf` script from `zsh/modules/git/bin/`
- [x] 1.2 Remove `git-root-directory` script (redundant with `git-root`)
- [x] 1.3 Check for aliases referencing removed scripts in dotfiles, update if found

## 2. Shebang Unification

- [x] 2.1 Audit all 23 remaining scripts for current shebang
- [x] 2.2 Update scripts with `#!/bin/sh` to `#!/usr/bin/env bash`
- [x] 2.3 Update scripts with `#!/bin/bash` to `#!/usr/bin/env bash`
- [x] 2.4 Verify scripts already using `#!/usr/bin/env bash` are unchanged

## 3. git-status-enhanced Implementation

- [x] 3.1 Create `git-status-enhanced` script skeleton with argument parsing
- [x] 3.2 Implement branch state display (ahead/behind counts)
- [x] 3.3 Implement remote branch comparison (deleted, diverged, new)
- [x] 3.4 Implement `--all` flag for multi-branch overview
- [x] 3.5 Implement `--short` flag for compact output
- [x] 3.6 Implement integration branch detection (main/master)
- [x] 3.7 Add color coding and formatting

## 4. git-change-author Modernization

- [x] 4.1 Add `git-filter-repo` availability check
- [x] 4.2 Replace `git filter-branch` with `git filter-repo` when available
- [x] 4.3 Add fallback to `git filter-branch` with deprecation warning

## 5. Test Framework Setup

- [x] 5.1 Install bats-core (or add as submodule)
- [x] 5.2 Create `tests/` directory structure
- [x] 5.3 Create test helper functions (`setup_git_repo`, `cleanup_git_repo`)
- [x] 5.4 Create `tests/run.sh` test runner script

## 6. Test Implementation

- [ ] 6.1 Write tests for `git-root` (correct path, --relative, outside repo)
- [ ] 6.2 Write tests for `git-publish` (push, upstream tracking)
- [ ] 6.3 Write tests for `git-delete-local-merged` (merged deletion, unmerged preservation)
- [ ] 6.4 Write tests for `git-status-enhanced` (all scenarios from spec)
- [ ] 6.5 Write tests for `git-sync` (fetch, merge, push workflow)
- [ ] 6.6 Verify all tests pass

## 7. Documentation

- [ ] 7.1 Add usage comment header to all scripts missing it
- [ ] 7.2 Create `zsh/modules/git/README.md` with module overview
- [ ] 7.3 Add script listing table (name, description, usage) to README
- [ ] 7.4 Add installation instructions to README
- [ ] 7.5 Add top 5 usage examples to README

## 8. Final Verification

- [ ] 8.1 Run all tests and confirm passing
- [ ] 8.2 Manually verify `git-status-enhanced` works in a test repo
- [ ] 8.3 Verify no broken aliases or references to removed scripts
- [ ] 8.4 Review all scripts for consistent formatting