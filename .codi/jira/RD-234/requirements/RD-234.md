# Task: Refactorizar el modulo herdr: naming, estructura y testing

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Unificar naming con prefijo de padre, dividir el god file de pkg/, eliminar duplicados en bin/ y agregar tests bats
- component: DevOps
- labels: [herdr, refactor, tech-debt, zsh, testing]
- parentEpic: <no value>
- issueKey: RD-234
- jpdSource: <no value>

## Scenario

El modulo zsh/modules/herdr tiene 2622 lineas en 47 archivos y CERO tests. Crecio por acumulacion: cada comando nuevo se sumo al final de pkg/helper.zsh en vez de crear un modulo propio. El resultado son cinco problemas que se refuerzan entre si.

Problemas identificados:

1. Naming. `hrd::internal::derive_project_name` produce `{parent_dir}-{current_dir}`. Para un proyecto en una carpeta padre `codiplab` llamado `base-template` produce `codiplab-base-template`. La misma funcion esta clonada verbatim en zsh/modules/tmux/internal/base.zsh:37-64.

2. Estructura. pkg/helper.zsh tiene 390 lineas y 10 funciones de 5 concerns sin relacion: lifecycle, project launcher, editores de configuracion, gestion de plugins y worktree. Es el archivo mas grande del modulo y junto con data/config.toml (301 lineas) e internal/install.zsh (188 lineas) concentra el 33% del modulo.

3. Duplicacion. bin/ contiene tres CLIs bash que reimplementan la logica de worktree de pkg/helper.zsh bajo los mismos nombres de usuario pero con backends distintos: `git worktree` crudo contra `herdr worktree`. Son 475 lineas. El mismo comando produce resultados distintos segun como se invoque. El prefijo de rama git-flow esta copiado en 4 lugares.

4. Deriva de spec. herdr-project.md seccion 6 describe un tab unico de 3 panes, pero internal/pane.zsh:100 pone 2 tabs por defecto. El diagrama ASCII en pane.zsh:11-14 contradice su propio codigo en las lineas 66-87.

5. Higiene. No hay chequeo de sintaxis `zsh -n` en pre-commit ni en CI, que solo corre shellcheck. La indentacion mezcla 2 y 4 espacios aunque `.editorconfig` exige 2 para `[*]`. Codigo muerto: `derive_repo_name` no lo llama nadie, `list_templates` y `select_template` no se invocan desde pkg/helper.zsh, y los stubs pkg/osx.zsh, pkg/linux.zsh y pkg/alias.zsh estan vacios.

Decisiones ya tomadas con el solicitante:

- El prefijo de carpeta padre NO se calcula por algoritmo. `codiplab` a `cl` no es derivable: por consonantes daria `cdplb`, por truncado daria `cod`. Se usa un mapa explicito `parent_dir -> prefix` declarado en config.
- Sin entrada en el mapa, el padre se usa completo. Es el comportamiento actual y no debe romperse para proyectos fuera de CodipLabs.
- Los workspaces ya creados con el formato largo NO se recrean: el lookup prueba primero la etiqueta nueva y, si no existe, prueba la legacy.

Esta task se ejecuta en cuatro fases ordenadas. Cada fase debe dejar el modulo con los tests en verde antes de empezar la siguiente. El orden no es negociable: la Fase 2 cambia el formato de las etiquetas de workspace y necesita la red de la Fase 1 para detectar regresiones; la Fase 3 toca los mismos archivos que la Fase 2 y por eso va despues en lugar de en paralelo.

FASE 1, red de tests. Crear zsh/modules/herdr/tests/ siguiendo el precedente de zsh/modules/git/tests/run.sh. No toca codigo de produccion.

FASE 2, naming. Implementar el mapa de prefijos, el fallback legacy y extraer la derivacion a un helper compartido entre herdr y tmux. Es la unica fase que cambia comportamiento observable.

FASE 3, reestructuracion. Dividir pkg/helper.zsh, unificar bin/ con pkg/helper.zsh y normalizar los namespaces `hrd::` y `herdr::`. Puro estructural, cero cambios de comportamiento.

FASE 4, higiene. Reconciliar la spec con el codigo, eliminar el codigo muerto y agregar el chequeo de sintaxis a CI.


### Acceptance Tests

FASE 1, tests:

