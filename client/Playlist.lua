--[[
    dwkemotes - Playlists
    ---------------------------------------------------------------------------
    Una playlist es una secuencia de animaciones que se reproducen una tras otra.

    Por que el reproductor vive aqui y no en la NUI: una playlist tiene que poder
    lanzarse con el menu cerrado (una tecla, /playlist, una peticion de grupo),
    asi que la fuente de verdad son estas tablas y el KVP, no el localStorage del
    navegador. El menu es solo el editor.

    Por que cada paso lleva su propio tiempo: el recurso no tiene ningun evento de
    "animacion terminada". Lo unico que hay es checkStatusThread (Emote.lua), que
    ni siquiera se instala para las emotes con prop y cuya unica reaccion es
    cancelar. Y el catalogo son casi todo poses en bucle que no acaban nunca. El
    temporizador de cada entrada es la unica senal de avance que existe.
]]

local KVP_KEY <const> = ('%s_playlists'):format(Config.keybindKVP)

--- Tipos que tiene sentido encadenar. Las compartidas necesitan pareja y un
--- handshake, y los andares, expresiones y emojis no son animaciones con
--- principio y fin, sino estados.
local PLAYABLE_TYPES <const> = {
    [EmoteType.EMOTES] = true,
    [EmoteType.DANCES] = true,
    [EmoteType.PROP_EMOTES] = true,
    [EmoteType.ANIMAL_EMOTES] = true,
}

---@class PlaylistItem
---@field name string
---@field emoteType EmoteType
---@field label string
---@field duration integer milisegundos que se mantiene el paso

---@class Playlist
---@field id string
---@field name string
---@field color string
---@field loop boolean
---@field items PlaylistItem[]

---@type table<string, Playlist>
local playlists = {}
local dirty = false
local idCounter = 0

-- Generacion del reproductor. Cada arranque la incrementa; el hilo en curso se
-- detiene solo en cuanto ve que ya no es el suyo.
local playbackToken = 0
local playing = nil ---@type string|nil id o nombre de la playlist en curso

-- ─── Persistencia ────────────────────────────────────────────────────────────

local function save()
    SetResourceKvpNoSync(KVP_KEY, json.encode(playlists))
    dirty = false
end

local function load()
    local raw = GetResourceKvpString(KVP_KEY)
    if not raw or raw == '' then return end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then
        print('^3[dwkemotes] Las playlists guardadas estan ilegibles, se empieza de cero^0')
        return
    end

    -- json.encode de una tabla vacia devuelve "[]", que al decodificar vuelve
    -- como array. Se normaliza a mapa para que el resto del fichero no tenga que
    -- distinguir.
    for id, list in pairs(decoded) do
        if type(list) == 'table' and type(list.items) == 'table' then
            list.id = list.id or tostring(id)
            list.items = list.items or {}
            playlists[list.id] = list
        end
    end
end

-- ─── Consulta ────────────────────────────────────────────────────────────────

