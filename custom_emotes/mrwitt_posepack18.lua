-- MrWitt Pose Pack #18
-- Source files: stream/NUEVOS EMOTES/81a0b9-Pose Pack #18/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["mrwittoldschoolhip"] = {
        "mrwitt@oldschool_hip_position_f",
        "mrwittoldschoolhip_clip",
        "MrWitt Oldschool Hip",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittnaturebench"] = {
        "mrwitt@nature_bench_rest_f",
        "mrwittnaturebench_clip",
        "MrWitt Nature Bench",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittmodellike"] = {
        "mrwitt@model_like_posing_f",
        "mrwittmodellike_clip",
        "MrWitt Model Posing",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittphoneleg"] = {
        "mrwitt@phone_leg_position_f",
        "mrwittphoneleg_clip",
        "MrWitt Phone Leg",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittrefreshment"] = {
        "mrwitt@refreshment_magic_f",
        "mrwittrefreshment_clip",
        "MrWitt Refreshment Magic",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
