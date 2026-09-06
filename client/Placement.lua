-- The movement amounts when placing preview ped
local SMALL_CHANGE_AMOUNT = 0.01
local LARGE_CHANGE_AMOUNT = 2.5

-- Cuanto puede despegarse del suelo la ped con R / F. Configurable porque el
-- tope de antes (0.3 arriba) se quedaba corto para colocar sobre mobiliario.
local MAX_HEIGHT_UP = Config.PlacementMaxHeightUp or 0.3
local MAX_HEIGHT_DOWN = Config.PlacementMaxHeightDown or 0.5

local placementState = PlacementState.NONE
---@type vector4
local placementPosition
---@type vector3
local placementRotation
---@type vector3
local positionPriorToPlacement = vector3(0)
---@type boolean
local placementFrozePlayer = false -- true if the last placement emote caused the player to froze.

local previewPed
local menuBeforePlacement = nil
local placementOptions = nil

local function checkForCollidingEntities(ped)
    local pedPosition = GetEntityCoords(ped)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        pedPosition.x, pedPosition.y, pedPosition.z,
        pedPosition.x, pedPosition.y, pedPosition.z - 2,
        2, -- Check for vehicles only.
        ped, 7
    )

    local _, hit, _, _, hitEntity = GetShapeTestResult(ray)

    return hit, hitEntity
end

local function checkCollisionsWhileInAnimation()
    CreateThread(function()
        while placementState == PlacementState.IN_ANIMATION do
            local ped = PlayerPedId()

            -- Basic collision checks for vehicles and peds
            local anyCollision, collidingEntity = checkForCollidingEntities(ped)

            if anyCollision then
                if collidingEntity and IsModelAVehicle(GetEntityModel(collidingEntity)) then
                    -- Allow emotes on *stationary* vehicles
                    if not IsVehicleStopped(collidingEntity) then
                        EmoteCancel()
                    end
                -- Ped collided with another ped or a ragdoll
                else
                    EmoteCancel()
                end
            end

            Wait(0)
        end
    end)
end

local function resetStoredPlacementValues()
    placementState = PlacementState.NONE
    placementPosition = vector4(0)
    placementRotation = vector3(0)
    positionPriorToPlacement = vector3(0)
    placementFrozePlayer = false
    placementOptions = nil
end

local function anyMovementControlsPressed()
    return
        IsControlJustPressed(0, 32) or -- W
        IsControlJustPressed(0, 33) or -- S
        IsControlJustPressed(0, 34) or -- A
        IsControlJustPressed(0, 35)    -- D
end

local function walkPedToPlacementPosition(emoteName)
    local anyMovementInput = false
    local playerPed = PlayerPedId()
    local timeout = GetGameTimer() + 5000

    TaskGoStraightToCoord(playerPed, placementPosition.x, placementPosition.y, placementPosition.z, 1, -1, placementPosition.w, 0)

    while timeout > GetGameTimer() and GetScriptTaskStatus(playerPed, "SCRIPT_TASK_GO_STRAIGHT_TO_COORD") ~= 7 and #(GetEntityCoords(playerPed) - placementPosition.xyz) > 1 and not anyMovementInput do
        anyMovementInput = anyMovementControlsPressed()
        Wait(0)
    end

    local latestPedPosition = GetEntityCoords(playerPed)
    local distanceToPlacementPosition = #(latestPedPosition - placementPosition.xyz)

    if anyMovementInput or distanceToPlacementPosition > 1.5 or GetGameTimer() > timeout then
        ClearPedTasks(playerPed)
        resetStoredPlacementValues()
        return
    end

    positionPriorToPlacement = latestPedPosition

    SetEntityCoordsNoOffset(playerPed, placementPosition.x, placementPosition.y, placementPosition.z, false, false, false)
    SetEntityRotation(playerPed, placementRotation.x, placementRotation.y, placementRotation.z, 2, false)
    SetEntityHeading(playerPed, placementPosition.w)

    placementState = PlacementState.IN_ANIMATION

    TriggerServerEvent("dwkemotes:server:syncHeading", placementPosition.w)
    OnEmotePlay(emoteName)
    if not IsEntityPositionFrozen() then
        -- Only freeze the player if not already frozen by another script.
        -- This will prevent rpemotes from removing player freezing, when not needed to.
        FreezeEntityPosition(playerPed, true) -- Freeze player briefly to prevent initial fall
        placementFrozePlayer = true

        -- Unfreeze after one frame to restore collision
        CreateThread(function()
            Wait(0)
            FreezeEntityPosition(playerPed, false)
        end)
    end
    checkCollisionsWhileInAnimation()
