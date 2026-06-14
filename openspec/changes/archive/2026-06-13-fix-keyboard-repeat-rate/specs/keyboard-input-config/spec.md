## ADDED Requirements

### Requirement: Keyboard repeat rate configurabil

El sistema SHALL permitir configurar la velocidad de repetición de teclas (`repeat_rate`) y el retardo antes de repetir (`repeat_delay`) en Hyprland mediante la sección `input { keyboard {} }`.

#### Scenario: Repeat rate aplicado correctamente

- **WHEN** Hyprland carga la configuración con `repeat_rate = 35` y `repeat_delay = 200`
- **THEN** el compositor aplica esos valores y la repetición de teclas responde con latencia reducida

#### Scenario: Recarga en caliente

- **WHEN** se ejecuta `hyprctl reload` después de cambiar los valores
- **THEN** los nuevos valores de repeat_rate y repeat_delay se aplican sin necesidad de reiniciar Hyprland

#### Scenario: Validación de valores inválidos

- **WHEN** se configura un valor inválido (ej. `repeat_delay = -1`)
- **THEN** Hyprland rechaza la configuración y muestra un error en el log del compositor
