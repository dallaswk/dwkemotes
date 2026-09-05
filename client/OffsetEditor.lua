-- ─── Editor de SyncOffset en vivo (/emoteoffset) ─────────────────────────────
--
-- Las shared emotes colocan al jugador que las inicia junto a su pareja usando
-- AnimationOptions.SyncOffset* (ver client/Syncing.lua). Esos cuatro numeros
-- solo se pueden calibrar viendo la pose puesta, asi que este editor los mueve
-- en caliente sobre la animacion que ya esta corriendo y manda el resultado al
-- servidor, que lo guarda y lo reparte al resto sin reiniciar el recurso.
--
-- El override se aplica en GetSyncOffset(), no escribiendo en SharedEmoteData:
-- asi da igual si los offsets llegan del servidor antes o despues de que el
-- menu haya convertido las listas de animaciones.

local DEFAULT_OFFSET <const> = vector4(0.0, 1.0, 0.0, 180.0)

-- Pasos de ajuste. El fino es el que se usa casi siempre; el grueso (Shift) es
-- para llegar rapido a la zona correcta antes de afinar.
local STEP_FINE <const> = 0.01
local STEP_COARSE <const> = 0.05
local STEP_HEADING_FINE <const> = 1.0
local STEP_HEADING_COARSE <const> = 5.0

-- Limites de seguridad: el editor recoloca el ped del jugador, asi que no puede
-- servir para desplazarse a voluntad. Una pose de pareja no necesita mas.
local LIMIT_HORIZONTAL <const> = 2.0
local LIMIT_VERTICAL <const> = 1.5

---@type table<string, {side: number, front: number, height: number, heading: number}>
local overrides = {}

local editing = false

--- Mientras el editor esta abierto coloca el ped a mano y frame a frame, asi que
--- el reanclaje de client/Syncing.lua tiene que apartarse: los dos se pelearian
--- por el mismo ped y no se podria calibrar nada.
---@return boolean
function IsOffsetEditorActive()
    return editing
end

--- Si el editor fue quien congelo al jugador. Es de modulo y no local al hilo de
--- edicion a proposito: soltarlo tiene que poder hacerse desde fuera si ese hilo
--- se cae, porque quedarse clavado en el sitio no tiene arreglo desde el juego.
local editorFroze = false

local function releaseEditorFreeze()
    if not editorFroze then return end
    editorFroze = false
    FreezeEntityPosition(PlayerPedId(), false)
    DebugPrint('[dwkemotes] editor de offsets: jugador descongelado')
end

--- Con 'zero' los dos peds quedan en la misma coordenada y con el mismo rumbo.
--- No es lo mismo que DEFAULT_OFFSET, que separa un metro y da media vuelta:
--- aqui no se desplaza nada a proposito.
local ZERO_OFFSET <const> = vector4(0.0, 0.0, 0.0, 0.0)

--- Offset efectivo de una shared emote. Lo llama client/Syncing.lua.
---
--- Lo elige Config.SyncOffsetSource: 'saved' (el fichero guardado y, en su
--- defecto, el .lua), 'pack' (siempre el .lua) o 'zero' (sin desplazamiento).
--- Ningun modo toca lo guardado, asi que se puede ir y volver. Sin la clave en
--- el config se comporta como 'saved', que es como era antes.
---@param emoteName string
---@param options table|nil AnimationOptions de la emote
---@return vector4
function GetSyncOffset(emoteName, options)
    local source = Config.SyncOffsetSource or 'saved'

    if source == 'zero' then
        return ZERO_OFFSET
    end

    if source ~= 'pack' then
        local o = overrides[emoteName]
        if o then
            return vector4(o.side, o.front, o.height, o.heading)
        end
    end

    return options and options.syncOffset or DEFAULT_OFFSET
end

