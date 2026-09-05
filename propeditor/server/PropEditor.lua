-- ─── Persistencia de los props ajustados con /propeditor ────────────────────
--
-- El editor vive en propeditor/client/PropEditor.lua; aqui solo se guarda lo
-- que manda, se reparte al resto de clientes y se exporta a Lua cuando se
-- quiere dejar el ajuste fijo en el pack de animaciones.
--
-- El fichero de datos es la fuente de verdad en caliente: mientras exista, sus
-- valores mandan sobre lo que declara la emote. `emoteprops export` es el paso
-- final que lleva esos valores a un .lua listo para pegar.
--
-- A diferencia de los SyncOffset, aqui no hay `apply`: los props se declaran en
-- bloques AnimationOptions repartidos por varios ficheros y con formatos muy
-- distintos, y reescribirlos a ciegas destrozaria packs ajenos. El export deja
-- el bloque hecho y el pegado es a mano, que es un minuto por emote.

local CFG = Config.PropEditor

local OVERRIDES_FILE <const> = 'propeditor/data/prop_overrides.json'
local EXPORT_FILE <const> = 'propeditor/data/prop_overrides_export.lua'

-- Los mismos limites que aplica el cliente. Se revalidan aqui porque un evento
-- de red puede llegar con cualquier cosa.
local LIMIT_POS <const> = CFG.limitPos
local MAX_MODEL_LEN <const> = 64
local MAX_EMOTE_LEN <const> = 64

---@type table<string, table>
local overrides = {}

local function resource() return GetCurrentResourceName() end

local function countOverrides()
    local n = 0
    for _ in pairs(overrides) do n += 1 end
    return n
end

local function loadOverrides()
    local raw = LoadResourceFile(resource(), OVERRIDES_FILE)
    if not raw or raw == '' then return end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then
        print('^1[dwkemotes] ' .. OVERRIDES_FILE .. ' ilegible, se ignora^0')
        return
    end

    overrides = decoded

    local count = countOverrides()
    if count > 0 then
        print(('^2[dwkemotes] %d ajuste(s) de prop cargados de %s^0'):format(count, OVERRIDES_FILE))
    end
end

local function saveOverrides()
    -- Este fichero lo lee el recurso, no una persona: el que se lee a mano es el
    -- que genera `emoteprops export`.
    SaveResourceFile(resource(), OVERRIDES_FILE, json.encode(overrides), -1)
end

loadOverrides()

--- Comprueba el permiso para tocar props. Con Config.PropEditor.ace a nil puede
--- cualquiera, que es lo util mientras se calibra un pack; poner ahi un ACE lo
--- cierra a quien lo tenga, sin cambiar nada mas.
---@param source number
---@return boolean
local function canEdit(source)
    if not CFG.enabled then return false end
    if not CFG.ace then return true end
    return IsPlayerAceAllowed(source, CFG.ace)
end

---@param value any
---@param limit number
---@return number
local function clampNumber(value, limit)
    local n = tonumber(value) or 0.0
    if n ~= n then return 0.0 end -- NaN
    if n > limit then return limit end
    if n < -limit then return -limit end
    return tonumber(('%.3f'):format(n)) or 0.0
end

---@param value any
---@return number
local function normalizeAngle(value)
    local n = tonumber(value) or 0.0
    if n ~= n then return 0.0 end
    return tonumber(('%.2f'):format(n % 360)) or 0.0
end

