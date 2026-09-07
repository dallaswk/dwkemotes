-- Smos Free Female Pack #3
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/cc9ae1-Free Female Pack #3)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["ffp_lean"] = {
        "anim@female_lean_01",
        "f_lean_01_clip",
        "FFP Lean",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["ffp_model1"] = {
        "anim@female_model_01",
        "f_model_01_clip",
        "FFP Model 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["ffp_model2"] = {
        "anim@female_model_02",
        "f_model_02_clip",
        "FFP Model 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["ffp_model3"] = {
        "anim@female_model_03",
        "f_model_03_clip",
        "FFP Model 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.PropEmotes = {
}

RegisterAddonEmotes(CustomDP)
