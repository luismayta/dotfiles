## ADDED Requirements

### Requirement: Starship uses Catppuccin Macchiato palette
The starship prompt SHALL use colors from the Catppuccin Macchiato palette instead of ad-hoc inline color names.

#### Scenario: Palette is defined globally
- **WHEN** starship loads
- **THEN** a global `[palette]` block SHALL define Macchiato color variables (e.g., `text = "#cad3f5"`, `subtext0 = "#a5adcb"`, `surface0 = "#363a4f"`, `blue = "#8aadf4"`, `green = "#a6da95"`, `red = "#ed8796"`, `yellow = "#eed49f"`, `purple = "#c6a0f6"`, `teal = "#8bd5ca"`)

#### Scenario: All module colors reference palette variables
- **WHEN** a module has a `style` field
- **THEN** it SHALL use a palette variable reference (e.g., `"bold $blue"` or `"$green"`) instead of raw color names or hex values

#### Scenario: Existing inline colors are replaced
- **WHEN** the configuration is applied
- **THEN** all existing inline color styles (`bold green`, `bold cyan`, `purple`, `bold red`, `blue bold`, `green bold`, `bold blue`, etc.) SHALL be replaced with their Catppuccin Macchiato equivalent via palette references

### Requirement: Preserve custom module indicators
Custom indicators (proxy_is_on, proxy_is_off, env_var, custom githash/giturl) SHALL remain functional after color migration, only their color values SHALL change to Macchiato palette references.

#### Scenario: Custom indicators use Macchiato colors
- **WHEN** a custom indicator shows (e.g., proxy indicator)
- **THEN** its `style` field SHALL reference Macchiato palette colors
