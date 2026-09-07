# dwkemotes

Menú de animaciones (emotes) para FiveM con interfaz NUI. Es un fork de
[rpemotes-reborn-nui](https://github.com/Jerrys-C/rpemotes-reborn-nui), que a su
vez deriva de [rpemotes-reborn](https://github.com/vipexv/rpemotes-reborn), con
la capa de interfaz reescrita y varias correcciones en el lado Lua.

Toda la biblioteca de animaciones, props y efectos del proyecto original se
mantiene sin cambios: más de 1.000 emotes, bailes, formas de caminar, estados de
ánimo, emojis y emotes compartidos.

---

## Qué cambia respecto al original

### Interfaz

| | Antes | Ahora |
|---|---|---|
| Iconos | Font Awesome desde CDN | Sprite SVG local, sin peticiones externas |
| Búsqueda | `includes()` sin orden | Puntuación por relevancia con resaltado |
| Columnas | 2 fijas | 1 a 4, a elección del jugador |
| Historial | — | Categorías **Recientes** y **Más usadas** |
| Secuencias | — | Categoría **Playlist**: varias animaciones encadenadas |
| Personalización | — | Panel de ajustes en el propio menú |
| Posición del panel | Se perdía al recargar | Se recuerda |
| Perfil | Atado al navegador | Exportable e importable como JSON |

**Sin CDN.** El menú cargaba Font Awesome desde `cdnjs.cloudflare.com` en cada
apertura. En un servidor sin salida a internet los iconos sencillamente no
aparecían, y cuando aparecían lo hacían después del primer pintado. Ahora los
trazos viajan con el recurso (`html/js/icons.js`) y se montan una vez como
`<symbol>`: cada tarjeta solo necesita un `<use>`.

**Búsqueda por relevancia.** Escribir `dance` ya no devuelve `linedance` antes
que `dance`. La puntuación va de coincidencia exacta a prefijo, prefijo de
palabra, subcadena, iniciales (`cross arms` ← `ca`) y subsecuencia difusa
(`crossarms` ← `cra`). Los tramos que coinciden se resaltan en la tarjeta.

**Historial de uso.** El cliente recuerda qué animaciones usa el jugador —desde
el menú, desde `/e` y desde los atajos de teclado— y las expone en dos
categorías nuevas. Todo se guarda en el KVP local: nada viaja al servidor.

**Panel de ajustes.** Botón de los deslizadores en la cabecera. Permite cambiar
color de acento, número de columnas, escala, animaciones, nombres de la barra
lateral, retardo de la vista previa (0 la desactiva) y visibilidad de las
categorías de historial. Se guarda en el cliente
de cada jugador y no afecta a los demás.

**Atajos de teclado.**

| Tecla | Acción |
|---|---|
| `↑` `↓` `←` `→` | Moverse por la rejilla |
| `Enter` | Reproducir lo seleccionado |
| `Tab` / `Shift+Tab` | Categoría siguiente / anterior |
| `Ctrl+1`…`Ctrl+9` | Saltar a la categoría *n* |
| `Ctrl+F` o `/` | Ir a la búsqueda |
| `F` | Marcar o desmarcar favorito |
| `Supr` | Cancelar la animación actual |
| `Inicio` / `Fin` | Primer / último elemento |
| `RePág` / `AvPág` | Página anterior / siguiente |
| `Esc` | Cerrar |
| `Shift` + clic | Colocar la animación en el mundo |
| Clic central | Asignar a una tecla |
| Clic derecho | Menú contextual |

El menú contextual recupera dos acciones que se habían perdido al pasar a NUI:
**animación en grupo** y **colocar en el mundo**.

### Lado Lua

- **`/emotes` ya existe.** Se sugería en el chat pero nunca se registró como
  comando. Ahora abre el menú, igual que `/emotemenu` y `/dwkemotes`.
- **`DisableControlsInMenu` y `DisableCombatInMenu` vuelven a funcionar.** Eran
  restos del menú NativeUI y no tenían ningún efecto.
- **Comprobador de versiones.** El original consultaba el repositorio del
  proyecto de origen, así que cualquier servidor veía avisos de "versión
  desactualizada" que no le correspondían. Ahora está desactivado por defecto y
  solo consulta el repositorio que se indique en `Config.UpdateRepo`.
- **Locale español completo.** Tenía 41 de 122 claves; el resto caía a inglés.
  Ahora está al día y es el idioma por defecto (`Config.MenuLanguage = 'es'`).
- **Sugerencias de chat** para `/walk` y `/mood`, que faltaban.
- **Se eliminó `NativeUI.lua`** (150 KB) y `header.png`: ningún archivo los
  cargaba desde que el menú es NUI.
- **Opciones muertas fuera de `config.lua`**: `MenuTitle`, `TitleOutline`,
  `TitleColour`, `CustomMenuEnabled` y `PreviewPedToggle` no hacían nada.

### Compatibilidad con rpemotes

El fork cambia de nombre, pero no rompe lo que ya dependía del original:

- `provide 'rpemotes'` y `provide 'rpemotes-reborn'` en el manifiesto.
- Los exports responden también a `exports.rpemotes:…` y
  `exports['rpemotes-reborn']:…`.
- El state bag de props se escribe en `dwkemotes:props` **y** en `rpemotes:props`
  (`Config.LegacyStateBagKey`, ponlo a `nil` si no lo necesitas).
- Los keybinds y favoritos guardados por rpemotes se importan una sola vez al
  entrar (`Config.MigrateLegacyKvp`), tanto los del KVP como los del
  almacenamiento local de la NUI.

Los **eventos de red** internos sí pasan a `dwkemotes:*`. Si tienes scripts
propios que escuchan `rpemotes:client:*`, actualiza el prefijo.

---

## Instalación

1. Copia la carpeta `dwkemotes` a tu carpeta `resources`.
2. Añade `ensure dwkemotes` a `server.cfg`.
3. Si vienes de rpemotes, quita el recurso anterior: los dos declaran
   `provide 'rpemotes'` y arrancarlos a la vez da conflictos.

Requiere OneSync y artifacts del servidor `6683` o superior.

---

## Configuración

Todo está en `config.lua` y comentado. Lo más relevante de este fork:

```lua
Config.MenuLanguage = 'es'      -- Idioma del menú (carpeta locales/)
Config.keybindKVP = 'dwkemotes' -- Prefijo de los datos guardados en el cliente
Config.MigrateLegacyKvp = true  -- Importar una vez lo guardado por rpemotes

-- Historial de uso
Config.RecentsEnabled = true
Config.MaxRecents = 30          -- Cuántas recientes se recuerdan
Config.MostUsedMinCount = 3     -- Usos mínimos para salir en "Más usadas"

-- Valores de partida de la interfaz (cada jugador puede cambiarlos después)
Config.UI = {
    accent = '#019685',   -- --rrp-teal del sistema de diseño ResetRP
    columns = 2,
    scale = 100,
    previewDelay = 500,
    animations = true,
    showRecents = true,
    showMostUsed = true,
    showLabels = false,   -- false = barra lateral de solo iconos
}

-- Comprobación de versiones: desactivada salvo que indiques tu repositorio
Config.CheckForUpdates = false
Config.UpdateRepo = nil -- p. ej. 'MiOrg/dwkemotes'
```

---

## Exports

Los del proyecto original siguen ahí. Los nuevos:

```lua
exports.dwkemotes:openMenu()            -- Abre el menú
exports.dwkemotes:closeMenu()           -- Lo cierra
exports.dwkemotes:isMenuOpen()          -- boolean
exports.dwkemotes:getAvailableEmotes()  -- Categorías filtradas por permisos y modelo
exports.dwkemotes:notify(msg, tipo, ms) -- Aviso en el menú ('success'|'error'|'warning'|'info')

exports.dwkemotes:getRecentEmotes()     -- { {name, label, emoteType, count}, ... }
exports.dwkemotes:getMostUsedEmotes()
exports.dwkemotes:clearEmoteUsage()

exports.dwkemotes:IsWalkLockEnabled()   -- boolean: caminar con la animación
exports.dwkemotes:SetWalkLock(bool)     -- fíjalo (aplica a la animación en curso)
exports.dwkemotes:ToggleWalkLock()      -- altérnalo
```

### Registrar animaciones desde otro recurso

`AddEmote` deja que un pack de props, una tienda o un minijuego metan sus
animaciones en el menú sin tocar `AnimationList.lua`.

```lua
exports.dwkemotes:AddEmote('mi_emote', {
    'anim@dict', 'anim_name', 'Mi animación',
    AnimationOptions = { EmoteLoop = true, Prop = 'prop_x' }
}, 'PropEmotes')   -- tipo opcional; por defecto 'Emotes'
```

El formato de la tabla es el mismo que el de las entradas de
`AnimationList.lua`, así que copiar una y cambiarle el diccionario ya vale.
Se puede llamar en cualquier momento del arranque: si el menú todavía no ha
construido su tabla, la animación entra en la cola de conversión. Aparece la
próxima vez que se abra el menú.

Devuelve `ok, error`. Rechaza los nombres duplicados de otro dueño y lo imprime
en consola, porque muchos recursos llaman con `pcall` y se tragan el valor
devuelto. Existen los alias `addEmote`, `AddPropEmote` y `RegisterEmote`, que
son los nombres que prueban los recursos escritos contra otros forks de
rpemotes.

Las animaciones registradas así quedan fuera del sistema de permisos ACE: el
manifiesto lo construye el servidor recorriendo su caché de emotes, que solo
contiene las de `AnimationList.lua` y `custom_emotes/`, así que sobre una
animación que llega después no puede opinar. Si necesitas restringirlas, hazlo
en el recurso que las registra.

Heredados y todavía disponibles: `EmoteCommandStart`, `EmoteCancel`,
`CanCancelEmote`, `IsPlayerInAnim`, `getCurrentEmote`, `IsPlayerCrouched`,
`IsPlayerProne`, `IsPlayerCrawling`, `GetPlayerProneType`, `StopPlayerProne`,
`IsPlayerInHandsUp`, `IsPlayerPointing`, `toggleWalkstyle`, `getWalkstyle`,
`setWalkstyle`, `toggleBinoculars`, `toggleNewscam`, `StartNewPlacement`,
`GetPlacementState`.

---

## Ajustar animaciones compartidas (`/emoteoffset`)

Las poses de pareja colocan a quien inicia la animación junto a la otra persona
usando cuatro números (`SyncOffsetFront`, `Side`, `Height` y `Heading`). Afinarlos
a ojo desde el `.lua` es lento, así que se pueden mover en vivo sobre la pose ya
puesta:

1. Lanza la animación compartida con normalidad y espera a que la acepten.
2. Quien la inició escribe **`/emoteoffset`**.
3. Ajusta con el teclado. Los valores se ven en pantalla mientras se mueven:

   | Tecla | Ajusta |
   |---|---|
   | `W` / `S` | adelante / atrás |
   | `A` / `D` | izquierda / derecha |
   | `R` / `F` | altura |
   | `Q` / `E` | giro |
   | `Shift` | paso grande (0.05 y 5°) en vez del fino (0.01 y 1°) |
   | `Enter` | guardar |
   | `Retroceso` | descartar |

Mientras dura el ajuste, tu compañero se queda inmóvil y los dos peds dejan de
chocar entre sí, para que lo que mides sea una distancia fija y no el resultado
de haberos empujado. Si tu cliente se cae a media calibración, el compañero se
suelta solo a los 10 segundos.

Al guardar, el valor se escribe en `data/sync_offsets.json` y se reparte a todos
los clientes en el momento: la siguiente vez que alguien lance esa animación ya
sale colocada, sin reiniciar el recurso.

Las teclas mueven los ejes del *offset*, que son relativos a la otra persona, no
a tu cámara: `W` desplaza por el eje frontal de tu pareja, que es justo el número
que acabará en el `.lua`.

**Cada lado de la pareja lleva su propio offset.** Quien se recoloca es siempre
quien inicia la animación, y puede iniciarla cualquiera de los dos: el juego usa
el `SyncOffset` de la entrada concreta que se elige en el menú. Una pose calibrada
solo por un lado sale a un metro cuando se lanza por el otro, así que hay que
ajustarla dos veces, una desde cada entrada.

Cuando el ajuste esté bien, se pasa al pack desde la consola del servidor:

```
emoteoffsets list                 # lo ajustado hasta ahora
emoteoffsets export               # escribe data/sync_offsets_export.lua
emoteoffsets apply                # lo escribe en los .lua de custom_emotes/
emoteoffsets clear <emote|all>    # descarta ajustes
```

`apply` reescribe la línea `addPair(...)` de cada animación en los packs
declarados en `Config.OffsetEditorPacks`, dejando copia en `data/*.bak`; hay que
reiniciar el recurso para que cargue el `.lua` nuevo. En esa línea los cuatro
primeros números son el offset del lado A y los cuatro siguientes, opcionales, el
del lado B; `apply` sustituye el que corresponda y conserva el otro. Lo que no esté declarado
con `addPair()` no se toca: `export` deja su bloque `AnimationOptions` listo para
pegar.

El editor está abierto a cualquier jugador por defecto. Para cerrarlo antes de
producción basta con dar un ACE a `Config.OffsetEditorAce`
(p. ej. `'dwkemotes.offseteditor'`); lo valida el servidor, tanto al abrirlo como
al guardar.

---

## Colocar props en las animaciones (`/propeditor`)

Los objetos que lleva el ped durante una animación se declaran con cuatro campos
(`Prop`, `PropBone`, `PropPlacement` y `PropNoCollision`) y se afinan igual de
mal a ojo desde el `.lua`: un cigarro girado 10° de más se ve enseguida en el
juego y no se adivina nunca leyendo números. El editor los coloca en vivo.

1. Lanza la animación y escribe **`/propeditor`**, o abre el editor y la
   animación de una vez con **`/propeditor <emote>`**.
2. La cámara pasa a orbitar alrededor del ped y sus huesos salen marcados como
   puntos. Pincha el hueso donde quieras colgar el objeto.
3. Elige el modelo: la lista trae los props que ya usa el pack y una selección de
   los del juego base, y el campo de texto acepta cualquier otro modelo — dice si
   este servidor lo tiene antes de intentarlo.
4. Colócalo:

   | Tecla | Ajusta |
   |---|---|
   | `W` / `S` | eje Y |
   | `A` / `D` | eje X |
   | `R` / `F` | eje Z |
   | `Ctrl` + esas | girar en vez de mover |
   | `Shift` | paso grande (0.05 m y 10°) en vez del fino (0.005 m y 1°) |
   | `Tab` | cambiar entre el prop principal y el secundario |
   | `Enter` | guardar |
   | `Retroceso` | salir |

   El panel de la derecha hace lo mismo con deslizadores y casillas de número, y
   la cámara se orbita arrastrando sobre el fondo (rueda para el zoom).

Mientras el editor está abierto se trabaja sobre una copia local del prop, para
poder recolocarla frame a frame sin reiniciar la animación y sin que el resto del
servidor vea el objeto bailando. Al guardar, el ajuste se escribe en
`propeditor/data/prop_overrides.json` y se reparte a todos los clientes en el
momento: los props se rehacen sin reiniciar el recurso.

### Dejarlo fijo en el pack

Lo que guardas **ya es permanente**: el JSON sobrevive a los reinicios y se aplica
al arrancar. Bajarlo al `.lua` sirve para que el pack se valga por sí mismo, sin
depender de `propeditor/data/`. Desde la consola del servidor:

```
emoteprops list                 # lo ajustado hasta ahora
emoteprops export               # escribe propeditor/data/prop_overrides_export.lua
emoteprops clear <emote|all>    # devuelve la emote a los props de su pack
```

El ciclo es: `export` → pegar el bloque `AnimationOptions` en el `.lua` de la
animación → `restart` y comprobar en el juego → `emoteprops clear <emote>` para
que a partir de ahí mande el pack.

Aquí no hay `apply` automático como en `/emoteoffset`: los props se declaran en
bloques repartidos por muchos ficheros y con formatos muy distintos, y
reescribirlos a ciegas destrozaría packs ajenos.

Dos avisos que ahorran un rato de desconcierto: **una animación de escenario
nunca puede llevar prop** (el juego la reproduce entera y `OnEmotePlay` sale antes
de enganchar nada), y **`client/AnimationList.lua` no se toca** — si la animación
vive ahí, se redefine en `custom_emotes/`, que se carga después y gana.

El detalle completo, con ejemplo y los casos raros, está en
**[`propeditor/README.md`](propeditor/README.md)**.

Todo el editor vive en **[`propeditor/`](propeditor/README.md)**: comentando el
bloque del final de `fxmanifest.lua` desaparece por completo, incluidos los
ajustes guardados. Igual que el de offsets, está abierto a cualquier jugador por
defecto y se cierra dando un ACE a `Config.PropEditor.ace`.

---

## Estructura

```
dwkemotes/
├── client/
│   ├── AnimationList.lua      Biblioteca de animaciones (sin tocar)
│   ├── EmoteMenu.lua          Puente Lua ↔ NUI, payload y callbacks
│   ├── Migrate.lua            Importación de datos de rpemotes        [nuevo]
│   ├── Usage.lua              Historial de uso                        [nuevo]
│   ├── Playlist.lua           Secuencias de animaciones               [nuevo]
│   ├── OffsetEditor.lua       Editor de SyncOffset en vivo            [nuevo]
│   ├── Syncing.lua            Animaciones compartidas
│   └── …
├── server/
│   ├── OffsetEditor.lua       Guarda y exporta los SyncOffset         [nuevo]
│   └── …
├── data/                      Lo que el recurso escribe en caliente   [nuevo]
├── html/
│   ├── index.html
│   ├── css/style.css
│   └── js/
│       ├── icons.js           Sprite SVG                              [nuevo]
│       ├── fuzzy.js           Puntuación de búsqueda                  [nuevo]
│       ├── store.js           Estado, ajustes, favoritos, listas
│       ├── grid.js            Rejilla virtualizada
│       ├── settings.js        Panel de ajustes                        [nuevo]
│       ├── playlist.js        Editor de playlists                     [nuevo]
│       ├── search.js
│       ├── smoothScroll.js
│       ├── nui.js
│       └── app.js
├── propeditor/                Editor de props en vivo                 [nuevo]
│   ├── config.lua             Sus ajustes
│   ├── client/                Cámara, previsualización, teclado
│   ├── server/                Persistencia y comandos de consola
│   ├── ui/                    Su capa de interfaz
│   └── data/                  Lo que guarda
├── locales/                   Traducciones (es y en completos)
├── docs/referencia-emotes.md  Cómo añadir animaciones, props y PTFX
└── config.lua
```

`propeditor/` es opcional y aislado a propósito: se desactiva comentando el
bloque del final de `fxmanifest.lua`, y lo único suyo que vive fuera son las dos
líneas de `html/index.html` que cargan su CSS y su JS (dos 404 inocuos si el
directorio no está).

Para añadir animaciones propias, props, efectos de partículas o emotes
compartidos, consulta **[docs/referencia-emotes.md](docs/referencia-emotes.md)**.

---

## Créditos y licencia

Publicado bajo **GPL-3.0**, la misma licencia del proyecto original.

Este trabajo no existiría sin:

- **[rpemotes-reborn](https://github.com/vipexv/rpemotes-reborn)** y toda la
  comunidad que ha mantenido la biblioteca de animaciones.
- **[rpemotes-reborn-nui](https://github.com/Jerrys-C/rpemotes-reborn-nui)**, de
  donde procede la primera versión NUI del menú.
- Los autores de las animaciones y props, acreditados uno a uno en
  [docs/referencia-emotes.md](docs/referencia-emotes.md) y en los comentarios de
  `client/AnimationList.lua`.
