---
name: image-compression
description: Reduce image file size using the MCP image-compression tool. If no path is provided, ask the user for the file.
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
---

# Image Compression Skill

## Trigger phrases

- "reduce el peso de una imagen"
- "comprime una imagen"
- "optimiza esta imagen"
- "image compression"
- "compress image"

## Inputs

- `path` (optional): workspace-relative or absolute path to the image (example: `assets/images/project-hero.png`).

If `path` is not provided, ask the user for the file path (recommend: workspace-relative).

## What I do

- Validate the input file exists and is an image.
- Report current file size (and dimensions when available).
- Compress using the MCP tool `image-compression_image_compression`.
- Write the compressed output next to the original with a predictable name.

## Default behavior

- Do not overwrite the original.
- Output file name: `<original-basename>-compressed.<ext>` (example: `project-hero-compressed.png`).

If the user explicitly requests overwriting, replace the original after compression.

## Process

1. Gather input

- If `path` is missing: ask the user for the file path.
- If the path contains spaces, treat it as a single path (quote it in shell commands).

2. Inspect current image

- Get file size.
- Get dimensions when possible.

3. Compress

- Call the MCP tool:
  - `urls`: the provided local file path (no URL prefix).
  - `format`: infer from extension when obvious (e.g., `png`, `jpg`, `webp`). If unclear, omit.

4. Place the output

- The MCP tool returns a new image path.
- Rename/move that file to the default output name next to the original.

5. Report results

- Show before/after file sizes and the percentage saved.
- Show the final output path.

## Notes

- If the file is already small or compression increases size, keep the original and report that compression was not beneficial.