1. Existe zsh/modules/herdr/tests/ con un runner al estilo de zsh/modules/git/tests/run.sh.
2. Casos para las tres ramas de derivacion: PWD igual a HOME da `core`; padre igual a HOME da `core-{dir}`; el resto da `{parent}-{dir}` mas prefijo.
3. Casos de slug: caracteres no alfanumericos convertidos a `-`, guiones repetidos colapsados, guiones inicial y final removidos, mayusculas convertidas a lowercase.
4. Caso con argumento explicito en `$1`, que tiene prioridad sobre el contexto de directorio.
5. Casos con espacios, puntos y caracteres no ASCII en el nombre del directorio, para fijar el comportamiento del slug.
6. Casos de codigos de salida de `hrd::project` con `herdr` mockeado: adjuntar a workspace existente retorna 0, creacion retorna 0, decline retorna 0, fallo duro retorna 1.
7. zsh/modules/herdr/Taskfile.yml gana un target `test` ejecutable.
8. Los tests fallan si alguien altera las reglas de derivacion documentadas.

FASE 2, naming:

9. Con un padre que tiene entrada en el mapa, el nombre derivado usa el prefijo. Caso de referencia: padre `codiplab`, actual `base-template`, resultado `cl-base-template`.
10. Con un padre sin entrada en el mapa, se usa el nombre completo del padre, con comportamiento identico al actual.
11. El mapa se declara en zsh/modules/herdr/config/base.zsh y el usuario puede sobreescribirlo sin editar el repo.
12. Lookup con fallback: cuando la etiqueta nueva no existe en `herdr workspace list`, se intenta la legacy `{parent_dir}-{current_dir}` y se adjunta a ese workspace. Nunca se recrea un workspace ya existente.
13. Se preservan sin modificacion las tres ramas de derivacion y las reglas de slug.
14. `ZSH_HERDR_WORKSPACE_PREFIX`, en config/base.zsh linea 11, hoy declarado y nunca leido, queda documentado como reservado o se elimina. No queda un hook declarado que ningun codigo lea.
15. Los 4 call sites de pkg/helper.zsh, lineas 105, 277, 342 y 377, siguen funcionando: hrd::project adjunta o crea, hrdw::create, open y remove resuelven el workspace por label.
16. La funcion sigue siendo pura: no muta estado global ni toca el filesystem.
17. Existe una unica fuente de verdad para la derivacion del nombre, compartida por herdr y tmux.
18. zsh/modules/tmux/internal/base.zsh deja de contener la copia y delega en el helper compartido.
19. Sin cambio observable en tmux: `tx::project` sigue produciendo el mismo nombre de sesion y los mismos codigos de salida.
20. El helper compartido usa la sintaxis `function name {` y vive en el modulo de sistema correspondiente. No se crea una tercera copia.

FASE 3, reestructuracion:

21. pkg/helper.zsh queda dividido en modulos cohesivos bajo pkg/: project.zsh, worktree.zsh, plugin.zsh, config-editor.zsh y lifecycle.zsh.
22. pkg/main.zsh hace source de los nuevos archivos en el orden correcto.
23. La API publica no cambia: `hrd`, `hrdk`, `hrd::start`, `hrd::project`, `hrd::plugin`, `hrdw::list`, `hrdw::create`, `hrdw::open`, `hrdw::remove`, `edit-herdr-config` y `edit-herdr-plugins` siguen disponibles tras sourced el plugin.
24. Ningun archivo resultante supera 150 lineas.
25. El namespace de cada funcion se preserva exactamente, sin renombrar nada.
26. Queda una sola implementacion de la logica de worktree: bin/ delega en la de pkg/, o se elimina documentando el reemplazo.
27. bin/hrdw-create y bin/hrdw-delete usan la misma derivacion de nombre que pkg/helper.zsh, incluido el slugify, el prefijo `core` y el prefijo de carpeta padre.
28. La divergencia de backend queda resuelta y documentada: o los dos lados usan `herdr worktree`, o los dos usan `git worktree` crudo. No queda un comando cuyo comportamiento depende de como se invoque.
29. El prefijo de rama git-flow, hoy copiado en 4 lugares, se define en un unico lugar.
30. La etiqueta de worktree se construye igual en ambos lados: `{project_context}/{branch_leaf}`.
31. Se elige una unica convencion de namespace en internal/ y pkg/, en lugar de la convivencia actual de `hrd::internal::*` y `herdr::internal::*`, y queda escrita en herdr-project.md o en el README.
32. Si hay codigo fuera del modulo que llame a los nombres viejos, se actualiza o se documenta el alias. La busqueda debe cubrir todo el repo, no solo zsh/modules/herdr.
33. Cero cambios de comportamiento observable en esta fase.

