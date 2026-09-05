-- RealDiday Male Pose Pack
-- Source files: stream/[NUEVOS EMOTES]/posepack*@diday.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["posepack1"] = {
        "posepack1@diday",
        "posepack1_clip",
        "Male Pose 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepack2"] = {
        "posepack2@diday",
        "posepack2_clip",
        "Male Pose 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepack3"] = {
        "posepack3@diday",
        "posepack3_clip",
        "Male Pose 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepack4"] = {
        "posepack4@diday",
        "posepack4_clip",
        "Male Pose 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepack5"] = {
        "posepack5@diday",
        "posepack5_clip",
        "Male Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepack6"] = {
        "posepack6@diday",
        "posepack6_clip",
        "Male Pose 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