--- Todas las playlists, como array ordenado por nombre (la NUI las pinta asi).
---@return Playlist[]
function GetPlaylists()
    local out = {}
    for _, list in pairs(playlists) do out[#out + 1] = list end

    table.sort(out, function(a, b)
        return string.lower(a.name or '') < string.lower(b.name or '')
    end)

    return out
end

---@param id string
---@return Playlist|nil
function GetPlaylist(id)
    return playlists[id]
end

--- Busca por nombre, sin distinguir mayusculas. Para /playlist.
---@param name string
---@return Playlist|nil
local function findByName(name)
    local needle = string.lower(name)
    for _, list in pairs(playlists) do
        if string.lower(list.name or '') == needle then return list end
    end
end

--- Si una animacion puede formar parte de una playlist. La usa tambien la NUI
--- (via el payload) para no ofrecer lo que no se puede encadenar.
---@param emoteType EmoteType
---@param emoteName string
---@return boolean
function IsPlaylistable(emoteType, emoteName)
    if not PLAYABLE_TYPES[emoteType] then return false end

    local data = EmoteData and EmoteData[emoteName]
    if not data then return false end

    -- Los escenarios salen por otra rama de OnEmotePlay: no aceptan flags y no
    -- hay manera de saber cuando acaban.
    return not data.scenario
end

-- ─── Edicion ─────────────────────────────────────────────────────────────────

local function clampDuration(value)
    local ms = tonumber(value) or Config.PlaylistDefaultDuration or 5000
    local min = Config.PlaylistMinDuration or 500
    local max = Config.PlaylistMaxDuration or 60000

    if ms < min then ms = min end
    if ms > max then ms = max end

    return math.floor(ms)
end

--- Limpia lo que llega de la NUI. Es entrada de fuera aunque venga de nuestra
--- propia interfaz: un perfil importado puede traer cualquier cosa.
---@param raw table
---@return PlaylistItem[]
local function sanitizeItems(raw)
    local out = {}
    if type(raw) ~= 'table' then return out end

    local limit = Config.MaxPlaylistItems or 64

    for _, item in ipairs(raw) do
        if type(item) == 'table' and type(item.name) == 'string' and item.name ~= '' then
            out[#out + 1] = {
                name = item.name,
                emoteType = item.emoteType or EmoteType.EMOTES,
                label = tostring(item.label or item.name),
                duration = clampDuration(item.duration),
            }
        end

        if #out >= limit then break end
    end

    return out
end

--- Crea o actualiza. Devuelve la playlist guardada, o nil con el motivo.
---@param data table
---@return Playlist|nil, string|nil
function SavePlaylist(data)
    if type(data) ~= 'table' then return nil, 'datos invalidos' end

    local name = tostring(data.name or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' then return nil, 'la playlist necesita un nombre' end
    if #name > 40 then name = string.sub(name, 1, 40) end

    local id = data.id
    if not id or not playlists[id] then
        local max = Config.MaxPlaylists or 20
        local count = 0
        for _ in pairs(playlists) do count += 1 end
        if count >= max then return nil, ('maximo de %d playlists'):format(max) end

        -- El contador evita que dos playlists creadas en el mismo tick (una
        -- importacion de perfil las crea todas seguidas) compartan id.
        idCounter += 1
        id = ('pl_%s_%s'):format(GetGameTimer(), idCounter)
    end

    playlists[id] = {
        id = id,
        name = name,
        color = tostring(data.color or '#019685'),
        loop = data.loop == true,
        items = sanitizeItems(data.items),
    }

    dirty = true
    save()

    return playlists[id]
end

---@param id string
function DeletePlaylist(id)
    if not playlists[id] then return false end

    if playing == id then StopPlaylist() end

    playlists[id] = nil
    dirty = true
    save()

    return true
end

--- Reemplaza el conjunto entero. La usa la importacion de perfil de la NUI.
---@param list table[]
function ReplacePlaylists(list)
    playlists = {}

    if type(list) == 'table' then
        for _, entry in ipairs(list) do
            -- Se pasa por SavePlaylist para que lo importado quede saneado igual
            -- que lo que se crea a mano.
            entry.id = nil
            SavePlaylist(entry)
        end
    end

    save()
    return GetPlaylists()
end

-- ─── Reproduccion ────────────────────────────────────────────────────────────

--- Corta la playlist en curso. No cancela la animacion: quien pare una playlist
--- casi siempre quiere quedarse en la pose, y si lo que quiere es cortar del todo
--- ya esta la tecla de cancelar de siempre.
function StopPlaylist()
    playbackToken += 1
    playing = nil
end

---@return boolean
function IsPlaylistPlaying()
    return playing ~= nil
end

--- Espera troceada, para poder abortar a mitad de un paso largo.
---@param ms integer
---@param token integer
---@param expected string nombre de la emote que este paso puso a sonar
---@return boolean seguir
local function waitStep(ms, token, expected)
    local deadline = GetGameTimer() + ms

    while GetGameTimer() < deadline do
        if playbackToken ~= token then return false end

        -- El jugador ha cancelado, o ha lanzado otra emote por su cuenta. En los
        -- dos casos la playlist deja de mandar: no tiene sentido pisarle lo que
        -- acaba de poner.
        if not IsInAnimation then return false end
        if CurrentAnimationName ~= expected then return false end

        Wait(100)
    end

    return playbackToken == token
end

--- Reproduce una secuencia de pasos ya saneada.
---@param items PlaylistItem[]
---@param loop boolean
---@param label string
local function runSequence(items, loop, label)
    playbackToken += 1
    local token = playbackToken

    CreateThread(function()
        local hadProp = false

        repeat
            for _, item in ipairs(items) do
                if playbackToken ~= token then return end

                local data = EmoteData and EmoteData[item.name]
                -- Un paso puede haber dejado de valer desde que se guardo: la
                -- animacion ya no existe, el jugador cambio de modelo, o el
                -- perfil importado trae algo que no se puede encadenar. Se salta
                -- sin cortar la secuencia.
                local allowed = data
                    and IsPlaylistable(item.emoteType, item.name)
                    and HasEmotePermission(item.name, item.emoteType)
                    and (not CachedPlayerModel or IsModelCompatible(CachedPlayerModel, item.name))

                if allowed then
                    -- OnEmotePlay solo limpia los props cuando la emote nueva
                    -- trae uno. Al encadenar una con prop y otra sin el, el
                    -- objeto se quedaria en la mano toda la playlist.
                    if hadProp and not (data.AnimationOptions and data.AnimationOptions.Prop) then
                        DestroyAllProps()
                    end

                    OnEmotePlay(item.name, nil, item.emoteType)
                    hadProp = (data.AnimationOptions and data.AnimationOptions.Prop) ~= nil

                    if not waitStep(item.duration, token, item.name) then return end
                end
            end
        until not loop or playbackToken ~= token

        if playbackToken == token then playing = nil end
    end)
end

--- Lanza una playlist guardada, por id o por nombre.
---@param idOrName string
---@return boolean
function PlaylistStart(idOrName)
    if not Config.PlaylistsEnabled then return false end
    if type(idOrName) ~= 'string' then return false end

    local list = playlists[idOrName] or findByName(idOrName)
    if not list then
        EmoteChatMessage(Translate('playlistnotfound', idOrName))
        return false
    end

    if #list.items == 0 then
        EmoteChatMessage(Translate('playlistempty'))
        return false
    end

    playing = list.id
    runSequence(list.items, list.loop, list.name)

    return true
end

--- Lanza una secuencia que llega de fuera (una peticion de grupo). No se busca
--- en las playlists locales a proposito: el resto de jugadores no tienen por que
--- tener guardada la playlist de quien la lanza.
---@param items table[]
---@param loop boolean
function PlaylistStartFromData(items, loop)
    if not Config.PlaylistsEnabled then return false end

    local clean = sanitizeItems(items)
    if #clean == 0 then return false end

    playing = '__remote'
    runSequence(clean, loop == true, 'playlist')

    return true
end

-- ─── Enganches ───────────────────────────────────────────────────────────────

-- Cancelar la animacion para tambien la secuencia: es lo que espera cualquiera
-- que pulse la tecla de cancelar mientras corre una playlist.
do
    local originalEmoteCancel = EmoteCancel

    function EmoteCancel(force)
        if playing then StopPlaylist() end
        return originalEmoteCancel(force)
    end
end

-- ─── Comando ─────────────────────────────────────────────────────────────────

CreateThread(function()
    load()

    if not Config.PlaylistsEnabled then return end

    RegisterCommand('playlist', function(_, args)
        if #args == 0 then
            EmoteChatMessage(Translate('playlistusage'))
            return
        end

        PlaylistStart(table.concat(args, ' '))
    end, false)

    TriggerEvent('chat:addSuggestion', '/playlist', Translate('playlistsuggestion'), {
        { name = 'nombre', help = Translate('playlistsuggestionarg') }
    })
end)

-- Volcado del KVP agrupado, igual que el historial de uso.
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if dirty then save() end
    if FlushResourceKvp then FlushResourceKvp() end
end)

CreateExport('getPlaylists', GetPlaylists)
CreateExport('playPlaylist', PlaylistStart)
CreateExport('stopPlaylist', StopPlaylist)
