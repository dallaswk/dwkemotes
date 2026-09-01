--[[
    dwkemotes - Historial de uso
    ---------------------------------------------------------------------------
    Registra que emotes usa el jugador para alimentar las categorias "Recientes"
    y "Mas usados" del menu. Todo es local al cliente (KVP), nada se envia al
    servidor.

    El registro se engancha a las funciones que representan una accion explicita
    del jugador (menu, comando /e, keybind, caminatas). Las reproducciones
    internas -recuperacion tras ragdoll, manos arriba, señalar- no cuentan.
]]

local USAGE_KEY <const> = ('%s_usage'):format(Config.keybindKVP)
local MAX_ENTRIES <const> = 200 -- Tope duro para que el KVP no crezca sin control

---@class UsageEntry
---@field name string
---@field label string
---@field emoteType EmoteType
---@field count integer
---@field last integer Marca de tiempo (os.time)

---@type table<string, UsageEntry>
local usage = {}
local dirty = false
local loaded = false

local function keyFor(name, emoteType)
    return ('%s_%s'):format(emoteType or '', name)
end

local function load()
    if loaded then return end
    loaded = true

    local raw = GetResourceKvpString(USAGE_KEY)
    if not raw or raw == '' then return end

    local ok, decoded = pcall(json.decode, raw)
    if ok and type(decoded) == 'table' then
        usage = decoded
    end
end

--- Elimina las entradas menos relevantes cuando se supera MAX_ENTRIES.
local function prune()
    local count = 0
    for _ in pairs(usage) do count += 1 end
    if count <= MAX_ENTRIES then return end

    local keys = {}
    for key in pairs(usage) do keys[#keys + 1] = key end

    -- Menos usadas primero y, a igualdad, las mas antiguas.
    table.sort(keys, function(a, b)
        local ea, eb = usage[a], usage[b]
        if ea.count ~= eb.count then return ea.count < eb.count end
        return (ea.last or 0) < (eb.last or 0)
    end)

    for i = 1, count - MAX_ENTRIES do
        usage[keys[i]] = nil
    end
end

local function save()
    if not dirty then return end
    dirty = false
    prune()
    SetResourceKvpNoSync(USAGE_KEY, json.encode(usage))
end

--- Resuelve la etiqueta visible de una emote a partir de las tablas ya convertidas.
---@param name string
---@param emoteType EmoteType
---@return string
local function resolveLabel(name, emoteType)
    local source
    if emoteType == EmoteType.WALKS then
        source = WalkData
    elseif emoteType == EmoteType.EXPRESSIONS then
        source = ExpressionData
    elseif emoteType == EmoteType.SHARED then
        source = SharedEmoteData
    else
        source = EmoteData
    end

    local data = source and source[name]
    return (data and data.label) or name
end

--- Suma un uso al historial.
---@param name string
---@param emoteType EmoteType
function RegisterEmoteUsage(name, emoteType)
    if not Config.RecentsEnabled then return end
    if type(name) ~= 'string' or name == '' then return end

    load()

    local key = keyFor(name, emoteType)
    local entry = usage[key]

    if entry then
        entry.count += 1
        entry.last = os.time()
        entry.label = resolveLabel(name, emoteType)
    else
        usage[key] = {
            name = name,
            label = resolveLabel(name, emoteType),
            emoteType = emoteType,
            count = 1,
            last = os.time(),
        }
    end

    dirty = true
end

---@param a UsageEntry
---@param b UsageEntry
local function byRecency(a, b)
    return (a.last or 0) > (b.last or 0)
end

---@param a UsageEntry
---@param b UsageEntry
local function byCount(a, b)
    if a.count ~= b.count then return a.count > b.count end
    return (a.last or 0) > (b.last or 0)
end

---@param comparator fun(a: UsageEntry, b: UsageEntry): boolean
---@param limit integer
---@param minCount integer
---@return UsageEntry[]
local function collect(comparator, limit, minCount)
    load()

    local list = {}
    for _, entry in pairs(usage) do
        if entry.count >= minCount then
            list[#list + 1] = entry
        end
    end

    table.sort(list, comparator)

    local result = {}
    for i = 1, math.min(limit, #list) do
        local entry = list[i]
        result[i] = {
            name = entry.name,
            label = resolveLabel(entry.name, entry.emoteType),
            emoteType = entry.emoteType,
            count = entry.count,
        }
    end
    return result
end

--- Emotes ordenadas por ultimo uso.
---@return table[]
function GetRecentEmotes()
    if not Config.RecentsEnabled then return {} end
    return collect(byRecency, Config.MaxRecents or 30, 1)
end

--- Emotes ordenadas por numero de usos.
---@return table[]
function GetMostUsedEmotes()
    if not Config.RecentsEnabled then return {} end
    return collect(byCount, Config.MaxRecents or 30, Config.MostUsedMinCount or 3)
end

--- Borra todo el historial.
function ClearEmoteUsage()
    usage = {}
    loaded = true
    dirty = false
    DeleteResourceKvp(USAGE_KEY)
end

-- ─── Enganches ───
-- Envolvemos las funciones globales existentes en lugar de editarlas, para que el
-- diff con el proyecto original siga siendo pequeño y facil de actualizar.

do
    local originalEmoteMenuStart = EmoteMenuStart
    function EmoteMenuStart(name, textureVariation, emoteType)
        RegisterEmoteUsage(name, emoteType or (EmoteData[name] and EmoteData[name].emoteType))
        return originalEmoteMenuStart(name, textureVariation, emoteType)
    end

    local originalEmoteCommandStart = EmoteCommandStart
    function EmoteCommandStart(args)
        local name = args and args[1] and string.lower(args[1])
        if name and name ~= 'c' and EmoteData[name] then
            RegisterEmoteUsage(name, EmoteData[name].emoteType)
        end
        return originalEmoteCommandStart(args)
    end

    local originalWalkMenuStart = WalkMenuStart
    function WalkMenuStart(name, force)
        if WalkData and WalkData[name] then
            RegisterEmoteUsage(name, EmoteType.WALKS)
        end
        return originalWalkMenuStart(name, force)
    end
end

-- Volcado periodico del KVP: agrupa las escrituras en vez de tocar disco en cada emote.
CreateThread(function()
    while true do
        Wait(20000)
        if dirty then
            save()
            FlushResourceKvp()
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    save()
    FlushResourceKvp()
end)

CreateExport('getRecentEmotes', GetRecentEmotes)
CreateExport('getMostUsedEmotes', GetMostUsedEmotes)
CreateExport('clearEmoteUsage', ClearEmoteUsage)
