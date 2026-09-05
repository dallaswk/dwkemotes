# ResetRP — Referencia de componentes

Cada patrón del mockup original tiene su clase equivalente aquí. Copia el
HTML, ajusta el contenido, no toques los estilos base.

## Reparto de color

Antes de elegir un color, mira para qué sirve. El sistema tiene cinco
papeles y no se sale de ahí:

| Papel | Color | Dónde |
|---|---|---|
| Superficie | Negro neutro (`--rrp-surface-*`) | Todo lo que es contenedor. Es el papel. |
| Selección y acción principal | Teal (`--rrp-teal`) | El slot elegido, la fila activa, **un** botón por pantalla. |
| Aviso | Amarillo (`--rrp-warning`) | Combustible bajo, durabilidad al límite, tiempo agotándose. |
| Resultado | Rojo / verde / azul | Error, confirmación, información. |
| Hover | Ninguno | Sube la superficie y marca el borde. **Nunca tiñe.** |

Que el hover sea neutro es lo que hace que el teal signifique algo: si el
verde aparece cada vez que el ratón pasa por encima, deja de decir "esto
es lo que tienes seleccionado".

## Escala de superficies

Todas neutras: se distinguen por luminancia y por el borde, nunca por
color. Ojo al orden — `surface-2` es más **oscura** que `surface-1`, no
más clara: lo hundido (un campo, un slot) va por debajo del papel.

| Token | Hex | Dónde |
|---|---|---|
| `--rrp-bg` | `#070809` | Fondo de la página / detrás del HUD |
| `--rrp-surface-1` | `#121415` | Panel, ventana, tarjeta: el papel |
| `--rrp-surface-2` | `#0D0F10` | Hundido: campos, slots, celdas de datos |
| `--rrp-surface-3` | `#1A1D1E` | Elevado: hover neutro, fila activa |
| `--rrp-surface-4` | `#202324` | Pulsado, carril de una barra de progreso |
| `--rrp-border-subtle` | `#202324` | Borde por defecto entre superficies |
| `--rrp-border-strong` | `#35393A` | Borde en hover |
| `--rrp-border-teal` | `rgba(1,150,133,.45)` | Borde de lo seleccionado |

Para un contenedor propio del recurso que no encaje en un componente,
usa las utilidades `.rrp-surface-1` / `.rrp-surface-2` / `.rrp-surface-3`
y `.rrp-divider` en vez de inventar un color.

## Texto

Cuatro tonos, y la jerarquía se hace con ellos antes que con el tamaño.

| Token | Hex | Dónde |
|---|---|---|
| `--rrp-text` | `#E7E8E6` | Texto principal. Blanco roto: el blanco puro deslumbra sobre negro. |
| `--rrp-text-2` | `#A9ADAA` | Descripciones, etiquetas de campo |
| `--rrp-text-muted` | `#777D79` | Unidades, metadatos, ayuda |
| `--rrp-text-faint` | `#4E5551` | Placeholder, número de slot, deshabilitado |

## Panel contenedor

Fondo `surface-1` con borde de 1 px. Con cabecera, usa `--flush` para
que el relleno lo pongan la cabecera y el cuerpo: así la línea de
separación llega de lado a lado.

```html
<div class="rrp-panel">
  ...contenido del panel...
</div>

<div class="rrp-panel rrp-panel--flush">
  <div class="rrp-panel__head">
    <div>
      <h2 class="rrp-panel__title">Componentes base</h2>
      <p class="rrp-panel__sub">Una sola acción dominante.</p>
    </div>
    <span class="rrp-badge rrp-badge--teal">Sistema activo</span>
  </div>
  <div class="rrp-panel__body">...</div>
</div>
```

## Título principal

Sin caja: el peso y el tamaño ya lo separan, y una línea lo cierra. El
antetítulo (`.rrp-kicker`) es el único texto del sistema en teal.

```html
<div class="rrp-title">
  <p class="rrp-kicker">Reset RP · Comisaría</p>
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

Superficie hundida (`surface-2`) con borde de 1 px. Modificadores:
`--teal` (borde y tinte teal, para **una** caja que deba destacar por
pantalla — es el mismo recurso que marca la selección) y `--outline`
(solo el borde más marcado, sin color).

```html
<div class="rrp-textbox">
  <p class="rrp-textbox__title">Texto básico</p>
  <p>Párrafo de contenido normal, Montserrat Regular.</p>
