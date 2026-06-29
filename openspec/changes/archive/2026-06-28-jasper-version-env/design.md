## Context

La base de código tiene un patrón emergente de override vía `JASPER_` prefix, pero solo 2 de ~8 módulos con versiones lo implementan. El resto usa `${VAR:-default}` sin prefix dedicado o valores硬coded. Esto obliga a modificar archivos del dotfiles para cambiar versiones, en lugar de poder hacerlo desde `.customrc` o variables de entorno del sistema.

Módulos auditados con versiones:

| Módulo | Archivo | Estado actual |
|---|---|---|
| `goenv` | `config/base.zsh` | ✅ `JASPER_GOENV_VERSION_GLOBAL` |
| `docker` | `config/base.zsh` | ✅ `JASPER_CONTAINER_APP_NAME` |
| `mobile/flutter` | `config/flutter.zsh` | ❌ `FLUTTER_VERSION` sin `JASPER_` |
| `mobile/android` | `config/android.zsh` | ❌ `ANDROID_*_VERSION` sin `JASPER_` |
| `fnm` | `config/base.zsh` | ❌ `FNM_VERSION`硬coded (sin `:-default`) |
| `core/env` | `config/env.zsh` | ❌ `ANDROID_*_VERSION`硬coded |

## Goals / Non-Goals

**Goals:**
- Todos los módulos con versiones de herramientas exponen variables `JASPER_` para override externo
- El patrón es consistente: `export VAR="${JASPER_VAR:-default}"`
- Los valores default no cambian — compatibilidad total hacia atrás
- Documentar en cada `config/*.zsh` las variables `JASPER_` disponibles

**Non-Goals:**
- No cambiar la lógica interna de los módulos (install, load, etc.)
- No crear un sistema de gestión de versiones centralizado — solo exponer overrides
- No modificar módulos que no tengan versiones de herramientas (tmux, git, starship, etc.)

## Decisions

### 1. Patrón uniforme `export VAR="${JASPER_VAR:-default}"`

**Decisión:** Usar el mismo patrón que goenv ya implementa. La variable interna (`VAR`) mantiene su nombre actual para no cambiar las referencias en `internal/` y `pkg/`. La variable `JASPER_VAR` actúa como override opcional desde el entorno.

**Alternativa considerada:** Crear un archivo central `versions.zsh` con todas las versiones. Se descartó porque rompe el encapsulamiento por módulo y centraliza algo que cada módulo debe poder gestionar independientemente.

### 2. Variables硬coded → patrón con default

**Decisión:** Donde hoy hay `VAR=valor` (sin `:-`), se cambia a `VAR="${JASPER_VAR:-valor}"`. Esto aplica a:
- `fnm/config/base.zsh:9` → `FNM_VERSION="${JASPER_FNM_VERSION:-0.39.5}"`
- `core/config/env.zsh:16-17` → `ANDROID_PLATFORM_VERSION="${JASPER_ANDROID_PLATFORM_VERSION:-35}"`

**Riesgo:** Ninguno — el default es idéntico al valor actual.

### 3. Naming: `JASPER_{MODULE}_{VARIABLE}`

**Decisión:** El prefijo es `JASPER_` seguido del nombre de la variable interna. Ej: para `FLUTTER_VERSION` → `JASPER_FLUTTER_VERSION`. Consistente con `JASPER_GOENV_VERSION_GLOBAL`.

### 4. No tocar `GOENV_VERSIONS` (array)

**Decisión:** La variable `GOENV_VERSIONS` es un array, no un scalar. El patrón `JASPER_` para arrays requeriría parsing adicional. Se deja fuera de alcance.

## Risks / Trade-offs

- **[Bajo]** Variable `JASPER_` mal escrita en entorno → no hay error, solo se usa el default (comportamiento bash estándar con `:-`)
- **[Ninguno]** Los módulos ya cargan estos valores al inicio del shell; no hay impacto en rendimiento
- **[Ninguno]** Los nombres de variables internas no cambian, solo se modifica cómo se asignan
