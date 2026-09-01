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
color de acento, número de columnas, escala, opacidad, modo compacto,
animaciones, nombres de la barra lateral, retardo de la vista previa (0 la
desactiva) y visibilidad de las categorías de historial. Se guarda en el cliente
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
    accent = '#0A84FF',
    columns = 2,
    scale = 100,
    opacity = 92,
    previewDelay = 500,
    compact = false,
    animations = true,
    showRecents = true,
    showMostUsed = true,
    showLabels = true,
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
```

Heredados y todavía disponibles: `EmoteCommandStart`, `EmoteCancel`,
`CanCancelEmote`, `IsPlayerInAnim`, `getCurrentEmote`, `IsPlayerCrouched`,
`IsPlayerProne`, `IsPlayerCrawling`, `GetPlayerProneType`, `StopPlayerProne`,
`IsPlayerInHandsUp`, `IsPlayerPointing`, `toggleWalkstyle`, `getWalkstyle`,
`setWalkstyle`, `toggleBinoculars`, `toggleNewscam`, `StartNewPlacement`,
`GetPlacementState`.

---

## Estructura

```
dwkemotes/
├── client/
│   ├── AnimationList.lua      Biblioteca de animaciones (sin tocar)
│   ├── EmoteMenu.lua          Puente Lua ↔ NUI, payload y callbacks
│   ├── Migrate.lua            Importación de datos de rpemotes        [nuevo]
│   ├── Usage.lua              Historial de uso                        [nuevo]
│   └── …
├── html/
│   ├── index.html
│   ├── css/style.css
│   └── js/
│       ├── icons.js           Sprite SVG                              [nuevo]
│       ├── fuzzy.js           Puntuación de búsqueda                  [nuevo]
│       ├── store.js           Estado, ajustes, favoritos, listas
│       ├── grid.js            Rejilla virtualizada
│       ├── settings.js        Panel de ajustes                        [nuevo]
│       ├── search.js
│       ├── smoothScroll.js
│       ├── nui.js
│       └── app.js
├── locales/                   Traducciones (es y en completos)
├── docs/referencia-emotes.md  Cómo añadir animaciones, props y PTFX
└── config.lua
```

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
