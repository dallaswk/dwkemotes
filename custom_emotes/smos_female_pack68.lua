-- Smos Female Pack #68
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/ce7997-Female Pack #68)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["sp68_model217"] = {
        "smo@female_model_217",
        "f_model_217_clip",
        "FP68 Model 217",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["sp68_model218"] = {
        "smo@female_model_218",
        "f_model_218_clip",
        "FP68 Model 218",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["sp68_model219"] = {
        "smo@female_model_219",
        "f_model_219_clip",
        "FP68 Model 219",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["sp68_selfie151"] = {
        "smo@female_selfie_151",
        "f_selfie_151_clip",
        "FP68 Selfie 151",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.PropEmotes = {
    ["sp68_selfie149"] = {
        "smo@female_selfie_149",
        "f_selfie_149_clip",
        "FP68 Selfie 149",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'prop_npc_phone',
            PropBone = 28422,
            PropPlacement = {
                -0.506,
                0.375,
                -0.170,
                342.00,
                280.00,
                0.00
            },
        },
    },
    ["sp68_selfie150"] = {
        "smo@female_selfie_150",
        "f_selfie_150_clip",
        "FP68 Selfie 150",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'prop_amb_phone',
            PropBone = 60309,
            PropPlacement = {
                0.070,
                0.030,
                0.036,
                266.00,
                300.00,
                0.00
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
