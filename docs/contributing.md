# How To Contribute

Contributions to dotfiles are welcome.

## Getting Started

### Commits

Follow [semantic commits](https://seesparkbox.com/foundry/semantic_commit_messages) to make `git log`{.interpreted-text role="command"} a little easier to follow.

chore: something just needs to happen, e.g. versioning

docs: documentation pages in `_docs/` or docstrings

feat: new code in `src/`

fix: code improvement in `src/`

refactor: code movement in `src/`

style: aesthetic changes

test: test case modifications in `test/`

Examples commit messages:

- chore: v10.0 (IN-698)
- docs: Add configuration setting (IN-698)
- feat: Create Lambda function (IN-698)
- fix: Retry upload on failure (IN-698)
- refctor: Extract duplicate code (IN-698)
- style: isort, YAPF (IN-698)
- test: Coverage around add permissions (IN-698)

### Branches

Use [slash convention]() with the same leaders as `commits` e.g.:

- (prefix-task)

### Documentation

### Testing

## Code Submission

### Code Improvement

### Code Submission

1.  See if a [Pull Request](https://github.com/luismayta/dotfiles/pulls/) exists
    - Add some comments or review the code to help it along
    - Don\'t be afraid to comment when logic needs clarification
2.  Create a Fork and open a [Pull Request](https://github.com/luismayta/dotfiles/pulls/) if needed

### Code Review

- Anyone can review code
- Any [Pull Request](https://github.com/luismayta/dotfiles/pulls/) should be closed or merged within a week

### Code Acceptance

Try to keep history as linear as possible using a [rebase] merge strategy.

1. One thumb up at minimum, two preferred

2. Request submitter to [rebase]{.title-ref} and resolve all conflicts

   ```{.bash}
   # Update `develop`
   git checkout develop
   git pull origin develop

   # Update `IN-698` Branch
   git flow feature start IN-698
   git rebase develop

   # Update remote Branch and Pull Request
   git push -f
   ```

3. Merge the new feature

   ```{.bash}
   # Merge `IN-698` into `develop`
   git checkout develop
   git merge --ff-only feature/IN-698
   git push
   ```

4. Delete merged Branch