--- Deja un slot recibido por red en la forma exacta que se guarda, o nil si no
--- trae un modelo utilizable.
---@param slot any
---@return table|nil
local function sanitizeSlot(slot)
    if type(slot) ~= 'table' then return nil end

    local model = slot.model
    if type(model) ~= 'string' then return nil end

    model = model:gsub('%s', ''):lower()
    if model == '' or #model > MAX_MODEL_LEN or model:find('[^%w_%-]') then return nil end

    local bone = math.floor(tonumber(slot.bone) or 28422)
    if bone < 0 or bone > 65535 then bone = 28422 end

    local pos = type(slot.pos) == 'table' and slot.pos or {}
    local rot = type(slot.rot) == 'table' and slot.rot or {}

    return {
        model = model,
        bone = bone,
        pos = {
            x = clampNumber(pos.x, LIMIT_POS),
            y = clampNumber(pos.y, LIMIT_POS),
            z = clampNumber(pos.z, LIMIT_POS),
        },
        rot = {
            x = normalizeAngle(rot.x),
            y = normalizeAngle(rot.y),
            z = normalizeAngle(rot.z),
        },
        noCollision = slot.noCollision == true,
    }
end

-- ─── Eventos ─────────────────────────────────────────────────────────────────

RegisterNetEvent('dwkemotes:propeditor:request', function()
    local source = source
    TriggerClientEvent('dwkemotes:propeditor:overrides', source, overrides)
end)

RegisterNetEvent('dwkemotes:propeditor:open', function(emoteName)
    local source = source
    if type(emoteName) ~= 'string' or #emoteName == 0 or #emoteName > MAX_EMOTE_LEN then return end

    TriggerClientEvent('dwkemotes:propeditor:openReply', source, canEdit(source), emoteName)
end)

RegisterNetEvent('dwkemotes:propeditor:save', function(emoteName, data)
    local source = source
    if not canEdit(source) then return end

    if type(emoteName) ~= 'string' or #emoteName == 0 or #emoteName > MAX_EMOTE_LEN then return end
    if type(data) ~= 'table' then return end

    local slot1 = sanitizeSlot(data.slot1)
    local slot2 = sanitizeSlot(data.slot2)

    -- Sin el primero, el segundo asciende: addProps() solo mira SecondProp
    -- cuando Prop existe, asi que guardar solo el segundo no ensenaria nada.
    if not slot1 then
        slot1, slot2 = slot2, nil
    end

    local entry = (slot1 or slot2) and { slot1 = slot1, slot2 = slot2 } or nil

    overrides[emoteName] = entry
    saveOverrides()

    -- A todos, para que la siguiente vez que alguien lance esa emote ya use lo
    -- nuevo sin reiniciar el recurso.
    TriggerClientEvent('dwkemotes:propeditor:updated', -1, emoteName, entry)
    TriggerClientEvent('dwkemotes:propeditor:saved', source, emoteName, entry)

    local describe = 'sin props'
    if slot1 then
        describe = ('%s @ %d'):format(slot1.model, slot1.bone)
        if slot2 then
            describe = ('%s + %s @ %d'):format(describe, slot2.model, slot2.bone)
        end
    end

    print(('^2[dwkemotes]^0 %s ajusto los props de %s -> %s'):format(
        GetPlayerName(source) or source, emoteName, describe))
end)

-- ─── Consola del servidor ────────────────────────────────────────────────────

