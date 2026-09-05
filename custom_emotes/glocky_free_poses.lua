-- 94glocky Free Pose Pack 1
-- Source files: stream/[NUEVOS EMOTES]/*@94glocky.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["glockygdk1"] = {
        "gdk@1@94glocky",
        "gdk1_clip",
        "Glocky GDK 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockygdk2"] = {
        "gdk@2@94glocky",
        "gdk2_clip",
        "Glocky GDK 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["glockytata"] = {
        "oyk@tata@94glocky",
        "tataoyk_clip",
        "Glocky Tata",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'prop_cash_pile_02',
            PropBone = 28422,
            PropPlacement = {
                0.088,
                0.044,
                0.003,
                149.6422,
                -164.7312,
                25.2203
            },
            SecondProp = 'prop_cash_pile_02',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.088,
                0.044,
                0.033,
                149.6422,
                -164.7312,
                25.2203
            },
        },
    },
    ["glockyblunt"] = {
        "props@blunt@1@94glocky",
        "pb194_clip",
        "Glocky Blunt Pose",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'p_cs_joint_02',
            PropBone = 28422,
            PropPlacement = {
                0.07,
                -0.03,
                0.0,
                60.0,
                0.0,
                0.0
            },
            SecondProp = 'v_res_tt_lighter',
            SecondPropBone = 60309,
            SecondPropPlacement = {
                -0.03,
                -0.036,
                0.027,
                -168.0,
                -180.0,
                8.0
            },
        },
    },
    ["glockygunpose"] = {
        "slime@gunpose@94glocky",
        "slimegp1_clip",
        "Glocky Gun Pose",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'p_cs_joint_01',
            PropBone = 47419,
            PropPlacement = {
                0.015,
                -0.009,
                0.003,
                55.0,
                0.0,
                110.0
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
