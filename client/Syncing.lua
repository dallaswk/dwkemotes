local isRequestAnim = false
local targetPlayerId

-- Datos de la shared emote en curso, para el editor de offsets (/emoteoffset).
-- Solo quien la inicia se recoloca con el SyncOffset, asi que hay que saber si
-- somos ese lado: el otro no tiene nada que ajustar.
local activeSharedEmote = nil
local activeSharedIsSource = false

--- @return string|nil emote, number|nil partnerServerId, boolean isSource
function GetActiveSharedSync()
    return activeSharedEmote, targetPlayerId, activeSharedIsSource
end

-- ─── No-colision de la pareja, en TODOS los clientes ─────────────────────────
--
-- Dos peds en una pose de pareja se solapan por definicion, y la colision entre
-- ellos los empuja hasta sacarlos de la pose: se separan solos y, si la pose
-- deja a uno dentro del otro, salen andando por el mapa.
--
-- SetEntityNoCollisionEntity solo toca el mundo local de quien lo llama, asi que
-- si lo piden unicamente los dos participantes, cualquier otro jugador ve dos
-- peds clonados chocando entre si: su motor los empuja para separarlos y la
-- correccion de red los vuelve a juntar. La pose se ve temblando y desalineada
-- aunque el SyncOffset sea correcto, y de ahi que los dos de la pose la vean
-- bien y un tercero no.
--
-- Cada lado publica con quien esta emparejado en su state bag; todos los
-- clientes leen esas parejas y aplican la no-colision en su propio mundo.
--
-- Se pide cada frame con thisFrameOnly, asi la colision vuelve sola en cuanto la
-- pareja desaparece del registro y no hay nada que restaurar si el hilo muere.

local SHARED_PARTNER_KEY <const> = 'sharedEmotePartner'

---@type table<number, number> serverId de quien declara -> serverId de su pareja
local sharedPairs = {}
local sharedPairCount = 0
local sharedCollisionRunning = false

--- Al cargar el recurso el jugador puede no estar activo todavia y el serverId
--- salir -1, asi que se resuelve la primera vez que hace falta y se guarda.
local localServerId = nil

local function getLocalServerId()
    if not localServerId or localServerId <= 0 then
        localServerId = GetPlayerServerId(PlayerId())
    end
    return localServerId
end

--- Un solo hilo para todas las parejas del mundo, no uno por pareja: mientras no
--- haya ninguna registrada no corre nada. Por pareja son dos natives por frame,
--- y las que estan fuera del scope no tienen ped clonado y se saltan enteras.
local function runSharedCollisionThread()
    if sharedCollisionRunning then return end
    if not Config.SharedEmoteNoCollision then return end
    sharedCollisionRunning = true

    CreateThread(function()
        while sharedPairCount > 0 do
            for declarer, partner in pairs(sharedPairs) do
                -- GetPlayerPed(-1) devuelve el ped LOCAL, asi que el indice hay
                -- que comprobarlo antes: quien esta fuera del scope da -1 y
                -- pedirle el ped desactivaria la colision del jugador de aqui
                -- contra un ped que no viene al caso.
                local plyA = GetPlayerFromServerId(declarer)
                local plyB = GetPlayerFromServerId(partner)
                local pedA = plyA >= 0 and GetPlayerPed(plyA) or 0
                local pedB = plyB >= 0 and GetPlayerPed(plyB) or 0

                if pedA ~= 0 and pedB ~= 0 and pedA ~= pedB
                    and DoesEntityExist(pedA) and DoesEntityExist(pedB)
                then
                    -- En los dos sentidos: el otro lado puede no haber publicado
                    -- todavia su mitad de la pareja.
                    SetEntityNoCollisionEntity(pedA, pedB, true)
                    SetEntityNoCollisionEntity(pedB, pedA, true)
                end
            end

            Wait(0)
        end

        sharedCollisionRunning = false
    end)
end

---@param declarerServerId number
---@param partnerServerId number|nil nil borra la pareja
local function setSharedPair(declarerServerId, partnerServerId)
    local had = sharedPairs[declarerServerId] ~= nil

    if partnerServerId then
        sharedPairs[declarerServerId] = partnerServerId
        if not had then sharedPairCount += 1 end
        runSharedCollisionThread()
    elseif had then
        sharedPairs[declarerServerId] = nil
        sharedPairCount -= 1
    end
end

local sharedPairGuardRunning = false

