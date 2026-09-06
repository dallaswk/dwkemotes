-- Clyde Female Pose Pack #1
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/0514b7-Female_Pose_Pack#1)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["clydepose1"] = {
        "female_pose01@clyde",
        "female_pose01_clip",
        "Clyde Pose 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["clydepose2"] = {
        "female_pose02@clyde",
        "female_pose02_clip",
        "Clyde Pose 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["clydepose3"] = {
        "female_pose03@clyde",
        "female_pose03_clip",
        "Clyde Pose 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["clydepose4"] = {
        "female_pose04@clyde",
        "female_pose04_clip",
        "Clyde Pose 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["clydepose5"] = {
        "female_pose05@clyde",
        "female_pose05_clip",
        "Clyde Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
