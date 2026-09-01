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
| `components.css` | Clases listas para usar (`.rrp-title`, `.rrp-textbox`, `.rrp-dropdown`, `.rrp-btn`, `.rrp-gradient-N`) que ya aplican los tokens correctamente. |
| `components.md` | Referencia visual: qué clase usar para cada patrón del mockup, con ejemplos de HTML. |

## Principios

- **Jerarquía tipográfica fija**: Montserrat Bold solo para el título
  principal del panel. Montserrat SemiBold para subtítulos, títulos de
  sección, botones y cabeceras de desplegable. Montserrat Regular para
  todo el texto de cuerpo/opciones.
- **Escala de fondo consistente**: de más oscuro a más claro, el fondo
  de un panel siempre sigue `bg-dark → bg-primary → bg-secondary`. No
  uses `bg-secondary` como fondo exterior ni `bg-dark` como fondo de un
  botón.
- **El color accent (`#CEDC00`) es para llamar la atención**, no para
  decorar: hover de "Aceptar", filas seleccionadas que deben destacar
  al máximo. Si todo es amarillo, nada lo es.
- **Degradados**: siempre el stop más oscuro arriba y el más claro
  abajo (`linear-gradient(180deg, oscuro, claro)`). Usa las 4 clases
  `.rrp-gradient-1` a `.rrp-gradient-4` ya definidas en vez de crear
  degradados sueltos.
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
