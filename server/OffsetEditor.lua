-- ─── Persistencia de los SyncOffset ajustados con /emoteoffset ───────────────
--
-- El editor vive en client/OffsetEditor.lua; aqui solo se guarda lo que manda,
-- se reparte al resto de clientes y se exporta a Lua cuando se quiere dejar el
-- ajuste fijo en el pack de animaciones.
--
-- El fichero de datos es la fuente de verdad en caliente: mientras exista, sus
-- valores mandan sobre lo que declara la animacion. `emoteoffsets apply` es el
-- paso final que lleva esos valores al .lua del pack.

local OFFSETS_FILE <const> = 'data/sync_offsets.json'
local EXPORT_FILE <const> = 'data/sync_offsets_export.lua'

-- Los mismos limites que aplica el cliente. Se revalidan aqui porque un evento
-- de red puede llegar con cualquier cosa.
local LIMIT_HORIZONTAL <const> = 2.0
local LIMIT_VERTICAL <const> = 1.5

---@type table<string, {side: number, front: number, height: number, heading: number}>
local offsets = {}

local function resource() return GetCurrentResourceName() end

local function countOffsets()
    local n = 0
    for _ in pairs(offsets) do n += 1 end
    return n
end

local function loadOffsets()
    local raw = LoadResourceFile(resource(), OFFSETS_FILE)
    if not raw or raw == '' then return end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then
        print('^1[dwkemotes] ' .. OFFSETS_FILE .. ' ilegible, se ignora^0')
        return
    end

    offsets = decoded

    local count = countOffsets()
    if count > 0 then
        print(('^2[dwkemotes] %d SyncOffset(s) cargados de %s^0'):format(count, OFFSETS_FILE))
    end
end

local function saveOffsets()
    -- json.encode no ordena las claves, pero este fichero lo lee el recurso, no
    -- una persona: el que se lee a mano es el que genera `emoteoffsets export`.
    SaveResourceFile(resource(), OFFSETS_FILE, json.encode(offsets), -1)
end

loadOffsets()

--- Comprueba el permiso para tocar offsets. Con Config.OffsetEditorAce a nil
--- puede cualquiera, que es lo util mientras se calibra un pack; poner ahi un
--- ACE lo cierra a quien lo tenga, sin tocar nada mas.
---@param source number
---@return boolean
local function canEditOffsets(source)
    if not Config.OffsetEditorEnabled then return false end
    if not Config.OffsetEditorAce then return true end
    return IsPlayerAceAllowed(source, Config.OffsetEditorAce)
end

local function clamp(value, limit)
    if value > limit then return limit end
    if value < -limit then return -limit end
    return value
end

-- ─── Eventos ─────────────────────────────────────────────────────────────────

RegisterNetEvent('dwkemotes:server:requestSyncOffsets', function()
    local source = source
    TriggerClientEvent('dwkemotes:client:syncOffsets', source, offsets)
end)

RegisterNetEvent('dwkemotes:server:openOffsetEditor', function()
    local source = source
    TriggerClientEvent('dwkemotes:client:offsetEditorReply', source, canEditOffsets(source))
end)

--- Retransmite a la pareja la peticion de quedarse quieta mientras se calibra.
--- El cliente que recibe es quien decide y quien se suelta solo por plazo, asi
--- que aqui solo se comprueba que la peticion tiene sentido.
RegisterNetEvent('dwkemotes:server:offsetFreeze', function(targetServerId, frozen)
    local source = source
    if not canEditOffsets(source) then return end

    targetServerId = tonumber(targetServerId)
    if not targetServerId or targetServerId <= 0 or targetServerId == source then return end
    if not GetPlayerName(targetServerId) then return end

    -- La cercania solo se exige para congelar. Soltar tiene que llegar siempre:
    -- si se han separado, quien esta quieto no puede quedarse esperando al plazo.
    if frozen then
        local distance = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetServerId)))
        if distance > 5.0 then return end
    end

    TriggerClientEvent('dwkemotes:client:offsetFreeze', targetServerId, source, frozen == true)
end)

