# python ZSH Module

Port of [luismayta/zsh-pyenv](https://github.com/luismayta/zsh-pyenv) into the
dotfiles `modules/` convention, extended to manage the full Python toolchain
(pyenv + uv).

Provides pyenv (Python version manager) installation, PATH management,
uv installation and shell completions, and Python version setup with
OS-specific dispatch (macOS/Linux).

## Functions

| Function | Description |
|---|---|
| `python::install` | Install pyenv |
| `python::load` | Load pyenv into PATH |
| `python::upgrade` | Upgrade pyenv |
| `python::post_install` | Post-install tasks (global version + modules) |
| `python::version::all::install` | Install all configured Python versions |
| `python::version::global::install` | Install global Python version |
| `python::modules::install` | Install all configured Python modules |
| `python::module::install` | Install a single Python module |
| `python::poetry::install` | Install poetry and its plugins |

## Variables

| Variable | Default | Description |
|---|---|---|
| `PYTHON_PYENV_ENABLED` | `true` | Toggle pyenv management on/off |
| `PYTHON_UV_ENABLED` | `true` | Toggle uv management on/off |
| `PYTHON_ROOT` | `$HOME/.pyenv` | Python toolchain root directory |
| `PYTHON_VERSION_GLOBAL` | `3.11.5` | Default global Python version |

## Requirements

- zsh-core (for `core::exists`, `message_*` helpers)

## License

LGPL-3.0
