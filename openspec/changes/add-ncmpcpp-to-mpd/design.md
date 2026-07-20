## Context

El módulo `zsh/modules/mpd/` gestiona MPD (Music Player Daemon) con una arquitectura de 3 capas: config (valores), internal (install/service), pkg (API pública/aliases). Actualmente solo incluye `mpd`, `mpc` y `fmt`. ncmpcpp es un cliente NCurses que provee interfaz visual rica en terminal para navegar biblioteca, colas, y controlar playback.

## Goals / Non-Goals

**Goals:**
- Agregar ncmpcpp como paquete del módulo con instalación automática
- Configuración base funcional (colores, layout, atajos de teclado)
- Alias para lanzamiento rápido
- Seguir la arquitectura existente del módulo (config/internal/pkg)

**Non-Goals:**
- Configuración avanzada de skins personalizados
- Integración con servicios de streaming externos
- Modificar la funcionalidad existente de mpc/mpd

## Decisions

### 1. Estructura de archivos del módulo

**Decisión**: Mantener la misma estructura de 3 capas existente.

```
zsh/modules/mpd/
├── config/
│   ├── base.zsh          # Agregar NCMP_CPP_PACKAGE_NAME
│   └── linux.zsh/osx.zsh # Sin cambios
├── internal/
│   └── base.zsh          # Agregar install de ncmpcpp
├── pkg/
│   ├── base.zsh          # Agregar mpd::ncmpcpp()
│   └── alias.zsh         # Agregar alias ncmp/ncmpcpp
└── data/
    └── ncmpcpp/
        ├── config        # Configuración principal
        └── bindings      # Atajos de teclado
```

**Razón**: Consistencia con patrón existente. No hay razón para romper la arquitectura.

### 2. Configuración de ncmpcpp

**Decisión**: Crear config minimal pero funcional en `data/ncmpcpp/config`.

```conf
mpd_host = "localhost"
mpd_port = "6600"
mpd_connection_timeout = "60"
music_directory = "~/Music"
playlist_directory = "~/.mpd/playlists"
visualizer_data_source = "/tmp/mpd.fifo"
visualizer_look = "●▮"
visualizer_type = "spectrum"
user_interface = "alternative"
startup_screen = "playlist"
startup_slave_mode = "no"
alternative_header_first_line_format = "$b$1]$track$9$/b$1|$tag artist$9$R$/b$9$4$album$9$/b$9$3[%tag date$9$]$3$4$at$9$3$time$9$/b"
alternative_header_second_line_format = "$b$aqqu$/a$9$/b$1$crqs$/b$9$3 $4$at$9$3$time$9$/b$9$1 $queue-length$9$4 songs$9$3 playlist$9$3$4$4$9$]$R$9$/b"
```

**Razón**: Configuración estándar que funciona out-of-the-box con MPD local. El visualizer spectrum es popular y la UI alternativa es más moderna.

### 3. Ubicación de configuración

**Decisión**: Symlink de `data/ncmpcpp/config` a `~/.ncmpcpp/config`.

**Razón**: ncmpcpp busca su config en `~/.ncmpcpp/`. Usar symlink permite mantener fuente de verdad en el repo.

### 4. Aliases

**Decisión**: Aliases dedicados `ncmp` y `ncmpcpp`.

```
ncmp="ncmpcpp"
ncmpcpp="ncmpcpp"  # redundant pero explícito
```

**Razón**: `ncmp` es el alias corto estándar en la comunidad.

## Risks / Trade-offs

- **[Riesgo]** ncmpcpp no disponible en todos los gestores de paquetes → Mitigación: usar core::install que maneja brew/apt
- **[Riesgo]** Config puede no funcionar si MPD no está corriendo → Mitigación: ncmpcpp maneja esto gracefully, muestra error
- **[Trade-off]** Config minimal vs configuración rica → Elegimos minimal para evitar opiniones fuertes, usuario puede personalizar después
