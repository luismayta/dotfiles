<!-- Space: Projects -->
<!-- Parent: Dotfiles -->
<!-- Title: Contributing GitFlow Dotfiles -->
<!-- Label: Dotfiles -->
<!-- Label: Project -->
<!-- Label: Contributing -->
<!-- Label: GitFlow -->
<!-- Include: ./../disclaimer.md -->
<!-- Include: ac:toc -->

To contribute to dotfiles project on [GitHub](https://github.com/luismayta/dotfiles), We use Gitflow (See more [here](https://datasift.github.io/gitflow/IntroducingGitFlow.html)) In a nutshell, it means that you should branch from the main repository and contribute back by making [pull request](https://github.com/luismayta/dotfiles/pulls).

![workflow gitflow](https://datasift.github.io/gitflow/GitFlowHotfixBranch.png)

## Getting started

To follow the instructions in this guide and start contributing to dotfiles project on Gitlab:

1.  **Fork** the repo on GitHub
2.  **Clone** the project to your own machine

To synchronize with the main repository, add it to the remotes:

```bash
git remote add upstream  https://github.com/luismayta/dotfiles.git
```

Now your **upstream** points to **luismayta/dotfiles**.

## Branches

### master or main

The master branch contains production code and it stores the official release history.

### develop

The develop branch contains pre-production code and serves as an integration branch for features.

### Feature Branch

Each new feature should reside in its own branch, which can be pushed to the central repository for backup/collaboration. But, instead of branching off of master, **feature branches** use develop as their parent branch.

- When a feature is complete, it gets merged back into develop.
- Features should never interact directly with master.

### Release Branch

Once develop has acquired enough features for a release (or a predetermined release date is approaching), you fork a release branch off of develop. Creating this branch starts the next release cycle, so no new features can be added after this point — only bug fixes, documentation generation, and other release-oriented tasks should go in this branch.

### Hotfix Branch

Maintenance or **hotfix** branches are used to quickly patch production releases. Hotfix branches are necessary to act immediately upon an undesired status of master. Hotfix branches are a lot like release branches and feature branches except they’re based on master instead of develop. This is the only branch that should fork directly off of master. As soon as the fix is complete, it should be merged into both master and develop (or the current release branch), and master should be tagged with an updated version number.

## Merge requirements

### No merge conflicts

Resolve any merge conflicts that may arise. If conflict occurs, a corresponding message will be displayed on the PR page on Github.

To resolve a conflict, run the following commands.

```bash
# checkout a branch you open MR from
git fetch upstream # assuming upstream is luismayta/dotfiles
git merge upstream/merge_branch # Where merge_branch is a branch you open merge request against.
# resolve merge requests
git add changed_files
git commit
git push
```

Github will automatically update your pull request.

### Testing

All merge requests are automatically tested using [Github Actions](https://github.com/luismayta/dotfiles/actions). In case some tests fail, fix the issues or describe why the fix cannot be done.

### Review

Every pull request is reviewed by the assigned team members as per standard [Pull Request](https://opensource.com/article/19/7/create-pull-request-github). Reviewers can comment on a PR, approve it, or request changes to it. A PR can be merged when it is approved by at least two assigned reviewers and has no pending requests for changes.

## Gatekeepers or Maintainers

Gatekeeper is a person responsible for the final review and merge. They are also responsible for managing Git repositories. Only gatekeepers can write to **master** or **main**, **develop**, **hotfix** and **release** branches.

If a pull request meets all merge requirements, one of the gatekeepers performs the final review and merges the PR branch.
