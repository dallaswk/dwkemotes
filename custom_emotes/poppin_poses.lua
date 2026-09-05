-- Poppin Pose Packs (POSEPACKV3 + poppinposepack + pose)
-- Source files: stream/NUEVOS EMOTES/2dceba-POSEPACKV3/, ac0138-poppinposepack/, 3524de-pose/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["flexonem"] = {
        "flexonem@poppin",
        "flexonem_clip",
        "Poppin Flex On Em",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["fuckmyopps"] = {
        "fuckmyopps@poppin",
        "fuckmyopps_clip",
        "Poppin Fuck My Opps",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["penetrateem"] = {
        "penetrateem@poppin",
        "penetrateem_clip",
        "Poppin Penetrate Em",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["yusatarget"] = {
        "yusatarget@poppin",
        "yusatarget_clip",
        "Poppin Yusa Target",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["poppinpose3"] = {
        "poppinpose3@anim",
        "poppinpose3_clip",
        "Poppin Pose 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepoppin3"] = {
        "posepoppin3@anim",
        "posepoppin3_clip",
        "Pose Poppin 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepoppin4"] = {
        "posepoppin4@anim",
        "posepoppin4_clip",
        "Pose Poppin 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepoppin5"] = {
        "posepoppin5@anim",
        "posepoppin5_clip",
        "Pose Poppin 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["posepoppin6"] = {
        "posepoppin6@anim",
        "posepoppin6_clip",
        "Pose Poppin 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose3poppin"] = {
        "pose3@poppin",
        "pose3_clip",
        "Poppin Pose 3b",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose5poppin"] = {
        "pose5@poppin",
        "pose5_clip",
        "Poppin Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose6poppin"] = {
        "pose6@poppin",
        "pose6_clip",
        "Poppin Pose 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose8poppin"] = {
        "pose8@poppin",
        "pose8_clip",
        "Poppin Pose 8",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose9poppin"] = {
        "pose9@poppin",
        "pose9_clip",
        "Poppin Pose 9",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose10poppin"] = {
        "pose10@poppin",
        "pose10_clip",
        "Poppin Pose 10",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
