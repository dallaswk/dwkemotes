# ResetRP — Referencia de componentes

Cada patrón del mockup original tiene su clase equivalente aquí. Copia el
HTML, ajusta el contenido, no toques los estilos base.

## Escala de superficies (contenedores)

Los contenedores visten la **escala neutra** (negros con un tinte verdoso
mínimo) y el verde queda para jerarquía y acción. De fuera hacia dentro:

| Token | Hex | Dónde |
|---|---|---|
| `--rrp-black-green` | `#000908` | Fondo de la página / detrás del HUD |
| `--rrp-surface-1` | `#0A100F` | Panel exterior |
| `--rrp-surface-2` | `#121A19` | Cajas internas, cuerpo de desplegable |
| `--rrp-surface-3` | `#1B2523` | Elevación sobre `surface-2`, filas |

Para un contenedor propio del recurso que no encaje en un componente,
usa las utilidades `.rrp-surface-1` / `.rrp-surface-2` / `.rrp-surface-3`
y `.rrp-divider` en vez de inventar un color.

## Panel contenedor

Fondo `surface-1` con borde sutil. `.rrp-panel--green` recupera el panel
verde original (`bg-dark`) si el HUD ya está sobre un fondo negro propio.

```html
<div class="rrp-panel">
  ...contenido del panel...
</div>

<div class="rrp-panel rrp-panel--green">...variante verde...</div>
```

## Título principal

Montserrat Bold + subtítulo Montserrat SemiBold, sobre `bg-secondary`.

```html
<div class="rrp-title">
  <h1>Título principal</h1>
  <p>Subtítulo opcional</p>
</div>
```

## Título 2 / sección

Montserrat SemiBold, sin caja de fondo propia.

```html
<h2 class="rrp-heading2">Título de sección</h2>
```

## Caja de texto básico

Fondo `surface-2`, borde sutil de 1px, texto Regular. Modificadores:
`--teal` (borde teal, para la caja que debe destacar), `--outline`
(borde blanco duro del sistema original), `--green` (fondo `bg-primary`
+ borde blanco, la caja tal como era antes de la escala neutra).

```html
<div class="rrp-textbox">
  <p class="rrp-textbox__title">Texto básico</p>
  <p>Párrafo de contenido normal, Montserrat Regular.</p>
</div>

<div class="rrp-textbox rrp-textbox--teal">...caja destacada...</div>
```

## Desplegable (dropdown)

Cabecera SemiBold sobre `bg-secondary` (el verde marca la jerarquía),
cuerpo y opciones Regular sobre `surface-2`, separadas por un borde sutil.
Usa `.is-hover` para el estado de paso del ratón y `.is-selected` cuando la
fila necesita el énfasis máximo (accent).

```html
<div class="rrp-dropdown">
  <div class="rrp-dropdown__header">
    <span>Desplegables</span>
    <span>▾</span>
  </div>
  <div class="rrp-dropdown__option">Opción 1</div>
  <div class="rrp-dropdown__option is-selected">Opción 2</div>
  <div class="rrp-dropdown__option">Opción 4</div>
  <div class="rrp-dropdown__option">Opción 5</div>
</div>
```

## Botones

Estado normal: `bg-secondary`. Hover genérico y "Cancelar" hover: pasan a
`hoverBtnBg` (teal). "Aceptar" hover: pasa a `accent` con texto oscuro.

```html
<button class="rrp-btn">Botón</button>
<button class="rrp-btn rrp-btn--cancel">Cancelar</button>
<button class="rrp-btn rrp-btn--accept">Aceptar</button>
```

No hace falta clase aparte para el hover: el `:hover` ya está resuelto en
`components.css`. Si necesitas forzar visualmente el estado hover (por
ejemplo para un storybook interno), añade la clase `.is-hover` a mano y
duplica las reglas de `:hover` sobre esa clase.

## Degradados

Cinco pasos, siempre oscuro arriba → claro abajo. El paso 0 es neutro
(negro → `surface-2`): úsalo para fondos de contenedor sin verde.

```html
<div class="rrp-gradient-0" style="width:120px;height:160px"></div>
<div class="rrp-gradient-1" style="width:120px;height:160px"></div>
<div class="rrp-gradient-2" style="width:120px;height:160px"></div>
<div class="rrp-gradient-3" style="width:120px;height:160px"></div>
<div class="rrp-gradient-4" style="width:120px;height:160px"></div>
```

---

# Componentes NUI

Patrones habituales de una interfaz de recurso FiveM. Antes de construir
algo a mano, comprueba si ya está aquí.

## Estados semánticos