</div>

<div class="rrp-textbox rrp-textbox--teal">...caja destacada...</div>
```

## Desplegable (dropdown)

Cabecera sobre `surface-1` separada por una línea; cuerpo y opciones
sobre `surface-2`. El hover es neutro (`.is-hover` lo fuerza) y la fila
elegida lleva `.is-selected`: tinte teal y una línea teal a la izquierda.

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

El botón por defecto es **neutro**. El verde lo lleva solo la acción
dominante (`--primary`, o su alias histórico `--accept`), y solo puede
haber una por pantalla: si dos botones piden lo mismo, ninguno manda.

```html
<button class="rrp-btn">Botón</button>
<button class="rrp-btn rrp-btn--cancel">Cancelar</button>
<button class="rrp-btn rrp-btn--primary">Confirmar</button>
<button class="rrp-btn rrp-btn--danger">Eliminar</button>
<button class="rrp-btn rrp-btn--ghost">Secundario</button>
```

El botón principal es el único elemento del sistema con degradado y
brillo interior; por eso se ve antes que cualquier otro. El destructivo
va en rojo apagado sobre tinte: lo que destruye no tiene por qué ser lo
más llamativo de la pantalla.

Un botón con icono lleva el `<svg>` dentro y el sistema le pone el hueco;
los iconos se dimensionan solos (16 px, 14 px en `--sm`).

```html
<button class="rrp-btn rrp-btn--primary">
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">…</svg>
  Guardar
</button>
```

No hace falta clase aparte para el hover: el `:hover` ya está resuelto en
`components.css`.

## Degradados

Cinco pasos, siempre oscuro arriba → claro abajo. Son para superficies
grandes de marca (fondo de un HUD, cabecera a pantalla completa); un
botón o una tarjeta van planos. El único degradado que lleva un control
es el del botón principal, y ya está resuelto en el componente.

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

Cuatro colores de uso **restringido**: comunican el resultado o el riesgo
de una acción, no decoran.

| Token | Hex | Cuándo |
|---|---|---|
| `--rrp-success` | `#53B883` | Confirmación |
| `--rrp-warning` | `#CEDC00` | Aviso: combustible bajo, durabilidad al límite |
| `--rrp-danger` | `#D95C5C` | Error, o acción destructiva e irreversible |
| `--rrp-info` | `#5EA6D8` | Información neutra |

El amarillo es **solo aviso**. Marcar con él lo que está seleccionado es
el error clásico: la selección es teal, y si el amarillo aparece en dos
sitios con dos significados deja de avisar de nada. `--rrp-accent` existe
como alias del amarillo para un acento puntual (una cifra que debe leerse
antes que el resto) y nada más.

Los tintes `--rrp-*-soft` son para el fondo de una alerta; el color
macizo se queda en el punto del badge, el borde y el icono.

## Botones — variantes

```html
<button class="rrp-btn">Botón</button>
<button class="rrp-btn rrp-btn--cancel">Cancelar</button>
<button class="rrp-btn rrp-btn--primary">Confirmar</button>
<button class="rrp-btn rrp-btn--danger">Eliminar</button>
<button class="rrp-btn rrp-btn--ghost">Secundario</button>
<button class="rrp-btn rrp-btn--sm">Pequeño</button>
<button class="rrp-btn rrp-btn--icon" data-rrp-tip="Ordenar" aria-label="Ordenar">⇅</button>
<button class="rrp-btn rrp-btn--block">Ancho completo</button>
```

## Botón conmutador (queda marcado)

**Nuevo.** Un botón normal vuelve solo; este se queda encendido porque
representa un modo activo — caminar despacio, sordina de radio, ver solo
favoritos. Lleva la marca del sistema para "esto está elegido": velo
teal, borde teal y el texto arriba.

El estado real es `aria-pressed`, que es lo que anuncia un lector de
pantalla, y el CSS se engancha ahí — así no hay dos verdades que puedan
desincronizarse. `.is-active` queda como alias para el JS que ya trabaje
con clases.

