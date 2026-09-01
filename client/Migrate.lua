--[[
    dwkemotes - Migracion de datos locales
    ---------------------------------------------------------------------------
    Los datos del jugador (keybinds, favoritos) viven en el KVP del cliente bajo
    el prefijo Config.keybindKVP. Al renombrar el recurso ese prefijo cambia, asi
    que importamos una unica vez lo que hubiera guardado rpemotes.
]]

local LEGACY_PREFIX <const> = 'rpemotes'
local MIGRATION_FLAG <const> = 'dwkemotes_migrated_v1'

---@param key string
---@return string|nil
local function readKvp(key)
    local value = GetResourceKvpString(key)
    if value == nil or value == '' then return nil end
    return value
end

--- Copia una clave del prefijo antiguo al nuevo si el destino aun no existe.
---@param suffix string
---@return boolean copied
local function copyKey(suffix)
    local from = ('%s_%s'):format(LEGACY_PREFIX, suffix)
    local to = ('%s_%s'):format(Config.keybindKVP, suffix)

    if readKvp(to) then return false end

    local value = readKvp(from)
    if not value then return false end

    SetResourceKvp(to, value)
    return true
end

CreateThread(function()
    if not Config.MigrateLegacyKvp then return end
    if Config.keybindKVP == LEGACY_PREFIX then return end
    if GetResourceKvpString(MIGRATION_FLAG) then return end

    local migrated = 0

    if copyKey('favorites') then migrated += 1 end

    for slot = 1, #Config.KeybindKeys do
        if copyKey(('bind_%s'):format(slot)) then migrated += 1 end
    end

    SetResourceKvp(MIGRATION_FLAG, tostring(GetGameTimer()))

    if migrated > 0 then
        print(('^2[dwkemotes]^7 Migradas %d claves guardadas de rpemotes.'):format(migrated))
    end
end)