FASE 4, higiene:

34. herdr-project.md seccion 3 documenta las reglas nuevas de derivacion y el fallback legacy.
35. herdr-project.md seccion 6 y internal/pane.zsh coinciden: si el layout por defecto es de 2 tabs, la spec lo dice; si es de 1 tab, el codigo cambia.
36. El diagrama ASCII de pane.zsh lineas 11 a 14 se corrige para reflejar el orden real de creacion de panes de las lineas 66 a 87.
37. El codigo muerto se elimina o se conecta: `derive_repo_name`, `list_templates`, `select_template` y los stubs vacios pkg/osx.zsh, pkg/linux.zsh y pkg/alias.zsh.
38. pre-commit y CI ejecutan `zsh -n` sobre todos los .zsh del modulo, no solo shellcheck.
39. La indentacion se normaliza a 2 espacios en todo el modulo, segun `.editorconfig`.
40. README.md se regenera con `task readme` desde README.yaml si cambian archivos o comandos. README.md es generado, nunca se edita a mano.

Cierre:

41. Las cuatro fases se ejecutan en orden y cada una deja los tests en verde al terminar.
42. shellcheck pasa sobre todo el modulo. CI corre pre-commit con `--exclude=SC1072,SC1073,SC2068,SC1091`.
43. El ahorro de lineas duplicadas queda cuantificado en la descripcion del PR de cierre.


### Sources

- zsh/modules/herdr/internal/base.zsh (hrd::internal::derive_project_name, lineas 41-67; y resolve_workspace_id, lineas 125-130)
- zsh/modules/herdr/pkg/helper.zsh (390 lineas, 10 funciones; call sites del naming en 105, 277, 342 y 377; prefijo git-flow duplicado en 267-273 y 332-338)
- zsh/modules/herdr/config/base.zsh (ZSH_HERDR_WORKSPACE_PREFIX linea 11, declarado y nunca leido)
- zsh/modules/herdr/pkg/main.zsh (orden de sourcing)
- zsh/modules/herdr/pkg/base.zsh (53 lineas, patron de wrappers finos ya existente)
- zsh/modules/herdr/pkg/osx.zsh, pkg/linux.zsh, pkg/alias.zsh (stubs vacios)
- zsh/modules/herdr/plugin.zsh (punto de entrada; prepend de bin/ al PATH)
- zsh/modules/herdr/internal/pane.zsh (138 lineas; diagrama ASCII contradictorio en 11-14; creacion de panes en 66-87; 2 tabs por defecto en linea 100)
- zsh/modules/herdr/internal/worktree.zsh (implementacion zsh; derive_repo_name lineas 11-22 sin uso)
- zsh/modules/herdr/internal/workspace.zsh, install.zsh, update.zsh, osx.zsh, linux.zsh (namespace herdr::internal::* frente a hrd::internal::*)
- zsh/modules/herdr/bin/hrdw-create (163 lineas; variante de naming en 69-74; prefijo git-flow en 115-121)
- zsh/modules/herdr/bin/hrdw-delete (187 lineas; naming inline en 86-90; prefijo en 175-181)
- zsh/modules/herdr/bin/hrdw-list (125 lineas)
- zsh/modules/herdr/herdr-project.md (seccion 2 codigos de salida, seccion 3 reglas de derivacion, seccion 6 layout, seccion 9 notas de Rust)
- zsh/modules/herdr/README.yaml y zsh/modules/herdr/Taskfile.yml (README.md es generado)
- zsh/modules/tmux/internal/base.zsh lineas 37-64 (tx::internal::derive_project_name, clon)
- zsh/modules/tmux/pkg/helper.zsh linea 29 (call site en tmux)
- zsh/modules/tmux/data/sync/tmuxinator/default.yml lineas 1-2 (el nombre llega como nombre de sesion)
- Precedente de testing: zsh/modules/git/tests/run.sh y zsh/modules/git/tests/test_helper.bash
- .github/workflows/lint.yml y .pre-commit-config.yaml lineas 141-150 (CI actual, solo shellcheck)
- .editorconfig (regla `[*]` indent_size 2)

- https://github.com/luismayta/dotfiles.git