Tres colores fuera de la paleta base, de uso **restringido**: comunican el
resultado o el riesgo de una acción, no decoran.

| Token | Hex | Cuándo |
|---|---|---|
| `--rrp-success` | `#019685` | Confirmación (reutiliza el teal de la paleta) |
| `--rrp-warning` | `#F2A93B` | Aviso: combustible bajo, tiempo agotándose |
| `--rrp-danger` | `#E4483F` | Error, o acción destructiva e irreversible |

Si algo es solo *importante*, eso es `--rrp-accent`, no `--rrp-danger`.
Los tintes `--rrp-*-soft` son para fondos de alerta y badges; el color
macizo se reserva al borde y al texto.

## Botones — variantes

```html
<button class="rrp-btn">Botón</button>
<button class="rrp-btn rrp-btn--cancel">Cancelar</button>
<button class="rrp-btn rrp-btn--accept">Aceptar</button>
<button class="rrp-btn rrp-btn--danger">Eliminar</button>
<button class="rrp-btn rrp-btn--ghost">Secundario</button>
<button class="rrp-btn rrp-btn--sm">Pequeño</button>
<button class="rrp-btn rrp-btn--block">Ancho completo</button>
```

## Campos de formulario

`.rrp-field` agrupa etiqueta + control + ayuda. Todos los controles
comparten `--rrp-control-height`, así que una fila de input + select +
botón queda alineada sin retoques.

```html
<div class="rrp-field">
  <label class="rrp-label" for="matricula">Matrícula</label>
  <input class="rrp-input" id="matricula" placeholder="ABC 123">
  <span class="rrp-hint">Sin espacios ni guiones.</span>
</div>

<div class="rrp-field">
  <label class="rrp-label" for="importe">Importe</label>
  <div class="rrp-input-group">
    <span class="rrp-input-group__affix">$</span>
    <input class="rrp-input" id="importe" type="number" value="1500">
  </div>
</div>

<div class="rrp-field">
  <label class="rrp-label" for="motivo">Motivo</label>
  <textarea class="rrp-textarea" id="motivo"></textarea>
</div>

<select class="rrp-select">
  <option>Comisaría de Mission Row</option>
  <option>Hospital Pillbox</option>
</select>

<!-- Error de validación -->
<input class="rrp-input is-invalid" value="">
<span class="rrp-error">Este campo es obligatorio.</span>
```

## Checkbox, radio e interruptor

```html
<label class="rrp-check"><input type="checkbox" checked> Guardar posición</label>
<label class="rrp-check"><input type="radio" name="turno" checked> Turno de día</label>

<label class="rrp-switch">
  <input type="checkbox" checked>
  <span class="rrp-switch__track"></span>
  Modo servicio
</label>
```

## Slider

```html
<input class="rrp-slider" type="range" min="0" max="100" value="60">
```

## Barra de progreso y medidor de HUD

`.rrp-progress__fill` se controla desde JS con `style.width`. Las variantes
`--success`, `--warning`, `--danger` y `--accent` cambian el color de la
barra según el estado.

```html
<div class="rrp-progress"><div class="rrp-progress__fill" style="width:64%"></div></div>

<div class="rrp-meter">
  <span class="rrp-meter__label">Sed</span>
  <div class="rrp-progress rrp-progress--warning"><div class="rrp-progress__fill" style="width:28%"></div></div>
  <span class="rrp-meter__value">28%</span>
</div>
```

## Progreso animado

Tres formas de animar una barra, según lo que sepas del proceso:

| Modo | Clase | Cuándo |
|---|---|---|
| Temporizada | `rrp-progress--timed` | Sabes cuánto dura: una acción de N segundos |
| Cuenta atrás | `rrp-progress--countdown` | El mismo reloj, pero vaciándose (tiempo restante) |
| Indeterminada | `rrp-progress--indeterminate` | No sabes cuánto falta: esperando al servidor |
| Real | *(sin clase)* | Sabes el porcentaje: `fill.style.width = '64%'` |

La duración se pasa por variable, nunca con CSS nuevo:

```html
<div class="rrp-progress rrp-progress--timed" style="--rrp-progress-duration: 6s">
  <div class="rrp-progress__fill"></div>
</div>

<div class="rrp-progress rrp-progress--indeterminate">
  <div class="rrp-progress__fill"></div>
</div>
```

Añadidos combinables: `--striped` (rayas en movimiento, "esto trabaja"),
`--shine` (destello que recorre la barra) y las variantes de color
`--success` / `--warning` / `--danger` / `--accent`.

