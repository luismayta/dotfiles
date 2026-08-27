# Task: Implementar soporte para múltiples tabs en el layout de pane herdr

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Modificar setup_3_pane_layout para crear 2 tabs por defecto con layout de 3 paneles
- component: 
- labels: [herdr, zsh, multi-tab]
- parentEpic: RD-30
- issueKey: RD-130
- jpdSource: 

## Scenario

Actualmente herdr solo crea un tab con 3 paneles. Los desarrolladores necesitan múltiples contextos simultáneos (uno para código, otro para tests/monitoreo). Este cambio permite crear 2 tabs automáticamente, cada uno con su propio layout de 3 paneles (editor, shell, agent).

### Acceptance Tests

- setup_3_pane_layout sin argumento num_tabs crea 2 tabs
- setup_3_pane_layout con num_tabs=1 crea 1 tab
- setup_3_pane_layout con num_tabs=3 crea 3 tabs
- Cada tab tiene layout de 3 paneles (editor, shell, agent)
- Se emite warning si falla la creación de tab pero continúa
- Se enfoca en el primer tab después de completar
- Syntax zsh válido
- Shellcheck limpio

### Sources


- https://github.com/luismayta/dotfiles.git
