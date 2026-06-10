## 1. Pipeline principal (run.sh)

- [ ] 1.1 Fix `exit 1` → `exit 0` en `run.sh:11` para TEST mode
- [ ] 1.2 Agregar guard `|| die` si `bootstrap.sh` no es legible en `run.sh:7`

## 2. Rutas y redirects

- [ ] 2.1 Reemplazar ruta hardcodeada `~/.dotfiles` por `${PATH_REPO}` en `functions.sh:82`
- [ ] 2.2 Corregir `>>/dev/null` → `>/dev/null` en `install.sh:138`

## 3. Git-extras

- [ ] 3.1 Remover `git-extras` del array `APPS` en `config/base.sh`
- [ ] 3.2 Agregar mensaje post-instalación en `install.sh` informando cómo instalar git-extras manualmente
