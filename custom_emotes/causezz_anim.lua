-- Causezz Animation Pack
-- Source files: stream/NUEVOS EMOTES/9e83a3-12b9d9-Causezz Anim/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["cbluuu"] = {
        "cbluuu@animation",
        "cbluuu_clip",
        "Causezz Cbluuu",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["die4z"] = {
        "die4z@animation",
        "die4z_clip",
        "Causezz Die4z",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["droppingmakk"] = {
        "droppingmakk@animation",
        "droppingmakk_clip",
        "Causezz Dropping Makk",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["grape"] = {
        "grape@animation",
        "grape_clip",
        "Causezz Grape",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["hatzk"] = {
        "hatzk@animation",
        "hatzk_clip",
        "Causezz Hatzk",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