Estados, solo cambiando la clase del contenedor: `.is-paused` congela la
animación, `.is-cancelled` la congela y pinta la barra de rojo, `.is-done`
la pinta del verde de éxito.

Las barras animadas mueven `transform`, no `width`: en CEF eso evita un
relayout por frame, que es justo lo que hace que una NUI baje de FPS.

## Barra de acción (patrón qb-progressbar)

El bloque completo — etiqueta, tiempo y barra — para las acciones con
duración. Con `--bottom` queda fijo sobre el HUD, como en un recurso real.

```html
<div class="rrp-progressbar rrp-progressbar--bottom" style="--rrp-progress-duration: 6s">
  <div class="rrp-progressbar__head">
    <span class="rrp-progressbar__label">Forzando cerradura</span>
    <span class="rrp-progressbar__time">6s</span>
  </div>
  <div class="rrp-progress rrp-progress--timed rrp-progress--striped">
    <div class="rrp-progress__fill"></div>
  </div>
</div>
```

Para lanzarla desde el JS del recurso. El `void fill.offsetWidth` no es
adorno: sin ese reflow la animación no se reinicia en la segunda llamada.

```js
function startProgress(label, ms) {
  const box  = document.querySelector('.rrp-progressbar');
  const fill = box.querySelector('.rrp-progress__fill');
  box.querySelector('.rrp-progressbar__label').textContent = label;
  box.style.setProperty('--rrp-progress-duration', ms + 'ms');
  box.classList.remove('is-cancelled');
  box.hidden = false;

  fill.style.animation = 'none';
  void fill.offsetWidth;          // fuerza el reflow que reinicia la animación
  fill.style.animation = '';

  return new Promise(resolve => {
    fill.addEventListener('animationend', function done() {
      box.hidden = true;
      resolve(true);
    }, { once: true });
  });
}
```

Para cancelarla a media acción, añade `.is-cancelled` al `.rrp-progress` y
al `.rrp-progressbar`: la barra se congela en rojo y la etiqueta también.

## Anillo de progreso (HUD)

Los indicadores redondos junto al minimapa. El valor va de 0 a 100 en una
variable, y la transición de 400 ms lo lleva suave de un valor al otro.

```html
<div class="rrp-ring rrp-ring--warning" style="--rrp-ring-value: 28">
  <span class="rrp-ring__value">28</span>
</div>
```

```js
ring.style.setProperty('--rrp-ring-value', 72);   // anima solo
```

Variantes: `--success`, `--warning`, `--danger`, `--accent`, `--lg`.
Con `rrp-ring--timed` se llena solo en `--rrp-progress-duration`, igual que
la barra temporizada.

## Notificaciones (toasts)

`.rrp-notify-stack` es el contenedor fijo en pantalla; dentro van los
avisos. Para cerrar uno, añade `.is-leaving` y elimínalo del DOM al acabar
la animación (160 ms).

```html
<div class="rrp-notify-stack">
  <div class="rrp-notify rrp-notify--success">
    <span class="rrp-notify__icon">✓</span>
    <div>
      <p class="rrp-notify__title">Vehículo guardado</p>
      <p class="rrp-notify__text">Sultan RS · Garaje Legion Square</p>
    </div>
  </div>
</div>
```

Variantes: `--success`, `--warning`, `--danger`, `--info`.

## Aviso en línea

El mismo mensaje, pero dentro del panel en vez de flotando.

```html
<div class="rrp-alert rrp-alert--warning">
  <span>⚠</span>
  <div>El depósito está por debajo del 15 %.</div>
</div>
```

## Menú de opciones

El patrón de `qb-menu` / `ox_lib`: icono, título, descripción y un dato a
la derecha. `.is-active` marca la fila seleccionada, `.is-disabled` la
bloquea.

```html
<div class="rrp-menu">
  <button class="rrp-menu__item">
    <span class="rrp-menu__icon">🚗</span>
    <span class="rrp-menu__body">
      <p class="rrp-menu__title">Sacar vehículo</p>
      <p class="rrp-menu__desc">Sultan RS · en el garaje</p>
    </span>
    <span class="rrp-menu__meta">$250</span>
  </button>
  <button class="rrp-menu__item is-active">…</button>
  <button class="rrp-menu__item is-disabled">…</button>
</div>
```

## Navegación lateral / secciones

La barra de categorías de una NUI (Animaciones, Objetos, Bailes…), en
vertical con `.rrp-nav`, en horizontal con `.rrp-nav--row`, o como carril
de solo iconos con `.rrp-nav--rail`.