--- La pareja propia no puede quedarse publicada si la pose nunca llego a
--- arrancar (OnEmotePlay se corta por cooldown, ped ocupado, permisos) o si
--- termino por una via que no pasa por EmoteCancel: el registro se quedaria fijo
--- y esos dos peds dejarian de chocar para siempre, en todos los clientes.
---
--- Un solo hilo, a 1 s, y solo mientras hay pareja propia publicada.
local function runSharedPairGuard()
    if sharedPairGuardRunning then return end
    sharedPairGuardRunning = true

    CreateThread(function()
        -- Margen para que OnEmotePlay levante la animacion.
        Wait(1000)

        while sharedPairs[getLocalServerId()] do
            if not activeSharedEmote or not IsInAnimation then
                LocalPlayer.state:set(SHARED_PARTNER_KEY, nil, true)
                setSharedPair(getLocalServerId(), nil)
                DebugPrint('[dwkemotes] pareja compartida sin emote activa: registro liberado')
                break
            end

            Wait(1000)
        end

        sharedPairGuardRunning = false
    end)
end

--- Publica la pareja propia y la registra en local. La entrada local se pone a
--- mano en vez de esperar el eco del state bag: hay que tenerla aplicada en el
--- mismo frame en que el ped se coloca encima de la pareja.
---@param partnerServerId number|nil
local function publishSharedPair(partnerServerId)
    local serverId = getLocalServerId()

    -- Borrar cuando ya no hay pareja no escribe nada: CancelSharedEmote entra
    -- aqui al cancelar cualquier emote, no solo las compartidas, y no vale la
    -- pena replicar un nil sobre un nil.
    if not partnerServerId and not sharedPairs[serverId] then return end

    LocalPlayer.state:set(SHARED_PARTNER_KEY, partnerServerId, true)
    setSharedPair(serverId, partnerServerId)

    if partnerServerId then runSharedPairGuard() end
end

-- El serverId sale del nombre de la bag y no de GetPlayerFromStateBagName, que
-- devuelve 0 para quien esta fuera del scope: asi la pareja queda registrada
-- aunque sus peds no esten clonados todavia, y el hilo la salta hasta que lo
-- esten.
AddStateBagChangeHandler(SHARED_PARTNER_KEY, nil, function(bagName, _, value)
    local serverId = tonumber(bagName:match('^player:(%d+)$'))
    if not serverId then return end

    -- La propia pareja la lleva publishSharedPair; un nil replicado con retraso
    -- no puede borrar un registro que se acaba de poner.
    if serverId == getLocalServerId() then return end

    setSharedPair(serverId, type(value) == 'number' and value or nil)
end)

-- ─── Reanclaje del lado que inicia la pose ───────────────────────────────────
--
-- Quien inicia se coloca junto a su pareja con SetEntityCoordsNoOffset, una sola
-- vez y en el mismo frame en que arranca la animacion. Eso basta en su propia
-- pantalla, pero no en las demas: los clones remotos reciben la task de
-- animacion y anclan ahi el mover del ped, y como un ped en pose no se mueve,
-- casi no recibe actualizaciones de posicion, asi que la correccion de red no
-- llega a cerrar el hueco. El resultado es que el iniciador se ve bien a si
-- mismo y todos los demas lo ven donde estaba antes de recolocarse: los
-- observadores coinciden entre si y solo discrepan del propietario del ped.
--
-- Dos medidas, las dos en el cliente del iniciador y ninguna con coste en el
-- servidor:
--   1. Entre colocar el ped y lanzar el clip se deja pasar un tick de red, para
--      que la posicion nueva llegue a los clones ANTES que la animacion.
--   2. Mientras dura la pose se comprueba la desviacion dos veces por segundo y
--      solo se recoloca si se ha salido de la tolerancia.

--- Margen para que la posicion nueva salga por la red antes que la task.
local ANCHOR_SETTLE_MS <const> = 150

local ANCHOR_CHECK_MS <const> = 500
local ANCHOR_TOLERANCE <const> = 0.02
local ANCHOR_HEADING_TOLERANCE <const> = 1.0

--- Coloca el ped donde dicen los cuatro numeros del offset, relativo a la
--- pareja. Es la misma cuenta que hace el editor de offsets.
local function anchorSourcePed(ped, partner, offset)
    local coords = GetOffsetFromEntityInWorldCoords(partner, offset.x + 0.0, offset.y + 0.0, offset.z + 0.0)
    SetEntityHeading(ped, GetEntityHeading(partner) - offset.w + 0.0)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)
end

--- Un contador en vez de un booleano de "ya corre": si se lanza otra pose, el
--- hilo anterior tiene que morir y el nuevo arrancar siempre. Con un booleano,
--- relanzar una pose con la misma pareja dejaba al hilo viejo vivo unos cientos
--- de milisegundos e impedia arrancar el bueno, y la pose se quedaba sin
--- vigilancia.
local anchorGeneration = 0

