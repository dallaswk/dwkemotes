# ResetRP — Sistema de diseño para NUIs de FiveM

Este directorio es la fuente de verdad visual para **cualquier interfaz (NUI)**
de un recurso FiveM del proyecto ResetRP. Aplica a Claude Code, OpenCode,
GPT Codex, Gemini CLI o cualquier otro agente que genere HTML/CSS/JS para
un recurso.

## Regla de oro

Antes de escribir un solo `<style>` o archivo `.css` para una NUI nueva:

1. Copia (o enlaza como submódulo/paquete compartido) esta carpeta
   `resetrp-design-system/` dentro del recurso, típicamente en
   `nui/design-system/`.
2. Importa `tokens.css` y `components.css` en el `<head>` del HTML de la NUI,
   en ese orden, antes de cualquier CSS propio del recurso:
   ```html
   <link rel="stylesheet" href="design-system/tokens.css">
   <link rel="stylesheet" href="design-system/components.css">
   <link rel="stylesheet" href="style.css"> <!-- CSS específico del recurso -->
   ```
3. **No inventes colores, tipografías ni radios nuevos.** Usa las variables
   `--rrp-*` de `tokens.css` y las clases `.rrp-*` de `components.css`. Si
   necesitas un color que no existe en la paleta, para y pregunta — no
   generes un hex nuevo por tu cuenta.
4. Si el recurso no es HTML/CSS (por ejemplo, generas datos de configuración,
   o necesitas los valores en JS/Lua), lee `tokens.json`: contiene los
   mismos valores en formato plano, con su propósito documentado en `usage`.

## Qué contiene esta carpeta

| Archivo | Para qué sirve |
|---|---|
| `tokens.css` | Variables CSS (`--rrp-*`): colores, tipografía, espaciado, radios, degradados. |
| `tokens.json` | Los mismos tokens en JSON, para JS/Lua o cualquier consumidor no-CSS. |
| `components.css` | Clases listas para usar que ya aplican los tokens: la base (`.rrp-panel`, `.rrp-title`, `.rrp-textbox`, `.rrp-dropdown`, `.rrp-btn`, `.rrp-gradient-N`) y los componentes NUI (formularios, `.rrp-notify`, `.rrp-menu`, `.rrp-modal`, `.rrp-progress`, `.rrp-slots`, `.rrp-inv`, `.rrp-table`, `.rrp-keyhint`…). |
| `components.md` | Referencia visual: qué clase usar para cada patrón del mockup, con ejemplos de HTML. |
| `inv-dock.css` | Variante `.rrp-dock`: el inventario acoplado que flota sobre el juego. Extiende `.rrp-inv` sin tocarlo; se carga **después** de `components.css`. Trae además la bandeja de detalle con el traspaso dentro (`.rrp-dock__detail`), la barra rápida (`.rrp-hotbar`), el tooltip rico de objeto (`.rrp-itip`), el fantasma de arrastre (`.rrp-drag-ghost`) y el precio en el slot (`.rrp-inv-slot__price`). |
| `inventory.html` | Laboratorio del inventario acoplado: la NUI a escala real de 1080p sobre una captura, con mandos para halo, opacidad, ancho y duración. |

## Principios

- **Jerarquía tipográfica fija**: Montserrat Bold solo para el título
  principal y para una cifra grande. SemiBold para títulos de sección,
  botones, etiquetas y valores. Medium para filas de navegación.
  Regular para el texto de cuerpo.
- **El color tiene cinco papeles y no se sale de ahí**: negro neutro
  para todas las superficies; teal (`--rrp-teal`) para la selección y
  la acción principal; amarillo (`--rrp-warning`) solo para avisar;
  rojo, verde y azul para el resultado de una acción; y el hover, sin
  color. Antes de pintar algo, decide cuál de los cinco papeles es.
- **El hover es neutro**: sube la superficie (`surface-3`) y marca más
  el borde (`--rrp-border-strong`), nunca tiñe. Es lo que hace que el
  teal signifique algo: si el verde aparece cada vez que el ratón pasa
  por encima, deja de decir "esto es lo que tienes seleccionado".
- **Una sola acción dominante por pantalla**: el botón por defecto es
  neutro, y solo `--primary` (alias `--accept`) lleva el degradado
  verde. Si dos botones piden lo mismo a la vez, ninguno manda.
- **El amarillo avisa, no selecciona**: `#CEDC00` es combustible bajo,
  durabilidad al límite, tiempo agotándose. Marcar con él lo que está
  elegido es el error clásico — para eso está el teal. Si el amarillo
  sale en dos sitios con dos significados, deja de avisar de nada.