---@return string[] nombres de emote ordenados
local function sortedNames()
    local names = {}
    for name in pairs(overrides) do names[#names + 1] = name end
    table.sort(names)
    return names
end

---@param slot table
---@param prefix string '' o 'Second'
---@param out string[]
local function writeSlotBlock(slot, prefix, out)
    out[#out + 1] = ('        %sProp = "%s",'):format(prefix, slot.model)
    out[#out + 1] = ('        %sPropBone = %d,'):format(prefix, slot.bone)
    out[#out + 1] = ('        %sPropPlacement = {'):format(prefix)
    out[#out + 1] = ('            %.3f, %.3f, %.3f,'):format(slot.pos.x, slot.pos.y, slot.pos.z)
    out[#out + 1] = ('            %.2f, %.2f, %.2f,'):format(slot.rot.x, slot.rot.y, slot.rot.z)
    out[#out + 1] = '        },'
    if slot.noCollision then
        out[#out + 1] = ('        %sPropNoCollision = true,'):format(prefix)
    end
end

--- Escribe un .lua legible con todo lo ajustado, listo para pegar a mano en el
--- AnimationOptions de cada emote.
local function exportOverrides()
    local names = sortedNames()
    if #names == 0 then
        print('^3[dwkemotes] No hay ningun ajuste de prop que exportar^0')
        return
    end

    local out = {
        '-- Props ajustados con /propeditor',
        ('-- %s | %d emote(s)'):format(os.date('%Y-%m-%d %H:%M:%S'), #names),
        '--',
        '-- Pega el bloque AnimationOptions de cada emote sobre el que ya tiene en',
        '-- su pack. Los campos que no aparecen aqui (Flag, EmoteDuration, Ptfx*)',
        '-- se dejan como estaban: este export solo cubre los props.',
        '',
    }

    for _, name in ipairs(names) do
        local entry = overrides[name]

        out[#out + 1] = ('["%s"] = {'):format(name)
        out[#out + 1] = '    AnimationOptions = {'

        if entry.slot1 then writeSlotBlock(entry.slot1, '', out) end
        if entry.slot2 then writeSlotBlock(entry.slot2, 'Second', out) end

        out[#out + 1] = '    },'
        out[#out + 1] = '},'
        out[#out + 1] = ''
    end

    SaveResourceFile(resource(), EXPORT_FILE, table.concat(out, '\n'), -1)
    print(('^2[dwkemotes] %d emote(s) exportadas a %s^0'):format(#names, EXPORT_FILE))
end

local function listOverrides()
    local names = sortedNames()
    if #names == 0 then
        print('^3[dwkemotes] Ningun prop ajustado^0')
        return
    end

    print(('^2[dwkemotes] %d emote(s) con props ajustados^0'):format(#names))
    for _, name in ipairs(names) do
        local entry = overrides[name]
        for _, key in ipairs({ 'slot1', 'slot2' }) do
            local slot = entry[key]
            if slot then
                print(('  %-28s %-34s hueso %-6d  pos %6.3f %6.3f %6.3f  rot %6.1f %6.1f %6.1f'):format(
                    key == 'slot1' and name or '', slot.model, slot.bone,
                    slot.pos.x, slot.pos.y, slot.pos.z,
                    slot.rot.x, slot.rot.y, slot.rot.z))
            end
        end
    end
end

---@param name string|nil
local function clearOverrides(name)
    if not name then
        print('^1[dwkemotes] Uso: emoteprops clear <emote|all>^0')
        return
    end

    if name == 'all' then
        for emote in pairs(overrides) do
            TriggerClientEvent('dwkemotes:propeditor:updated', -1, emote, nil)
        end
        overrides = {}
        saveOverrides()
        print('^2[dwkemotes] Todos los ajustes de prop borrados^0')
    elseif overrides[name] then
        overrides[name] = nil
        saveOverrides()
        TriggerClientEvent('dwkemotes:propeditor:updated', -1, name, nil)
        print(('^2[dwkemotes] Props de %s devueltos a los del pack^0'):format(name))
    else
        print(('^1[dwkemotes] %s no tiene props ajustados^0'):format(name))
    end
end

RegisterCommand('emoteprops', function(source, args)
    if source > 0 then return end -- solo desde la consola del servidor

    local action = args[1]

    if action == 'list' then
        listOverrides()
    elseif action == 'export' then
        exportOverrides()
    elseif action == 'clear' then
        clearOverrides(args[2])
    else
        print('\n^5### dwkemotes - Editor de props ###^0\n')
        print('  ^2emoteprops list^0                 lo ajustado hasta ahora')
        print(('  ^2emoteprops export^0               escribe %s'):format(EXPORT_FILE))
        print('  ^2emoteprops clear <emote|all>^0    devuelve la emote a los props del pack')
        print(('\nEn juego se ajusta con ^2/%s^0 durante una emote.\n'):format(CFG.command))
    end
end, true)
