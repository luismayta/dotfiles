## 1. Organización del archivo

- [x] 1.1 Agrupar módulos en secciones lógicas con comentarios `## TITLE` y separadores
- [x] 1.2 Ordenar secciones: Core → Shell → Git → Cloud → Languages → Tools → Environment → System → Custom
- [x] 1.3 Agregar comentarios descriptivos arriba de módulos con nombres no obvios

## 2. Limpieza de configuraciones muertas

- [x] 2.1 Eliminar sección `[battery]` completa (disabled + display blocks)
- [x] 2.2 Eliminar sección `[time]` completa
- [x] 2.3 Eliminar sección `[localip]` completa
- [x] 2.4 Eliminar línea comentada `# style = "dim green"` en kubernetes

## 3. Consistencia de formato

- [x] 3.1 Unificar `[golang]` format: remover pipe prefix, usar `"[$symbol $version]($style) "`
- [x] 3.2 Verificar que todos los format strings sigan patrón `"[$output]($style) "`
- [x] 3.3 Estandarizar íconos a Nerd Font donde exista equivalente

## 4. Refactor de custom modules

- [x] 4.1 Simplificar `[custom.githash]` command: usar `git rev-parse --short HEAD` directo sin variable intermedia
- [x] 4.2 Simplificar `[custom.giturl]` command: limpiar formato del script bash
- [x] 4.3 Agrupar `[custom.proxy_is_on]` y `[custom.proxy_is_off]` como secciones adyacentes
- [x] 4.4 Unificar `shell` en todos los custom modules a `["bash", "--noprofile", "--norc"]`

## 5. Validación post-refactor

- [x] 5.1 Verificar que no hay duplicados de módulos: `grep '^\[' | sort | uniq -d` → 0 duplicados
- [x] 5.2 Verificar que el prompt se renderiza sin errores: `starship prompt` → OK
- [x] 5.3 Confirmar que `pyenv_version_name` es válido en la versión actual de starship (v1.25.1) → OK
