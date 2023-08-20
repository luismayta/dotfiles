<!-- Space: Projects -->
<!-- Parent: Dotfiles -->
<!-- Title: Commands Dotfiles -->
<!-- Label: Dotfiles -->
<!-- Label: Project -->
<!-- Label: Commands -->
<!-- Include: disclaimer.md -->
<!-- Include: ac:toc -->

# Commands

## Taskfile

### Confluence

#### Sync Markdown with confluence

```{.bash}
task confluence:sync:all
```

### Python

#### Format syntax code python with [black](https://github.com/psf/black)

```{.bash}
task python:fmt -- {{file_name or path}}
```

### Diagrams

#### Publish diagrams

```{.bash}
task diagrams:publish
```

### Mkdocs

#### Generate Website

```{.bash}
task docs:build
```

### Changelog

#### Generate Changelog Next Tag

```{.bash}
task changelog:next APP_TAG={{tag name}}
```

#### Parameters

| Name     | Description   | sample | Required |
| -------- | ------------- | ------ | :------: |
| tag name | Name next tag | 0.1.0  |   yes    |

### Version

#### Version Major

```{.bash}
task version:major
```

#### Version Minor

```{.bash}
task version:minor
```

#### Version Patch

```{.bash}
task version:patch
```

### Docs

#### build

```{.bash}
task docs:build
```

#### server

```{.bash}
task docs:serve
```
