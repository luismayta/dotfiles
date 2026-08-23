# Task: Migrar pyenv a uv en módulo python de zsh

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Reemplazar pyenv por uv como gestor de versiones de Python en zsh/modules/python con 3.14 como versión estándar
- component:
- labels: [python,uv,zsh,migration]
- parentEpic:
- issueKey: HAD-100

## Scenario

El módulo zsh/modules/python/ gestiona hoy las versiones de Python mediante pyenv: lo clona desde GitHub en ~/.pyenv, expone shims en PATH y fija la versión global vía pyenv global (config/base.zsh define 3.10.6 y 3.11.5). El equipo estandariza uv como gestor único de Python por su velocidad y simplicidad, y adopta Python 3.14 como versión estándar.
Este módulo debe migrar de pyenv a uv manteniendo su API pública.


### Acceptance Tests

- [ ] No quedan referencias funcionales a pyenv en zsh/modules/python/ (plugin.zsh, config/, internal/, pkg/) ni en README.md y README.yaml
- [ ] La instalación y fijación de versiones usa `uv python install` y el pinning de uv en lugar de `pyenv install` y `pyenv global`
- [ ] config/base.zsh define 3.14 como versión global estándar (PYTHON_VERSION_GLOBAL=3.14 o equivalente) y las variables de pyenv (PYTHON_PYENV_ENABLED, PYTHON_ROOT=~/.pyenv, PYTHON_INSTALL_URL) se eliminan o reemplazan por equivalentes de uv
- [ ] Las funciones públicas conservan su contrato: python::install, python::upgrade, python::version::global::install, python::version::all::install y python::load operan vía uv
- [ ] El soporte existente de uv (PYTHON_UV_ENABLED, python::internal::uv::load, completions) pasa a ser la ruta principal del módulo
- [ ] shellcheck pasa sin errores sobre los archivos modificados del módulo
- [ ] Una sesión zsh nueva resuelve `python` desde la versión 3.14 gestionada por uv


### Sources

- https://docs.astral.sh/uv/ — documentación oficial de uv
- https://github.com/luismayta/dotfiles.git