-- Seimen Instagram Pose Pack
-- Source files: stream/[NUEVOS EMOTES]/instagrampose*@seimen.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["instagrampose"] = {
        "instagrampose@seimen",
        "instagrampose_clip",
        "Instagram Pose",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instagrampose5"] = {
        "instagrampose5@seimen",
        "instagrampose5_clip",
        "Instagram Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instagrampose6"] = {
        "instagrampose6@seimen",
        "instagrampose6_clip",
        "Instagram Pose 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instagrampose7"] = {
        "instagrampose7@seimen",
        "instagrampose7_clip",
        "Instagram Pose 7",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instagrampose8"] = {
        "instagrampose8@seimen",
        "instagrampose8_clip",
        "Instagram Pose 8",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["instagrampose9"] = {
        "instagrampose9@seimen",
        "instagrampose9_clip",
        "Instagram Pose 9",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
