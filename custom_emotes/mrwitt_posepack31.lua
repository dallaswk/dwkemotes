-- MrWitt Pose Pack #31
-- Source files: stream/NUEVOS EMOTES/bfdce6-Pose Pack #31/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["mrwitthipemphasis"] = {
        "mrwitt@hip_emphasized_hand_placement_f",
        "mrwitthipemphasis_clip",
        "MrWitt Hip Emphasized",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittinstaaesthetic"] = {
        "mrwitt@instagram_aesthetics_f",
        "mrwittinstaaesthetic_clip",
        "MrWitt Instagram Aesthetic",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittinstamodel"] = {
        "mrwitt@instagram_model_wine_glass_f",
        "mrwittinstamodel_clip",
        "MrWitt Instagram Model Wine",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwitttightdress"] = {
        "mrwitt@tight_dress_sensuality_f",
        "mrwitttightdress_clip",
        "MrWitt Tight Dress",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwitturbanstreet"] = {
        "mrwitt@urban_street_modeling_f",
        "mrwitturbanstreet_clip",
        "MrWitt Urban Street",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
