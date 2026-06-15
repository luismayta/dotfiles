## 1. Fix pake build path

- [x] 1.1 In `apps::internal::webapp::build()`, wrap `pake` invocation with `pushd "${APPS_WEB_APPS_BUILD_DIR}"` and `popd` to ensure artifact lands in the build directory
- [x] 1.2 Keep `mkdir -p` inside `build()` for safety (ensure()` depends on it, design doc: "keep for clarity")
- [x] 1.3 Run `task validate` to confirm shellcheck and pre-commit pass
