-- Azztek Free Pose Pack
-- Source files: stream/[NUEVOS EMOTES]/azztek@pose*.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["azztekpose2"] = {
        "azztek@pose2",
        "azztekpose2_clip",
        "Azztek Pose 2",
        AnimationOptions = { EmoteLoop = true },
    },
    ["azztekpose4"] = {
        "azztek@pose4",
        "azztekpose4_clip",
        "Azztek Pose 4",
        AnimationOptions = { EmoteLoop = true },
    },
    ["azztekpose5"] = {
        "azztek@pose5",
        "azztekpose5_clip",
        "Azztek Pose 5",
        AnimationOptions = { EmoteLoop = true },
    },
    ["azztekpose8"] = {
        "azztek@pose8",
        "azztekpose8_clip",
        "Azztek Pose 8",
        AnimationOptions = { EmoteLoop = true },
    },
    ["azztekpose9"] = {
        "azztek@pose9",
        "azztekpose9_clip",
        "Azztek Pose 9",
        AnimationOptions = { EmoteLoop = true },
    },
}

RegisterAddonEmotes(CustomDP)
