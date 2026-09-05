# Changelog

## dwkemotes v1.0.0

Fork de `rpemotes-reborn-nui` con la capa de interfaz reescrita. La biblioteca de
animaciones se mantiene intacta.

### Interfaz

- **Sistema de diseno ResetRP, version de negro neutro.** `html/design-system/`
  se actualiza a la revision en la que las superficies pierden el tinte verde y
  el reparto de color queda cerrado: negro para todas las superficies, teal solo
  para seleccion y accion principal, amarillo solo para avisar, y el hover
  neutro -- sube la superficie y marca mas el borde, sin teñir. El acento por
  defecto pasa de amarillo a teal, porque en este sistema el amarillo no marca lo
  que esta elegido; el amarillo sigue en el selector como acento puntual.
  Cambios que trae de arrastre: `surface-2` es ahora mas oscura que `surface-1`
  (el panel es el papel y la tarjeta va hundida), los radios bajan (8/14 -> 6/8),
  los botones son neutros y el degradado teal se reserva a la unica accion
  dominante de cada pantalla -- aqui, guardar una lista.
- **El panel se trata como la tarjeta activa del inventario acoplado**
  (`.rrp-dock__card.is-active`), porque el menu abierto es justo eso: la ventana
  con la que el jugador esta trabajando. Mismo degradado de superficie en
  diagonal, misma opacidad (`--rrp-dock-alpha`, 0.95), el borde que arranca teal
  por el canto izquierdo y se apaga a neutro antes de llegar al otro, la linea
  del canto, el halo teal corto y la elevacion negra -- anillo exterior mas
  sombra -- que separa el panel de un fondo de juego claro. El asa de arrastre
  pasa a ser el `.rrp-notch` del sistema: la cejilla teal con halo. Las dos NUI
  pueden verse a la vez en pantalla y ahora parecen de la misma familia.
- **Los iconos de categoria son monocromos.** Heredan el color de su fila como
  `.rrp-nav__icon`, y solo las listas del jugador conservan color propio, que es
  contenido suyo. La categoria activa se marca como `.rrp-nav__item.is-active`:
  velo del acento, borde y el halo inferior de 1 px, en lugar de la barra de
  color al costado.
- **Los ajustes guardados se migran por version** (`SETTINGS_VERSION`). Un valor
  por defecto nuevo no llega a quien ya tiene el ajuste guardado, y el acento y
  la barra lateral no son preferencias sino decisiones de diseño: se reponen una
  vez y el resto de lo que haya elegido el jugador se respeta.
- **El amarillo sale del selector de acento.** Aqui el acento marca la categoria
  activa, la tarjeta seleccionada y los favoritos; el amarillo del sistema avisa
  y no selecciona, asi que no puede ser el acento. Quedan los dos teales.
- **Barra lateral de solo iconos y dos columnas, de partida.** Cada icono
  conserva su tooltip y su `aria-label`, que es lo que el sistema pide para un
  icono sin etiqueta. Los nombres se recuperan desde los ajustes.
- **Fuera el deslizador de opacidad y el modo compacto.** La opacidad la fija
  ahora el sistema de diseño, para que el menu no pueda quedar mas transparente
  o mas opaco que el resto de las NUI; el modo compacto no aportaba sobre el
  ajuste de escala, que hace lo mismo y afecta a todo el panel.
- **Fuera el CDN de Font Awesome.** Los iconos son ahora un sprite SVG local
  (`html/js/icons.js`) montado una sola vez: el menu funciona sin salida a
  internet y no hay iconos que aparezcan tarde.
- **Busqueda por relevancia** (`html/js/fuzzy.js`): coincidencia exacta, prefijo,
  prefijo de palabra, subcadena, iniciales y subsecuencia difusa, con resaltado
  de los tramos coincidentes. Antes era `includes()` sin ningun orden.
- **Categorias "Recientes" y "Mas usadas"**, alimentadas por el historial local.
- **Panel de ajustes** dentro del menu: color de acento, columnas (1-4), escala,
  animaciones, nombres de la barra lateral, retardo de la vista previa y
  visibilidad de las categorias de historial.
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

### Herramientas

- **Editor de props en vivo (`/propeditor`), en su propio directorio
  `propeditor/`.** Los cuatro campos que colocan un objeto en el ped (`Prop`,
  `PropBone`, `PropPlacement`, `PropNoCollision`) se ajustaban a ojo desde el
  `.lua`, que es el peor sitio posible para acertar una rotacion. Ahora la camara
  orbita alrededor del ped con sus huesos marcados como puntos: se pincha uno, se
  elige el modelo -- lista con los props que ya usa el pack mas los del juego
  base, o el nombre a mano, validado contra `IsModelInCdimage` mientras se
  escribe -- y se coloca con `WASD`/`RF` (con `Ctrl`, gira) o con los
  deslizadores del panel. `Tab` alterna entre el prop principal y el secundario.
  Al guardar, el ajuste se escribe sobre `AnimationOptions` en todos los clientes
  y los props se rehacen sin reiniciar el recurso, asi que lo ven tambien los
  demas jugadores.
  Tres decisiones que llevan el peso del diseno:
  - **Los huesos los proyecta Lua, no el navegador.** El cliente manda en cada
    frame las coordenadas de pantalla de cada hueso y la interfaz solo coloca los
    puntos, asi que el punto cae donde esta el hueso de verdad con la animacion
    en marcha y la camara moviendose. El catalogo se filtra antes con
    `GetPedBoneIndex()`: un id equivocado no rompe nada, como mucho ese punto no
    aparece.
  - **El editor crea sus propios props.** Mientras esta abierto, los reales se
    quitan y se trabaja sobre copias locales sin colision, que se pueden
    recolocar frame a frame sin reiniciar la animacion y sin que el resto del
    servidor vea el objeto bailando.
  - **No hay `apply` automatico**, al contrario que en `/emoteoffset`.
    `emoteprops export` deja el bloque `AnimationOptions` listo para pegar y el
    pegado es a mano: los props se declaran repartidos por muchos ficheros y con
    formatos muy distintos, y reescribirlos a ciegas destrozaria packs ajenos.
