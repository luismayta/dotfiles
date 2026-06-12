---
description: Compress an image using the MCP image-compression server (asks for file path if missing)
---

1. Read the image path from `{{args}}`.
2. If `{{args}}` is missing, ask the user for the file path (recommend workspace-relative, e.g. `assets/images/project-hero.png`).
3. Load skill: image-compression
4. Compress the image using the MCP tool `image-compression_image_compression`.
5. Rename/move the generated file to `<original-basename>-compressed.<ext>` next to the original.
6. Print before/after size and the output path.