**No lleva el halo inferior** de `.rrp-tab` / `.rrp-nav__item`. Ese halo
dice "estás aquí" dentro de un grupo donde solo uno manda; un conmutador
dice "esto está encendido" y puede haber varios a la vez. Si se marcaran
igual, una barra de herramientas parecería una fila de pestañas.

```html
<button class="rrp-btn rrp-btn--icon" aria-pressed="false"
        data-rrp-tip="Caminar" aria-label="Caminar">
  <svg><use href="#i-walk"/></svg>
</button>
```

```js
btn.addEventListener('click', () => {
  btn.setAttribute('aria-pressed', btn.getAttribute('aria-pressed') === 'true' ? 'false' : 'true');
});
```

Un conmutador no es un checkbox disfrazado: es un botón que recuerda su
estado. Si lo que quieres es un ajuste de un formulario, usa
`.rrp-check` o el interruptor.

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

## Campo numérico y su paso

**Nuevo.** La flecha doble que pinta el navegador en un
`input[type="number"]` es un widget del sistema operativo: llega en
blanco, con su tamaño y sus esquinas, y sobre negro parece un pegote. No
se puede teñir ni redondear.

`components.css` **la quita siempre**, haya paso propio o no — un campo
sin flechas se sigue subiendo con las teclas de cursor. Y pone las
cifras en `tabular-nums`, para que cambiar 1500 por 1600 no mueva todos
los dígitos de sitio.

Cuando el campo se merece flechas, `.rrp-step` las pone a ras del canto
derecho del grupo:

```html
<div class="rrp-input-group">
  <span class="rrp-input-group__affix">$</span>
  <input class="rrp-input" type="number" value="1500" step="50" min="0">
  <span class="rrp-step">
    <button type="button" class="rrp-step__btn" data-step="up" aria-label="Subir importe">
      <svg viewBox="0 0 24 24"><path d="M6 15l6-6 6 6"/></svg>
    </button>
    <button type="button" class="rrp-step__btn" data-step="down" aria-label="Bajar importe">
      <svg viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
    </button>
  </span>
</div>
```

Los botones son **transparentes**: heredan la superficie del grupo. Con
fondo propio abrirían dos agujeros en el canto del campo, porque el
grupo es `surface-3` (elevado) y un control hundido encima se lee como
un hueco.

En el JS, usa `stepUp()` / `stepDown()` del propio input en vez de sumar
a mano: respetan `step`, `min` y `max` sin que tengas que repetir la
aritmética. Y deshabilita el botón cuando se llega al tope — apagado
dice "por aquí ya no se sigue"; quitarlo deja un hueco y el campo parece
roto.

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

`.rrp-progress__fill` se controla desde JS con `style.width`. La barra va
en teal por defecto; `--warning` y `--danger` la pasan a amarillo y rojo
según el nivel, y `--sm` (3 px) / `--lg` (10 px) cambian el grosor. Una
barra de vida o de peso no necesita más colores que esos tres.

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
`--success` / `--warning` / `--danger`.

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

Variantes: `--success`, `--warning`, `--danger`, `--lg`.
Con `rrp-ring--timed` se llena solo en `--rrp-progress-duration`, igual que
la barra temporizada.

## Notificaciones (toasts)

`.rrp-notify-stack` es el contenedor fijo en pantalla; dentro van los
avisos. Para cerrar uno, añade `.is-leaving` y elimínalo del DOM al acabar
la animación (160 ms).

El estado no se dice con una franja de color a lo ancho, sino con un velo
que muere a un tercio y con el icono en su círculo. Así tres toasts
seguidos no forman un semáforo. `__meta`, `__close` y `__timer` son
opcionales: la hora o la cifra, el aspa y lo que le queda de vida.

```html
<div class="rrp-notify-stack">
  <div class="rrp-notify rrp-notify--success">
    <span class="rrp-notify__icon">✓</span>
    <div class="rrp-notify__body">
      <div class="rrp-notify__head">
        <p class="rrp-notify__title">Vehículo guardado</p>
        <span class="rrp-notify__meta">ahora</span>
      </div>
      <p class="rrp-notify__text">Sultan RS · Garaje Legion Square</p>
    </div>
    <button class="rrp-notify__close" aria-label="Cerrar notificación">✕</button>
    <span class="rrp-notify__timer"><span style="width:78%"></span></span>
  </div>
</div>
```