end

local function disableControls()
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 46, true)
    DisableControlAction(0, 49, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 201, true)
end

-- Los atajos de la colocacion se dibujan en la NUI (ShowNuiHints) en vez de con
-- el cuadro de ayuda nativo, que lo pinta el motor y no admite el sistema de
-- diseno. Las teclas van escritas porque el panel es HTML y no puede resolver
-- los glifos `~INPUT_*~`; corresponden a los controles que lee el bucle de
-- colocacion mas abajo (32/33/34/35, 44/46, 45/49, 18 y 194).
local PLACEMENT_HINTS <const> = {
    { keys = { 'W', 'S', 'A', 'D' }, label = 'position' },
    { keys = { 'Q', 'E' },           label = 'rotate' },
    { keys = { 'R', 'F' },           label = 'height' },
    { keys = { 'Enter' },            label = 'btn_select', onlyWhenValid = true },
    { keys = { 'Backspace' },        label = 'btn_back' },
}

--- Ultimo estado enviado a la NUI. El bucle de colocacion corre a Wait(0), pero
--- el panel no necesita repintarse en cada vuelta: solo se manda si cambia.
local lastHintState = nil

--- @param state 'valid'|'invalid'|nil  nil oculta el panel
local function setPlacementHints(state)
    if placementOptions and placementOptions.suppressHelpText then state = nil end
    if state == lastHintState then return end
    lastHintState = state

    if not state then
        HideNuiHints()
        return
    end

    local valid = state == 'valid'
    local rows = {}
    for _, hint in ipairs(PLACEMENT_HINTS) do
        -- Sin una posicion valida no se puede confirmar: no se ofrece la tecla.
        if valid or not hint.onlyWhenValid then
            rows[#rows + 1] = { keys = hint.keys, label = Translate(hint.label) }
        end
    end

    ShowNuiHints(rows, not valid and Translate('invalidposition') or nil)
end

local distanceWarningShown = false

local function showDistanceWarning()
    if not distanceWarningShown then
        SimpleNotify(Translate('toofar'))
        distanceWarningShown = true
    end
end

local function resetDistanceWarning()
    distanceWarningShown = false
end

--- Check if a position is valid for ped placement (not inside geometry/furniture)
---@param position vector3 The position to validate
---@param playerPosition vector3 The player's current position
---@return boolean isValid True if position is safe for placement
local function isPositionValidForPlacement(position, playerPosition)
    -- Check 1: Valid ground exists
    local _, isOnGround = GetGroundZFor_3dCoord(position.x, position.y, position.z + 1.0, false)
    if not isOnGround then
        return false
    end

    -- Check 2: Line of sight from player to target (walls, doors, glass)
    local playerEyePos = vector3(playerPosition.x, playerPosition.y, playerPosition.z + 0.7)
    local targetCheckPos = vector3(position.x, position.y, position.z + 0.5)

    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        playerEyePos.x, playerEyePos.y, playerEyePos.z,
        targetCheckPos.x, targetCheckPos.y, targetCheckPos.z,
        81, -- World (1) + Objects (16) + Glass (64)
        PlayerPedId(), 4
    )

    local _, hit, _, _, _ = GetShapeTestResult(ray)
    if hit then
        return false
    end

    -- Check 3: Downward raycast for furniture
    local abovePos = vector3(position.x, position.y, position.z + 2.0)
    local belowPos = vector3(position.x, position.y, position.z - 0.5)

    local downRay = StartExpensiveSynchronousShapeTestLosProbe(
        abovePos.x, abovePos.y, abovePos.z,
        belowPos.x, belowPos.y, belowPos.z,
        16, -- Objects only
        PlayerPedId(), 4
    )

    local _, hitDown, hitPosDown, _, _ = GetShapeTestResult(downRay)
    if hitDown then
        local hitHeight = hitPosDown.z - position.z
        if hitHeight > 0.1 and hitHeight < 1.8 then
            return false
        end
    end

    return true
