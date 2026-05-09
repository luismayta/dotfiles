---
name: skills-readme-generator
description: Genera archivos readme.yaml para cada skill en el directorio skills/. Usa IA para extraer metadata de SKILL.md y llena el template `readme.yaml.tpl` desde la carpeta del skill.
license: Proprietary
metadata:
  opencode:
    emoji: "📖"
    tags:
      - skills
      - readme
      - generator
      - validation
      - ia
    mcp:
      preferredServer: filesystem
---

# Skills Readme Generator

## Trigger phrases

- "valida los skills"
- "genera los readme.yaml de los skills"
- "skills readme generator"

## Inputs

- `skillName` (optional): nombre del skill a validar/generar. Si no se provee, se procesan todos los skills.

## What I do

- Determino la **carpeta base del skill** (puede ser `.agents/skills`, `.claude/skills`, `.opencode/skills` u otra según instalación) para localizar `readme.yaml.tpl`.
- Busco todas las carpetas que contienen `SKILL.md` (`skills/**/SKILL.md`) para generar los `readme.yaml`.
- Por cada skill (o solo el indicado):
  1. Verifico que exista `SKILL.md`.
  2. Leo el contenido de `SKILL.md`.
  3. Extraigo la metadata usando IA:
     - `name`
     - `description`
     - `triggers`
     - `what_i_do`
     - `usage_examples`
   4. Cargo el template `readme.yaml.tpl` desde la **carpeta base del skill**.
     - Si no existe, se reporta un error.
  5. Lleno el template con la metadata extraída.
  6. Genero `readme.yaml` dentro de la carpeta del skill (`skills/<skill_name>/readme.yaml`) **solo si no existe**.
- Reporto archivos creados, existentes o errores encontrados.

## Default behavior

- No sobrescribo archivos existentes.
- Se crean solo los archivos que faltan.
- `SKILL.md` es la fuente de verdad y no se modifica.
   - La estructura de `readme.yaml` siempre sigue el template `readme.yaml.tpl`.

## Process

1. Determinar la **carpeta base del skill** según la instalación (`.agents/skills`, `.claude/skills`, `.opencode/skills`).
2. Buscar todas las carpetas que contienen `skills/**/SKILL.md`.
3. Para cada skill (o solo el indicado):
   - Leer `SKILL.md`.
   - Extraer metadata usando IA.
   - Cargar el template `readme.yaml.tpl` desde la carpeta base del skill.
   - Generar `readme.yaml` en la carpeta del skill **solo si no existe**.
4. Reportar resultados de generación por skill.

## Notes

- Este skill respeta el estándar de SKILL.md como fuente de documentación principal.
- `readme.yaml` siempre tendrá la estructura:
  - `name`
  - `description`
  - `triggers`
  - `what_i_do`
  - `usage_examples`
- Otros procesos pueden usar `readme.yaml` para generar `README.md` u otros pipelines automatizados.

## Example usage

```bash
# Validar/generar todos los skills
skills-readme-generator

# Validar/generar un skill específico
skills-readme-generator github-create-pr
````

```json
{
  "skillName": "github-create-pr"
}
```