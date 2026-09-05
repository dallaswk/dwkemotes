-- 94glocky Free Pose Pack 2
-- Source files: stream/NUEVOS EMOTES/d0bc5b-94FREEPOSEPACK2/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["glockydoak2"] = {
        "doak@2@94glocky",
        "doak2_clip",
        "Glocky Doak 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockygunposefrom"] = {
        "gunpose@from94",
        "gunpose_clip",
        "Glocky Gun Pose From",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockyslimekf2"] = {
        "slime@kf2@94glocky",
        "slimekf2_clip",
        "Glocky Slime KF2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockyslimeoyk"] = {
        "slime@oyk@94glocky",
        "slimeoyk_clip",
        "Glocky Slime Oyk",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockysmmmbf"] = {
        "smm@mbf@94glocky",
        "smmmbf_clip",
        "Glocky SMM MBF",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