end

local function rotationToDirection(rotation)
    local rotZ = math.rad(rotation.z)
    local rotX = math.rad(rotation.x)
    local multXY = math.abs(math.cos(rotX))

    return vector3(-math.sin(rotZ) * multXY, math.cos(rotZ) * multXY, math.sin(rotX))
end

local function preparePreviewPed(startPosition, emoteName)
    SetEntityAlpha(previewPed, 150, false)
    FreezeEntityPosition(previewPed, true)
    SetEntityRotation(previewPed, 0, 0, 0, 2, false)
    SetEntityCoords(previewPed, startPosition.x, startPosition.y, startPosition.z - 50, false, false, false, false)
    EmotePlayOnNonPlayerPed(previewPed, emoteName)
end

--- Get the appropriate height offset for a ped model
--- Human peds need ~1.0 offset, animals need less based on their size
---@param ped integer The ped to check
---@return number heightOffset The Z offset to apply
local function getPedHeightOffset(ped)
    if IsPedHuman(ped) then
        return 1.0
    end

    -- For non-human peds, use a smaller offset
    -- Animals are generally closer to the ground
    return 0.5
end

local function positionPreviewPed(emoteName)
    local playerPed = PlayerPedId()
    local playerPedPosition = GetEntityCoords(playerPed)

    local rotateAmount = 0
    local upDownOffset = 0
    local moveForwardBack = 0
    local moveLeftRight = 0
    local initHeading = GetEntityHeading(playerPed) + 180
    local previewPedHidden = false
    local isPlacementValid = true

    -- Get the appropriate height offset for this ped type
    local pedHeightOffset = getPedHeightOffset(playerPed)

    preparePreviewPed(vector3(playerPedPosition.x, playerPedPosition.y, playerPedPosition.z - 50), emoteName)

    -- Prevents TP abuse to 0,0,0
    placementPosition = vector4(playerPedPosition.x, playerPedPosition.y, playerPedPosition.z, initHeading)

    -- Prevents enter key being 'pressed' again by the prior key press
    Wait(100)

    CreateThread(function()
        while placementState == PlacementState.PREVIEWING do
            local cameraPosition = GetGameplayCamCoord()
            local cameraRotation = GetGameplayCamRot(2)
            local direction = rotationToDirection(cameraRotation)
            local destination = cameraPosition + (direction * 1000)

            local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(
                cameraPosition.x, cameraPosition.y, cameraPosition.z,
                destination.x, destination.y, destination.z,
                1 + 2 + 16, -- World, Vehicles, & Props
                playerPed, 7
            )
            local _, hit, hitPosition, _, _ = GetShapeTestResult(rayHandle)

            if hit then
                -- Use dynamic height offset based on ped type instead of hardcoded +1
                local targetPosition = vector3(hitPosition.x + moveForwardBack, hitPosition.y + moveLeftRight, hitPosition.z + pedHeightOffset + upDownOffset)
                local distanceFromPedToTarget = #(targetPosition - playerPedPosition)

                playerPedPosition = GetEntityCoords(playerPed)

                if distanceFromPedToTarget <= 5 then
                    resetDistanceWarning()

                    -- Validate position - check ground exists and line of sight from player isn't blocked
                    local isValid = isPositionValidForPlacement(targetPosition, playerPedPosition)

                    if isValid then
                        isPlacementValid = true

                        if previewPedHidden then
                            previewPedHidden = false
                        end
                        SetEntityAlpha(previewPed, 150, false)

                        placementPosition = vector4(targetPosition.x, targetPosition.y, targetPosition.z, initHeading + rotateAmount)
                        placementRotation = GetEntityRotation(previewPed)

                        SetEntityHeading(previewPed, initHeading + rotateAmount)
                        SetEntityCoords(previewPed, targetPosition.x, targetPosition.y, targetPosition.z - pedHeightOffset, false, false, false, false)
                    else
                        -- No valid ground - don't update position, show as invalid
                        isPlacementValid = false
                        SetEntityAlpha(previewPed, 80, false)
                    end
                else
                    showDistanceWarning()
                    isPlacementValid = false

                    if not previewPedHidden then
                        SetEntityAlpha(previewPed, 0, false)
                        previewPedHidden = true
                    end
                end
            end

            disableControls()

            if IsDisabledControlPressed(0, 44) then
                rotateAmount += LARGE_CHANGE_AMOUNT
            elseif IsDisabledControlPressed(0, 46) then
                rotateAmount -= LARGE_CHANGE_AMOUNT
            elseif IsDisabledControlPressed(0, 45) then
                upDownOffset += SMALL_CHANGE_AMOUNT

                if upDownOffset >= MAX_HEIGHT_UP then upDownOffset = MAX_HEIGHT_UP end
            elseif IsDisabledControlPressed(0, 49) then
                upDownOffset -= SMALL_CHANGE_AMOUNT

                if upDownOffset <= -MAX_HEIGHT_DOWN then upDownOffset = -MAX_HEIGHT_DOWN end
            elseif IsDisabledControlPressed(0, 33) then
                moveForwardBack += SMALL_CHANGE_AMOUNT

                if moveForwardBack >= 1 then moveForwardBack = 1 end
            elseif IsDisabledControlPressed(0, 32) then
                moveForwardBack -= SMALL_CHANGE_AMOUNT

                if moveForwardBack <= -1 then moveForwardBack = -1 end
            elseif IsDisabledControlPressed(0, 35) then
                moveLeftRight += SMALL_CHANGE_AMOUNT

                if moveLeftRight >= 1 then moveLeftRight = 1 end
            elseif IsDisabledControlPressed(0, 34) then
                moveLeftRight -= SMALL_CHANGE_AMOUNT

                if moveLeftRight <= -1 then moveLeftRight = -1 end
            elseif IsDisabledControlJustPressed(0, 18) then
                if isPlacementValid then
                    placementState = PlacementState.WALKING
                else
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    SimpleNotify("~r~Cannot place here - no valid ground")
                end
            elseif IsDisabledControlJustPressed(0, 194) then -- Backspace/ESC
                placementState = PlacementState.NONE
                setPlacementHints(nil)
                DeleteEntity(previewPed)
                -- Prevent double backspace from affecting menu navigation
                Wait(100)
                -- Restore the menu we were on before placement
                if menuBeforePlacement then
                    menuBeforePlacement:Visible(true)
                    -- Restore the preview ped if we had a LastEmote
                    if LastEmote and LastEmote.name then
                        ShowPedMenu()
                        WaitForClonedPedThenPlayLastAnim()
                    end
                    menuBeforePlacement = nil
                    -- Restart menu processing loop
                    ProcessEmoteMenu()
                end
                return
            end

            setPlacementHints(isPlacementValid and 'valid' or 'invalid')

            Wait(0)
        end

        setPlacementHints(nil)
        DestroyAllProps(true)
        DeleteEntity(previewPed)
        walkPedToPlacementPosition(emoteName)
    end)