**El estado activo no se marca con un bloque macizo de color bajo el
texto.** Un fondo teal o lima relleno hunde el contraste de la etiqueta y
deja de leerse justo el elemento que querías destacar. El activo va con
tinte suave + barra de acento al costado, y el texto sube a blanco. El
color macizo se queda para los botones, donde el texto se elige a juego.

```html
<nav class="rrp-nav">
  <p class="rrp-nav__group">Categorías</p>

  <button class="rrp-nav__item">
    <span class="rrp-nav__icon">📁</span>
    <span class="rrp-nav__label">Policía</span>
  </button>

  <button class="rrp-nav__item is-active">
    <span class="rrp-nav__icon">▶</span>
    <span class="rrp-nav__label">Animaciones</span>
  </button>

  <button class="rrp-nav__item">
    <span class="rrp-nav__icon">🎭</span>
    <span class="rrp-nav__label">Ánimos</span>
  </button>
</nav>
```

Carril de iconos: la etiqueta se oculta y pasa al tooltip.

```html
<nav class="rrp-nav rrp-nav--rail">
  <button class="rrp-nav__item is-active" data-rrp-tip="Animaciones" data-rrp-tip-pos="right" aria-label="Animaciones">
    <span class="rrp-nav__icon">▶</span>
    <span class="rrp-nav__label">Animaciones</span>
  </button>
</nav>
```

## Tooltip por atributo

Para un botón de icono no hace falta envolverlo en `.rrp-tooltip`: basta
con `data-rrp-tip`. **Un icono sin etiqueta visible siempre lleva tooltip
y `aria-label`** — si el único modo de saber qué hace un botón es
pulsarlo, el botón está mal.

```html
<button class="rrp-btn rrp-btn--icon" data-rrp-tip="Caminar" aria-label="Caminar">🚶</button>
<button class="rrp-btn rrp-btn--icon" data-rrp-tip="Filtros" data-rrp-tip-pos="bottom" aria-label="Filtros">⚙</button>
```

Posiciones: por defecto arriba; `data-rrp-tip-pos` acepta `bottom`,
`right` y `left`. El tooltip aparece también al llegar con el teclado.

## Foco

Dos formas, y no son intercambiables:

| Token | Para qué |
|---|---|
| `--rrp-focus-ring` | Aro de acento en lo que **no** tiene borde propio: botones, filas de menú, slots, pestañas |
| `--rrp-focus-glow` | Halo teal en los **campos**, que ya marcan el foco con su borde |

Un aro lima de 2 px sobre un input que además tiene borde produce un doble
marco chillón. Por eso los campos usan borde teal + halo suave, y un campo
inválido conserva su rojo al enfocarse: el estado manda sobre el foco.

## Pestañas

```html
<div class="rrp-tabs">
  <button class="rrp-tab is-active">Inventario</button>
  <button class="rrp-tab">Vehículos</button>
  <button class="rrp-tab">Facturas</button>
</div>
```

## Badge y punto de estado

```html
<span class="rrp-badge"><span class="rrp-dot"></span> En servicio</span>
<span class="rrp-badge rrp-badge--success">Pagado</span>
<span class="rrp-badge rrp-badge--warning">Pendiente</span>
<span class="rrp-badge rrp-badge--danger">Buscado</span>
<span class="rrp-badge rrp-badge--accent">Nuevo</span>
```

## Modal de confirmación

Para lo irreversible. El botón de confirmar usa `--danger` cuando la
acción destruye algo.

```html
<div class="rrp-modal">
  <div class="rrp-modal__box">
    <div class="rrp-modal__header">¿Eliminar vehículo?</div>
    <div class="rrp-modal__body">
      Se borrará el Sultan RS de tu garaje. Esta acción no se puede deshacer.
    </div>
    <div class="rrp-modal__footer">
      <button class="rrp-btn rrp-btn--ghost">Cancelar</button>
      <button class="rrp-btn rrp-btn--danger">Eliminar</button>
    </div>
  </div>
</div>
```

## Ayuda de tecla

El prompt de interacción que aparece al acercarse a un punto.

```html
<div class="rrp-keyhint">
  <span class="rrp-key">E</span>
  <span>Abrir taquilla</span>
</div>
```

## Lista clave / valor y tabla

```html
<div class="rrp-list">
  <div class="rrp-list__row">
    <span class="rrp-list__key">Propietario</span>
    <span class="rrp-list__value">John Doe</span>
  </div>
</div>

<table class="rrp-table">
  <thead><tr><th>Artículo</th><th>Cantidad</th></tr></thead>
  <tbody><tr><td>Vendaje</td><td>3</td></tr></tbody>
</table>
```

## Rejilla de slots

