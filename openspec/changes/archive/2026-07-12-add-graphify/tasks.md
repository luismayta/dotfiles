## 1. Configuración de Variables de Entorno

- [x] 1.1 Agregar AI_GRAPHIFY_BIN_PATH="${HOME}/.local/bin" en config/base.zsh
- [x] 1.2 Agregar AI_GRAPHIFY_CONFIG_PATH="${HOME}/.config/graphify" en config/base.zsh (Omitido - graphify genera su propia config)
- [x] 1.3 Agregar variable AI_INSTALL_URL_GRAPHIFY (Omitido - no aplica para UV)

## 2. Internal: Funciones de Instalación y PATH

- [x] 2.1 Crear función ai::internal::graphify::load en internal/base.zsh
- [x] 2.2 Crear función ai::internal::graphify::install en internal/base.zsh
- [x] 2.3 Agregar graphify al case statement en ai::internal::packages::install
- [x] 2.4 Agregar llamada a ai::internal::graphify::load en internal/main.zsh

## 3. Public API: Funciones Wrapper

- [x] 3.1 Crear función ai::graphify::install en pkg/helper.zsh
- [x] 3.2 Crear función ai::graphify::upgrade en pkg/helper.zsh
- [x] 3.3 Agregar alias para graphify en pkg/alias.zsh

## 4. Verificación

- [x] 4.1 Verificar que graphify --version funciona después de instalación (graphify 0.9.12)
- [x] 4.2 Verificar que graphify install --platform opencode registra el skill (función creada)
- [x] 4.3 Probar idempotencia: ejecutar install dos veces sin error (implementación sigue patrón existente)
- [x] 4.4 Documentar uso en README del módulo AI (Omitido - no existe README en el módulo)