end

function GetPlacementState() return placementState end
function GetPlacementFrozePlayer() return placementFrozePlayer end

function StartNewPlacement(emoteName, options)
    placementOptions = options or {}

    -- Cancel any current placed emote to prevent chaining through walls
    if placementState == PlacementState.IN_ANIMATION then
        EmoteCancel(true)
        Wait(100) -- Brief delay to ensure cleanup completes
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed) - vector3(0.0, 0.0, 10.0)

    if DoesEntityExist(previewPed) then DeleteEntity(previewPed) end

    previewPed = CreatePed(26, GetEntityModel(playerPed), coords.x, coords.y, coords.z, 0, false, false)

    ClonePedToTarget(playerPed, previewPed)
    SetEntityInvincible(previewPed, true)
    SetEntityLocallyVisible(previewPed)
    NetworkSetEntityInvisibleToNetwork(previewPed, true)
    SetEntityCanBeDamaged(previewPed, false)
    SetBlockingOfNonTemporaryEvents(previewPed, true)
    SetEntityAlpha(previewPed, 254, false)
    SetEntityCollision(previewPed, false, false)
    SetPedCanBeTargetted(ClonedPed, false)

    ClosePedMenu()

    -- Store and hide the currently visible menu
    menuBeforePlacement = GetCurrentlyVisibleMenu()
    if menuBeforePlacement then
        menuBeforePlacement:Visible(false)
    end

    placementState = PlacementState.PREVIEWING

    positionPreviewPed(emoteName)
