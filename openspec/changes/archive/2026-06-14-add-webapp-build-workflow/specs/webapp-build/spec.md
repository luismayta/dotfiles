## ADDED Requirements

### Requirement: Configurable build directory
The system SHALL read `APPS_WEB_APPS_BUILD_DIR` environment variable to determine the working directory for pake builds. If unset, it SHALL default to `/tmp/pake-build`.

#### Scenario: Default build directory
- **WHEN** `APPS_WEB_APPS_BUILD_DIR` is not set
- **THEN** the build directory SHALL default to `/tmp/pake-build`

#### Scenario: Custom build directory
- **WHEN** `APPS_WEB_APPS_BUILD_DIR` is set to `/custom/path`
- **THEN** the build SHALL use `/custom/path` as the working directory

### Requirement: Build directory lifecycle
The system SHALL create `APPS_WEB_APPS_BUILD_DIR` before each build if it does not exist. On `webapp::all::build`, it SHALL clean the directory (remove contents) before starting the batch.

#### Scenario: Directory creation
- **WHEN** `APPS_WEB_APPS_BUILD_DIR` does not exist
- **THEN** the system SHALL create it with `mkdir -p`

#### Scenario: Clean before batch build
- **WHEN** `apps::webapp::all::build` is invoked
- **THEN** `APPS_WEB_APPS_BUILD_DIR` SHALL be emptied before building

### Requirement: Pake invocation with full flags
The system SHALL invoke `pake` with: URL, `--name`, `--width 1200`, `--height 800`, `--hide-title-bar`, `--hide-menu`, `--targets zst`, running from within `APPS_WEB_APPS_BUILD_DIR`.

#### Scenario: Full pake build
- **WHEN** `apps::internal::webapp::build` is called with url and name
- **THEN** the system SHALL `cd` to `APPS_WEB_APPS_BUILD_DIR` and run `pake "${url}" --name "${name}" --width 1200 --height 800 --hide-title-bar --hide-menu --targets zst`

### Requirement: Artifact rename
After a successful pake build, the system SHALL rename the output `*.pkg.tar.zst` file matching the app name to a canonical lowercase form `${name:l}.pkg.tar.zst`.

#### Scenario: Rename built artifact
- **WHEN** pake produces `Chatgpt_2026-06-14_x86_64.pkg.tar.zst`
- **THEN** the system SHALL rename it to `chatgpt.pkg.tar.zst` in the same directory

#### Scenario: No matching artifact
- **WHEN** no `*.pkg.tar.zst` file matching the app name is found after build
- **THEN** the system SHALL log a warning and skip the rename

### Requirement: Install built artifact on Linux
On Linux, the system SHALL install the renamed artifact using `paru -U`.

#### Scenario: Install with paru
- **WHEN** `paru` is installed and artifact exists
- **THEN** the system SHALL run `paru -U <artifact_path> --noconfirm`

#### Scenario: Missing paru
- **WHEN** `paru` is not installed
- **THEN** the system SHALL log `"paru is required but not installed"` and skip installation

### Requirement: Install built artifact on macOS
On macOS, after building a webapp, the system SHALL open the built `.app` bundle using the `open` command.

#### Scenario: Open app bundle on macOS
- **WHEN** a webapp build completes successfully on macOS
- **THEN** the system SHALL run `open <path_to_app_bundle>`

### Requirement: Error handling
The system SHALL validate that `pake` exists before attempting any build. If any step in the build → rename → install chain fails, the system SHALL log the error and continue with the next webapp entry (fail-continue, not fail-stop).

#### Scenario: Missing pake binary
- **WHEN** `pake` is not installed
- **THEN** the system SHALL log `"pake is required but not installed"` and skip the build

#### Scenario: Build failure continues loop
- **WHEN** one webapp build fails
- **THEN** the system SHALL log the error and continue building the next webapp in the list
