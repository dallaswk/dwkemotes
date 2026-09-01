# ResetRP — Referencia de componentes

Cada patrón del mockup original tiene su clase equivalente aquí. Copia el
HTML, ajusta el contenido, no toques los estilos base.

## Panel contenedor

```html
<div class="rrp-panel">
  ...contenido del panel...
</div>
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

Fondo `bg-primary`, borde blanco de 1px, texto Regular.

```html
<div class="rrp-textbox">
  <p class="rrp-textbox__title">Texto básico</p>
  <p>Párrafo de contenido normal, Montserrat Regular.</p>
</div>
```

## Desplegable (dropdown)

Cabecera SemiBold sobre `bg-secondary`, opciones Regular sobre `bg-dark`.
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

Cuatro pasos de la escala de fondo, siempre oscuro arriba → claro abajo.

```html
<div class="rrp-gradient-1" style="width:120px;height:160px"></div>
<div class="rrp-gradient-2" style="width:120px;height:160px"></div>
<div class="rrp-gradient-3" style="width:120px;height:160px"></div>
<div class="rrp-gradient-4" style="width:120px;height:160px"></div>
```

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
