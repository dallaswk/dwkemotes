--[[
    dwkemotes - Puente de compatibilidad con scully_emotemenu
    ---------------------------------------------------------------------------
    Varios recursos del servidor llaman a `exports.scully_emotemenu:...` para
    reproducir o cancelar animaciones (qbx_mechanicjob, qbx_truckerjob y
    qbx_smallresources, entre otros). Al retirar aquel menu esas llamadas
    reventarian con "No such export".

    En lugar de editar cada recurso, publicamos aqui la misma superficie de
    exports bajo el nombre antiguo. FiveM resuelve un export por el evento
    `__cfx_export_<recurso>_<nombre>`, asi que basta con registrarlo con el
    nombre de recurso de scully para que las llamadas existentes sigan
    funcionando sin tocarlas.

    Solo se cubre lo que puede traducirse con exactitud. Los exports que
    dependen del formato de datos propio de scully (registerEmote,
    addEmoteToMenu, getEmoteProps, setLimitation...) no se declaran: es
    preferible que fallen de forma visible a que devuelvan algo incorrecto.
]]

local LEGACY_RESOURCE <const> = 'scully_emotemenu'

--- Publica una funcion como export de otro recurso.
---@param name string
---@param fn function
local function provideAs(name, fn)
    AddEventHandler(('__cfx_export_%s_%s'):format(LEGACY_RESOURCE, name), function(setCb)
        setCb(function(...)
            return fn(...)
        end)
    end)
end

-- ─── Animaciones ───

--- scully: playEmoteByCommand(command, variant)
--- Equivale a escribir /e <command> [variant].
provideAs('playEmoteByCommand', function(command, variant)
    if type(command) ~= 'string' then return end
    local args = { command }
    if variant ~= nil then args[2] = tostring(variant) end
    EmoteCommandStart(args)
end)

provideAs('cancelEmote', function()
    EmoteCancel()
end)

provideAs('isInEmote', function()
    return IsInAnimation == true
end)

provideAs('getLastEmote', function()
    return CurrentAnimationName
end)

-- ─── Formas de caminar ───

provideAs('getCurrentWalk', function()
    local walk = GetResourceKvpString('walkstyle')
    if walk == '' then return nil end
    return walk
end)

provideAs('setWalk', function(name)
    if type(name) ~= 'string' then return end
    WalkMenuStart(name)
end)

provideAs('setWalkByCommand', function(name)
    if type(name) ~= 'string' then return end
    WalkMenuStart(name)
end)

provideAs('resetWalk', function()
    ResetWalk()
    DeleteResourceKvp('walkstyle')
end)

-- ─── Expresiones ───

provideAs('getCurrentExpression', function()
    local expression = GetResourceKvpString('expression')
    if expression == '' then return nil end
    return expression
end)

provideAs('setExpression', function(name)
    if type(name) ~= 'string' then return end
    EmoteMenuStart(name, nil, EmoteType.EXPRESSIONS)
end)

provideAs('setExpressionByCommand', function(name)
    if type(name) ~= 'string' then return end
    EmoteMenuStart(name, nil, EmoteType.EXPRESSIONS)
end)

provideAs('resetExpression', function()
    DeleteResourceKvp('expression')
    ClearFacialIdleAnimOverride(PlayerPedId())
end)
