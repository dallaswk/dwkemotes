-- Selfie Arm Pose Pack (SMO)
-- Source files: stream/NUEVOS EMOTES/smo@selfie_arm_*.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["selfiearm1"] = {
        "smo@selfie_arm_01",
        "selfiearm1_clip",
        "Selfie Arm 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["selfiearm2"] = {
        "smo@selfie_arm_02",
        "selfiearm2_clip",
        "Selfie Arm 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["selfiearm3"] = {
        "smo@selfie_arm_03",
        "selfiearm3_clip",
        "Selfie Arm 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["selfiearm4"] = {
        "smo@selfie_arm_04",
        "selfiearm4_clip",
        "Selfie Arm 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["selfiearm5"] = {
        "smo@selfie_arm_05",
        "selfiearm5_clip",
        "Selfie Arm 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["selfiearm6"] = {
        "smo@selfie_arm_06",
        "selfiearm6_clip",
        "Selfie Arm 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
