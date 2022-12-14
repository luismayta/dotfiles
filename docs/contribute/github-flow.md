<!-- Space: Projects -->
<!-- Parent: Dotfiles -->
<!-- Title: Contributing GithubFlow Dotfiles -->
<!-- Label: Dotfiles -->
<!-- Label: Project -->
<!-- Label: Contributing -->
<!-- Label: GithubFlow -->
<!-- Include: ./../disclaimer.md -->
<!-- Include: ac:toc -->

To contribute to dotfiles project on [GitHub](https://github.com/luismayta/dotfiles), We use [GitHub Flow](https://githubflow.github.io/), it means that you should branch from the main repository and contribute back by making [pull request](https://github.com/luismayta/dotfiles/pulls).

GitHub Flow is very lightweight (especially compared to GitFlow). This workflow uses only two kinds of branches:

- Feature branch
- Main branch (previously called master)

The _feature_ branches are used to develop new features as well as fixes. These branches are usually created out of main.

Anything in the _main_ branch is deployable. The _main_ branch is expected to be deployed regularly and is considered stable.

For more information see [GitHub Flow](https://githubflow.github.io/)

## Getting started

To follow the instructions in this guide and start contributing to dotfiles project on GitHub:

1. **Fork** the repo on GitHub
2. **Clone** the project to your own machine

To synchronize with the main repository, add it to the remotes:

```bash
git remote add upstream  https://github.com/luismayta/dotfiles.git
```

Now your **upstream** points to **luismayta/dotfiles**.

## Branches

### master or main

The master branch contains production code and it stores the official release history.

### Feature Branch

Each new feature should reside in its own branch, which can be pushed to the central repository for backup/collaboration. But, instead of branching off of main, **feature branches** use develop as their parent branch.

- When a feature is complete, it gets merged back into main.

## Merge requirements

### No merge conflicts

Resolve any merge conflicts that may arise. If conflict occurs, a corresponding message will be displayed on the PR page on GitHub.

To resolve a conflict, run the following commands.

```bash
# checkout a branch you open PR from
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

## Code of Conduct

Please have a look at our [Code of Conduct](../code_of_conduct.md) before you write an Issue or make a PR.
