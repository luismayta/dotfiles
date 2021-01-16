# Releasing

## Bump a new version

Make a new version of dotfiles in the following steps:

- Make sure everything is commit to github.com.
- Update `Changelog.md` with the next version.

- Dry Run: `bumpversion --dry-run --verbose --new-version 0.8.1 patch`
- Do it: `bumpversion --new-version 0.8.1 patch`
- \... or: `bumpversion --new-version 0.9.0 minor`
- Push it: `git push --tags`

See the [bumpversion](https://pypi.org/project/bumpversion/) documentation for details.
