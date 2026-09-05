-- Gelo "Cant Be Fucked With" Pack
-- Source files: stream/[NUEVOS EMOTES]/gelo@*.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["gelowawg"] = {
        "gelo@wawg",
        "wawg_clip",
        "Gelo Wawg",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["gelocuffher"] = {
        "gelo@cuffher",
        "cuffher_clip",
        "Gelo Cuff Her",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["gelowrist"] = {
        "gelo@wrist",
        "wrist_clip",
        "Gelo Wrist",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["gelostorerun"] = {
        "gelo@storerun",
        "storerun_clip",
        "Gelo Store Run",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