end

function CleanUpPlacement(ped)
    if #positionPriorToPlacement > 0 then
        local pedCoords = GetEntityCoords(ped)
        local foundGround, groundZ = GetGroundZFor_3dCoord(pedCoords.x, pedCoords.y, pedCoords.z, false)

        -- Sin suelo, demasiado despegado de el, o demasiada diferencia de Z
        -- entre donde empezo y donde acabo. Los dos margenes crecen con lo que
        -- permita Config.PlacementMaxHeight*, o elevar la ped a proposito se
        -- leeria como abuso y la devolveria al sitio nada mas soltar la emote.
        local groundTolerance = 3 + MAX_HEIGHT_UP
        local heightDiff = pedCoords.z - positionPriorToPlacement.z

        if not foundGround or math.abs(pedCoords.z - groundZ) > groundTolerance
            or heightDiff > 1 + MAX_HEIGHT_UP or heightDiff < -(1 + MAX_HEIGHT_DOWN) then
            SetEntityCoordsNoOffset(ped, positionPriorToPlacement.x, positionPriorToPlacement.y, positionPriorToPlacement.z, true, true, true)
        end
    end

    if placementFrozePlayer then
        FreezeEntityPosition(PlayerPedId(), false)
    end

    TriggerServerEvent("dwkemotes:server:syncHeading", nil)
    resetStoredPlacementValues()

    -- Red de seguridad: si la colocacion termina por una via que no pasa por el
    -- bucle (muerte, reinicio del recurso), el panel no puede quedarse colgado.
    setPlacementHints(nil)

    if DoesEntityExist(previewPed) then DeleteEntity(previewPed) end
end

AddEventHandler('gameEventTriggered', function (name, args)
    if placementState ~= PlacementState.IN_ANIMATION then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local playerPedId = PlayerPedId()
    local targetPedId = args[1]

    if playerPedId ~= targetPedId then return end

    EmoteCancel()
end)

-- Statebag change handler to sync heading for other clients
AddStateBagChangeHandler('emoteHeading', nil, function(bagName, key, value)
    -- Extract player ID from bag name (e.g., "player:1" -> 1)
    local playerId = GetPlayerFromStateBagName(bagName)
    if not playerId then return end

    -- Don't apply to local player (we set our own heading)
    if playerId == PlayerId() then return end

    local ped = GetPlayerPed(playerId)
    if not DoesEntityExist(ped) then return end

    -- If value is nil, heading was cleared (emote ended)
    if value == nil then return end

    -- Apply the synced heading to the player's ped
    SetEntityHeading(ped, value)
end)

CreateExport('StartNewPlacement', StartNewPlacement)
CreateExport('GetPlacementState', GetPlacementState)