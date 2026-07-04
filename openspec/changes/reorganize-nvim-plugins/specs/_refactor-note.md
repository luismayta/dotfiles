# Structural Refactor — No Spec Changes

This change is a **pure structural reorganization** of the nvim plugins directory.

- **No new capabilities** are introduced
- **No existing capability requirements** are modified
- All plugin behavior remains identical before and after the move

Each file moved maintains its exact plugin spec, opts, and configuration — only its filesystem location and Lua import path change.