Variantes: `--success`, `--warning`, `--danger`, `--info`.

**Tamaño.** El título va a 14 px y la línea de debajo a 13, no a 11/10
como una etiqueta de campo: un toast se lee por el rabillo del ojo, sobre
un juego en movimiento y a la distancia a la que estés de la pantalla. Van
casi a la par a propósito — la jerarquía la hacen el peso y el tono, y
estirar la diferencia dejaría el dato (qué objeto y cuántos) más pequeño
justo cuando es lo que has salido a leer. Si tu NUI reescala el aviso con
una variable propia, sube estos dos con ella o anularás el ajuste.

**Duración.** Un aviso que contesta a algo que el jugador acaba de hacer
—«no cabe», «desde ahí no»— lo está mirando: 3 s. Un aviso que llega
mientras está en otra cosa —ha recogido algo, le han dado algo— necesita
aguantar hasta que gire la vista: 7 s. Pon la misma cifra en
`--rrp-notify-duration` para que la barra del temporizador y el `setTimeout`
del recurso digan lo mismo.

### Aviso de un objeto

Cuando el toast va de un objeto concreto, el arte del objeto sustituye al
pictograma en el círculo y el estado baja a una chapa sobre él. Es la
misma jerarquía que dentro del slot: el objeto identifica, el color dice
qué le ha pasado. El estado sigue estando en tres sitios — el velo del
fondo, el color de la barra y el de la chapa —, así que no se pierde nada
por bajar el pictograma de tamaño.

El título dice **qué ha pasado** y el texto **cuánto y de qué**; al revés
obliga a leer la línea entera para saber si has ganado o perdido algo.

```html
<div class="rrp-notify rrp-notify--success">
  <span class="rrp-notify__art">
    <img src="images/bandage.png" alt="">
    <i class="rrp-notify__art-badge"><svg><use href="#i-check"/></svg></i>
  </span>
  <div class="rrp-notify__body">
    <div class="rrp-notify__head">
      <p class="rrp-notify__title">Recibido</p>
    </div>
    <p class="rrp-notify__text">2 × Vendaje</p>
  </div>
  <span class="rrp-notify__timer"><span></span></span>
</div>
```

Sin PNG, `.rrp-notify__art` acepta un `<svg>` de categoría directamente:
un hueco vacío se lee como una imagen que no ha cargado.

Con avisos de 7 s conviene **agrupar las repeticiones**: si el mismo
suceso del mismo objeto sigue en pantalla, súmale la cantidad y reinicia
su reloj en vez de apilar otro. Recoger munición de nueve en nueve daba
tres toasts empujándose; uno que cuente 27 dice más.

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

### Dos columnas

**Nuevo.** Para listas largas de una sola línea — animaciones, emotes,
frecuencias de radio — donde una columna obliga a desplazar el doble por
nada: el nombre ocupa un tercio del ancho y los otros dos tercios se
quedan vacíos.

```html
<div class="rrp-scroll rrp-scroll--shadow" style="max-height:196px;--rrp-scroll-bg:var(--rrp-surface-1)">
  <div class="rrp-menu rrp-menu--cols" style="border:none;background:none">
    <button class="rrp-menu__item"><span class="rrp-menu__body"><p class="rrp-menu__title">Abrirse paso</p></span></button>
    <button class="rrp-menu__item is-active"><span class="rrp-menu__body"><p class="rrp-menu__title">Air Guitar</p></span></button>
    …
  </div>
</div>
```

Con descripción (`.rrp-menu__desc`) no compensa: a media anchura el texto
se corta y la fila deja de leerse de un vistazo. Dos columnas son para
nombres cortos, con metadato corto a la derecha como mucho.

Los items se quedan **transparentes** a propósito: es lo que deja pasar
las sombras de `.rrp-scroll--shadow`, que se pintan en el contenedor y
por detrás. Un item con fondo propio las taparía y el degradado de "hay
más abajo" desaparecería. Por eso las separaciones son bordes y no
huecos de rejilla, que necesitarían que el fondo lo pusiera el item.

