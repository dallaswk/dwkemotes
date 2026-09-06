-- MrWitt Duo Pose Pack #1 (Shared, 2x female)
-- Source files: stream/[Custom Emotes]/ (COMPARTIDAS/bba3d7-Duo Pose Pack #1)
-- Dict/clip tomados del Readme.txt del pack (clip = "mrwitt").
-- Cada duo tiene dos variantes femeninas (l/r, 1, back, b) que se emparejan.

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Shared = {
    ["mduo1_bfriend_a"] = {
        "mrwitt@best_friend_street_pose_f",
        "mrwitt",
        "Duo Best Friend (A)",
        "mduo1_bfriend_b",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_bfriend_b"] = {
        "mrwitt@best_friend_street_pose_f_1",
        "mrwitt",
        "Duo Best Friend (B)",
        "mduo1_bfriend_a",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_skate_a"] = {
        "mrwitt@skateboard_friends_adventure_f",
        "mrwitt",
        "Duo Skateboard (A)",
        "mduo1_skate_b",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_skate_b"] = {
        "mrwitt@skateboard_friends_adventure_f_back",
        "mrwitt",
        "Duo Skateboard (B)",
        "mduo1_skate_a",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_style_l"] = {
        "mrwitt@street_style_skateboard_f_l",
        "mrwitt",
        "Duo Street Style (L)",
        "mduo1_style_r",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_style_r"] = {
        "mrwitt@street_style_skateboard_f_r",
        "mrwitt",
        "Duo Street Style (R)",
        "mduo1_style_l",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_teen_l"] = {
        "mrwitt@teen_meeting_point_f_l",
        "mrwitt",
        "Duo Teen Meeting (L)",
        "mduo1_teen_r",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_teen_r"] = {
        "mrwitt@teen_meeting_point_f_r",
        "mrwitt",
        "Duo Teen Meeting (R)",
        "mduo1_teen_l",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_edited_a"] = {
        "mrwitt@well_edited_duo_f",
        "mrwitt",
        "Duo Well Edited (A)",
        "mduo1_edited_b",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["mduo1_edited_b"] = {
        "mrwitt@well_edited_duo_f_b",
        "mrwitt",
        "Duo Well Edited (B)",
        "mduo1_edited_a",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
}

RegisterAddonEmotes(CustomDP)
