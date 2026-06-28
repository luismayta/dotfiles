## Context

El archivo `starship.toml` contiene la configuración completa del prompt de starship para el dotfiles de Hadenlabs. Actualmente tiene 271 líneas con módulos declarados en orden arbitrario, mezcla de estilos TOML y format strings, y configuraciones muertas. No hay un estándar definido para la estructura del archivo ni para el estilo de los format strings.

La configuración es puramente declarativa (TOML), no hay lógica de runtime involucrada — el refactor es enteramente cosmético y organizativo.

## Goals / Non-Goals

**Goals:**
- Estructurar el archivo en secciones lógicas con comentarios de cabecera
- Unificar el patrón de `format`, `style` y `symbol` en todos los módulos
- Remover configuraciones muertas (`disabled = true` con bloques anidados que nunca se usan)
- Estandarizar el uso de íconos: Nerd Font como estándar, emoji solo donde no exista equivalente
- Simplificar los custom modules inline (`[custom.giturl]`, `[custom.githash]`, `[custom.proxy_*]`)
- Verificar consistencia post-migración pyenv→python

**Non-Goals:**
- NO cambiar el output visual del prompt (el usuario no debe notar diferencia)
- NO agregar nuevos módulos o funcionalidades
- NO modificar la lógica de los custom modules, solo su presentación si aplica
- NO tocar otros archivos fuera de `starship.toml`

## Decisions

| Decisión | Opción elegida | Alternativas | Razón |
|---|---|---|---|
| Separación en secciones | Comentarios `## TITLE` con línea separadora | Archivos incluidos vía `$include` | starship soporta includes pero agrega complejidad innecesaria para un solo archivo |
| Formato de format strings | `"[$symbol$version]($style)"`  | Variantes con pipes `\| Go [$symbol]($style)` | El estándar starship usa `[$symbol]($style)`. Los pipes se eliminan — no aportan valor visual |
| Estándar de íconos | Nerd Font como default | Solo emoji | Nerd Font está instalado en el sistema y da mejor resolución en terminal |
| Custom modules | Mantener como `[custom.*]` | Mover a scripts externos | Los scripts son simples (1-3 líneas) y no justifican archivos separados. Sí se reducirá el formato inline |
| Config muerta | Eliminar por completo | Dejar comentada | El VCS guarda el historial; no hay razón para mantener código comentado |
| Orden de secciones | Core → Git → Cloud → Lenguajes → Tools → Env → System | Alfabético | Sigue la relevancia para el flujo de trabajo diario |

## Risks / Trade-offs

- **[Riesgo Bajo] Error al reordenar**: Una sección mal colocada podría romper la precedencia de módulos duplicados.
  → **Mitigación**: starship usa la última definición de un módulo. Con `grep '^\['` se verifica que no haya duplicados después del cambio.
- **[Riesgo Bajo] Custom modules dejen de funcionar**: Al modificar el format string de `[custom.*]`.
  → **Mitigación**: Verificar visualmente el prompt después del cambio. Los tests son manuales (captura de pantalla del prompt).
- **[Riesgo Medio] Python `pyenv_version_name`**: Si la migración pyenv→python cambió cómo se detecta la versión.
  → **Mitigación**: Confirmar que `pyenv_version_name` sigue siendo válido en la versión actual de starship.