RegisterNetEvent('dwkemotes:server:saveSyncOffset', function(emoteName, side, front, height, heading)
    local source = source
    if not canEditOffsets(source) then return end

    if type(emoteName) ~= 'string' or #emoteName == 0 or #emoteName > 64 then return end
    if type(side) ~= 'number' or type(front) ~= 'number'
        or type(height) ~= 'number' or type(heading) ~= 'number' then
        return
    end

    local data = {
        side = clamp(side, LIMIT_HORIZONTAL),
        front = clamp(front, LIMIT_HORIZONTAL),
        height = clamp(height, LIMIT_VERTICAL),
        heading = heading % 360,
    }

    offsets[emoteName] = data
    saveOffsets()

    -- A todos, para que la siguiente vez que alguien lance esa emote ya use el
    -- valor nuevo sin reiniciar el recurso.
    TriggerClientEvent('dwkemotes:client:syncOffsetUpdated', -1, emoteName, data)
    TriggerClientEvent('dwkemotes:client:syncOffsetSaved', source, emoteName, data)

    print(('^2[dwkemotes]^0 %s ajusto %s -> front %.2f, side %.2f, height %.2f, heading %.1f'):format(
        GetPlayerName(source) or source, emoteName, data.front, data.side, data.height, data.heading))
end)

-- ─── Exportacion ─────────────────────────────────────────────────────────────

