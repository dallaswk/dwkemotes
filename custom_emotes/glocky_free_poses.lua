-- 94glocky Free Pose Pack 1
-- Source files: stream/[NUEVOS EMOTES]/*@94glocky.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["glockygdk1"] = {
        "gdk@1@94glocky",
        "gdk1_clip",
        "Glocky GDK 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockygdk2"] = {
        "gdk@2@94glocky",
        "gdk2_clip",
        "Glocky GDK 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockytata"] = {
        "oyk@tata@94glocky",
        "tataoyk_clip",
        "Glocky Tata",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockyblunt"] = {
        "props@blunt@1@94glocky",
        "pb194_clip",
        "Glocky Blunt Pose",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockygunpose"] = {
        "slime@gunpose@94glocky",
        "slimegp1_clip",
        "Glocky Gun Pose",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
