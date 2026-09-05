# propeditor/ — editor de props en vivo

Coloca desde el juego los objetos que lleva el ped durante una emote: se ve al
muñeco con sus huesos marcados como puntos, se pincha uno, se elige un modelo y
se mueve y se gira hasta que encaja. Lo que se guarda son exactamente los campos
que ya usa el pack (`Prop`, `PropBone`, `PropPlacement`, `PropNoCollision`, y sus
equivalentes `Second*`), así que el resultado se puede llevar tal cual al `.lua`
de la emote.

Todo lo que hace falta vive en este directorio.

---

## Uso

```
/propeditor            edita los props de la emote que ya está sonando
/propeditor <emote>    lanza esa emote y abre el editor sobre ella
```

En pantalla:

| Acción | Cómo |
|---|---|
| Elegir hueso | Pinchar uno de los puntos, o buscarlo en la lista del panel |
| Elegir modelo | Buscar en la lista, o escribir el nombre y pulsar Enter |
| Mover el prop | `W`/`S` eje Y, `A`/`D` eje X, `R`/`F` eje Z |
| Girar el prop | `Ctrl` + esas mismas teclas |
| Paso grueso | `Shift` mantenido |
| Orbitar la cámara | Arrastrar sobre el fondo, o las flechas |
| Zoom | Rueda del ratón |
| Cambiar de prop (1 ↔ 2) | `Tab`, o las pestañas del panel |
| Guardar | `Enter`, o el botón |
| Salir | `Retroceso`, o el botón |

Los deslizadores y las casillas de número del panel hacen lo mismo que las
teclas, con más precisión. El campo de modelo valida contra el juego mientras se
escribe: dice si este servidor tiene o no ese modelo antes de intentarlo.

Un guardado se ve al momento y lo ven también los demás jugadores: el ajuste se
escribe sobre `EmoteData` en todos los clientes y los props se rehacen sin
reiniciar el recurso.

---

## Consola del servidor

```
emoteprops list                 lo ajustado hasta ahora
emoteprops export               escribe propeditor/data/prop_overrides_export.lua
emoteprops clear <emote|all>    devuelve la emote a los props de su pack
```

`export` deja el bloque `AnimationOptions` de cada emote listo para pegar en su
`.lua`. **No hay un `apply` automático** como el de `/emoteoffset`: los props se
declaran en bloques repartidos por muchos ficheros y con formatos muy distintos,
y reescribirlos a ciegas destrozaría packs ajenos. El pegado es a mano, que es un
minuto por emote y se ve lo que se está tocando.

---

## Cómo desactivarlo

Comentar o borrar el bloque `Editor de props en vivo (propeditor/)` del final de
`fxmanifest.lua`. Con eso no se carga nada del editor: ni el comando, ni la
interfaz, ni los ajustes guardados, y el pack vuelve a comportarse exactamente
como antes.

Fuera de este directorio solo hay dos líneas más, en `html/index.html`, que
cargan `editor.css` y `editor.js`. Se pueden dejar puestas: si el directorio no
está, son dos 404 que no rompen nada.

Para desactivarlo del todo y para siempre, borrar el directorio, esas dos líneas
y el bloque del `fxmanifest.lua`.

---

## Ajustes

En `propeditor/config.lua`:

| Clave | Qué hace |
|---|---|
| `enabled` | A `false`, el comando no responde y el servidor rechaza guardados. Lo ya guardado se sigue aplicando |
| `command` | Nombre del comando. Por defecto `propeditor` |
| `ace` | ACE que hace falta para abrir y guardar. `nil` = cualquiera |
| `stepFine` / `stepCoarse` | Paso de posición con y sin `Shift` |
| `stepRotFine` / `stepRotCoarse` | Lo mismo para la rotación |
| `limitPos` | Distancia máxima del prop al hueso, en metros |
| `camDistance*` | Distancia inicial, mínima y máxima de la cámara |

---

## Cómo está montado

| Fichero | Qué hace |
|---|---|
| `config.lua` | Ajustes. Es `shared_script`: lo leen el cliente y el servidor |
| `client/Bones.lua` | Catálogo de huesos del ped (id, nombre técnico, etiqueta) |
| `client/PropCatalog.lua` | Lista de props de base del juego para el buscador |
| `client/PropEditor.lua` | El editor: cámara, props de previsualización, teclado, puente con la interfaz |
| `server/PropEditor.lua` | Persistencia, reparto a los clientes y comandos de consola |
| `ui/editor.css`, `ui/editor.js` | La interfaz. Se monta en la misma página NUI del menú, en su propia capa |
| `data/` | Lo que escribe el editor. Ver su `README.md` |

Dos detalles que conviene saber si hay que tocarlo:

- **Los huesos los proyecta Lua, no el navegador.** El cliente manda en cada
  frame las coordenadas de pantalla de cada hueso y la interfaz solo coloca los
  puntos. Así el punto cae siempre donde está el hueso de verdad, con la
  animación en marcha y la cámara moviéndose.

- **El editor crea sus propios props.** Mientras está abierto, los props reales
  de la emote se quitan y se trabaja sobre copias locales, que se pueden
  recolocar frame a frame sin reiniciar la animación y sin que el resto del
  servidor vea el objeto bailando. Al cerrar se rehacen los de verdad desde
  `AnimationOptions`.

- **Un id de hueso equivocado no rompe nada.** El editor descarta con
  `GetPedBoneIndex()` todo hueso que el ped no tenga, así que como mucho ese
  punto no aparece. Si una emote del pack usa un hueso que no está en el
  catálogo, se añade solo a la lista con su número.
