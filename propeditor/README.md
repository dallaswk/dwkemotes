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

## Dejarlo fijo en el pack

Hay **dos capas**, y conviene tenerlas claras:

| Capa | Dónde | Quién manda |
|---|---|---|
| Ajuste en caliente | `propeditor/data/prop_overrides.json` | Pisa lo que declare la emote |
| Pack | El `AnimationOptions` del `.lua` | Lo que queda si no hay ajuste |

**Lo que ajustas ya es permanente en cuanto le das a Guardar**: el JSON sobrevive
a los reinicios y se aplica al arrancar. No hace falta nada más para que funcione.

Lo que consigues bajándolo al `.lua` es que el pack se valga por sí mismo. Mientras
la verdad viva en el JSON, el ajuste se pierde si copias el recurso sin
`propeditor/data/`, o si algún día desactivas el editor. Y si alguien edita el
`.lua` a mano, no verá ningún efecto, porque el JSON le está pisando el valor.

### Los cuatro pasos

1. **Exporta**, en la consola del servidor:

   ```
   emoteprops export
   ```

   Escribe `propeditor/data/prop_overrides_export.lua` con un bloque por emote.

2. **Pega** el bloque en el `AnimationOptions` de esa emote, en su `.lua` de
   `custom_emotes/`. Sustituye los campos `Prop*` que ya tuviera; **el resto de
   campos se dejan como estaban** (`EmoteLoop`, `EmoteDuration`, `Ptfx*`…), que el
   export no los toca.

   Si la emote tenía el bloque en una línea, se expande:

   ```lua
   -- antes
   AnimationOptions = { EmoteLoop = true, EmoteMoving = false },

   -- después
   AnimationOptions = {
       EmoteLoop = true,
       EmoteMoving = false,
       Prop = 'mne_can_pink',
       PropBone = 60309,
       PropPlacement = {
           0.090,
           0.000,
           0.026,
           91.00,
           157.00,
           178.00
       },
   },
   ```

3. **Reinicia** el recurso (`restart dwkemotes`) y comprueba en el juego que se ve
   igual que antes de tocar nada. Si algo no cuadra, el ajuste sigue en el JSON:
   no has perdido nada.

4. **Descarta el ajuste en caliente**, para que a partir de ahí mande el pack:

   ```
   emoteprops clear <emote>
   ```

   Con `emoteprops clear all` de golpe, pero solo cuando hayas bajado **todas** las
   que aparecen en `emoteprops list`: lo que no hayas pegado se pierde.

### Cosas que se aprenden a base de tropezar

- **Una emote de escenario nunca puede llevar prop.** Las que se declaran con
  `ScenarioType.*` (`maid`, `WORLD_HUMAN_*`…) las reproduce el juego entero:
  `OnEmotePlay` hace `return` en `client/Emote.lua:964`, mucho antes del código
  que engancha props (`client/Emote.lua:1045`). El editor te dejará ajustar el
  prop y guardarlo, pero en el juego no aparecerá. Para un escenario con objeto,
  hay que convertirlo en una emote normal con su `dict` y su `anim`.

- **`client/AnimationList.lua` no se toca.** Es la biblioteca heredada y el pack
  la mantiene intacta a propósito. Si la emote que has ajustado vive ahí, no
  pegues nada en ese fichero: redefínela en un `.lua` de `custom_emotes/`, que se
  carga después y gana. El ajuste en caliente, mientras tanto, funciona igual.

- **El slot 2 no existe sin el slot 1.** `addProps()` solo mira `SecondProp` si
  `Prop` está puesto. El editor ya lo tiene en cuenta y asciende el segundo si
  dejas el primero vacío, pero si lo pegas a mano, respétalo.

- **Comprueba que el modelo viaja en el servidor.** El editor solo ofrece modelos
  que pasan `IsModelInCdimage`, así que lo que elijas desde el buscador está
  garantizado. Si escribes uno a mano, mira el aviso bajo el campo. Y para los
  props custom con `.ytyp`, hace falta además su línea `DLC_ITYP_REQUEST` en
  `fxmanifest.lua`, o el modelo existe pero sale invisible. `/propscheck` lista
  los que falten.

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