---@param emoteName string
---@param partnerServerId number
---@param options table|nil AnimationOptions de la emote
local function runSourceAnchorThread(emoteName, partnerServerId, options)
    anchorGeneration += 1
    local generation = anchorGeneration

    CreateThread(function()
        while generation == anchorGeneration
            and activeSharedEmote == emoteName
            and activeSharedIsSource
            and targetPlayerId == partnerServerId
            and IsInAnimation
        do
            local ply = GetPlayerFromServerId(partnerServerId)
            local partner = ply >= 0 and GetPlayerPed(ply) or 0
            local ped = PlayerPedId()

            -- El editor de offsets coloca el ped a mano frame a frame: mientras
            -- este abierto, aqui no se toca nada.
            local editorOpen = IsOffsetEditorActive and IsOffsetEditorActive()

            if not editorOpen and partner ~= 0 and partner ~= ped and DoesEntityExist(partner) then
                -- El offset se relee en cada pasada y no se captura al arrancar:
                -- asi, si se acaba de guardar uno nuevo con /emoteoffset, el
                -- reanclaje respeta ese y no devuelve el ped al anterior.
                local offset = GetSyncOffset(emoteName, options)

                local target = GetOffsetFromEntityInWorldCoords(partner,
                    offset.x + 0.0, offset.y + 0.0, offset.z + 0.0)
                local wantedHeading = GetEntityHeading(partner) - offset.w

                -- Diferencia de rumbo por el camino corto, para que 359 y 1 no
                -- salgan a 358 grados.
                local headingDelta = math.abs((GetEntityHeading(ped) - wantedHeading + 180.0) % 360.0 - 180.0)

                if #(GetEntityCoords(ped) - target) > ANCHOR_TOLERANCE
                    or headingDelta > ANCHOR_HEADING_TOLERANCE
                then
                    anchorSourcePed(ped, partner, offset)
                end
            end

            Wait(ANCHOR_CHECK_MS)
        end
    end)
end

if Config.SharedEmotesEnabled then
    RegisterCommand('nearby', function(source, args, raw)
        if not LocalPlayer.state.canEmote then return end
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            return EmoteChatMessage(Translate('not_in_a_vehicle'))
        end

        if #args > 0 then
            local emotename = string.lower(args[1])
            local target, distance = GetClosestPlayer()
            if (distance ~= -1 and distance < 3) then
                local emote = SharedEmoteData[emotename]
                if emote ~= nil then
                    TriggerServerEvent("dwkemotes:server:requestEmote", GetPlayerServerId(target), emotename)
                    SimpleNotify(Translate('sentrequestto') ..
                        GetPlayerName(target) .. " ~w~(~g~" .. emote.label .. "~w~)")
                else
                    EmoteChatMessage("'" .. emotename .. "' " .. Translate('notvalidsharedemote') .. "")
                end
            else
                SimpleNotify(Translate('nobodyclose'))
            end
        else
            NearbysOnCommand()
        end
    end, false)
end

RegisterNetEvent("dwkemotes:client:syncEmote", function(emote, player)
    EmoteCancel()
    Wait(300)
    targetPlayerId = player
    activeSharedEmote = emote
    activeSharedIsSource = false

    -- Antes de que la pareja se coloque encima: la no-colision tiene que estar
    -- pedida ya cuando los dos peds empiecen a solaparse.
    publishSharedPair(player)

    local plyServerId = GetPlayerFromServerId(player)

    if IsPedInAnyVehicle(GetPlayerPed(plyServerId ~= 0 and plyServerId or GetClosestPlayer()), true) then
        return EmoteChatMessage(Translate('not_in_a_vehicle'))
    end

    local emoteData = SharedEmoteData[emote]
    if not emoteData then
        DebugPrint("dwkemotes:client:syncEmote : Emote not found")
        return
    end

    local options = emoteData.AnimationOptions
    if options and options.Attachto then
        local targetEmote = emoteData.secondPlayersAnim
        if not targetEmote
            or not SharedEmoteData[targetEmote]
            or not SharedEmoteData[targetEmote].AnimationOptions
            or not SharedEmoteData[targetEmote].AnimationOptions.Attachto
        then
            local ped = PlayerPedId()
            local pedInFront = GetPlayerPed(plyServerId ~= 0 and plyServerId or GetClosestPlayer())

            AttachEntityToEntity(
                ped,
                pedInFront,
                GetPedBoneIndex(pedInFront, options.bone or -1),
                options.pos.x,
                options.pos.y,
                options.pos.z,
                options.rot.x,
                options.rot.y,
                options.rot.z,
                false,
                false,
                false,
                true,
                1,
                true
            )
        end
    end

    OnEmotePlay(emote, nil, EmoteType.SHARED)
end)

