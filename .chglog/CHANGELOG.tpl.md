# Changelog

{{- $jira := "https://hadenlabs.atlassian.net/browse" -}}
{{- $pattern := "([A-Z]+-[0-9]+)" -}}

{{ range .Versions }}
## {{ if .Tag.Previous }}[{{ .Tag.Name }}]({{ $.Info.RepositoryURL }}/compare/{{ .Tag.Previous.Name }}...{{ .Tag.Name }}){{ else }}{{ .Tag.Name }}{{ end }} ({{ datetime "2006-01-02" .Tag.Date }})

{{ range .CommitGroups -}}
---
# {{ .Title }}

{{- $hasFeat := false }}
{{- $hasFix := false }}
{{- $hasRefactor := false }}
{{- $hasChore := false }}
{{- $hasDocs := false }}
{{- $hasHotfix := false }}
{{- $hasDeprecate := false }}
{{- $hasPerf := false }}
{{- $hasRevert := false }}
{{- range .Commits }}
{{- if eq .Type "feat" }}{{ $hasFeat = true }}{{ end }}
{{- if eq .Type "fix" }}{{ $hasFix = true }}{{ end }}
{{- if eq .Type "refactor" }}{{ $hasRefactor = true }}{{ end }}
{{- if eq .Type "chore" }}{{ $hasChore = true }}{{ end }}
{{- if eq .Type "docs" }}{{ $hasDocs = true }}{{ end }}
{{- if eq .Type "hotfix" }}{{ $hasHotfix = true }}{{ end }}
{{- if eq .Type "deprecate" }}{{ $hasDeprecate = true }}{{ end }}
{{- if eq .Type "perf" }}{{ $hasPerf = true }}{{ end }}
{{- if eq .Type "revert" }}{{ $hasRevert = true }}{{ end }}
{{- end }}

{{- if $hasFeat }}
## ✨ Features
{{- range .Commits }}{{ if eq .Type "feat" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasFix }}
## 🐛 Bug Fixes
{{- range .Commits }}{{ if eq .Type "fix" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasHotfix }}
## 🚑 Hotfixes
{{- range .Commits }}{{ if eq .Type "hotfix" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasPerf }}
## ⚡ Performance Improvements
{{- range .Commits }}{{ if eq .Type "perf" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasDeprecate }}
## ⚰ Deprecations
{{- range .Commits }}{{ if eq .Type "deprecate" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasRevert }}
## ⏪ Reverts
{{- range .Commits }}{{ if eq .Type "revert" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasDocs }}
## 📚 Documentation
{{- range .Commits }}{{ if eq .Type "docs" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasRefactor }}
## 🎨 Refactoring
{{- range .Commits }}{{ if eq .Type "refactor" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{- if $hasChore }}
## 🧹 Chores
{{- range .Commits }}{{ if eq .Type "chore" }}
* {{ regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) }}
{{- end }}{{ end }}
{{- end }}

{{ end -}}

{{- if .RevertCommits -}}

### Reverts

{{ range .RevertCommits -}}
{{- $header := regexReplaceAll $pattern .Revert.Header (printf "[$1](%s/$1)" $jira) }}
* {{ $header }}
{{ end }}
{{ end -}}

{{- if .NoteGroups -}}
{{ range .NoteGroups -}}
### {{ .Title }}

{{ range .Notes }}
{{ .Body }}
{{ end }}
{{ end -}}
{{ end -}}
{{ end -}}
