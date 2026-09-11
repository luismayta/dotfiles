# Task: Implementar setup de chrome-headless-shell para mermaid en dotfiles

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Crear script de instalacion y configuracion de chrome-headless-shell y mmdc para renderizado de diagramas mermaid
- component: DevOps
- labels: []
- parentEpic: 
- issueKey: RD-174
- jpdSource: 

## Scenario

El renderizado de diagramas mermaid con mmdc (mermaid-cli) requiere chrome-headless-shell. La instalacion actual se realizo via npx @puppeteer/browsers y vive en /tmp (efimera). Se necesita un setup reproducible y persistente en dotfiles para que el renderizado de diagramas funcione de forma estable.

### Acceptance Tests

- Script de instalacion de chrome-headless-shell en ubicacion persistente (~/.local/share/chrome-headless-shell)
- Configuracion de puppeteer-config.json con executablePath correcto
- mmdc renderiza diagramas mermaid sin errores
- Documentacion del setup en dotfiles

### Sources

- npx @puppeteer/browsers install chrome-headless-shell@stable
- https://github.com/luismayta/dotfiles.git
- https://github.com/luismayta/dotfiles.git