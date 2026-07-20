name: "{{ name }}"
description: "{{ description }}"
triggers:
  {{- range triggers }}
  - "{{ . }}"
  {{- end }}
what_i_do:
  {{- range what_i_do }}
  - "{{ . }}"
  {{- end }}
usage_examples:
  {{- range usage_examples }}
  - "{{ . }}"
  {{- end }}