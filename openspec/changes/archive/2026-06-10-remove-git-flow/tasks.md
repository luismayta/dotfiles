## 1. Git Module — Remove git-flow package installation

- [x] 1.1 Remove `GIT_FLOW_PACKAGE_NAME=gitflow-avh` from `zsh/modules/git/config/linux.zsh` (line 3)
- [x] 1.2 Remove `core::ensure "${GIT_FLOW_PACKAGE_NAME:-git-flow}"` from `zsh/modules/git/internal/main.zsh` (line 24)

## 2. Git Module — Remove git-flow helpers and functions

- [x] 2.1 Remove `gitflow::is_installed` function from `zsh/modules/git/pkg/base.zsh` (lines 4-13)
- [x] 2.2 Remove `gff` function from `zsh/modules/git/pkg/base.zsh` (lines 20-43)
- [x] 2.3 Remove `git::internal::gitflow::branch::develop` from `zsh/modules/git/internal/base.zsh` (lines 54-57)
- [x] 2.4 Remove `git::internal::gitflow::branch::base` from `zsh/modules/git/internal/base.zsh` (lines 59-62)
- [x] 2.5 Remove `git::internal::gitflow::validate::exist::develop` from `zsh/modules/git/internal/base.zsh` (lines 64-72)
- [x] 2.6 Remove `git::internal::gitflow::validate::exist::master` from `zsh/modules/git/internal/base.zsh` (lines 75-83)
- [x] 2.7 Remove `git::internal::gitflow::has_master::configured` from `zsh/modules/git/internal/base.zsh` (lines 86-89)
- [x] 2.8 Remove `git::internal::gitflow::has_develop::configured` from `zsh/modules/git/internal/base.zsh` (lines 91-94)
- [x] 2.9 Remove `git::internal::gitflow::setup` from `zsh/modules/git/internal/base.zsh` (lines 96-101)

## 3. Issues Module — Remove git-flow workflow detection and execution

- [x] 3.1 Remove git-flow detection block from `zsh/modules/issues/internal/base.zsh` (lines 31-38)
- [x] 3.2 Remove `gitflow)` case block from `zsh/modules/issues/workflow/main.zsh` (lines 20-22)
- [x] 3.3 Delete `zsh/modules/issues/workflow/gitflow.zsh`

## 4. Issues Module — Clean up git-flow conditional call sites

- [x] 4.1 Remove the git-flow branch check in `zsh/modules/git/internal/base.zsh` line 155 (conditional on develop branch name)
- [x] 4.2 Remove the git-flow develop branch checkout in `zsh/modules/git/internal/base.zsh` line 204

## 5. Documentation clean-up

- [x] 5.1 Remove GitFlow comparative reference from `docs/contribute/github-flow.md` (line 3)