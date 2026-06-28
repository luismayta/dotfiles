## Context

The mobile module's Android SDK installation (`zsh/modules/mobile/internal/base.zsh`) currently provisions Java via Homebrew OpenJDK 11/17/21. This approach has three problems:

1. **Keg-only**: OpenJDK formulae are keg-only in Homebrew — they don't symlink `java` into `/usr/local/bin`. So `core::exists java` always fails, and the Java check re-triggers on every shell load even though the JDKs are installed.
2. **macOS-only**: Homebrew is primarily macOS. `internal/linux.zsh` is empty, so Android install on Linux is non-functional.
3. **Over-installation**: Three JDK versions (11, 17, 21) installed when only one (17) is needed for modern Android Gradle Plugin.

SDKMAN (sdkman.io) is the de-facto standard for Java version management on Unix systems. It works on both macOS and Linux, exposes `java` in PATH immediately after install, and supports `sdk default` for persistent version selection.

Additionally, `android::load` only adds `platform-tools` to PATH — missing `cmdline-tools/latest/bin` (for `sdkmanager`), `build-tools/` (for `aapt`, `zipalign`), and `emulator/`. And `flutter::post_install` is macOS-gated, so Linux never runs `flutter config --android-sdk` or `flutter doctor --android-licenses`.

## Goals / Non-Goals

**Goals:**
- Replace brew OpenJDK provisioning with SDKMAN + Temurin JDK 17
- Add SDKMAN auto-install if not present
- Add Linux Android SDK install path (direct Google cmdline-tools download)
- Extend `android::load` PATH with cmdline-tools, build-tools, emulator
- Make `flutter::post_install` Android config run on Linux too
- Remove `2>/dev/null || true` suppression from sdkmanager calls

**Non-Goals:**
- No changes to Flutter install/load logic (only post_install guard)
- No changes to iOS tooling (`internal/osx.zsh`, `pkg/osx.zsh`)
- No changes to env var names in `config/android.zsh`
- No changes to public API signatures

## Decisions

### Decision 1: SDKMAN over Homebrew OpenJDK

| Criteria | Homebrew OpenJDK | SDKMAN |
|---|---|---|
| `java` in PATH | ❌ Keg-only, must symlink | ✅ Instant |
| Linux support | ❌ No | ✅ Native |
| Multi-version | Manual `brew link --overwrite` | `sdk use`/`sdk default` |
| Init in shell | None needed | `sdkman-init.sh` in `.zshrc` |
| CI-friendly | Works | `?rcupdate=false` flag |

**Chosen**: SDKMAN. Solves both macOS (keg-only) and Linux (no brew) in one tool.

### Decision 2: Temurin JDK 17 over Corretto/Zulu/Oracle

Temurin (Eclipse Adoptium) is the default SDKMAN vendor, most widely used for Android dev, and LTS. JDK 17 is the minimum for modern Android Gradle Plugin (AGP 8.x).

### Decision 3: Linux cmdline-tools via direct download vs brew on Linux

Homebrew-on-Linux (Linuxbrew) exists but is not commonly installed on Linux dev machines. Direct download from Google's Android repository is the canonical approach documented at developer.android.com.

### Decision 4: Error visibility over silence

Current `yes | sdkmanager ... 2>/dev/null || true` hides failures. We'll keep `yes |` piping but remove `2>/dev/null || true` so that sdkmanager errors surface in terminal output. If a version string is wrong, the user should see it.

## Risks / Trade-offs

- **[Risk] SDKMAN not installed → auto-install adds ~5s to first load**: Acceptable. Only happens once. Mitigation: guard with `[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]]` before installing.
- **[Risk] SDKMAN modifies `.zshrc`**: The `?rcupdate=false` flag prevents this during auto-install. We source `sdkman-init.sh` explicitly in the function.
- **[Risk] sdkmanager on Linux requires Java first**: SDKMAN installs Java before we attempt sdkmanager — ordering is deliberate.
- **[Trade-off] One more dependency (SDKMAN)**: But it replaces brew OpenJDK, which is effectively broken. Net dependency count is neutral.
- **[Trade-off] cmdline-tools version pinning**: The direct download URL encodes a version number. If Google updates the cmdline-tools zip name, the URL breaks. Mitigation: extract version dynamically or maintain as a config variable.