RegisterNetEvent("dwkemotes:client:syncEmoteSource", function(emote, player)
    local ped = PlayerPedId()
    local plyServerId = GetPlayerFromServerId(player)
    local pedInFront = GetPlayerPed(plyServerId ~= 0 and plyServerId or GetClosestPlayer())

    if IsPedInAnyVehicle(ped, true) or IsPedInAnyVehicle(pedInFront, true) then
        return EmoteChatMessage(Translate('not_in_a_vehicle'))
    end

    local emoteData = SharedEmoteData[emote]
    local options = emoteData and emoteData.AnimationOptions

    -- Cancelar va PRIMERO. Antes se colocaba el ped junto a la pareja y se
    -- cancelaba despues, asi que entre el ClearPedTasks de EmoteCancel y el
    -- arranque de la pose quedaban 300 ms con los dos peds ya solapados y con
    -- colision: se empujaban, el empujon lo replicaba el propietario y la pose
    -- arrancaba desalineada para todo el mundo, sin que nada la volviese a
    -- colocar. Ahora el ped solo se mueve cuando ya nada puede empujarlo.
    EmoteCancel()
    Wait(300)

    -- Los peds se releen: EmoteCancel y el Wait dejan pasar frames y el ped pudo
    -- cambiar por el camino.
    ped = PlayerPedId()
    pedInFront = GetPlayerPed(GetPlayerFromServerId(player))
    if not DoesEntityExist(pedInFront) or pedInFront == ped then
        pedInFront = GetPlayerPed(GetClosestPlayer())
    end

    if not DoesEntityExist(pedInFront) or pedInFront == ped then
        DebugPrint("dwkemotes:client:syncEmoteSource : ped de la pareja no disponible")
        return
    end

    targetPlayerId = player
    activeSharedEmote = emote
    activeSharedIsSource = true

    -- La no-colision se pide ANTES de solaparse, no despues: el hilo hace su
    -- primera pasada de forma sincrona, dentro de este mismo frame.
    publishSharedPair(player)

    if options and options.Attachto then
        AttachEntityToEntity(
            ped,
            pedInFront,
            GetPedBoneIndex(pedInFront, options.bone or -1),
            options.pos.x,
            options.pos.y,
            options.pos.z,
            options.rot.x,
            options.rot.y,
            options.rot.z,
            false,
            false,
            false,
            true,
            1,
            true
        )
    end

    local offset = GetSyncOffset(emote, options)
    anchorSourcePed(ped, pedInFront, offset)

    -- Un tick de red entre colocar el ped y lanzar el clip: si la task de
    -- animacion llega a los otros clientes antes que la posicion nueva, sus
    -- clones anclan la pose donde el ped estaba y ya no la mueven de ahi.
    Wait(ANCHOR_SETTLE_MS)

    -- De pie y sin task, el ped ha podido resbalar o caer en esos milisegundos,
    -- asi que se vuelve a colocar antes de arrancar la pose.
    ped = PlayerPedId()
    if not DoesEntityExist(pedInFront) or pedInFront == ped then
        DebugPrint("dwkemotes:client:syncEmoteSource : la pareja se fue antes de arrancar")
        return
    end

    anchorSourcePed(ped, pedInFront, offset)

    if emoteData ~= nil then
        OnEmotePlay(emote, nil, EmoteType.SHARED)

        -- Y a partir de aqui, vigilancia a 2 Hz: el clip de un clon remoto puede
        -- arrastrar el mover, y la pareja puede moverse.
        runSourceAnchorThread(emote, player, options)
    end
end)

RegisterNetEvent("dwkemotes:client:cancelEmote", function(player)
    if targetPlayerId and targetPlayerId == player then
        targetPlayerId = nil
        activeSharedEmote = nil
        activeSharedIsSource = false
        publishSharedPair(nil)
        EmoteCancel()
    end
end)

function CancelSharedEmote()
    activeSharedEmote = nil
    activeSharedIsSource = false
    publishSharedPair(nil)
    if targetPlayerId then
        TriggerServerEvent("dwkemotes:server:cancelEmote", targetPlayerId)
        targetPlayerId = nil
    end
end

RegisterNetEvent("dwkemotes:client:requestEmote", function(emotename, target)
    isRequestAnim = true

    local emote = SharedEmoteData[emotename]
    PlaySound(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", false, 0, true)
    SimpleNotify(Translate('doyouwanna') .. emote.label .. "~w~)")
    -- The player has now 10 seconds to accept the request
    local timer = 10 * 1000
    while isRequestAnim do
        Wait(5)
        timer = timer - 5
        if timer <= 0 then
            isRequestAnim = false
            SimpleNotify(Translate('refuseemote'))
        end

        if IsControlJustPressed(1, 246) then
            isRequestAnim = false

            local otheremote = emote and emote.secondPlayersAnim or emotename
            TriggerServerEvent("dwkemotes:server:confirmEmote", target, emotename, otheremote)
        elseif IsControlJustPressed(1, 182) then
            isRequestAnim = false
            SimpleNotify(Translate('refuseemote'))
        end
    end
end)