Son **dos** columnas, no N: la primera fila se queda sin línea arriba con
`:nth-child(-n + 2)` y la vertical la pone `:nth-child(even)`. Las dos
cuentan columnas a mano, así que un tercer tramo pide su propia regla, no
una variable.

### Filtrar la lista

Ocultar con `[hidden]` funciona — `components.css` lo fuerza a
`display: none`, que sin ayuda perdería contra el `display: flex` del
item. Ojo a un detalle: la línea de separación la quita `:first-child`,
que sigue siendo el primero del DOM aunque esté oculto, así que al
filtrar el primero visible aparece con su línea arriba. Dentro de un
`.rrp-scroll--shadow` la sombra superior la disimula; si te molesta,
mueve tú la clase al primero que quede visible.

```js
const norm = s => s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
items.forEach(it => {
  it.hidden = !!q && !norm(it.querySelector('.rrp-menu__title').textContent).includes(norm(q));
});
```

Normaliza acentos y mayúsculas: es como la gente escribe cuando busca
deprisa. Y ten un estado vacío (`.rrp-empty`) preparado — una lista que
se queda en blanco sin decir nada parece que ha fallado.

## Navegación lateral / secciones

La barra de categorías de una NUI (Animaciones, Objetos, Bailes…), en
vertical con `.rrp-nav`, en horizontal con `.rrp-nav--row`, o como carril
de solo iconos con `.rrp-nav--rail`.

**La fila va en horizontal: icono a la izquierda, etiqueta a la derecha.**
El orden del marcado es el de la lectura — primero `.rrp-nav__icon`, luego
`.rrp-nav__label` — y el CSS no lo toca. Apilado, el icono flota sobre un
texto que no lo toca y cada fila crece a lo alto justo donde una NUI no
sobra sitio; en fila, el ojo baja por un único borde izquierdo y los
nombres se leen de un barrido. En `--rail` la etiqueta se oculta y el
icono se centra solo; en `--row` el par icono+etiqueta se centra en su
tramo.

La etiqueta se corta con ellipsis si no cabe, así que la anchura del
contenedor la eliges tú: por debajo de unos 150 px una palabra como
"Herramientas" llega cortada.

**El estado activo no se marca con un bloque macizo de color bajo el
texto.** Un fondo teal o lima relleno hunde el contraste de la etiqueta y
deja de leerse justo el elemento que querías destacar. El activo va con
tinte suave, borde teal y el halo inferior, y el texto sube a blanco. El
color macizo se queda para los botones, donde el texto se elige a juego.

**El halo inferior es el mismo que el de `.rrp-tab`**, y está definido
una sola vez para las dos: una fila de navegación es una pestaña puesta
de canto, y las dos dicen "estás aquí". Vale para las tres variantes —
vertical, `--rail` de solo icono y `--row`.

Va en `::before` y no en `::after` a propósito: `::after` es del tooltip
por atributo. Un elemento activo con `data-rrp-tip` perdería el tooltip,
que es justo el caso del carril de solo iconos, donde el tooltip es la
única forma de saber qué hace el botón.

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

Carril de iconos: la etiqueta se oculta y pasa al tooltip. El
`.rrp-nav__label` se deja en el marcado — es lo que lee un lector de
pantalla si un día se quita `--rail` —, y el `aria-label` cubre mientras
tanto.

**El carril no recorta.** `.rrp-nav` lleva `overflow: hidden auto` porque
una lista de categorías con nombre acaba siendo más larga que la pantalla;
un carril de iconos no, son cuatro o seis. Heredar ese recorte mataba el
tooltip contra el borde del propio carril, y el tooltip es la única
etiqueta que tiene el botón. Por eso `--rail` vuelve a `overflow: visible`.

Si algún carril necesita desplazarse de verdad, el scroll va en un
envoltorio por fuera y el tooltip se coloca con `data-rrp-tip-pos="bottom"`,
que sale por el eje que el envoltorio no recorta.

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

Control segmentado: las pestañas viven dentro de una caja hundida y la
activa es la única que se levanta, con tinte teal y una línea inferior
que se apaga hacia los lados.

