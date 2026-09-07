-- ============================================================================
--  Midnight Clique - gang sign propio
--  --------------------------------------------------------------------------
--  Animacion hecha desde cero en Blender sobre el esqueleto de ped de GTA V y
--  exportada con Sollumz. Fuentes del proyecto:
--    D:\Proyectos\Personal\Blender\scripts\mncsign\  (pose_lib, pose_mnc, anim_mnc)
--  Asset: stream/[Custom Emotes]/Midnight Clique/dwk@mncsign.ycd
--
--  El dict se llamaba `dwk@mnc` y se renombro a `dwk@mncsign` porque el cliente
--  se quedaba pegado a una version antigua del .ycd por cache: mismo nombre de
--  archivo, contenido nuevo, y el juego seguia reproduciendo la vieja. Cambiar
--  el nombre del asset es la unica forma determinista de forzar carga limpia.
--
--  La mano DERECHA forma la M (indice, corazon y anular hacia abajo) y la
--  IZQUIERDA la C (arco de pulgar e indice). Van cruzadas a proposito: el ped
--  mira hacia la camara, asi que su derecha cae a la izquierda de quien lo ve
--  y el gesto se lee "M C" en ese orden.
--
--  Es una pose sostenida: el .ycd son 4 segundos en bucle limpio (el ultimo
--  frame repite el primero) con un ciclo de respiracion, sin la subida de
--  brazos. Esa entrada la hace el propio blend-in de TaskPlayAnim; animarla
--  aqui haria que el personaje levantase las manos dos veces.
-- ============================================================================

local ENABLED = true -- Set to false to disable this pack

if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local MidnightClique = {}

MidnightClique.Emotes = {
    ["mncsign"] = {
        "dwk@mncsign",
        "mncsign",
        "Midnight Clique",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(MidnightClique)
