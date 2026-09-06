-- Poppin Pose Packs (POSEPACKV3 + poppinposepack + pose)
-- Source files: stream/NUEVOS EMOTES/2dceba-POSEPACKV3/, ac0138-poppinposepack/, 3524de-pose/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
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
    ["posepoppin5"] = {
        "posepoppin5@anim",
        "posepoppin5_clip",
        "Pose Poppin 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose5poppin"] = {
        "pose5@poppin",
        "pose5_clip",
        "Poppin Pose 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["pose9poppin"] = {
        "pose9@poppin",
        "pose9_clip",
        "Poppin Pose 9",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.PropEmotes = {
    ["posepoppin3"] = {
        "posepoppin3@anim",
        "posepoppin3_clip",
        "Pose Poppin 3",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'beanmachine_cup2',
            PropBone = 60309,
            PropPlacement = {
                0.080,
                -0.090,
                0.050,
                275.00,
                160.00,
                7.00
            },
        },
    },
    ["pose3poppin"] = {
        "pose3@poppin",
        "pose3_clip",
        "Poppin Pose 3b",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'prop_cigar_03',
            PropBone = 28422,
            PropPlacement = {
                0.140,
                0.386,
                -0.060,
                183.00,
                316.00,
                330.00
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
