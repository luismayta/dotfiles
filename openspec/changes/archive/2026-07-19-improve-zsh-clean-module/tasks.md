## 1. Core Refactoring

- [x] 1.1 Consolidate `cleanup::unnecessary` into `cleanup` function in `pkg/base.zsh`
- [x] 1.2 Replace all inline message functions with core utilities (`message_info`, `message_success`, etc.)
- [x] 1.3 Fix typo in `CLEAN_MESSAGE_NOT_IMPLEMENTED` in `config/base.zsh`
- [x] 1.4 Add consistent `cleanup::` prefix to all public functions
- [x] 1.5 Add `_cleanup::` prefix to internal helper functions

## 2. Safety Features

- [x] 2.1 Add `--dry-run` flag parsing to main cleanup functions
- [x] 2.2 Implement confirmation prompts with y/n input
- [x] 2.3 Add `--force` flag to skip confirmation prompts
- [ ] 2.4 Implement deletion logging with item counts
- [x] 2.5 Add `--silent` flag to suppress verbose output

## 3. Configuration System

- [x] 3.1 Add `CLEAN_*` environment variable support for custom paths
- [x] 3.2 Implement path validation for custom paths
- [x] 3.3 Add `CLEAN_DRY_RUN`, `CLEAN_CONFIRM`, `CLEAN_VERBOSE` flags
- [x] 3.4 Create help text showing available configuration options
- [x] 3.5 Add fallback logic for non-existent custom paths

## 4. Linux Platform Implementation

- [x] 4.1 Implement `cleanup::linux::trash` with trash-cli support
- [x] 4.2 Add manual trash cleanup fallback for systems without trash-cli
- [x] 4.3 Implement `cleanup::linux::logs` for browser caches and thumbnails
- [x] 4.4 Add journal log cleanup with `journalctl --vacuum-time`
- [ ] 4.5 Test on multiple Linux distributions

## 5. Platform Integration

- [x] 5.1 Update `cleanup::all` to call platform-specific functions
- [x] 5.2 Add macOS functions to main cleanup flow (adobe_cache, ios_backup, xcode)
- [x] 5.3 Implement cross-platform function aliases (cleanup::system::trash, cleanup::system::logs)
- [x] 5.4 Add platform detection and routing logic

## 6. Modern Tool Support

- [x] 6.1 Implement `cleanup::cargo` for Rust cache cleanup
- [x] 6.2 Implement `cleanup::go` for Go module cache cleanup
- [x] 6.3 Implement `cleanup::bun` for Bun cache cleanup
- [x] 6.4 Implement `cleanup::pnpm` for pnpm store cleanup
- [x] 6.5 Implement `cleanup::ccache` for compiler cache cleanup
- [x] 6.6 Implement `cleanup::docker::volumes` for Docker volume cleanup

## 7. Integration and Testing

- [x] 7.1 Add modern tool cleanup to `cleanup::all` function
- [ ] 7.2 Test all functions on macOS
- [ ] 7.3 Test all functions on Linux
- [x] 7.4 Verify backward compatibility with existing scripts
- [ ] 7.5 Update module documentation

## 8. Cleanup and Finalization

- [x] 8.1 Remove deprecated function stubs
- [x] 8.2 Consolidate duplicate file patterns in find commands
- [x] 8.3 Optimize find commands with proper exclusions
- [ ] 8.4 Add progress indicators for long-running operations
- [ ] 8.5 Create usage examples in comments