- **Escala de superficies, y ojo al orden**: `surface-2` es más oscura
  que `surface-1`, no más clara. El panel es el papel (`surface-1`) y
  lo hundido — un campo, un slot, una celda — va por debajo
  (`surface-2`). `surface-3` es para lo que se levanta: hover, fila
  activa. `surface-4`, para lo pulsado y el carril de una barra.
- **Separación por borde, no por color**: dos superficies contiguas se
  distinguen con `--rrp-border-subtle`, nunca subiendo el verde.
  `--rrp-border-teal` es el borde de lo seleccionado, y por eso no se
  usa de adorno.
- **Los estados semánticos comunican, no decoran**: `--rrp-success`,
  `--rrp-warning`, `--rrp-danger` e `--rrp-info` dicen cómo ha ido una
  acción o qué riesgo tiene. Un botón es `--danger` cuando destruye
  algo, no cuando es importante. Sobre negro, el color va en el punto,
  el borde y el icono; el fondo usa el tinte `--rrp-*-soft`.
- **El estado activo no se pinta con un bloque macizo**: en pestañas,
  navegación y categorías, rellenar el fondo de color bajo el texto
  hunde el contraste justo del elemento que querías destacar. Se marca
  con velo teal + borde teal, y el texto sube a `--rrp-text`.
- **Iconos monocromos de línea, nunca emoji**: van en un sprite SVG del
  propio recurso (`<symbol>` + `<use href>`) con `stroke="currentColor"`,
  para que hereden el color y los estados. Un emoji trae su propio color
  y rompe la escala neutra; una fuente de iconos por CDN deja la NUI
  llena de cuadrados el día que no haya red.
- **El arte de objeto es la excepción, y va dentro del slot**: el PNG a
  color de un objeto de inventario es contenido, no cromo. Es lo único
  de la NUI que lleva color libre, y se ve bien justo porque todo lo que
  lo rodea es neutro. Las imágenes viven en el recurso, nunca enlazadas
  a un servidor externo.
- **Escala tipográfica cerrada**: 20 / 14 / 13 / 12 / 11 / 10 px. La
  jerarquía se hace con el peso y con los cuatro tonos de texto
  (`--rrp-text` → `--rrp-text-faint`) antes que con el tamaño. Saltar de
  11 a 22 px hace que todo grite.
- **Un icono sin etiqueta lleva tooltip y `aria-label`**: `data-rrp-tip`
  resuelve el tooltip sin envolver el botón. Si la única forma de saber
  qué hace un botón es pulsarlo, el botón está mal.
- **Ninguna lista se queda con la barra nativa**: los contenedores del
  sistema ya la llevan estilizada; para uno propio, `.rrp-scroll`. Y el
  scroll lateral vive dentro de su contenedor (`.rrp-table-wrap`), nunca
  en la página: una NUI no debe desplazarse entera de lado.
- **Mira el catálogo antes de construir**: `components.md` cubre ya los
  patrones habituales de una NUI (formularios, toasts, menú de opciones,
  modal, progreso, slots, inventario completo, tabla, tooltip, key hint). Si el
  patrón existe, úsalo; no rehagas uno equivalente con otro nombre.
- **Degradados, con cuentagotas**: solo para superficies grandes de
  marca, y siempre el stop más oscuro arriba (`linear-gradient(180deg,
  oscuro, claro)`) con las clases `.rrp-gradient-0` a `.rrp-gradient-4`.
  Un botón o una tarjeta van planos; el único control con degradado es
  el botón principal, y ya está resuelto en el componente.
- **Coherencia entre recursos**: dos NUIs distintas de ResetRP deben
  poder ponerse una al lado de la otra y parecer de la misma familia.
  Si un recurso necesita algo que el sistema no cubre (un componente
  nuevo, un estado nuevo), la extensión va en un archivo CSS aparte del
  recurso, apoyándose en los tokens existentes — nunca sobreescribiendo
  `tokens.css` ni `components.css` directamente.

## Cuándo pedir aclaración en vez de improvisar

Si una NUI necesita un patrón que no está en `components.md` (por ejemplo,
un slider, un date picker, una barra de progreso), construye el componente
nuevo reutilizando los tokens de color/tipografía/espaciado existentes, y
avisa de que es un componente nuevo para que se pueda añadir a este sistema
si se reutiliza en otro recurso.
