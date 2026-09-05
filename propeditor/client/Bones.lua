-- ─── Catalogo de huesos del ped ──────────────────────────────────────────────
--
-- Los IDs son los que espera GetPedBoneIndex(), que es lo que guarda el campo
-- PropBone de cada emote. La lista no pretende ser exhaustiva: estan los huesos
-- a los que de verdad se cuelga algo (manos, dedos, cabeza, torso, pies) y se
-- dejan fuera los de la cara y los de simulacion de tela, que solo ensuciarian
-- la pantalla con puntos.
--
-- Un ID equivocado aqui no rompe nada: el editor descarta con GetPedBoneIndex()
-- todo hueso que el ped no tenga, asi que como mucho el punto no aparece.

---@class PropEditorBone
---@field id integer id de hueso (PropBone)
---@field name string nombre tecnico, el que se ve en otros editores
---@field label string nombre corto en castellano
---@field group string grupo con el que se pinta y se filtra
---@field major boolean se ve siempre; los demas solo con "todos los huesos"

---@type PropEditorBone[]
PropEditorBones = {}

--- @param group string
--- @param entries {[1]: integer, [2]: string, [3]: string, [4]: boolean?}[]
local function addGroup(group, entries)
    for _, e in ipairs(entries) do
        PropEditorBones[#PropEditorBones + 1] = {
            id = e[1],
            name = e[2],
            label = e[3],
            group = group,
            major = e[4] ~= false,
        }
    end
end

-- PH_* son los huesos "prop hook" que usa el propio juego para las armas y los
-- objetos de mano: son los que llevan el 90% de las emotes de este pack.
addGroup('Manos', {
    { 28422, 'PH_R_Hand',  'Mano derecha (gancho)' },
    { 60309, 'PH_L_Hand',  'Mano izquierda (gancho)' },
    { 57005, 'SKEL_R_Hand', 'Mano derecha (hueso)' },
    { 18905, 'SKEL_L_Hand', 'Mano izquierda (hueso)' },
    { 6286,  'IK_R_Hand',  'Mano derecha (IK)', false },
    { 36029, 'IK_L_Hand',  'Mano izquierda (IK)', false },
})

addGroup('Brazos', {
    { 28252, 'SKEL_R_Forearm',  'Antebrazo derecho' },
    { 61163, 'SKEL_L_Forearm',  'Antebrazo izquierdo' },
    { 40269, 'SKEL_R_UpperArm', 'Brazo derecho' },
    { 45509, 'SKEL_L_UpperArm', 'Brazo izquierdo' },
    { 10706, 'SKEL_R_Clavicle', 'Clavicula derecha' },
    { 64729, 'SKEL_L_Clavicle', 'Clavicula izquierda' },
    { 2992,  'MH_R_Elbow',      'Codo derecho', false },
    { 22711, 'MH_L_Elbow',      'Codo izquierdo', false },
})

addGroup('Cabeza', {
    { 31086, 'SKEL_Head',        'Cabeza' },
    { 12844, 'IK_Head',          'Cabeza (IK)' },
    { 39317, 'SKEL_Neck_1',      'Cuello' },
    { 65068, 'FACIAL_facialRoot', 'Raiz facial', false },
})

addGroup('Torso', {
    { 24818, 'SKEL_Spine3',     'Pecho' },
    { 24817, 'SKEL_Spine2',     'Espalda alta' },
    { 24816, 'SKEL_Spine1',     'Espalda media' },
    { 23553, 'SKEL_Spine0',     'Espalda baja' },
    { 57597, 'SKEL_Spine_Root', 'Raiz de la espalda', false },
    { 11816, 'SKEL_Pelvis',     'Pelvis' },
    { 0,     'SKEL_ROOT',       'Raiz del ped' },
})