Ese halo inferior lo comparte con `.rrp-nav__item.is-active`: está
definido una sola vez en `components.css`, en la sección de pestañas.
Si lo cambias ahí, cambia en la navegación — que es lo que se quiere.

```html
<div class="rrp-tabs">
  <button class="rrp-tab is-active">Inventario</button>
  <button class="rrp-tab">Vehículos</button>
  <button class="rrp-tab">Facturas</button>
</div>
```

## Badge y punto de estado

El badge es neutro y el estado lo dice un punto de color, que el
componente pinta solo. Así una fila con cuatro badges no se convierte en
cuatro manchas.

```html
<span class="rrp-badge">Sin estado</span>
<span class="rrp-badge rrp-badge--success">Pagado</span>
<span class="rrp-badge rrp-badge--warning">Pendiente</span>
<span class="rrp-badge rrp-badge--danger">Buscado</span>
<span class="rrp-badge rrp-badge--info">Nuevo</span>
<span class="rrp-badge rrp-badge--teal">Sistema activo</span>
<span class="rrp-badge rrp-badge--plain">12,4 kg</span>
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

Rejilla simple para una tienda o una armería: el número de columnas se
cambia con `--rrp-slots-columns` sin tocar el CSS del sistema. Para el
inventario del jugador (peso, cantidades, durabilidad, arrastre,
categorías) usa `.rrp-inv`, más abajo.

```html
<div class="rrp-slots" style="--rrp-slots-columns: 6">
  <div class="rrp-slot is-selected">
    <span class="rrp-slot__count">×3</span>
    <span class="rrp-slot__label">Vendaje</span>
  </div>
  <div class="rrp-slot is-empty"></div>
