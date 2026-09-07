-- ─── Editor de props en vivo (/propeditor) ───────────────────────────────────
--
-- Coloca los objetos que lleva el ped durante una emote sin salir del juego:
-- se ve el muneco con sus huesos marcados como puntos, se pincha uno, se elige
-- un modelo y se mueve y gira hasta que encaja. Lo que se guarda son los campos
-- que ya usa el pack (Prop, PropBone, PropPlacement, PropNoCollision y sus
-- equivalentes Second*), asi que el resultado se puede llevar tal cual al .lua
-- de la emote con `emoteprops export`.
--
-- Todo el editor vive en propeditor/. Mientras el bloque de fxmanifest.lua este
-- puesto, lo guardado se aplica sobre EmoteData en caliente; comentandolo, el
-- pack vuelve a comportarse exactamente como antes.

local CFG = Config.PropEditor

-- ─── Overrides guardados ─────────────────────────────────────────────────────
--
-- Llegan del servidor y se escriben sobre AnimationOptions de la emote. Se hace
-- asi, y no consultandolos en cada reproduccion, porque los props los crea
-- addProps() leyendo esa tabla: tanto los del jugador como los que ve el resto
-- a traves del state bag. Escribiendo una vez, lo ven todos.

---@type table<string, table>
local overrides = {}

--- Lo que traia el pack antes de pisarlo, para poder revertir sin reiniciar.
---@type table<string, table>
local originals = {}

---@param name string
---@return table|nil emote, boolean shared
local function findEmote(name)
    if EmoteData and EmoteData[name] then return EmoteData[name], false end
    if SharedEmoteData and SharedEmoteData[name] then return SharedEmoteData[name], true end
    return nil, false
end

---@param opts AnimationOptions
---@return table
local function snapshot(opts)
    return {
        Prop = opts.Prop,
        PropBone = opts.PropBone,
        PropPlacement = opts.PropPlacement,
        PropNoCollision = opts.PropNoCollision,
        SecondProp = opts.SecondProp,
        SecondPropBone = opts.SecondPropBone,
        SecondPropPlacement = opts.SecondPropPlacement,
        SecondPropNoCollision = opts.SecondPropNoCollision,
    }
end

---@param slot table|nil {model, bone, pos, rot, noCollision}
---@return string|nil model, integer|nil bone, number[]|nil placement, boolean|nil noCollision
local function slotToOptions(slot)
    if not slot or not slot.model or slot.model == '' then return nil, nil, nil, nil end

    local pos, rot = slot.pos or {}, slot.rot or {}
    return slot.model,
        math.floor(slot.bone or 28422),
        {
            pos.x or 0.0, pos.y or 0.0, pos.z or 0.0,
            rot.x or 0.0, rot.y or 0.0, rot.z or 0.0,
        },
        slot.noCollision and true or nil
end

--- Escribe (o revierte) el override de una emote sobre su AnimationOptions.
---@param name string
---@param data table|nil nil devuelve la emote a lo que traia el pack
---@return boolean aplicado
local function applyOverride(name, data)
    local emote = findEmote(name)
    if not emote then return false end

    emote.AnimationOptions = emote.AnimationOptions or {}
    local opts = emote.AnimationOptions

    if originals[name] == nil then
        originals[name] = snapshot(opts)
    end

    if data == nil then
        local o = originals[name]
        opts.Prop, opts.PropBone, opts.PropPlacement, opts.PropNoCollision =
            o.Prop, o.PropBone, o.PropPlacement, o.PropNoCollision
        opts.SecondProp, opts.SecondPropBone, opts.SecondPropPlacement, opts.SecondPropNoCollision =
            o.SecondProp, o.SecondPropBone, o.SecondPropPlacement, o.SecondPropNoCollision
        return true
    end

    opts.Prop, opts.PropBone, opts.PropPlacement, opts.PropNoCollision = slotToOptions(data.slot1)
    opts.SecondProp, opts.SecondPropBone, opts.SecondPropPlacement, opts.SecondPropNoCollision =
        slotToOptions(data.slot2)

    return true
end

