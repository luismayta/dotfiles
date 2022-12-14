<!-- Space: Projects -->
<!-- Parent: Dotfiles -->
<!-- Title: Contributing Dotfiles -->
<!-- Label: Dotfiles -->
<!-- Label: Contributing -->
<!-- Include: disclaimer.md -->
<!-- Include: ac:toc -->

# How To Contribute

Contributions to dotfiles are welcome.

Feel free to use all of the contribution options:

- Contribute to dotfiles repositories on [GitHub](https://github.com/luismayta/dotfiles). See [Git flow](./contribute/github-flow.md).

## Getting Started

### Development

In general, MRs are welcome. We follow the typical "fork-and-pull" [Git flow](./contribute/github-flow.md).

1.  **Fork** the repo on Github
2.  **Clone** the project to your own machine
3.  **Commit** changes to your own branch using [Git flow](./contribute/github-flow.md)
4.  **Push** your work back up to your fork

5.  Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to rebase the latest changes from "upstream" before making a pull request!

## Styleguides

### Git Commit Messages

Your commit messages should serve these 3 important purposes:

- To speed up the reviewing process.
- To provide the least amount of necessary documentation
- To help the future maintainers.

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0) to make `git log`{.interpreted-text role="command"} a little easier to follow. We use commitlint enforcing conventional commits (See more [here](https://github.com/conventional-changelog/commitlint))

**chore**: something just needs to happen, e.g. versioning

**docs**: documentation pages in `docs/` or docstrings

**feat**: new code in `./`

**fix**: code improvement in `./`

**refactor**: code movement in `./`

**style**: aesthetic changes

**test**: test case modifications in `test/`

Examples commit messages:

- chore: IN-698 implement model devices
- docs: IN-698 implement configuration settings
- feat: IN-698 create lambda function
- fix: IN-698 retry upload on failure
- refactor: IN-698 extract duplicate code
- style: IN-698 format files python
- test: IN-698 coverage around add permissions

**Keep it short and simple!**

### Branches

See [Git flow](./contribute/github-flow.md).

### Documentation

Documentation is a part of the dotfiles code base. You can find the documentation files in the `doc/` subdirectory of the [main repository](https://github.com/luismayta/dotfiles). This means that the contribution process is the same for both the source code and documentation.

### Testing

See [Testing](./testing.md).

### Code Submission

1.  See if a [Pull Request](https://github.com/luismayta/dotfiles/pulls) exists
    - Add some comments or review the code to help it along
    - Don\'t be afraid to comment when logic needs clarification
2.  Create a Fork and open a [Pull Request](https://github.com/luismayta/dotfiles/pulls) if needed

### Code Review

- Anyone can review code
- Any [Pull Request](https://github.com/luismayta/dotfiles/pulls) should be closed or merged within a week

### Code Acceptance

Try to keep history as linear as possible using a [rebase] merge strategy.
