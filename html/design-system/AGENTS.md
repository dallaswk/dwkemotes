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
| `components.css` | Clases listas para usar que ya aplican los tokens: la base (`.rrp-panel`, `.rrp-title`, `.rrp-textbox`, `.rrp-dropdown`, `.rrp-btn`, `.rrp-gradient-N`) y los componentes NUI (formularios, `.rrp-notify`, `.rrp-menu`, `.rrp-modal`, `.rrp-progress`, `.rrp-slots`, `.rrp-table`, `.rrp-keyhint`…). |
| `components.md` | Referencia visual: qué clase usar para cada patrón del mockup, con ejemplos de HTML. |

## Principios

- **Jerarquía tipográfica fija**: Montserrat Bold solo para el título
  principal del panel. Montserrat SemiBold para subtítulos, títulos de
  sección, botones y cabeceras de desplegable. Montserrat Regular para
  todo el texto de cuerpo/opciones.
- **Negro para contenedores, verde para jerarquía**: las superficies
  grandes (panel, cajas, cuerpo de listas) van sobre la escala neutra
  `surface-1 → surface-2 → surface-3`. El verde de `backgroundScale`
  se reserva para lo que marca jerarquía o invita a actuar: título
  principal, cabeceras de desplegable, botones y hovers. Así una NUI
  no se lee como un bloque verde uniforme.
- **Escala de fondo consistente**: cuando sí uses verde, de más oscuro
  a más claro el orden es `bg-dark → bg-primary → bg-secondary`. No
  uses `bg-secondary` como fondo exterior ni `bg-dark` como fondo de un
  botón.
- **Separación por borde, no por color**: sobre negro, dos superficies
  contiguas se distinguen con `--rrp-border-subtle`, no subiendo el
  verde. `--rrp-border-teal` es para la caja que debe destacar; el
  borde blanco duro es ahora opt-in (`.rrp-textbox--outline`).
- **El color accent (`#CEDC00`) es para llamar la atención**, no para
  decorar: hover de "Aceptar", filas seleccionadas que deben destacar
  al máximo. Si todo es amarillo, nada lo es.
- **Los estados semánticos comunican, no decoran**: `--rrp-success`,
  `--rrp-warning` y `--rrp-danger` dicen cómo ha ido una acción o qué
  riesgo tiene. Un botón es `--danger` cuando destruye algo, no cuando
  es importante — para eso está accent. Sobre negro, el color va en el
  borde y el texto, y el fondo usa el tinte `--rrp-*-soft`.
- **El estado activo no se pinta con un bloque macizo**: en pestañas y
  navegación, rellenar el fondo de teal o lima bajo el texto hunde el
  contraste justo del elemento que querías destacar. Se marca con tinte
  suave (`--rrp-*-soft`) más un indicador de acento al costado. El color
  macizo se reserva a los botones, donde el texto se elige a juego
  (`--rrp-text-on-accent`, `--rrp-text-on-danger`).
- **Un icono sin etiqueta lleva tooltip y `aria-label`**: `data-rrp-tip`
  resuelve el tooltip sin envolver el botón. Si la única forma de saber
  qué hace un botón es pulsarlo, el botón está mal.
- **Ninguna lista se queda con la barra nativa**: los contenedores del
  sistema ya la llevan estilizada; para uno propio, `.rrp-scroll`. Y el
  scroll lateral vive dentro de su contenedor (`.rrp-table-wrap`), nunca
  en la página: una NUI no debe desplazarse entera de lado.
- **Mira el catálogo antes de construir**: `components.md` cubre ya los
  patrones habituales de una NUI (formularios, toasts, menú de opciones,
  modal, progreso, slots de inventario, tabla, tooltip, key hint). Si el
  patrón existe, úsalo; no rehagas uno equivalente con otro nombre.
- **Degradados**: siempre el stop más oscuro arriba y el más claro
  abajo (`linear-gradient(180deg, oscuro, claro)`). Usa las 5 clases
  `.rrp-gradient-0` a `.rrp-gradient-4` ya definidas en vez de crear
  degradados sueltos; la 0 es la neutra (negro → `surface-2`).
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
