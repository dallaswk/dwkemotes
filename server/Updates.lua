--[[
    dwkemotes - Comprobacion de version
    ---------------------------------------------------------------------------
    El original consultaba el repositorio del proyecto del que procede este fork,
    asi que cualquier servidor acababa viendo avisos de "version desactualizada"
    que no correspondian a su copia. Aqui la comprobacion esta desactivada por
    defecto y solo apunta al repositorio que indique el propietario del servidor
    en Config.UpdateRepo ('usuario/repo'). Sin repositorio no se hace ninguna
    peticion HTTP.
]]

if not Config.CheckForUpdates then return end
if type(Config.UpdateRepo) ~= 'string' or Config.UpdateRepo == '' then return end

local function log(level, message)
    local color = level == 'success' and '^2' or (level == 'error' and '^1' or '^3')
    print(('%s[dwkemotes]^7 %s'):format(color, message))
end

---@param version string
---@return integer[]|nil
local function parseVersion(version)
    local major, minor, patch = version:match('(%d+)%.(%d+)%.(%d+)')
    if not major then return nil end
    return { tonumber(major), tonumber(minor), tonumber(patch) }
end

---@return integer -1 si a < b, 0 si iguales, 1 si a > b
local function compare(a, b)
    for i = 1, 3 do
        if a[i] ~= b[i] then return a[i] < b[i] and -1 or 1 end
    end
    return 0
end

CreateThread(function()
    Wait(2000)

    local currentRaw = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    local current = currentRaw and parseVersion(currentRaw)
    if not current then
        log('error', 'No se pudo leer la version del recurso; se omite la comprobacion.')
        return
    end

    local url = ('https://api.github.com/repos/%s/releases/latest'):format(Config.UpdateRepo)

    PerformHttpRequest(url, function(status, body)
        if status ~= 200 or not body then return end

        local ok, release = pcall(json.decode, body)
        if not ok or type(release) ~= 'table' or release.prerelease then return end

        local latest = release.tag_name and parseVersion(release.tag_name)
        if not latest then return end

        if compare(current, latest) < 0 then
            log('info', ('Hay una version mas reciente (%s -> %s): %s')
                :format(currentRaw, release.tag_name, release.html_url or url))
        end
    end, 'GET', '', { ['User-Agent'] = 'dwkemotes' })
end)