RegisterNetEvent('dwkemotes:client:syncOffsets', function(list)
    if type(list) ~= 'table' then return end

    overrides = list

    local count = 0
    for _ in pairs(overrides) do count += 1 end
    DebugPrint(('[dwkemotes] %d SyncOffset override(s) recibidos del servidor'):format(count))
end)

RegisterNetEvent('dwkemotes:client:syncOffsetUpdated', function(emoteName, data)
    if type(emoteName) ~= 'string' then return end
    overrides[emoteName] = data -- nil borra el override
end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('dwkemotes:server:requestSyncOffsets')
end)

-- ─── Congelacion de la pareja ────────────────────────────────────────────────
--
-- Calibrar recoloca el ped una y otra vez pegado al de la pareja, y la colision
-- entre los dos los va empujando por el mapa: lo que se esta midiendo deja de
-- ser una distancia fija. Mientras dura el ajuste, la pareja se queda quieta.
--
-- Lo pide el editor y lo aplica el cliente congelado, porque cada quien manda
-- sobre su propio ped; congelarlo desde fuera no aguanta la sincronizacion.

-- Si el editor deja de dar señales (se desconecta, cierra el juego, un error),
-- la pareja se suelta sola. El editor renueva cada HEARTBEAT.
local FREEZE_TIMEOUT_MS <const> = 10000
local FREEZE_HEARTBEAT_MS <const> = 3000

local frozenBy = nil
local freezeExpiry = 0
local freezeWasApplied = false

local function releaseOffsetFreeze()
    if not frozenBy then return end
    frozenBy = nil

    -- Solo se descongela si fue este flujo quien congelo: si el jugador ya
    -- estaba quieto por otro script, soltarlo aqui seria pisarlo.
    if freezeWasApplied then
        FreezeEntityPosition(PlayerPedId(), false)
        freezeWasApplied = false
    end
end

RegisterNetEvent('dwkemotes:client:offsetFreeze', function(editorServerId, frozen)
    if not frozen then
        if frozenBy == editorServerId then releaseOffsetFreeze() end
        return
    end

    freezeExpiry = GetGameTimer() + FREEZE_TIMEOUT_MS
    if frozenBy then return end -- ya congelado, esto solo renovaba el plazo

    frozenBy = editorServerId

    local ped = PlayerPedId()
    if not IsEntityPositionFrozen(ped) then
        FreezeEntityPosition(ped, true)
        freezeWasApplied = true
    end

    SimpleNotify(Translate('offset_partner_frozen'))

    CreateThread(function()
        while frozenBy == editorServerId
            and GetGameTimer() < freezeExpiry
            and IsInAnimation
        do
            Wait(500)
        end

        if frozenBy == editorServerId then releaseOffsetFreeze() end
    end)
end)

-- ─── Bucle de edicion ────────────────────────────────────────────────────────

-- Movimiento, camara al hombro, ataque y entrada a vehiculo: el editor usa
-- WASD/QE/RF y no puede dejar que el ped se vaya andando mientras se ajusta.
local BLOCKED_CONTROLS <const> = {
    21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35,
    44, 45, 46, 49, 75, 140, 141, 142, 143, 194, 201, 202,
}

local function disableEditorControls()
    for _, control in ipairs(BLOCKED_CONTROLS) do
        DisableControlAction(0, control, true)
    end
end

local lastHint = nil

--- Los valores van escritos en la propia fila de teclas para poder leerlos sin
--- salir del editor. El bucle corre a Wait(0) pero el panel solo se reenvia
--- cuando alguno cambia.
local function drawHints(side, front, height, heading, coarse)
    local key = ('%.2f|%.2f|%.2f|%.1f|%s'):format(front, side, height, heading, tostring(coarse))
    if key == lastHint then return end
    lastHint = key

    ShowNuiHints({
        { keys = { 'W', 'S' },    label = ('%s  %.2f'):format(Translate('offset_front'), front) },
        { keys = { 'A', 'D' },    label = ('%s  %.2f'):format(Translate('offset_side'), side) },
        { keys = { 'R', 'F' },    label = ('%s  %.2f'):format(Translate('offset_height'), height) },
        { keys = { 'Q', 'E' },    label = ('%s  %.1f'):format(Translate('offset_heading'), heading) },
        { keys = { 'Shift' },     label = Translate(coarse and 'offset_step_coarse' or 'offset_step_fine') },
        { keys = { 'Enter' },     label = Translate('offset_save') },
        { keys = { 'Backspace' }, label = Translate('btn_back') },
    })
