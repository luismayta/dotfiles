# Changelog

All notable changes to this project will be documented in this file. This file uses change log convention from [keep a CHANGELOG](http://keepachangelog.com/en/0.3.0/).

{{- $jira := "https://hadenlabs.atlassian.net/browse" -}}
{{- $pattern := "([A-Z]+-[0-9]+)" -}}

{{ range .Versions }}
<a name="{{ .Tag.Name }}"></a>
## {{ if .Tag.Previous }}[{{ .Tag.Name }}]({{ $.Info.RepositoryURL }}/compare/{{ .Tag.Previous.Name }}...{{ .Tag.Name }}){{ else }}{{ .Tag.Name }}{{ end }}

> {{ datetime "2006-01-02" .Tag.Date }}

{{ range .CommitGroups -}}

### {{ .Title }}

{{ range .Commits -}}
{{- $subject := regexReplaceAll $pattern .Subject (printf "[$1](%s/$1)" $jira) -}}
* {{ $subject }}
{{ end }}
{{ end -}}

{{- if .RevertCommits -}}

### Reverts

{{ range .RevertCommits -}}
{{- $header := regexReplaceAll $pattern .Revert.Header (printf "[$1](%s/$1)" $jira) -}}
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
