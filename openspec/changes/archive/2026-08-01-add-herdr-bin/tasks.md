## 1. Setup

- [x] 1.1 Create `bin/` directory in `zsh/modules/herdr/`
- [x] 1.2 Add `.gitignore` file in `bin/` to not ignore script files

## 2. Create hrdw-create script

- [x] 2.1 Create `hrdw-create` script in `bin/` directory
- [x] 2.2 Implement worktree creation logic (auto-prepend `feature/` if no prefix)
- [x] 2.3 Add handling for existing branches (prompt to open)
- [x] 2.4 Add usage information when run without arguments
- [x] 2.5 Make script executable

## 3. Create hrdw-list script

- [x] 3.1 Create `hrdw-list` script in `bin/` directory
- [x] 3.2 Implement worktree listing logic
- [x] 3.3 Add error handling for non-git repositories
- [x] 3.4 Make script executable

## 4. Create hrdw-delete script

- [x] 4.1 Create `hrdw-delete` script in `bin/` directory
- [x] 4.2 Implement worktree deletion by workspace ID
- [x] 4.3 Add fzf selector for interactive selection
- [x] 4.4 Add confirmation prompt before deletion
- [x] 4.5 Add error handling for non-git repositories
- [x] 4.6 Make script executable

## 5. Testing and Verification

- [x] 5.1 Test `hrdw-create` with various arguments
- [x] 5.2 Test `hrdw-list` in and outside git repositories
- [x] 5.3 Test `hrdw-delete` with both ID and fzf selection
- [x] 5.4 Verify all scripts are executable and tracked in git