end

local function clamp(value, limit)
    if value > limit then return limit end
    if value < -limit then return -limit end
    return value
end

local function startEditor(emoteName, partnerServerId)
    editing = true
    lastHint = nil

    -- Se avisa al abrir, no al guardar: si el modo no es 'saved', lo que se
    -- calibre aqui no se vera aplicado despues, y sin el aviso parece que el
    -- editor no funciona.
    local offsetSource = Config.SyncOffsetSource or 'saved'
    if offsetSource ~= 'saved' then
        SimpleNotify(Translate('offset_overrides_off', offsetSource))
    end

    local options = SharedEmoteData[emoteName] and SharedEmoteData[emoteName].AnimationOptions
    local start = GetSyncOffset(emoteName, options)
    local side, front, height, heading = start.x, start.y, start.z, start.w

    CreateThread(function()
        -- Evita que el Enter que envio el comando cuente ya como "guardar".
        Wait(150)

        -- Recolocar el ped corta la reproduccion durante unos frames, y la
        -- vigilancia de Emote.lua lee eso como "la animacion ha terminado" y
        -- cancela la emote. Hay que pararla mientras dure el ajuste.
        SetAnimationWatchSuspended(true)
        DebugPrint(('[dwkemotes] editor de offsets abierto para %s (front %.2f, side %.2f, height %.2f, heading %.1f)')
            :format(emoteName, front, side, height, heading))

        -- La pareja se queda quieta mientras se calibra; si no, la colision
        -- entre los dos peds los va desplazando y la medida no vale.
        TriggerServerEvent('dwkemotes:server:offsetFreeze', partnerServerId, true)
        local nextHeartbeat = GetGameTimer() + FREEZE_HEARTBEAT_MS

        -- Y el propio ped tambien: congelado sigue admitiendo SetEntityCoords,
        -- que es como lo mueve el editor, pero ya no lo empuja nada mas.
        if not IsEntityPositionFrozen(PlayerPedId()) then
            FreezeEntityPosition(PlayerPedId(), true)
            editorFroze = true
        end

        -- En las emotes enganchadas el attach recoloca el ped cada frame y las
        -- teclas no moverian nada: se desengancha mientras se ajusta y se vuelve
        -- a enganchar al salir usando el transform del offset guardado.
        local detachedForEdit = false
        if options and options.Attachto then
            DetachEntity(PlayerPedId(), true, true)
            detachedForEdit = true
        end

        -- Vigilante aparte: en cuanto se deja de editar, el jugador se suelta
        -- aunque el cierre de mas abajo no llegue a ejecutarse.
        CreateThread(function()
            while editing do Wait(250) end
            releaseEditorFreeze()
        end)

        --- Coloca el ped donde dicen los cuatro valores, que es exactamente lo
        --- que hara Syncing.lua cuando la emote se lance de verdad.
        local function anchorTo(ped, partner, partnerHeading)
            local coords = GetOffsetFromEntityInWorldCoords(partner, side + 0.0, front + 0.0, height + 0.0)
            SetEntityHeading(ped, partnerHeading - heading + 0.0)
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)

            -- Mover la entidad puede haber cortado la pose; se relanza solo si
            -- de verdad dejo de sonar, para no reiniciarla en cada tecla.
            if not IsCurrentAnimationPlaying() then
                ReplayCurrentAnimation()
            end
        end

        -- Ultima colocacion aplicada. Solo se toca el ped cuando cambia algo
        -- (una tecla o el movimiento de la pareja): cuanto menos se mueva la
        -- entidad, menos se interrumpe la animacion.
        local lastAnchor = nil

        while editing do
            local ped = PlayerPedId()
            local partner = GetPlayerPed(GetPlayerFromServerId(partnerServerId))

            -- La emote pudo terminar por cualquier via (cancelacion, ragdoll, el
            -- otro jugador se fue): el editor no puede quedarse colgado.
            if not IsInAnimation or partner == ped or not DoesEntityExist(partner) then
                editing = false
                DebugPrint(('[dwkemotes] editor de offsets cerrado: inAnim=%s partnerOk=%s'):format(
                    tostring(IsInAnimation), tostring(partner ~= ped and DoesEntityExist(partner))))
                SimpleNotify(Translate('offset_emote_ended'), 'error')
                break
            end

            disableEditorControls()

            -- La pareja esta congelada, pero su ped sigue teniendo colision: sin
            -- esto, al recolocarnos encima somos nosotros los que salimos
            -- despedidos. Con thisFrameOnly la colision vuelve sola al salir.
            SetEntityNoCollisionEntity(ped, partner, true)

            if GetGameTimer() >= nextHeartbeat then
                nextHeartbeat = GetGameTimer() + FREEZE_HEARTBEAT_MS
                TriggerServerEvent('dwkemotes:server:offsetFreeze', partnerServerId, true)
            end

            local coarse = IsDisabledControlPressed(0, 21) -- Shift

            -- El panel se pinta antes de tocar el ped, para que este en pantalla
            -- aunque la colocacion falle.
            drawHints(side, front, height, heading, coarse)

            local step = coarse and STEP_COARSE or STEP_FINE
            local stepHeading = coarse and STEP_HEADING_COARSE or STEP_HEADING_FINE

            if IsDisabledControlPressed(0, 32) then     -- W
                front = clamp(front + step, LIMIT_HORIZONTAL)
            elseif IsDisabledControlPressed(0, 33) then -- S
                front = clamp(front - step, LIMIT_HORIZONTAL)
            elseif IsDisabledControlPressed(0, 34) then -- A
                side = clamp(side - step, LIMIT_HORIZONTAL)
            elseif IsDisabledControlPressed(0, 35) then -- D
                side = clamp(side + step, LIMIT_HORIZONTAL)
            elseif IsDisabledControlPressed(0, 45) then -- R
                height = clamp(height + step, LIMIT_VERTICAL)
            elseif IsDisabledControlPressed(0, 49) then -- F
                height = clamp(height - step, LIMIT_VERTICAL)
            elseif IsDisabledControlPressed(0, 44) then -- Q
                heading = (heading + stepHeading) % 360
            elseif IsDisabledControlPressed(0, 46) then -- E
                heading = (heading - stepHeading) % 360
            elseif IsDisabledControlJustPressed(0, 18) then -- Enter
                editing = false

                -- El override se aplica ya en local, sin esperar la vuelta del
                -- servidor: en ese hueco el reanclaje de client/Syncing.lua leeria
                -- todavia el offset anterior y devolveria el ped al sitio de
                -- antes, deshaciendo en pantalla lo que se acaba de calibrar. El
                -- evento del servidor luego solo confirma lo mismo.
                overrides[emoteName] = { side = side, front = front, height = height, heading = heading }

                TriggerServerEvent('dwkemotes:server:saveSyncOffset', emoteName, side, front, height, heading)
                break
            elseif IsDisabledControlJustPressed(0, 194) then -- Backspace
                editing = false
                SimpleNotify(Translate('offset_cancelled'))
                break
            end

            -- La colocacion es siempre relativa a la pareja, igual que hace
            -- Syncing.lua al arrancar la emote: si ella se mueve, hay que
            -- reanclar para que lo que se ve sea lo que quedara guardado.
            local partnerCoords = GetEntityCoords(partner)
            local partnerHeading = GetEntityHeading(partner)
            local anchor = ('%.2f|%.2f|%.2f|%.1f|%.2f|%.2f|%.2f|%.1f'):format(
                side, front, height, heading,
                partnerCoords.x, partnerCoords.y, partnerCoords.z, partnerHeading)

            if anchor ~= lastAnchor then
                lastAnchor = anchor
                anchorTo(ped, partner, partnerHeading)
            end

            Wait(0)
        end

        -- Soltar va primero, siempre. Si fuese detras del anclaje y este fallara,
        -- el jugador se quedaria clavado sin forma de recuperarse.
        releaseEditorFreeze()
        TriggerServerEvent('dwkemotes:server:offsetFreeze', partnerServerId, false)

        -- Se sale del bucle sin haber colocado el ped en el frame del Enter, asi
        -- que se ancla una ultima vez: lo que queda en pantalla tiene que ser
        -- exactamente lo que se acaba de guardar. Descongelar justo antes no lo
        -- estropea porque entre las dos cosas no pasa ningun frame.
        local ped = PlayerPedId()
        local partner = GetPlayerPed(GetPlayerFromServerId(partnerServerId))
        if IsInAnimation and DoesEntityExist(partner) and partner ~= ped then
            if detachedForEdit then
                -- Reenganche con el transform recien guardado: lo que queda en
                -- pantalla y lo que vera un tercero son lo mismo.
                local pos, rot, boneIndex = GetAttachTransform(emoteName, options, partner)
                AttachEntityToEntity(
                    ped,
                    partner,
                    boneIndex,
                    pos.x,
                    pos.y,
                    pos.z,
                    rot.x,
                    rot.y,
                    rot.z,
                    false,
                    false,
                    false,
                    true,
                    1,
                    true
                )
            else
                anchorTo(ped, partner, GetEntityHeading(partner))
            end
        end

        SetAnimationWatchSuspended(false)
        HideNuiHints()
        lastHint = nil
    end)