--- Vuelca todo lo recibido sobre las tablas de emotes. Se reintenta porque el
--- servidor puede contestar antes de que EmoteMenu.lua haya convertido las
--- listas: sin emote a la que escribir, el override se perderia en silencio.
local function applyAll()
    CreateThread(function()
        local pending = {}
        for name in pairs(overrides) do pending[name] = true end

        local deadline = GetGameTimer() + 30000
        while next(pending) and GetGameTimer() < deadline do
            for name in pairs(pending) do
                if applyOverride(name, overrides[name]) then pending[name] = nil end
            end
            if next(pending) then Wait(500) end
        end

        local missing = {}
        for name in pairs(pending) do missing[#missing + 1] = name end
        if #missing > 0 then
            DebugPrint(('[propeditor] %d override(s) sin emote a la que aplicarse: %s')
                :format(#missing, table.concat(missing, ', ')))
        end
    end)
end

RegisterNetEvent('dwkemotes:propeditor:overrides', function(list)
    if type(list) ~= 'table' then return end
    overrides = list

    local count = 0
    for _ in pairs(overrides) do count += 1 end
    DebugPrint(('[propeditor] %d override(s) de prop recibidos del servidor'):format(count))

    applyAll()
end)

RegisterNetEvent('dwkemotes:propeditor:updated', function(name, data)
    if type(name) ~= 'string' then return end
    overrides[name] = data
    applyOverride(name, data)
end)

CreateThread(function()
    Wait(1500)
    TriggerServerEvent('dwkemotes:propeditor:request')
end)

-- ─── Catalogo de modelos disponibles ─────────────────────────────────────────

---@type {model: string, source: string}[]|nil
local catalogCache = nil

--- Props que ya usa el pack mas los de la lista de base, quitando los que este
--- servidor no tenga. Se calcula una sola vez: recorrer todas las emotes y
--- llamar a IsModelInCdimage varios cientos de veces no es gratis.
---@return {model: string, source: string}[]
local function buildCatalog()
    if catalogCache then return catalogCache end

    local seen, out = {}, {}

    local function add(model, source)
        if type(model) ~= 'string' or model == '' or seen[model] then return end
        seen[model] = true

        local hash = GetHashKey(model)
        if hash == 0 or not IsModelInCdimage(hash) then return end

        out[#out + 1] = { model = model, source = source }
    end

    local function scan(list)
        if type(list) ~= 'table' then return end
        for _, emote in pairs(list) do
            local opts = type(emote) == 'table' and emote.AnimationOptions
            if type(opts) == 'table' then
                add(opts.Prop, 'pack')
                add(opts.SecondProp, 'pack')
            end
        end
    end

    scan(EmoteData)
    scan(SharedEmoteData)

    for _, model in ipairs(PropEditorCatalogNames()) do
        add(model, 'base')
    end

    table.sort(out, function(a, b) return a.model < b.model end)
    catalogCache = out
    return out
end

-- ─── Sesion de edicion ───────────────────────────────────────────────────────

local editing = false

---@type table|nil
local session = nil

--- Si el editor esta abierto. Global a proposito: si algun dia otro flujo tiene
--- que apartarse (como hace Syncing.lua con el editor de offsets), le basta con
--- comprobar que esta funcion exista.
---@return boolean
function IsPropEditorActive()
    return editing
end

-- Movimiento, camara, ataque, rueda del raton y entrada a vehiculo: el editor
-- usa WASD/RF y no puede dejar que el ped se vaya andando mientras se ajusta.
local BLOCKED_CONTROLS <const> = {
    14, 15, 16, 17, 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 36, 37,
    44, 45, 46, 47, 49, 75, 140, 141, 142, 143, 194, 199, 200, 201, 202,
    241, 242, 243,
}

local function blockControls()
    for _, control in ipairs(BLOCKED_CONTROLS) do
        DisableControlAction(0, control, true)
    end
end

---@param value number
---@param limit number
---@return number
local function clamp(value, limit)
    if value > limit then return limit end
    if value < -limit then return -limit end
    return value
end

---@param n number
---@return number
local function round3(n)
    return tonumber(('%.3f'):format(n)) or 0.0
end

---@param slot integer
---@return table
local function slotData(slot)
    return session.slots[slot]
end

-- ─── Prop de previsualizacion ────────────────────────────────────────────────
--
-- El editor crea y mueve sus propios objetos en local en vez de dejarselo a
-- addProps(): hay que poder recolocarlos frame a frame sin reiniciar la emote y
-- sin que el resto del servidor vea el prop bailando durante el ajuste.

---@param slot integer
local function destroyPreview(slot)
    local entity = session.entities[slot]
    if not entity then return end
    session.entities[slot] = nil

    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

local function destroyAllPreviews()
    destroyPreview(1)
    destroyPreview(2)
end

--- Reengancha el objeto ya creado con el hueso y el transform actuales. Es lo
--- que se llama al mover o girar: recrear el objeto en cada pulsacion daria un
--- parpadeo en pantalla.
---@param slot integer
local function reattachPreview(slot)
    local entity = session.entities[slot]
    if not entity or not DoesEntityExist(entity) then return end

    local data = slotData(slot)
    local ped = PlayerPedId()
    local boneIndex = GetPedBoneIndex(ped, data.bone or 0)
    if boneIndex == -1 then boneIndex = 0 end

    AttachEntityToEntity(
        entity, ped, boneIndex,
        data.pos.x, data.pos.y, data.pos.z,
        data.rot.x, data.rot.y, data.rot.z,
        true, true, false, true, 1, true
    )
end

-- ─── Ejes de la vista ────────────────────────────────────────────────────────
--
-- AttachEntityToEntity interpreta el offset en el espacio del HUESO, y los
-- huesos de la mano de GTA estan girados de cualquier manera: pulsar W movia el
-- prop en una direccion que no tiene nada que ver con lo que se ve en pantalla.
-- Con Config.PropEditor.axisMode = 'camera' las teclas mueven respecto a la
-- vista, y estas dos funciones traducen ese desplazamiento al espacio del hueso.

--- Mide los tres ejes del hueso, en coordenadas del mundo.
---
--- Se miden en vez de calcularse: componer la matriz del hueso a mano obliga a
--- acertar el orden de los angulos de Euler que aplica el attach, y basta con
--- desplazar el prop una distancia conocida en cada eje local y mirar hacia
--- donde se ha ido de verdad. Cuesta tres frames y se hace una vez por hueso.
---
--- Se resta la posicion del hueso en cada lectura para que una animacion en
--- marcha no contamine la medida: asi se cancela lo que el hueso se traslada
--- entre frames. Lo que gire en esos tres frames si entra como error, de modo
--- que en una emote muy movida la medida sale algo torcida; en las emotes
--- quietas, que es donde se calibra un prop, es exacta.
---@param slot integer
---@return table|nil ejes { x = vector3, y = vector3, z = vector3 }
local function measureBoneBasis(slot)
    local entity = session.entities[slot]
    if not entity or not DoesEntityExist(entity) then return nil end

    local data = slotData(slot)
    local ped = PlayerPedId()
    local boneIndex = GetPedBoneIndex(ped, data.bone or 0)
    if boneIndex == -1 then boneIndex = 0 end

    local D <const> = 0.05
    local saved = { x = data.pos.x, y = data.pos.y, z = data.pos.z }

    local function sample()
        return GetEntityCoords(entity) - GetWorldPositionOfEntityBone(ped, boneIndex)
    end

    reattachPreview(slot)
    Wait(0)
    local origin = sample()

    local basis = {}
    for _, axis in ipairs({ 'x', 'y', 'z' }) do
        data.pos[axis] = saved[axis] + D
        reattachPreview(slot)
        Wait(0)
        basis[axis] = (sample() - origin) / D
        data.pos[axis] = saved[axis]
    end

    reattachPreview(slot)

    -- Un eje de longitud rara significa que la medida no vale (el hueso se
    -- movio demasiado, o el objeto no llego a reengancharse). Mejor no tener
    -- base y caer en los ejes de siempre que mover el prop a ciegas.
    for _, axis in ipairs({ 'x', 'y', 'z' }) do
        local len = #(basis[axis])
        if len < 0.9 or len > 1.1 then return nil end
    end
    return basis
end

--- Invalida la base medida de un slot. Depende del hueso y de la entidad, asi
--- que hay que llamarla al cambiar de hueso y al cambiar de modelo (que recrea
--- el objeto). Girar el prop NO la invalida: en AttachEntityToEntity el offset
--- y la rotacion son independientes, y girar no mueve el origen del objeto.
---@param slot integer|nil nil = los dos
local function forgetBoneBasis(slot)
    if not session then return end
    session.basis = session.basis or {}
    if slot then
        session.basis[slot] = nil
    else
        session.basis = {}
    end
end

--- Crea el objeto del slot desde cero. Solo hace falta al cambiar de modelo.
---@param slot integer
local function spawnPreview(slot)
    destroyPreview(slot)
    forgetBoneBasis(slot)

    local data = slotData(slot)
    if not data.model or data.model == '' then return end

    local hash = GetHashKey(data.model)
    if hash == 0 or not IsModelInCdimage(hash) then
        SimpleNotify(('El modelo %s no esta en este servidor'):format(data.model), 'error')
        return
    end

    LoadPropDict(data.model)
    if not HasModelLoaded(hash) then
        SimpleNotify(('No se pudo cargar %s'):format(data.model), 'error')
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local entity = CreateObject(hash, coords.x, coords.y, coords.z + 0.2, false, false, false)
    SetModelAsNoLongerNeeded(hash)

    if not DoesEntityExist(entity) then return end

    -- La colision del objeto de previsualizacion va siempre apagada: un prop
    -- con colision enganchado a la mano empuja al propio ped por el mapa y no
    -- habria forma de ajustar nada. El valor guardado si se respeta cuando la
    -- emote se reproduce de verdad.
    SetEntityCollision(entity, false, false)

    session.entities[slot] = entity
    reattachPreview(slot)
end

-- ─── Camara de orbita ────────────────────────────────────────────────────────

---@return vector3
local function cameraTarget()
    local ped = PlayerPedId()

    if session.followBone then
        local boneIndex = GetPedBoneIndex(ped, slotData(session.slot).bone or 24818)
        if boneIndex ~= -1 then
            return GetWorldPositionOfEntityBone(ped, boneIndex)
        end
    end

    local chest = GetPedBoneIndex(ped, 24818) -- SKEL_Spine3
    if chest ~= -1 then
        return GetWorldPositionOfEntityBone(ped, chest)
    end

    local coords = GetEntityCoords(ped)
    return vector3(coords.x, coords.y, coords.z + 0.4)
end

local function updateCamera()
    if not session.cam then return end

    local target = cameraTarget()

    -- El objetivo se persigue en vez de copiarse: enfocando un hueso de la mano
    -- durante un baile, copiarlo frame a frame convertiria la camara en un
    -- temblor imposible de mirar.
    local previous = session.camTarget
    if previous then
        target = vector3(
            previous.x + (target.x - previous.x) * 0.2,
            previous.y + (target.y - previous.y) * 0.2,
            previous.z + (target.z - previous.z) * 0.2
        )
    end
    session.camTarget = target

    local yaw, pitch = math.rad(session.camYaw), math.rad(session.camPitch)
    local horizontal = session.camDist * math.cos(pitch)

    SetCamCoord(session.cam,
        target.x + horizontal * math.sin(yaw),
        target.y - horizontal * math.cos(yaw),
        target.z + session.camDist * math.sin(pitch))
    PointCamAtCoord(session.cam, target.x, target.y, target.z)
end

-- ─── Puntos de hueso en pantalla ─────────────────────────────────────────────

--- Huesos que este ped tiene de verdad. Filtra el catalogo con GetPedBoneIndex,
--- que devuelve -1 para los que el esqueleto no lleva, y anade el hueso que ya
--- estuviera configurado aunque no aparezca en la lista: el pack usa alguna
--- variante suelta que no merece la pena adivinar.
---@return {id: integer, index: integer, label: string, name: string, group: string, major: boolean}[]
local function usableBones()
    local ped = PlayerPedId()
    local out, seen = {}, {}

    for _, bone in ipairs(PropEditorBones) do
        local index = GetPedBoneIndex(ped, bone.id)
        if index ~= -1 and not seen[bone.id] then
            seen[bone.id] = true
            out[#out + 1] = {
                id = bone.id,
                index = index,
                label = bone.label,
                name = bone.name,
                group = bone.group,
                major = bone.major,
            }
        end
    end

    for slot = 1, 2 do
        local id = session and session.slots[slot].bone
        if id and not seen[id] then
            local index = GetPedBoneIndex(ped, id)
            if index ~= -1 then
                seen[id] = true
                out[#out + 1] = {
                    id = id,
                    index = index,
                    label = PropEditorBoneLabel(id),
                    name = ('Hueso %d'):format(id),
                    group = 'Del pack',
                    major = true,
                }
            end
        end
    end

    return out
end

--- Proyecta los huesos visibles y los manda a la interfaz. El payload va como
--- lista de listas y no como objetos con clave: esto se envia en cada frame y
--- el ahorro de JSON se nota en el CEF.
local function sendBonePoints()
    local ped = PlayerPedId()
    local points = {}

    for _, bone in ipairs(session.bones) do
        if session.showAllBones or bone.major then
            local coords = GetWorldPositionOfEntityBone(ped, bone.index)
            local onScreen, sx, sy = World3dToScreen2d(coords.x, coords.y, coords.z)
            if onScreen then
                points[#points + 1] = { bone.id, round3(sx), round3(sy) }
            end
        end
    end

    SendNUIMessage({ action = 'propeditor:bones', points = points })
end

-- ─── Sincronizacion con la interfaz ──────────────────────────────────────────

---@param slot integer
---@return table
local function slotPayload(slot)
    local data = slotData(slot)
    return {
        model = data.model or '',
        bone = data.bone,
        boneLabel = PropEditorBoneLabel(data.bone),
        pos = { x = round3(data.pos.x), y = round3(data.pos.y), z = round3(data.pos.z) },
        rot = { x = round3(data.rot.x), y = round3(data.rot.y), z = round3(data.rot.z) },
        noCollision = data.noCollision and true or false,
    }
end

local function sendState()
    SendNUIMessage({
        action = 'propeditor:state',
        slot = session.slot,
        slots = { slotPayload(1), slotPayload(2) },
        followBone = session.followBone,
        showAllBones = session.showAllBones,
        dirty = session.dirty,
    })
end

-- ─── Props reales de la emote ────────────────────────────────────────────────

--- Rehace los props de la emote en curso leyendo AnimationOptions. Es lo que
--- convierte un guardado en algo visible sin volver a lanzar la emote, tanto
--- para uno mismo como para el resto (el state bag los recrea en cada cliente).
---@param name string
function RefreshEmoteProps(name)
    local emote, shared = findEmote(name)
    if not emote then return end

    local opts = emote.AnimationOptions

    -- DestroyAllProps() ya deja el state bag vacio, que es justo lo que hace
    -- falta: el manejador solo reacciona cuando el valor cambia, asi que sin
    -- pasar por vacio volver a escribir lo mismo no recrearia nada.
    DestroyAllProps()

    if not opts or not opts.Prop then return end

    if Config.UseOldPropSpawning then
        addProps(opts, CurrentTextureVariation, PlayerPedId(), PlayerId(), true)
        return
    end

    local emoteType = shared and EmoteType.SHARED or emote.emoteType

    CreateThread(function()
        Wait(50)
        SetPropStateBag({
            Emote = name,
            TextureVariation = CurrentTextureVariation,
            emoteType = emoteType,
        })
    end)
end

-- ─── Apertura y cierre ───────────────────────────────────────────────────────

---@param opts AnimationOptions|table|nil
---@param prefix string '' o 'Second'
---@return table
local function readSlot(opts, prefix)
    local placement = opts and opts[prefix .. 'PropPlacement'] or nil

    return {
        model = opts and opts[prefix .. 'Prop'] or nil,
        bone = (opts and opts[prefix .. 'PropBone']) or 28422, -- PH_R_Hand
        pos = {
            x = placement and placement[1] or 0.0,
            y = placement and placement[2] or 0.0,
            z = placement and placement[3] or 0.0,
        },
        rot = {
            x = placement and placement[4] or 0.0,
            y = placement and placement[5] or 0.0,
            z = placement and placement[6] or 0.0,
        },
        noCollision = (opts and opts[prefix .. 'PropNoCollision']) and true or false,
    }
end

---@param silent? boolean
local function closeEditor(silent)
    if not editing then return end
    editing = false

    destroyAllPreviews()

    if session.cam then
        RenderScriptCams(false, true, 400, true, true)
        DestroyCam(session.cam, false)
        session.cam = nil
    end

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = 'propeditor:close' })

    -- Los props reales se rehacen desde AnimationOptions, que ya lleva lo
    -- guardado (o lo de siempre, si se salio sin guardar).
    local emoteName = session.emote
    session = nil

    if IsInAnimation and CurrentAnimationName == emoteName then
        RefreshEmoteProps(emoteName)
    end

    if not silent then
        SimpleNotify('Editor de props cerrado')
    end
end

--- Prepara los dos slots para guardarlos. Si el primero quedo vacio pero el
--- segundo no, se asciende: addProps() solo mira SecondProp cuando Prop existe,
--- asi que un ajuste con solo el segundo no ensenaria nada en el juego.
---@return table
local function normalizedSlots()
    local out = {}

    for slot = 1, 2 do
        local data = slotData(slot)
        if data.model and data.model ~= '' then
            out[#out + 1] = {
                model = data.model,
                bone = math.floor(data.bone or 28422),
                pos = { x = round3(data.pos.x), y = round3(data.pos.y), z = round3(data.pos.z) },
                rot = { x = round3(data.rot.x), y = round3(data.rot.y), z = round3(data.rot.z) },
                noCollision = data.noCollision and true or false,
            }
        end
    end

    return { slot1 = out[1], slot2 = out[2] }
end

function SavePropEditorSession()
    if not editing then return end
    TriggerServerEvent('dwkemotes:propeditor:save', session.emote, normalizedSlots())
end

---@param emoteName string
local function startEditor(emoteName)
    local emote = findEmote(emoteName)
    if not emote then
        return SimpleNotify(('La emote %s no existe'):format(emoteName), 'error')
    end

    editing = true
    session = {
        emote = emoteName,
        label = emote.label or emoteName,
        ped = PlayerPedId(),
        slot = 1,
        slots = { readSlot(emote.AnimationOptions, ''), readSlot(emote.AnimationOptions, 'Second') },
        entities = {},
        camYaw = (GetEntityHeading(PlayerPedId()) + 150.0) % 360,
        camPitch = 8.0,
        camDist = CFG.camDistance,
        followBone = false,
        showAllBones = false,
        dirty = false,
        bones = {},
        basis = {},
    }
    session.bones = usableBones()
    -- Los props reales se quitan: a partir de aqui manda la copia del editor,
    -- que es la unica que se puede recolocar sin reiniciar la emote. Esto
    -- tambien los quita de la pantalla del resto, via state bag.
    DestroyAllProps()

    spawnPreview(1)
    spawnPreview(2)

    session.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(session.cam, true)
    updateCamera()
    RenderScriptCams(true, true, 400, true, true)

    local boneList = {}
    for _, bone in ipairs(session.bones) do
        boneList[#boneList + 1] = {
            id = bone.id,
            label = bone.label,
            name = bone.name,
            group = bone.group,
            major = bone.major,
        }
    end

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    SendNUIMessage({
        action = 'propeditor:open',
        emote = emoteName,
        label = session.label,
        bones = boneList,
        props = buildCatalog(),
        limitPos = CFG.limitPos,
    })
    sendState()

    CreateThread(function()
        -- El Enter que envio el comando no puede contar ya como "guardar".
        Wait(150)

        while editing do
            blockControls()

            -- Un cambio de ped (muerte, /skin) deja los indices de hueso y los
            -- objetos enganchados apuntando a una entidad que ya no existe.
            local ped = PlayerPedId()
            if not DoesEntityExist(ped) or ped ~= session.ped then
                SimpleNotify('Editor cerrado: el ped ha cambiado', 'error')
                closeEditor(true)
                break
            end

            updateCamera()
            sendBonePoints()

            local coarse = IsDisabledControlPressed(0, 21)   -- Shift
            local rotating = IsDisabledControlPressed(0, 36) -- Ctrl
            local step = coarse and CFG.stepCoarse or CFG.stepFine
            local stepRot = coarse and CFG.stepRotCoarse or CFG.stepRotFine
            local data = slotData(session.slot)
            local moved = false

            -- La base se mide una vez por hueso y se guarda. measureBoneBasis
            -- gasta tres frames, asi que no puede ir en cada pulsacion.
            if CFG.axisMode == 'camera' and not session.basis[session.slot] then
                session.basis[session.slot] = measureBoneBasis(session.slot) or false
            end
            local basis = session.basis[session.slot] or nil

            ---@param axis string 'x', 'y' o 'z' del hueso
            ---@param direction number
            local function nudgeLocal(axis, direction)
                data.pos[axis] = clamp(data.pos[axis] + direction * step, CFG.limitPos)
                moved = true
            end

            --- Mueve el prop en una direccion del MUNDO, repartiendola entre los
            --- tres ejes del hueso. La base es ortonormal (los huesos no
            --- escalan), asi que proyectar sobre cada eje basta y no hace falta
            --- invertir ninguna matriz.
            ---@param world vector3 unitario
            ---@param direction number
            local function slide(world, direction)
                local d = direction * step
                for _, axis in ipairs({ 'x', 'y', 'z' }) do
                    local e = basis[axis]
                    local amount = (world.x * e.x + world.y * e.y + world.z * e.z) * d
                    data.pos[axis] = clamp(data.pos[axis] + amount, CFG.limitPos)
                end
                moved = true
            end

            ---@param axis string
            ---@param direction number
            local function rotate(axis, direction)
                data.rot[axis] = (data.rot[axis] + direction * stepRot) % 360
                moved = true
            end

            -- Ejes de la vista en coordenadas del mundo, sacados de updateCamera:
            -- con camYaw 0 la camara esta al sur mirando al norte, asi que
            -- adelante es +Y y la derecha de la pantalla es +X. Arriba es el del
            -- mundo a proposito: para colocar un prop, "subir" es subir.
            local yaw = math.rad(session.camYaw)
            local viewFwd <const> = vector3(-math.sin(yaw), math.cos(yaw), 0.0)
            local viewRight <const> = vector3(math.cos(yaw), math.sin(yaw), 0.0)
            local viewUp <const> = vector3(0.0, 0.0, 1.0)

            --- Aplica una tecla. Girar sigue siendo en ejes del hueso: recomponer
            --- los angulos de Euler para que girar fuese "respecto a la pantalla"
            --- es otro problema, y el resultado tiene que seguir siendo un Euler
            --- que el attach entienda.
            ---@param control integer
            ---@param axis string eje local, para rotar o si no hay base medida
            ---@param world vector3 direccion en pantalla
            ---@param direction number
            ---@return boolean pulsada
            local function key(control, axis, world, direction)
                if not IsDisabledControlPressed(0, control) then return false end
                if rotating then
                    rotate(axis, direction)
                elseif basis then
                    slide(world, direction)
                else
                    nudgeLocal(axis, direction)
                end
                return true
            end

            local _ = key(32, 'y', viewFwd, 1)       -- W: alejar
                or key(33, 'y', viewFwd, -1)         -- S: acercar
                or key(34, 'x', viewRight, -1)       -- A: izquierda
                or key(35, 'x', viewRight, 1)        -- D: derecha
                or key(45, 'z', viewUp, 1)           -- R: subir
                or key(49, 'z', viewUp, -1)          -- F: bajar
            -- Flechas: orbitar. Es la alternativa de teclado a arrastrar con el
            -- raton sobre el fondo, que es como se usa normalmente.
            if IsDisabledControlPressed(0, 174) then session.camYaw = (session.camYaw - 1.5) % 360 end
            if IsDisabledControlPressed(0, 175) then session.camYaw = (session.camYaw + 1.5) % 360 end
            if IsDisabledControlPressed(0, 172) then session.camPitch = math.min(session.camPitch + 1.0, 85.0) end
            if IsDisabledControlPressed(0, 173) then session.camPitch = math.max(session.camPitch - 1.0, -85.0) end

            if IsDisabledControlJustPressed(0, 37) then     -- Tab
                session.slot = session.slot == 1 and 2 or 1
                sendState()
            elseif IsDisabledControlJustPressed(0, 18) then -- Enter
                SavePropEditorSession()
            elseif IsDisabledControlJustPressed(0, 194) then -- Backspace
                closeEditor()
                break
            end

            if moved then
                session.dirty = true
                reattachPreview(session.slot)
                sendState()
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('dwkemotes:propeditor:saved', function(name, data)
    overrides[name] = data
    applyOverride(name, data)

    if editing and session.emote == name then
        session.dirty = false
        sendState()
    end

    SimpleNotify(('Props de %s guardados'):format(name), 'success')
end)

-- ─── Callbacks de la interfaz ────────────────────────────────────────────────

--- Envoltorio de RegisterNUICallback que descarta lo que llegue con el editor
--- cerrado: la interfaz vive en la misma pagina que el menu de emotes y no
--- puede dar por hecho que haya sesion.
---@param name string
---@param handler fun(data: table)
local function callback(name, handler)
    RegisterNUICallback(name, function(data, cb)
        if not editing then return cb({}) end
        handler(data or {})
        cb({})
    end)
end

callback('propEditorSetSlot', function(data)
    local slot = tonumber(data.slot)
    if slot ~= 1 and slot ~= 2 then return end

    session.slot = slot
    sendState()
end)

callback('propEditorSetBone', function(data)
    local bone = tonumber(data.bone)
    if not bone then return end

    slotData(session.slot).bone = math.floor(bone)
    session.dirty = true
    forgetBoneBasis(session.slot)
    reattachPreview(session.slot)
    sendState()
end)

callback('propEditorSetModel', function(data)
    local model = type(data.model) == 'string' and (data.model:gsub('%s', '')) or ''
    local slot = slotData(session.slot)

    slot.model = model ~= '' and model:lower() or nil
    session.dirty = true
    spawnPreview(session.slot)
    sendState()
end)

callback('propEditorSetTransform', function(data)
    local slot = slotData(session.slot)

    for _, axis in ipairs({ 'x', 'y', 'z' }) do
        local p = data.pos and tonumber(data.pos[axis])
        if p then slot.pos[axis] = clamp(p, CFG.limitPos) end

        local r = data.rot and tonumber(data.rot[axis])
        if r then slot.rot[axis] = r % 360 end
    end

    if data.noCollision ~= nil then
        slot.noCollision = data.noCollision and true or false
    end

    session.dirty = true
    reattachPreview(session.slot)
    sendState()
end)

callback('propEditorRemove', function()
    slotData(session.slot).model = nil
    session.dirty = true
    destroyPreview(session.slot)
    sendState()
end)

callback('propEditorResetSlot', function()
    local emote = findEmote(session.emote)
    local original = originals[session.emote] or (emote and emote.AnimationOptions) or {}

    session.slots[session.slot] = readSlot(original, session.slot == 1 and '' or 'Second')
    session.dirty = true
    spawnPreview(session.slot)
    sendState()
end)

callback('propEditorToggle', function(data)
    if data.key == 'followBone' then
        session.followBone = not session.followBone
    elseif data.key == 'showAllBones' then
        session.showAllBones = not session.showAllBones
    end
    sendState()
end)

callback('propEditorOrbit', function(data)
    session.camYaw = (session.camYaw + (tonumber(data.dx) or 0) * 0.35) % 360
    session.camPitch = math.max(-85.0, math.min(85.0, session.camPitch - (tonumber(data.dy) or 0) * 0.25))
end)

callback('propEditorZoom', function(data)
    local delta = (tonumber(data.delta) or 0) * 0.0015
    session.camDist = math.max(CFG.camDistanceMin, math.min(CFG.camDistanceMax, session.camDist + delta))
end)

callback('propEditorSave', function()
    SavePropEditorSession()
end)

callback('propEditorClose', function()
    closeEditor()
end)

-- El campo de texto necesita el teclado entero; el resto del tiempo las teclas
-- tienen que seguir llegando al juego para poder mover el prop con WASD.
RegisterNUICallback('propEditorInputFocus', function(data, cb)
    if editing then
        SetNuiFocusKeepInput(not (data and data.focused))
    end
    cb({})
end)

RegisterNUICallback('propEditorValidateModel', function(data, cb)
    local model = type(data) == 'table' and data.model or nil
    if type(model) ~= 'string' or model == '' then return cb({ valid = false }) end

    local hash = GetHashKey(model)
    cb({ valid = hash ~= 0 and IsModelInCdimage(hash) })
end)

-- ─── Comando ─────────────────────────────────────────────────────────────────

RegisterNetEvent('dwkemotes:propeditor:openReply', function(allowed, emoteName)
    if not allowed then
        return SimpleNotify('No tienes permiso para editar props', 'error')
    end
    if editing then return end

    startEditor(emoteName)
end)

RegisterCommand(CFG.command, function(_, args)
    if not CFG.enabled then return end

    if editing then
        return SimpleNotify('El editor de props ya esta abierto', 'error')
    end

    local resource = GetCurrentResourceName()
    if exports[resource]:isMenuOpen() then
        exports[resource]:closeMenu()
    end

    local requested = args[1]

    if requested then
        local emote, shared = findEmote(requested)
        if not emote then
            return SimpleNotify(('La emote %s no existe'):format(requested), 'error')
        end

        -- Se lanza antes de abrir para poder colocar el prop sobre la pose real.
        -- Las compartidas no: necesitan a alguien enfrente que acepte, y sin
        -- pareja el intento solo saca un aviso. Se editan sobre el ped quieto,
        -- que para colocar un prop en la mano da igual, o lanzandolas a mano
        -- antes de abrir el editor.
        if not shared and CurrentAnimationName ~= requested then
            RouteEmoteToFunction(requested, emote.emoteType)
            Wait(600)
        end
    elseif not IsInAnimation or not CurrentAnimationName then
        return SimpleNotify(
            ('Lanza una emote primero, o usa /%s <emote>'):format(CFG.command), 'error')
    end

    -- El permiso lo decide el servidor, que es quien despues acepta o rechaza el
    -- guardado: asi el gate vive en un solo sitio.
    TriggerServerEvent('dwkemotes:propeditor:open', requested or CurrentAnimationName)
end, false)

-- Parar el recurso con el editor abierto dejaria la camara puesta y el raton
-- capturado, y eso solo se arregla reconectando.
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if editing then closeEditor(true) end
end)

CreateExport('IsPropEditorActive', IsPropEditorActive)
