---
name: add-dwkemotes-pack
description: Use when the user leaves a new emote/animation pack (often a .zip, .rar, or a folder of .ycd files) in the NUEVOS EMOTES folder of the dwkemotes FiveM resource, and needs it extracted/moved into stream/[Custom Emotes] and registered in custom_emotes/*.lua so it works in the emote menu. Triggers on keywords like "nuevo pack de emotes", "añade los emotes", "da de alta", "NUEVOS EMOTES", ".ycd", "zip de animaciones".
---

# Añadir un pack de emotes a dwkemotes

Workflow para integrar un pack de animaciones nuevo en el recurso FiveM
`dwkemotes`, que va dejando el usuario en la carpeta `stream/NUEVOS EMOTES`.

## Contexto del proyecto

- Recurso FiveM con menú de emotes NUI (fork de rpemotes-reborn).
- `fxmanifest.lua`:
  - Carga `'custom_emotes/*.lua'` (línea ~58) para los registros de emotes.
  - FiveM streamea todo `stream/` de forma **recursiva**, así que la ubicación
    exacta de los `.ycd` dentro de `stream/` no afecta al dict name.
  - Los `.ytyp` de props de packs nuevos pueden necesitar una
    `data_file 'DLC_ITYP_REQUEST'` extra (en especial packs de props).
- Los `.ycd` (animation dictionaries) viven en `stream/`, organizados por pack
  dentro de `stream/[Custom Emotes]/<NombrePack>/`.
- Los registros (cómo aparece cada emote en el menú) viven en
  `custom_emotes/*.lua`.
- `RegisterAddonEmotes()` está definida en `client/AnimationListCustom.lua` y
  es la única función externa que usan los registros.

## Estructura de carpetas

```
dwkemotes/
├── fxmanifest.lua
├── custom_emotes/          <- REGISTROS .lua (uno por pack/tematica)
│   ├── gelo_poses.lua
│   ├── pazeee_fortnite_v4.lua
│   └── ...
└── stream/
    ├── NUEVOS EMOTES/       <- Bandeja de entrada: el usuario deja aqui los packs
    └── [Custom Emotes]/     <- Destino final: una subcarpeta por pack
        ├── Gelo/
        ├── Pazeee Fortnite V4/
        └── ...
```

La carpeta `NUEVOS EMOTES` es una bandeja de entrada reutilizable: el usuario
la mantiene para ir soltando packs nuevos. Se pueden dejar vacíos los restos
(txt/png/xml) o el zip, pero el destino de los `.ycd` siempre es
`stream/[Custom Emotes]/`.

## Pasos

### 1. Localizar y extraer el pack

Busca en `stream/NUEVOS EMOTES/` cualquier archivo/zip nuevo:

```powershell
Get-ChildItem -LiteralPath "...\stream\NUEVOS EMOTES" -Recurse
```

Si es un `.zip`/`.rar`, descomprímelo a una carpeta temporal
(`%TEMP%\opencode\...`) para inspeccionarlo. Atención: algunos zips contienen
un `AnimationList.lua` con las definiciones exactas (dict, clip, etiqueta) que
debemos respetar.

### 2. Identificar qué contiene

Los packs de animación traen `.ycd` (dictionaries). Pueden venir con:
- `stream/*.ycd` dentro del zip.
- Un `AnimationList.lua` que ya define diccionarios/clips/labels. **Usa esa
  definición tal cual** (dict name y clip name son literales internos del
  `.ycd`: NO los inventes, deben coincidir exactamente).
- Subcarpetas anidadas, XML source, previews .png/.jpg, readmes... **solo se
  mueven los `.ycd`**, el resto se descarta.

### 3. Mover los `.ycd` a `[Custom Emotes]`

Crea una subcarpeta por pack dentro de `stream/[Custom Emotes]/` y mueve ahí
todos los `.ycd`:

```powershell
$ce = "...\stream\[Custom Emotes]"
New-Item -ItemType Directory -Force -Path (Join-Path $ce "<NombrePack>") | Out-Null
Get-ChildItem -LiteralPath "..." -Filter '*.ycd' -File | ForEach-Object {
  Move-Item -LiteralPath $_.FullName -Destination (Join-Path $ce "<NombrePack>") -Force
}
```

Usa SIEMPRE `-LiteralPath` (los nombres de carpeta llevan `[`, `#`, espacios,
`@`...). Usa rutas absolutas. No cambies de directorio con `cd`; usa el
parámetro `workdir` o rutas absolutas.

### 4. Decidir el tipo de emote y crear el `.lua`

Crea un archivo nuevo en `custom_emotes/` siguiendo EXACTAMENTE este patrón:

```lua
-- <Nombre Pack> <descripcion>
-- Source files: stream/[Custom Emotes]/<NombrePack>/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.<TIPO> = {
    ["identificador"] = {
        "dict_name",        -- [1] dict exacto del .ycd
        "clip_name",        -- [2] clip exacto
        "Etiqueta Menú",     -- [3] nombre visible
        AnimationOptions = { EmoteLoop = true },
    },
    -- ... más emotes
}

RegisterAddonEmotes(CustomDP)
```

**Elige el tipo (`<TIPO>`) según la tabla destino:**

| Tipo | Uso |
|------|-----|
| `Emotes` | Poses/emotes de pie normales (la mayoría de packs de poses) |
| `Dances` | Bailes (pack "Dance", Fortnite, etc.) |
| `Shared` | Parejas/duo: entrada extra `[4]` = identificador de la pareja + `AnimationOptions` con `Attachto/offsets` o `SyncOffset*` |
| `PropEmotes` | Emotes que sostienen un objeto (`Prop`, `PropBone`, `PropPlacement`) |
| `Expressions` / `Walks` / `AnimalEmotes` | Casos especiales (no suelen venir en packs) |

Convenciones fijas del proyecto:
- Prefijo único por pack en los identificadores (p.ej. `gelo*`, `pf*`, `glocky*`).
- `AnimationOptions = { EmoteLoop = true }` para poses/bailes en loop.
- No añadas comentarios más allá del encabezado.

### 5. Registrar props extra (solo si aplica)

Si el pack trae `.ytyp` de props (y no solo `.ycd`), añade la línea en
`fxmanifest.lua`:

```lua
data_file 'DLC_ITYP_REQUEST' 'stream/[Custom Emotes]/<NombrePack>/<archivo>.ytyp'
```

Usa la ruta donde quedó el `.ytyp`.

### 6. Verificar

- **Sin duplicados de identificadores** entre todos los archivos de
  `custom_emotes/*.lua`:

```powershell
$ids = Select-String -Path "...\custom_emotes\*.lua" -Pattern '^\s*\["([^"]+)"\]\s*=' |
  ForEach-Object { $_.Matches[0].Groups[1].Value }
$ids | Group-Object | Where-Object Count -gt 1
```

- Cada `.ycd` que moviste tiene su entrada en un `.lua`, y dict/clip coinciden.
- La carpeta de destino en `[Custom Emotes]` contiene los `.ycd` correctos.
- Los `.lua` se cargan con el glob `'custom_emotes/*.lua'`, así que basta con
  crearlos en esa carpeta: no hace falta tocar `fxmanifest.lua` para registros
  de emotes (solo para `.ytyp` de props).

### 7. Informar al usuario

Resume: qué pack, cuántos `.ycd`, a qué subcarpeta de `[Custom Emotes]` se
movió, qué `.lua` se creó, y si hizo falta quedó pendiente algo (p.ej. el zip
original o los restos en `NUEVOS EMOTES` que el usuario puede borrar).

## Recordatorios clave

- Dict y clip names son **literales**: deben copiarse exactos del
  `AnimationList.lua` del pack o de dentro del `.ycd`. No traducir ni inventar.
- `RegisterAddonEmotes(CustomDP)` es obligatorio al final de cada archivo de
  registro, o el pack no aparece.
- Mover `.ycd` de sitio NO cambia el dict name: FiveM streamea `stream/`
  recursivamente. Los registros `.lua` no se rompen al reordenar carpetas.
- PowerShell 5.1: usa `-LiteralPath` para rutas con `[`, `#`, `@` y espacios;
  evita `cd`.