end

-- ─── Comando ─────────────────────────────────────────────────────────────────

RegisterNetEvent('dwkemotes:client:offsetEditorReply', function(allowed)
    if not allowed then
        return SimpleNotify(Translate('offset_no_permission'), 'error')
    end

    -- Se vuelve a comprobar al volver del servidor: entre la ida y la vuelta la
    -- emote puede haber terminado.
    local emoteName, partnerServerId, isSource = GetActiveSharedSync()
    if not emoteName or not partnerServerId or not isSource or not IsInAnimation then
        return SimpleNotify(Translate('offset_no_emote'), 'error')
    end

    startEditor(emoteName, partnerServerId)
end)

RegisterNetEvent('dwkemotes:client:syncOffsetSaved', function(emoteName, data)
    overrides[emoteName] = data
    SimpleNotify(Translate('offset_saved', emoteName), 'success')
end)

RegisterCommand('emoteoffset', function()
    if not Config.OffsetEditorEnabled then return end

    if editing then
        return SimpleNotify(Translate('offset_already_editing'), 'error')
    end

    local emoteName, _, isSource = GetActiveSharedSync()
    if not emoteName or not IsInAnimation then
        return SimpleNotify(Translate('offset_no_emote'), 'error')
    end

    -- Solo el iniciador se recoloca con el offset; al otro lado no hay nada que
    -- ajustar y dejarle mover el ped solo desalinearia la pose.
    if not isSource then
        return SimpleNotify(Translate('offset_not_source'), 'error')
    end

    -- El permiso lo decide el servidor, que es quien despues acepta o rechaza el
    -- guardado: asi el gate vive en un solo sitio.
    TriggerServerEvent('dwkemotes:server:openOffsetEditor')
end, false)

CreateExport('GetSyncOffset', GetSyncOffset)