</div>
```

## Inventario completo

`.rrp-slots` es la pieza suelta (una tienda, una armería). `.rrp-inv` es la
pantalla entera y **trae su propio contenedor**: no lo metas dentro de un
`.rrp-panel`. Se compone de barra superior, rejilla, panel de detalle y
barra inferior de categorías.

La idea que lo sostiene: **el slot enseña lo justo y el detalle lo cuenta
todo**. Cantidad, nombre y peso en la tarjeta; categoría, descripción,
durabilidad y acciones solo del objeto seleccionado, en la columna de la
derecha. Es lo que permite que una rejilla de 25 huecos no sea una pared
de datos.

La geometría se cambia por variable, nunca tocando el CSS del sistema:

| Variable | Por defecto | Qué controla |
|---|---|---|
| `--rrp-inv-columns` | `5` | Columnas de la rejilla |
| `--rrp-inv-gap` | `--rrp-space-sm` | Hueco entre slots |
| `--rrp-inv-slot-ratio` | `1 / 1` | Proporción del slot |
| `--rrp-inv-slot-min` | `104px` | Alto mínimo del slot |
| `--rrp-inv-side` | `240px` | Ancho del panel de detalle |

```html
<section class="rrp-inv" style="--rrp-inv-columns: 5">

  <!-- Barra superior: marca, peso y herramientas -->
  <div class="rrp-inv__top">
    <div class="rrp-inv__brand">
      <span class="rrp-inv__mark" aria-hidden="true"><svg …></svg></span>
      <div>
        <h2 class="rrp-inv__title">Inventario</h2>
        <div class="rrp-inv__weight">
          <p class="rrp-inv__weight-text">
            <span class="rrp-inv__weight-value">8,10 / 30 kg</span>
            <span class="rrp-inv__weight-max">27%</span>
          </p>
          <div class="rrp-progress rrp-progress--sm">
            <div class="rrp-progress__fill" style="width:27%"></div>
          </div>
        </div>
      </div>
    </div>

    <div class="rrp-inv__tools">
      <div class="rrp-inv__cash"><span class="rrp-inv__cash-icon">$</span><span>1.240</span></div>
      <div class="rrp-input-group" style="width: 220px">
        <span class="rrp-input-group__affix"><svg …></svg></span>
        <input class="rrp-input" placeholder="Buscar objeto…" aria-label="Buscar objeto">
      </div>
      <select class="rrp-select" style="width: auto" aria-label="Ordenar">…</select>
    </div>
  </div>

  <!-- Cuerpo: rejilla + detalle -->
  <div class="rrp-inv__content">
    <div class="rrp-inv__main">
      <div class="rrp-inv__grid">

        <button class="rrp-inv-slot is-selected">
          <span class="rrp-inv-slot__head">
            <span class="rrp-inv-slot__index">1</span>
            <span class="rrp-inv-slot__amount">×1</span>
          </span>
          <span class="rrp-inv-slot__figure">
            <span class="rrp-inv-slot__icon"><svg …></svg></span>
          </span>
          <span class="rrp-inv-slot__foot">
            <span class="rrp-inv-slot__name">Teléfono</span>
            <span class="rrp-inv-slot__weight">0,22 kg</span>
          </span>
          <div class="rrp-progress">
            <div class="rrp-progress__fill" style="width:78%"></div>
          </div>
        </button>

        <!-- Con PNG en vez de icono -->
        <button class="rrp-inv-slot">
          <span class="rrp-inv-slot__head">
            <span class="rrp-inv-slot__index">2</span>
            <span class="rrp-inv-slot__amount">×24</span>
          </span>
          <span class="rrp-inv-slot__figure">
            <img class="rrp-inv-slot__img" src="img/ammo.png" alt="">
          </span>
          <span class="rrp-inv-slot__foot">
            <span class="rrp-inv-slot__name">Munición 9mm</span>
            <span class="rrp-inv-slot__weight">1,20 kg</span>
          </span>
        </button>

        <!-- Hueco libre: solo el número, aún más apagado -->
        <div class="rrp-inv-slot is-empty">
          <span class="rrp-inv-slot__head"><span class="rrp-inv-slot__index">3</span></span>
        </div>
      </div>
    </div>

    <aside class="rrp-inv__side">
      <p class="rrp-inv-detail__eyebrow">Objeto seleccionado</p>
      <div class="rrp-inv-detail__figure"><svg …></svg></div>
      <p class="rrp-inv-detail__title">Teléfono</p>
      <p class="rrp-inv-detail__desc">Dispositivo móvil personal.</p>
      <div class="rrp-inv-detail__rows">
        <div class="rrp-inv-detail__row">
          <span>Cantidad</span><span class="rrp-inv-detail__value">1</span>
        </div>
        <div class="rrp-inv-detail__row">
          <span>Peso</span><span class="rrp-inv-detail__value">0,22 kg</span>
        </div>
      </div>
      <div class="rrp-inv-detail__actions">
        <button class="rrp-btn rrp-btn--sm rrp-btn--primary">Usar</button>
        <button class="rrp-btn rrp-btn--sm">Dar</button>
        <button class="rrp-btn rrp-btn--sm rrp-btn--ghost">Partir</button>
        <button class="rrp-btn rrp-btn--sm rrp-btn--danger">Tirar</button>
      </div>
    </aside>
  </div>

  <!-- Barra inferior: categorías -->
  <div class="rrp-inv__bottom">
    <div class="rrp-inv__cats">
      <button class="rrp-inv__cat is-active">
        <span class="rrp-inv__cat-icon"><svg …></svg></span>Todo
      </button>
      <button class="rrp-inv__cat">
        <span class="rrp-inv__cat-icon"><svg …></svg></span>Armas
      </button>
    </div>
    <p class="rrp-inv__note">Clic para seleccionar · arrastra para mover</p>
  </div>