Inventario, tienda o armería. El número de columnas se cambia con
`--rrp-slots-columns` sin tocar el CSS del sistema.

```html
<div class="rrp-slots" style="--rrp-slots-columns: 6">
  <div class="rrp-slot is-selected">
    <span class="rrp-slot__count">×3</span>
    <span class="rrp-slot__label">Vendaje</span>
  </div>
  <div class="rrp-slot is-empty"></div>
</div>
```

## Tooltip

```html
<span class="rrp-tooltip">
  <span class="rrp-badge">Peso</span>
  <span class="rrp-tooltip__content">12,4 / 30 kg</span>
</span>
```

## Estadística, avatar y estado vacío

```html
<div class="rrp-stat">
  <p class="rrp-stat__label">En banco</p>
  <p class="rrp-stat__value">$14.320</p>
</div>

<span class="rrp-avatar">JD</span>

<div class="rrp-empty">
  <div class="rrp-empty__icon">📦</div>
  No hay nada aquí todavía.
</div>
```

## Carga

```html
<div class="rrp-spinner"></div>
<div class="rrp-skeleton" style="height:14px;width:70%"></div>
```

## Scroll

La barra por defecto de CEF es clara y ancha, y sobre el negro canta. Los
contenedores del sistema que pueden desbordar (`.rrp-nav`, `.rrp-menu`,
`.rrp-dropdown`, `.rrp-list`, `.rrp-textarea`, `.rrp-modal__body`,
`.rrp-table-wrap`) ya la llevan estilizada de oficio: no hay que añadir
nada. Para un contenedor propio del recurso, usa `.rrp-scroll`.

```html
<div class="rrp-scroll" style="max-height:220px">…</div>
```

| Variante | Para qué |
|---|---|
| `rrp-scroll--x` | Scroll horizontal (tiras, carruseles) |
| `rrp-scroll--overlay` | La barra solo aparece al pasar el ratón |
| `rrp-scroll--hidden` | Sin barra visible; se sigue desplazando con rueda y teclado |
| `rrp-scroll--shadow` | Sombras arriba/abajo que aparecen solo si queda contenido |
| `rrp-table-wrap` | Envoltorio de tabla ancha: el scroll lateral va aquí, nunca en la página |

Tres detalles que dan más problemas de los que parece:

- **`scrollbar-gutter: stable`** viene puesto en `.rrp-scroll` y en
  `.rrp-nav`. Sin él, el contenido pega un salto lateral en cuanto la
  lista crece lo justo para desbordar.
- **`min-height: 0`** también. Un contenedor con scroll dentro de un flex
  o un grid se estira hasta su contenido y nunca llega a desbordar; ese
  es el motivo habitual de "le puse `overflow:auto` y no hace scroll".
- **`--rrp-scroll-bg`** en `.rrp-scroll--shadow`: pásale el fondo real del
  contenedor para que el degradado case. Por defecto asume `surface-2`.

```html
<div class="rrp-scroll rrp-scroll--shadow" style="max-height:220px; --rrp-scroll-bg: var(--rrp-surface-1)">…</div>

<div class="rrp-table-wrap">
  <table class="rrp-table">…</table>
</div>
```

El grosor se ajusta con `--rrp-scroll-size` (6 px por defecto).

## Animaciones de apertura

Para abrir y cerrar la NUI sin parpadeo, usa `.rrp-fade` y alterna
`.is-open` desde el JS del recurso.

```html
<div id="app" class="rrp-fade">…</div>
```

Utilidades de entrada: `.rrp-anim-fade` y `.rrp-anim-pop`. Todas las
animaciones se desactivan solas con `prefers-reduced-motion`.

## Ejemplo completo (mini panel de menú)

```html
<link rel="stylesheet" href="design-system/tokens.css">
<link rel="stylesheet" href="design-system/components.css">

<div class="rrp-panel">
  <div class="rrp-title">
    <h1>Menú del recurso</h1>
    <p>Montserrat Bold</p>
  </div>

  <h2 class="rrp-heading2">Opciones</h2>
  <div class="rrp-textbox">
    <p class="rrp-textbox__title">Información</p>
    <p>Texto de ejemplo con estilo básico del sistema.</p>
  </div>

  <div class="rrp-dropdown">
    <div class="rrp-dropdown__header"><span>Selecciona</span><span>▾</span></div>
    <div class="rrp-dropdown__option is-selected">Opción activa</div>
    <div class="rrp-dropdown__option">Otra opción</div>
  </div>

  <button class="rrp-btn rrp-btn--cancel">Cancelar</button>
  <button class="rrp-btn rrp-btn--accept">Aceptar</button>
</div>
```
