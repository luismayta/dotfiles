---
type: Guide
title: GitHub Flow
description: Contribution workflow using GitHub Flow
tags: [contribute, github, guide]
---

Contributions to the [dotfiles](https://github.com/luismayta/dotfiles) project follow [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow): branch from `main`, make changes, and submit a [pull request](https://github.com/luismayta/dotfiles/pulls/new).

GitHub Flow is lightweight. It uses only two kinds of branches:

- **Main** (`main`) — production-ready, always deployable
- **Feature branches** — short-lived branches for new features or fixes, created from `main`

When a feature is complete, its branch is merged back into `main` via a pull request.

## Getting started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Add the upstream remote** to sync with the main repository:

```bash
git remote add upstream https://github.com/luismayta/dotfiles.git
```

Now `upstream` points to `luismayta/dotfiles` and `origin` points to your fork.

## Syncing your fork

Before starting new work, sync your fork with upstream:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

## Branches

### `main`

Contains production code and the official release history. Every commit on `main` should be deployable.

### Feature branches

Create a new branch for each feature or fix:

```bash
git checkout main
git checkout -b feat/my-feature
```

Use a descriptive name: `feat/description`, `fix/description`, or `chore/description`.

When the feature is complete, push the branch and open a pull request:

```bash
git push origin feat/my-feature
```

## Pull request requirements

### No merge conflicts

If GitHub shows a conflict, resolve it locally:

```bash
git fetch upstream
git checkout feat/my-feature
git merge upstream/main
# resolve conflicts, then:
git add <resolved-files>
git commit
git push
```

GitHub updates the PR automatically after the push.

### Tests must pass

All pull requests are automatically tested via [GitHub Actions](https://github.com/luismayta/dotfiles/actions). If tests fail, fix the issues or explain why they cannot be fixed.

### Code review

Every pull request is reviewed by at least one maintainer. Reviewers may comment, approve, or request changes. A PR can be merged once it is approved and has no pending change requests.

## Code of Conduct

Please read our [Code of Conduct](../code_of_conduct.md) before submitting an issue or pull request.