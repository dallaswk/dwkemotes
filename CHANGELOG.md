# Changelog

## dwkemotes v1.0.0

Fork de `rpemotes-reborn-nui` con la capa de interfaz reescrita. La biblioteca de
animaciones se mantiene intacta.

### Interfaz

- **Fuera el CDN de Font Awesome.** Los iconos son ahora un sprite SVG local
  (`html/js/icons.js`) montado una sola vez: el menu funciona sin salida a
  internet y no hay iconos que aparezcan tarde.
- **Busqueda por relevancia** (`html/js/fuzzy.js`): coincidencia exacta, prefijo,
  prefijo de palabra, subcadena, iniciales y subsecuencia difusa, con resaltado
  de los tramos coincidentes. Antes era `includes()` sin ningun orden.
- **Categorias "Recientes" y "Mas usadas"**, alimentadas por el historial local.
- **Panel de ajustes** dentro del menu: color de acento, columnas (1-4), escala,
  opacidad, modo compacto, animaciones, nombres de la barra lateral, retardo de
  la vista previa y visibilidad de las categorias de historial.
- **Rejilla de columnas configurables.** Antes eran dos fijas.
- **Perfil exportable e importable** (favoritos, listas y ajustes) como JSON.
- **La posicion del panel arrastrado se recuerda**; doble clic en el asa la
  restablece.
- **Atajos nuevos**: `Tab`/`Shift+Tab` entre categorias, `Ctrl+1..9`, `Ctrl+F` y
  `/` para buscar, `F` favorito, `Supr` cancelar, `Inicio`/`Fin`, `RePag`/`AvPag`.
- **Menu contextual con animacion en grupo y colocacion en el mundo**, dos
  acciones que se habian perdido en el paso a NUI.
- Estados vacios con icono y texto propio segun la categoria.
- `prefers-reduced-motion` y el interruptor de animaciones se respetan en toda la
  interfaz, incluido el desplazamiento suave.

### Correcciones

- **Un bloque negro tapaba el ped de vista previa.** El panel usaba
  `backdrop-filter`, pero en la NUI de FiveM el juego se dibuja en otra capa del
  compositor: el filtro no tiene backdrop que leer y CEF rellena la region con
  negro opaco, justo encima de la zona donde aparece la vista previa. Retirado
  del panel y de los modales, junto con la sombra de 5rem que pintaba un halo
  enorme sobre el juego.
- **Los nombres de la barra lateral se cortaban a siete caracteres**, con lo que
  dos categorias distintas quedaban como "Animaci". Ahora se ajustan en dos
  lineas con puntos suspensivos.
- **Orden natural de los numeros**: "Dance Club 2" iba detras de "Dance Club 10".

- **`/emotes` se sugeria en el chat pero no existia como comando.** Ahora abre el
  menu, igual que `/emotemenu` y el nuevo `/dwkemotes`.
- **`Config.DisableControlsInMenu` y `Config.DisableCombatInMenu` no hacian
  nada** desde el paso a NUI. Vuelven a aplicarse.
- **El comprobador de versiones apuntaba al repositorio del proyecto de origen**,
  de modo que cualquier servidor recibia avisos de version desactualizada que no
  le correspondian. Ahora esta desactivado por defecto y solo consulta
  `Config.UpdateRepo`.
- **Locale espanol completo**: tenia 41 de 122 claves. Ahora esta en paridad con
  el ingles y es el idioma por defecto.
- Faltaban sugerencias de chat para `/walk` y `/mood`.
- El panel abria demasiado grande; se ha reducido el tamano de partida (cada
  jugador puede escalarlo entre el 80 % y el 130 % desde los ajustes).
- El desplazamiento suave acumulaba el objetivo sin resincronizar tras un salto
  externo, lo que provocaba saltos al volver a usar la rueda.

### Mantenimiento

- Eliminados `NativeUI.lua` (150 KB) y `header.png`: ningun archivo los cargaba.
- Fuera de `config.lua` las opciones sin efecto: `MenuTitle`, `TitleOutline`,
  `TitleColour`, `CustomMenuEnabled`, `PreviewPedToggle`.
- La documentacion tecnica de creacion de emotes se conserva en
  `docs/referencia-emotes.md`.

### Compatibilidad

- `provide 'rpemotes'` y `provide 'rpemotes-reborn'` siguen declarados.
- Los exports responden tambien bajo los nombres `rpemotes` y `rpemotes-reborn`.
- El state bag de props se escribe en `dwkemotes:props` y, como espejo, en
  `rpemotes:props` (`Config.LegacyStateBagKey`).
- Los keybinds, favoritos y listas guardados por rpemotes se importan una sola
  vez, tanto del KVP como del almacenamiento local de la NUI.
- **Cambio con impacto**: los eventos de red internos pasan de `rpemotes:*` a
  `dwkemotes:*`. Los scripts propios que los escuchen deben actualizarse.

---

# Historial heredado de rpemotes-reborn-nui

## v2.1.1-ea.1 (2026-06-03)

Synced functional fixes from upstream up to `2.1.1`, excluding all UI/NUI changes (this fork uses its own `html/` NUI). Version aligned to upstream `2.1.1` with the fork's `-ea.1` pre-release suffix.

### Bug Fixes (Cherry-picked from upstream)

- **Gracefully clear scenarios while in vehicles** (upstream `a6205ce`)
- **Fix keybind functions in `animations:` events** - Bridge was calling non-existent `DeleteEmote`/`ListKeybinds` and a wrong `EmoteBindStart` signature (upstream `f2a8c01`)
- **Add missing arguments to various natives** (`SetCamRot`, `IsPedInAnyVehicle`, `SetFacialIdleAnimOverride`, fixed undefined `ped` var in `CleanUpPlacement`) (upstream `d5b9bd9`)
- **Correctly start newscam and binoculars anims** (upstream `791281c`)
- **Player ped now turns with the camera** while using binoculars/newscam (upstream `8d51e92`)
- **Use correct native name for ambient sound** in binoculars/newscam (upstream `9d273ac`)
- **Block emotes/expressions/emojis when ped is busy or dead**; default prop texture variation to `1` on `/e` (non-UI parts of upstream `#300`)

### Improvements

- **Expose `StartNewPlacement` and `GetPlacementState` as exports** (upstream `425f10d`)
- **Model compatibility update** - added new Popcorn RP pet models (upstream `ed92c06`)

### Maintenance

- **Update checker now points to this fork** (`Jerrys-C/rpemotes-reborn-nui`) instead of upstream, so it no longer reports outdated against upstream releases
- Removed redundant `lua54` field from `fxmanifest` (upstream `d9db2ef`)

## v2.0.4-ea.2 (2026-04-15)

### Bug Fixes (Cherry-picked from upstream)

- **Fixed hoe animations** (upstream `dbac5b7`)
- **Use `CanDoAction()` bridge function for pointing** - Fixed pointing not using the framework bridge function (upstream `6a70178`)

### Improvements

- **Added UI notification feedback for blocked emote/cancel states** - Players now receive a notification when emote or cancel actions are blocked, instead of being silently ignored
- **Default OneSync check behavior changed** - The `onesync` config variable now defaults to `"on"`, preventing unexpected behavior when not explicitly configured