- **`propeditor/` se desactiva comentando un bloque de `fxmanifest.lua`.** Lo
  unico suyo que vive fuera son dos lineas en `html/index.html` que cargan su CSS
  y su JS; sin el directorio son dos 404 inocuos. Comentado el bloque no se carga
  ni el comando, ni la interfaz, ni los ajustes guardados, y el pack se comporta
  exactamente como antes.

### Correcciones

- **20 de las 46 parejas de `duopareja.lua` no tenian Attachto activo.** El flag
  es el argumento 16 de `addPair()`, detras de los cuatro numeros del offset de A
  y los cuatro del de B. En las lineas que solo declaran el lado A, el `true`
  caia en el hueco de `bFront`: `attach` quedaba en `nil` -- ningun lado se
  enganchaba -- y el lado B se quedaba con `SyncOffsetFront = true`, un booleano
  donde va un numero, que acaba en el `vector4()` que arma `syncOffset`. Se
  rellena el hueco del offset de B con cuatro `nil` para que el flag caiga donde
  toca.
- **`emoteoffsets apply` borraba el flag Attachto de las lineas que reescribia.**
  El parser solo conservaba los numeros, asi que el `true` del final desaparecia
  sin decir nada y la pareja dejaba de engancharse. Ahora conserva todo argumento
  que no sea un numero y, si el lado B no traia offset, rellena su hueco antes de
  volver a poner el flag. El `nil` de relleno se descarta al parsear, con lo que
  reescribir dos veces da el mismo resultado.
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
- **Las poses de pareja se veian bien para los dos que las hacian y mal para
  cualquier otro jugador.** La no-colision entre los dos peds solo la pedian los
  dos participantes, y `SetEntityNoCollisionEntity` unicamente afecta al mundo
  local de quien la llama: en la pantalla de un tercero los dos peds clonados
  chocaban entre si, su motor los empujaba para separarlos y la correccion de red
  los volvia a juntar, asi que la pose se veia temblando y desalineada aunque el
  SyncOffset estuviese bien calibrado. Ahora cada lado publica su pareja en un
  state bag y todos los clientes aplican la no-colision en su propio mundo, con
  un unico hilo que solo corre mientras hay alguna pareja activa.
- **Las poses compartidas arrancaban desalineadas.** El iniciador se colocaba
  junto a su pareja y solo despues se cancelaba la emote anterior, asi que entre
  el `ClearPedTasks` y el arranque de la pose quedaban 300 ms con los dos peds ya
  solapados y con colision: se empujaban, el empujon lo replicaba el propietario
  y nada volvia a colocar el ped. El orden es ahora cancelar, esperar, pedir la
  no-colision y solo entonces mover el ped.
- **El iniciador de una pose compartida se veia bien a si mismo y todos los
  demas lo veian donde estaba antes de recolocarse.** El ped se colocaba una sola
  vez y en el mismo frame en que arrancaba el clip: los clones remotos reciben la
  task de animacion y anclan ahi el mover, y como un ped en pose no se mueve, casi
  no recibe actualizaciones de posicion y la correccion de red no cierra el hueco.
  La firma del fallo era que los observadores coincidian entre si y solo
  discrepaban del propietario del ped. Ahora entre colocar el ped y lanzar el clip
  se deja pasar un tick de red, para que la posicion nueva salga antes que la
  task, y mientras dura la pose se comprueba la desviacion dos veces por segundo,
  recolocando solo si se sale de 2 cm o 1 grado. Todo en el cliente del
  iniciador: el servidor no interviene. El reanclaje se aparta mientras
  `/emoteoffset` esta abierto y relee el offset en cada pasada, asi que respeta al
  instante lo que se acaba de calibrar.

### Mantenimiento

- Eliminados `NativeUI.lua` (150 KB) y `header.png`: ningun archivo los cargaba.
- Fuera de `config.lua` las opciones sin efecto: `MenuTitle`, `TitleOutline`,
  `TitleColour`, `CustomMenuEnabled`, `PreviewPedToggle`.
- La documentacion tecnica de creacion de emotes se conserva en
  `docs/referencia-emotes.md`.
- `Config.SyncOffsetSource` elige de donde sale el `SyncOffset` de las shared
  emotes: `'saved'` (manda `data/sync_offsets.json` y, en su defecto, el `.lua`
  del pack), `'pack'` (siempre el `.lua`) o `'zero'` (los dos peds en la misma
  coordenada y con el mismo rumbo, para comprobar si un pack esta hecho para
  reproducirse con los dos clips compartiendo origen). Ningun modo borra lo
  calibrado, asi que se puede ir y volver para comparar. Sale de fabrica en
  `'zero'`, con `Config.OffsetEditorEnabled` apagado a juego: sin offsets que
  aplicar, calibrar no sirve de nada.

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
