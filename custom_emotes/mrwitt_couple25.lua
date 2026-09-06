-- MrWitt Couple Pose Pack #25 (Shared)
-- Source files: stream/[Custom Emotes]/ (COMPARTIDAS/484fd7-Couple Pose Pack #25)
-- Dict/clip tomados del Readme.txt del pack (clip = "mrwitt").

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Shared = {
    ["mcouple25_leaked_f"] = {
        "mrwitt@leaked_picture_scene_f",
        "mrwitt",
        "Couple Leaked Picture (F)",
        "mcouple25_leaked_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_leaked_m"] = {
        "mrwitt@leaked_picture_scene_m",
        "mrwitt",
        "Couple Leaked Picture (M)",
        "mcouple25_leaked_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_helmet_f"] = {
        "mrwitt@beautiful_helmet_moment_f",
        "mrwitt",
        "Couple Helmet Moment (F)",
        "mcouple25_helmet_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_helmet_m"] = {
        "mrwitt@beautiful_helmet_moment_m",
        "mrwitt",
        "Couple Helmet Moment (M)",
        "mcouple25_helmet_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_handhold_f"] = {
        "mrwitt@hand_holding_couples_f",
        "mrwitt",
        "Couple Hand Holding (F)",
        "mcouple25_handhold_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_handhold_m"] = {
        "mrwitt@hand_holding_couples_m",
        "mrwitt",
        "Couple Hand Holding (M)",
        "mcouple25_handhold_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_bank_f"] = {
        "mrwitt@couple_bank_affection_f",
        "mrwitt",
        "Couple Bank Affection (F)",
        "mcouple25_bank_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_bank_m"] = {
        "mrwitt@couple_bank_affection_m",
        "mrwitt",
        "Couple Bank Affection (M)",
        "mcouple25_bank_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_ck_f"] = {
        "mrwitt@calvin_klein_photo_pose_f",
        "mrwitt",
        "Couple Calvin Klein (F)",
        "mcouple25_ck_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mcouple25_ck_m"] = {
        "mrwitt@calvin_klein_photo_pose_m",
        "mrwitt",
        "Couple Calvin Klein (M)",
        "mcouple25_ck_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
}

RegisterAddonEmotes(CustomDP)
