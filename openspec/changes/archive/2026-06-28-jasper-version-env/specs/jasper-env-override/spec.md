## ADDED Requirements

### Requirement: Module exposes JASPER_ override variables
Each module that defines a tool version SHALL expose a corresponding `JASPER_` prefixed environment variable that, when set, overrides the default version value.

#### Scenario: JASPER_ variable overrides default
- **WHEN** the environment variable `JASPER_FLUTTER_VERSION` is set to `3.44.4-stable`
- **THEN** the module SHALL use `3.44.4-stable` instead of the default version

#### Scenario: No JASPER_ variable set
- **WHEN** no `JASPER_FLUTTER_VERSION` environment variable is defined
- **THEN** the module SHALL use its default version value

### Requirement: Consistent variable naming pattern
All `JASPER_` override variables SHALL follow the pattern `JASPER_{MODULE}_{VARIABLE}` where:
- `{MODULE}` is the module name in UPPER_SNAKE_CASE
- `{VARIABLE}` is the internal variable name (without the module prefix)
- The assignment SHALL use the bash pattern: `export VAR="${JASPER_VAR:-default}"`

#### Scenario: Naming convention applied to flutter
- **WHEN** examining the flutter module config
- **THEN** the assignment SHALL be `export FLUTTER_VERSION="${JASPER_FLUTTER_VERSION:-3.44.4-stable}"`

#### Scenario: Naming convention applied to android
- **WHEN** examining the android module config
- **THEN** the assignments SHALL use `JASPER_ANDROID_PLATFORM_VERSION`, `JASPER_ANDROID_SDK_VERSION`, `JASPER_ANDROID_CMDLINE_TOOLS_VERSION`, and `JASPER_SDKMAN_JAVA_VERSION`

### Requirement: fnm version uses override pattern
The fnm module SHALL use the `JASPER_FNM_VERSION` override for its version variable instead of a hardcoded value.

#### Scenario: fnm version override
- **WHEN** checking `fnm/config/base.zsh`
- **THEN** the assignment SHALL be `FNM_VERSION="${JASPER_FNM_VERSION:-0.39.5}"`

### Requirement: Core env uses override pattern
The core environment configuration SHALL use `JASPER_` prefixed variables for Android version values instead of hardcoded values.

#### Scenario: Core android version override
- **WHEN** checking `zsh/core/config/env.zsh`
- **THEN** `ANDROID_PLATFORM_VERSION` SHALL use `JASPER_ANDROID_PLATFORM_VERSION` as override
- **THEN** `ANDROID_SDK_VERSION` SHALL use `JASPER_ANDROID_SDK_VERSION` as override

### Requirement: Backward compatibility
Existing default version values SHALL remain unchanged. The `JASPER_` override is additive and does not change behavior unless explicitly set.

#### Scenario: Default values preserved
- **WHEN** no `JASPER_*` variables are set in the environment
- **THEN** all module versions SHALL resolve to their current default values