</section>
```

Sin nada seleccionado, el panel lateral lleva
`<div class="rrp-inv-detail__empty">Selecciona un objeto</div>`.
`.rrp-inv--nodetail` quita la columna y deja la rejilla a todo el ancho;
por debajo de 900 px se cae sola.

### Estados del slot

| Clase | Cuándo |
|---|---|
| `is-selected` | Slot activo: velo teal, borde teal y línea teal al pie. **Solo uno.** |
| `is-empty` | Hueco libre; solo el número, más apagado. |
| `is-dragging` | Origen del arrastre: se apaga. |
| `is-dropzone` | Destino válido del arrastre. |
| `is-blocked` | Destino inválido: no cabe, objeto no permitido. |
| `is-dimmed` | Fuera del buscador o del filtro: sigue visible, deja de competir. |
| `is-locked` | Slot que el jugador todavía no tiene desbloqueado. |

El hover del slot es **neutro** a propósito: si el teal apareciera al pasar
el ratón, dejaría de significar "este es el que tienes elegido".

La durabilidad, la munición o la batería son una `.rrp-progress` normal
dentro del slot: el componente la pega al canto inferior en 2 px. Usa sus
modificadores según el nivel — `--warning` por debajo del 40 %, `--danger`
por debajo del 15 % — en vez de un color propio del inventario. El peso de
la barra superior funciona igual cuando el macuto se llena.

### Iconos de interfaz y arte de objeto

Son dos cosas distintas y no se mezclan:

- **Interfaz** (categorías, buscador, marca, botones): icono **de línea**
  en un sprite SVG del propio recurso (`<symbol id="i-gun">` +
  `<use href="#i-gun">`), con `stroke="currentColor"` en el `<svg>` para
  que herede el color y los estados. Monocromo siempre: es cromo, no
  contenido, y debe callarse.
- **Objeto** (lo que va dentro del slot y del detalle): **PNG a color**
  del pack del servidor, en `.rrp-inv-slot__img`. Un objeto se reconoce
  por su dibujo, no por un pictograma (renderizado estándar a 90×90 px dentro de .rrp-inv-slot__figure). Es la única parte de la NUI que
  lleva color libre, y funciona justo porque todo lo que la rodea es
  neutro.

Nada de fuentes de iconos por CDN: una NUI no tiene red garantizada, y si
la fuente no carga la interfaz se queda llena de cuadrados. Los emoji
tampoco valen en ninguno de los dos sitios — traen su propio color y su
propio estilo.

Las imágenes de objeto van **en el recurso**, nunca enlazadas a un
servidor externo. El preview usa `preview-items/` con 14 piezas del set
*Artwork-OX* de [items.rainmad.com](https://items.rainmad.com) a modo de
ejemplo; cada servidor pone las suyas.

### Detalle flotante

Para una NUI sin sitio para la columna, la misma información junto al
cursor. Sin `pointer-events`, para no cortar un arrastre que pase por
encima; el JS la coloca con `left`/`top` respecto al ancestro posicionado.

```html
<div class="rrp-inv-tip" hidden>
  <p class="rrp-inv-detail__title">Teléfono</p>
  <p class="rrp-inv-detail__desc">Dispositivo móvil personal.</p>
  <div class="rrp-inv-detail__rows">
    <div class="rrp-inv-detail__row">
      <span>Peso</span><span class="rrp-inv-detail__value">0,22 kg</span>
    </div>
  </div>
</div>
```

### Tablero de dos inventarios

Jugador ↔ alijo, maletero, tienda o cacheo. Dos `.rrp-inv` con una columna
central de traspaso; `.rrp-inv-board--stack` lo pasa a una sola columna
para una NUI estrecha. Con dos rejillas a la vez, usa `--nodetail` y baja
las columnas antes que encoger los slots.

```html
<div class="rrp-inv-board">
  <section class="rrp-inv rrp-inv--nodetail" style="--rrp-inv-columns: 4">…</section>

  <div class="rrp-inv-board__aside">
    <button class="rrp-btn rrp-btn--sm" data-rrp-tip="Pasar todo" aria-label="Pasar todo">»</button>
    <button class="rrp-btn rrp-btn--sm" data-rrp-tip="Traer todo" aria-label="Traer todo">«</button>
  </div>

  <section class="rrp-inv rrp-inv--nodetail" style="--rrp-inv-columns: 4">…</section>
</div>
```

### Patrones que ya cubre el sistema

No hagas versiones propias de esto dentro del inventario:

- **Clic derecho sobre un slot** → `.rrp-menu`.
- **Partir una pila con cantidad exacta** → `.rrp-modal` con `.rrp-input`.
- **Confirmar tirar al suelo** → `.rrp-modal` con `.rrp-btn--danger`.
- **Buscador** → `.rrp-input-group`; **orden** → `.rrp-select`.
- **Aviso de "no cabe"** → `.rrp-notify--danger` o `.rrp-alert`.
- **Tecla de acceso rápido** → el `__index` del slot ya es el número de
  tecla; para el prompt en el HUD, `.rrp-keyhint` y `.rrp-key`.

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
