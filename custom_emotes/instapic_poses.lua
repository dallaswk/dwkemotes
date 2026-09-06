-- Seimen Instapic Pose Pack (antes "Instagram Pose")
-- Source files: stream/[NUEVOS EMOTES]/instagrampose*@seimen.ycd
--
-- Los dict y clip de abajo siguen diciendo "instagrampose": son los nombres
-- internos de los .ycd y cambiarlos exige regenerar los archivos. No se ven en
-- ningun sitio del juego; lo que lee el jugador son la clave y la etiqueta.

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["instapicpose"] = {
        "instagrampose@seimen",
        "instagrampose_clip",
        "Instapic Pose",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instapicpose5"] = {
        "instagrampose5@seimen",
        "instagrampose5_clip",
        "Instapic Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instapicpose7"] = {
        "instagrampose7@seimen",
        "instagrampose7_clip",
        "Instapic Pose 7",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instapicpose9"] = {
        "instagrampose9@seimen",
        "instagrampose9_clip",
        "Instapic Pose 9",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.PropEmotes = {
    ["instapicpose8"] = {
        "instagrampose8@seimen",
        "instagrampose8_clip",
        "Instapic Pose 8",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'prop_npc_phone_02',
            PropBone = 28422,
            PropPlacement = {
                0.090,
                0.014,
                0.050,
                227.00,
                175.00,
                0.00
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
