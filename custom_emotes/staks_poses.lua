-- Staks Pose Pack
-- Source files: stream/NUEVOS EMOTES/2e2b70-Staks Pose Pack/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["stakpose17"] = {
        "stakpose17@animation",
        "stakpose17_clip",
        "Stak Pose 17",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["stakpose19"] = {
        "stakpose19@animation",
        "stakpose19_clip",
        "Stak Pose 19",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["stakpose21"] = {
        "stakpose21@animation",
        "stakpose21_clip",
        "Stak Pose 21",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["stakpose22"] = {
        "stakpose22@animation",
        "stakpose22_clip",
        "Stak Pose 22",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