--- Packs de custom_emotes/ que definen sus parejas con addPair(). No hay forma
--- de listar un directorio del recurso desde el servidor, asi que la lista sale
--- de Config.OffsetEditorPacks; los que no existan se descartan sin ruido.
---@return string[]
local function addonFiles()
    local files = {}
    for _, name in ipairs(Config.OffsetEditorPacks or {}) do
        local path = ('custom_emotes/%s.lua'):format(name)
        if LoadResourceFile(resource(), path) then
            files[#files + 1] = path
        end
    end
    return files
end

--- Parte un fichero en lineas conservando las vacias: `apply` reescribe el .lua
--- entero, asi que perder los saltos de linea destrozaria el formato del pack.
---@param content string
---@return string[]
local function splitLines(content)
    local normalized = content:gsub('\r\n', '\n')
    if normalized:sub(-1) ~= '\n' then normalized = normalized .. '\n' end

    local lines = {}
    for line in normalized:gmatch('(.-)\n') do
        lines[#lines + 1] = line
    end
    return lines
end

--- Descompone una linea addPair(): los dos nombres de emote, todo el texto hasta
--- el label (que se conserva intacto) y los argumentos que van detras, separados
--- en los numeros del offset (A y, si esta, B) y todo lo que no sea un numero.
---
--- Lo que no es numero importa: detras del offset va el flag Attachto de la
--- pareja, y reescribir la linea sin el lo apagaria en silencio.
---@return {a: string, b: string, prefix: string, nums: number[], extras: string[]}|nil
local function parseAddPairLine(line)
    local a, b = line:match('^addPair%("([%w_]+)",%s*"[^"]*",%s*"[^"]*",%s*"([%w_]+)"')
    if not a then return nil end

    local prefix, args = line:match('^(addPair%(.*",%s*)([^)]*)%)%s*$')
    if not prefix then return nil end

    local nums, extras = {}, {}
    for item in args:gmatch('[^,]+') do
        local value = item:match('^%s*(.-)%s*$')
        local n = tonumber(value)
        if n then
            nums[#nums + 1] = n
        elseif value ~= '' and value ~= 'nil' then
            -- El `nil` se descarta a proposito: solo aparece como relleno del
            -- offset de B que escribe rewriteAddPairLine, y contarlo como
            -- argumento haria que una segunda pasada lo dejase ahi y empujase el
            -- flag cuatro puestos mas alla. Descartandolo, reescribir es
            -- idempotente.
            extras[#extras + 1] = value
        end
    end

    return { a = a, b = b, prefix = prefix, nums = nums, extras = extras }
end

---@return string
local function formatOffset(front, side, height, heading)
    return ('%.2f, %.2f, %.2f, %.2f'):format(front, side, height, heading)
end

--- Devuelve la misma linea addPair() con el offset del lado indicado sustituido.
--- El otro lado se conserva; si se escribe el de B y la linea no lo tenia, se
--- anade detras del de A.
---@param line string
---@param emoteName string cual de los dos lados se esta escribiendo
---@param data table
---@return string|nil
local function rewriteAddPairLine(line, emoteName, data)
    local parsed = parseAddPairLine(line)
    if not parsed then return nil end

    local nums = parsed.nums
    local sideA = formatOffset(nums[1] or 0.0, nums[2] or 0.0, nums[3] or 0.0, nums[4] or 180.0)
    local sideB = #nums >= 8 and formatOffset(nums[5], nums[6], nums[7], nums[8]) or nil

    if emoteName == parsed.a then
        sideA = formatOffset(data.front, data.side, data.height, data.heading)
    elseif emoteName == parsed.b then
        sideB = formatOffset(data.front, data.side, data.height, data.heading)
    else
        return nil
    end

    local args = sideB and (sideA .. ', ' .. sideB) or sideA

    if #parsed.extras > 0 then
        -- El flag Attachto es el argumento 16 de addPair(), detras de los dos
        -- offsets. Si el lado B no lleva numeros hay que rellenar su hueco: sin
        -- los cuatro nil, el flag entraria como el SyncOffsetFront de B, que es
        -- justo lo que le pasa hoy a las lineas del pack que solo traen cuatro
        -- numeros y un `true` al final.
        if not sideB then
            args = args .. ', nil, nil, nil, nil'
        end
        args = args .. ', ' .. table.concat(parsed.extras, ', ')
    end

    return ('%s%s)'):format(parsed.prefix, args)
end

--- Indexa una sola vez que emote esta declarada en que fichero y con que linea.
---@return table<string, {path: string, line: string}>
local function indexAddPairLines()
    local index = {}
    for _, path in ipairs(addonFiles()) do
        for _, line in ipairs(splitLines(LoadResourceFile(resource(), path))) do
            local parsed = parseAddPairLine(line)
            if parsed then
                -- Los dos lados se indexan: cualquiera de ellos puede ser el que
                -- inicie la emote y por tanto el que lleve offset.
                index[parsed.a] = { path = path, line = line }
                index[parsed.b] = { path = path, line = line }
            end
        end
    end
    return index
end

---@return string[] nombres de emote ordenados
local function sortedNames()
    local names = {}
    for name in pairs(offsets) do names[#names + 1] = name end
    table.sort(names)
    return names
end

--- Escribe un .lua legible con todo lo ajustado, listo para pegar a mano.
local function exportOffsets()
    local names = sortedNames()
    if #names == 0 then
        print('^3[dwkemotes] No hay ningun offset ajustado que exportar^0')
        return
    end

    local index = indexAddPairLines()
    local out = {
        '-- SyncOffset exportados por /emoteoffset',
        ('-- %s | %d emote(s)'):format(os.date('%Y-%m-%d %H:%M:%S'), #names),
        '--',
        '-- Para las emotes declaradas con addPair() va la linea ya sustituida,',
        '-- lista para reemplazar la de su pack. Para el resto, el bloque',
        '-- AnimationOptions equivalente.',
        '',
    }

    for _, name in ipairs(names) do
        local data = offsets[name]
        local found = index[name]
        local rewritten = found and rewriteAddPairLine(found.line, name, data)

        if rewritten then
            out[#out + 1] = ('-- %s (%s)'):format(name, found.path)
            out[#out + 1] = rewritten
        else
            out[#out + 1] = ('["%s"] = {'):format(name)
            out[#out + 1] = '    AnimationOptions = {'
            out[#out + 1] = ('        SyncOffsetFront = %.2f,'):format(data.front)
            out[#out + 1] = ('        SyncOffsetSide = %.2f,'):format(data.side)
            out[#out + 1] = ('        SyncOffsetHeight = %.2f,'):format(data.height)
            out[#out + 1] = ('        SyncOffsetHeading = %.2f,'):format(data.heading)
            out[#out + 1] = '    }'
            out[#out + 1] = '},'
        end

        out[#out + 1] = ''
    end

    SaveResourceFile(resource(), EXPORT_FILE, table.concat(out, '\n'), -1)
    print(('^2[dwkemotes] %d offset(s) exportados a %s^0'):format(#names, EXPORT_FILE))
end

--- Lleva los offsets a los .lua de custom_emotes/, dejando copia de seguridad.
--- Es el paso definitivo: despues de esto el fichero de datos ya no hace falta.
local function applyOffsets()
    if countOffsets() == 0 then
        print('^3[dwkemotes] No hay ningun offset ajustado que aplicar^0')
        return
    end

    local applied = 0
    local written = {}

    for _, path in ipairs(addonFiles()) do
        local content = LoadResourceFile(resource(), path)
        local lines = splitLines(content)
        local touched = 0

        for i, line in ipairs(lines) do
            local parsed = parseAddPairLine(line)

            if parsed then
                -- Una misma linea puede llevar los dos lados ajustados.
                local updated = line
                for _, name in ipairs({ parsed.a, parsed.b }) do
                    local data = offsets[name]
                    if data then
                        local rewritten = rewriteAddPairLine(updated, name, data)
                        if rewritten then
                            updated = rewritten
                            written[name] = true
                        end
                    end
                end

                if updated ~= line then
                    lines[i] = updated
                    touched += 1
                end
            end
        end

        if touched > 0 then
            local backup = ('data/%s.bak'):format(path:match('([^/]+)$'))
            SaveResourceFile(resource(), backup, content, -1)
            SaveResourceFile(resource(), path, table.concat(lines, '\n') .. '\n', -1)
            applied += touched
            print(('^2[dwkemotes] %s: %d linea(s) actualizadas (copia en %s)^0'):format(path, touched, backup))
        end
    end

    -- Lo que no vive en un addPair() no se puede reescribir sin adivinar el
    -- formato del fichero: se dice cuales son en vez de tocarlos.
    local skipped = {}
    for _, name in ipairs(sortedNames()) do
        if not written[name] then skipped[#skipped + 1] = name end
    end

    if applied == 0 then
        print('^3[dwkemotes] Ninguna linea addPair() coincidio^0')
    else
        print(('^2[dwkemotes] %d offset(s) aplicados. Reinicia el recurso para cargarlos^0'):format(applied))
    end

    if #skipped > 0 then
        print(('^3[dwkemotes] Sin linea addPair(), siguen solo en el JSON: %s^0'):format(table.concat(skipped, ', ')))
        print(('^3[dwkemotes] Usa `emoteoffsets export` y pega su bloque a mano^0'))
    end
end

--- El offset del otro lado de la pareja es la misma relacion vista desde el otro
--- extremo, asi que se puede calcular en vez de calibrarla a mano.
---
--- Colocar es `pos_A = pos_B + R(hdg_B)·(side, front)` con `hdg_A = hdg_B - H`.
--- Despejando el caso inverso sale `H' = -H` y `(side', front') = -R(H)·(side, front)`,
--- con la altura simplemente cambiada de signo.
---@param o {side: number, front: number, height: number, heading: number}
---@return {side: number, front: number, height: number, heading: number}
local function mirrorOffset(o)
    local t = math.rad(o.heading)
    local cos, sin = math.cos(t), math.sin(t)

    -- Se redondea a los dos decimales que se escriben en el .lua, y de paso se
    -- quita el cero negativo que sale de invertir un cero.
    local function tidy(n)
        n = tonumber(('%.2f'):format(n)) or 0.0
        return n == 0 and 0.0 or n
    end

    return {
        side = tidy(-(o.side * cos - o.front * sin)),
        front = tidy(-(o.side * sin + o.front * cos)),
        height = tidy(-o.height),
        heading = tidy((-o.heading) % 360),
    }
end

--- Rellena el lado que falte de cada pareja a partir del que ya este calibrado.
---@param onlyName string|nil si se indica, fuerza el espejo desde esa emote a su
---                           pareja aunque la pareja ya tuviera offset
local function mirrorOffsets(onlyName)
    local written = {}
    local found = false

    for _, path in ipairs(addonFiles()) do
        for _, line in ipairs(splitLines(LoadResourceFile(resource(), path))) do
            local parsed = parseAddPairLine(line)

            if parsed then
                local n = parsed.nums

                -- Lo ajustado en caliente manda sobre lo declarado en el .lua.
                local current = {
                    [parsed.a] = offsets[parsed.a]
                        or (#n >= 4 and { front = n[1], side = n[2], height = n[3], heading = n[4] } or nil),
                    [parsed.b] = offsets[parsed.b]
                        or (#n >= 8 and { front = n[5], side = n[6], height = n[7], heading = n[8] } or nil),
                }

                for _, direction in ipairs({ { parsed.a, parsed.b }, { parsed.b, parsed.a } }) do
                    local from, to = direction[1], direction[2]
                    local origin = current[from]

                    if onlyName == from then found = true end

                    local apply
                    if onlyName then
                        -- Forzado: se sobrescribe el otro lado aunque ya tuviera.
                        apply = onlyName == from and origin ~= nil
                    else
                        apply = origin ~= nil and current[to] == nil
                    end

                    if apply then
                        offsets[to] = mirrorOffset(origin)
                        written[#written + 1] = { name = to, from = from }
                    end
                end
            end
        end
    end

    if onlyName and not found then
        print(('^1[dwkemotes] %s no aparece en ningun addPair() de los packs^0'):format(onlyName))
        return
    end

    if #written == 0 then
        print('^3[dwkemotes] Nada que reflejar: los dos lados ya tienen offset^0')
        return
    end

    saveOffsets()

    for _, entry in ipairs(written) do
        TriggerClientEvent('dwkemotes:client:syncOffsetUpdated', -1, entry.name, offsets[entry.name])
        local o = offsets[entry.name]
        print(('  %-28s <- espejo de %-24s front %6.2f  side %6.2f  height %6.2f  heading %6.1f'):format(
            entry.name, entry.from, o.front, o.side, o.height, o.heading))
    end

    print(('^2[dwkemotes] %d lado(s) rellenados por espejo. Revisalos en juego antes de `apply`^0'):format(#written))
end

local function listOffsets()
    local names = sortedNames()
    if #names == 0 then
        print('^3[dwkemotes] Ningun offset ajustado^0')
        return
    end

    print(('^2[dwkemotes] %d offset(s) ajustados^0'):format(#names))
    for _, name in ipairs(names) do
        local o = offsets[name]
        print(('  %-28s front %6.2f  side %6.2f  height %6.2f  heading %6.1f'):format(
            name, o.front, o.side, o.height, o.heading))
    end
end

local function clearOffsets(name)
    if not name then
        print('^1[dwkemotes] Uso: emoteoffsets clear <emote|all>^0')
        return
    end

    if name == 'all' then
        for emote in pairs(offsets) do
            TriggerClientEvent('dwkemotes:client:syncOffsetUpdated', -1, emote, nil)
        end
        offsets = {}
        saveOffsets()
        print('^2[dwkemotes] Todos los offsets borrados^0')
    elseif offsets[name] then
        offsets[name] = nil
        saveOffsets()
        TriggerClientEvent('dwkemotes:client:syncOffsetUpdated', -1, name, nil)
        print(('^2[dwkemotes] Offset de %s borrado^0'):format(name))
    else
        print(('^1[dwkemotes] %s no tiene offset ajustado^0'):format(name))
    end
end

RegisterCommand('emoteoffsets', function(source, args)
    if source > 0 then return end -- solo desde la consola del servidor

    local action = args[1]

    if action == 'list' then
        listOffsets()
    elseif action == 'export' then
        exportOffsets()
    elseif action == 'apply' then
        applyOffsets()
    elseif action == 'mirror' then
        mirrorOffsets(args[2])
    elseif action == 'clear' then
        clearOffsets(args[2])
    else
        print('\n^5### dwkemotes - SyncOffset ###^0\n')
        print('  ^2emoteoffsets list^0                 lo ajustado hasta ahora')
        print(('  ^2emoteoffsets export^0               escribe %s'):format(EXPORT_FILE))
        print('  ^2emoteoffsets mirror [emote]^0       calcula el lado que falta de cada pareja')
        print('  ^2emoteoffsets apply^0                lo escribe en los .lua de custom_emotes/')
        print('  ^2emoteoffsets clear <emote|all>^0    descarta ajustes')
        print('\nEn juego se ajusta con ^2/emoteoffset^0 durante una shared emote.\n')
    end
end, true)