addGroup('Piernas', {
    { 51826, 'SKEL_R_Thigh', 'Muslo derecho' },
    { 58271, 'SKEL_L_Thigh', 'Muslo izquierdo' },
    { 36864, 'SKEL_R_Calf',  'Gemelo derecho' },
    { 63931, 'SKEL_L_Calf',  'Gemelo izquierdo' },
    { 52301, 'SKEL_R_Foot',  'Pie derecho' },
    { 14201, 'SKEL_L_Foot',  'Pie izquierdo' },
    { 20781, 'SKEL_R_Toe0',  'Punta del pie derecho', false },
    { 2108,  'SKEL_L_Toe0',  'Punta del pie izquierdo', false },
    { 16335, 'MH_R_Knee',    'Rodilla derecha', false },
    { 46078, 'MH_L_Knee',    'Rodilla izquierda', false },
})

-- Los dedos solo hacen falta para colocar algo muy fino (un anillo, un cigarro
-- entre dos dedos), asi que nacen ocultos: con 30 puntos encima de una mano no
-- se acierta ninguno.
addGroup('Dedos derecha', {
    { 58866, 'SKEL_R_Finger00', 'Pulgar der. 1', false },
    { 64016, 'SKEL_R_Finger01', 'Pulgar der. 2', false },
    { 64017, 'SKEL_R_Finger02', 'Pulgar der. 3', false },
    { 58867, 'SKEL_R_Finger10', 'Indice der. 1', false },
    { 64064, 'SKEL_R_Finger11', 'Indice der. 2', false },
    { 64065, 'SKEL_R_Finger12', 'Indice der. 3', false },
    { 58868, 'SKEL_R_Finger20', 'Corazon der. 1', false },
    { 64096, 'SKEL_R_Finger21', 'Corazon der. 2', false },
    { 64097, 'SKEL_R_Finger22', 'Corazon der. 3', false },
    { 58869, 'SKEL_R_Finger30', 'Anular der. 1', false },
    { 64112, 'SKEL_R_Finger31', 'Anular der. 2', false },
    { 64113, 'SKEL_R_Finger32', 'Anular der. 3', false },
    { 58870, 'SKEL_R_Finger40', 'Menique der. 1', false },
    { 64160, 'SKEL_R_Finger41', 'Menique der. 2', false },
    { 64161, 'SKEL_R_Finger42', 'Menique der. 3', false },
    { 64080, 'SKEL_R_Finger2?', 'Dedo der. (variante)', false },
})

addGroup('Dedos izquierda', {
    { 26610, 'SKEL_L_Finger00', 'Pulgar izq. 1', false },
    { 4089,  'SKEL_L_Finger01', 'Pulgar izq. 2', false },
    { 4090,  'SKEL_L_Finger02', 'Pulgar izq. 3', false },
    { 26611, 'SKEL_L_Finger10', 'Indice izq. 1', false },
    { 4137,  'SKEL_L_Finger11', 'Indice izq. 2', false },
    { 4138,  'SKEL_L_Finger12', 'Indice izq. 3', false },
    { 26612, 'SKEL_L_Finger20', 'Corazon izq. 1', false },
    { 4185,  'SKEL_L_Finger21', 'Corazon izq. 2', false },
    { 4186,  'SKEL_L_Finger22', 'Corazon izq. 3', false },
    { 26613, 'SKEL_L_Finger30', 'Anular izq. 1', false },
    { 4233,  'SKEL_L_Finger31', 'Anular izq. 2', false },
    { 4234,  'SKEL_L_Finger32', 'Anular izq. 3', false },
    { 26614, 'SKEL_L_Finger40', 'Menique izq. 1', false },
    { 4281,  'SKEL_L_Finger41', 'Menique izq. 2', false },
    { 4282,  'SKEL_L_Finger42', 'Menique izq. 3', false },
    { 4169,  'SKEL_L_Finger2?', 'Dedo izq. (variante)', false },
})

---@type table<integer, PropEditorBone>
PropEditorBoneById = {}
for _, bone in ipairs(PropEditorBones) do
    PropEditorBoneById[bone.id] = bone
end

--- Nombre presentable de un hueso, aunque no este en el catalogo: el pack usa
--- alguna variante suelta que no merece la pena adivinar, y es mejor ensenar el
--- numero que dejar el campo en blanco.
---@param id integer|nil
---@return string
function PropEditorBoneLabel(id)
    if id == nil then return 'sin hueso' end
    local bone = PropEditorBoneById[id]
    if bone then return ('%s (%d)'):format(bone.label, id) end
    return ('Hueso %d'):format(id)
end
