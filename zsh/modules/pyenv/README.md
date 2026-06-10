# pyenv ZSH Module

Port of [luismayta/zsh-pyenv](https://github.com/luismayta/zsh-pyenv) into the
dotfiles `modules/` convention.

Provides pyenv (Python version manager) installation, PATH management,
and Python version setup with OS-specific dispatch (macOS/Linux).

## Functions

| Function | Description |
|---|---|
| `pyenv::install` | Install pyenv |
| `pyenv::load` | Load pyenv into PATH |
| `pyenv::upgrade` | Upgrade pyenv |
| `pyenv::post_install` | Post-install tasks (global version + modules) |
| `pyenv::version::all::install` | Install all configured Python versions |
| `pyenv::version::global::install` | Install global Python version |
| `pyenv::modules::install` | Install all configured Python modules |
| `pyenv::module::install` | Install a single Python module |
| `pyenv::poetry::install` | Install poetry and its plugins |

## Requirements

- zsh-core (for `core::exists`, `message_*` helpers)

## License

LGPL-3.0
