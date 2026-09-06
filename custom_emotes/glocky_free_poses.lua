-- 94glocky Free Pose Pack 1
-- Source files: stream/[NUEVOS EMOTES]/*@94glocky.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["glockygdk2"] = {
        "gdk@2@94glocky",
        "gdk2_clip",
        "Glocky GDK 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.PropEmotes = {
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
                0.066,
                0.026,
                -0.014,
                160.00,
                143.00,
                40.00
            },
            SecondProp = 'prop_cash_pile_02',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.080,
                0.014,
                -0.050,
                29.00,
                150.00,
                221.00
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
                0.090,
                0.040,
                -0.040,
                93.00,
                255.00,
                38.00
            },
            SecondProp = 'samnick_prop_lighter01',
            SecondPropBone = 60309,
            SecondPropPlacement = {
                0.066,
                0.014,
                0.014,
                274.00,
                208.00,
                32.00
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
                -0.040,
                -0.014,
                0.026,
                186.00,
                206.00,
                157.00
            },
            SecondProp = 'samnick_prop_lighter01',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.066,
                0.014,
                -0.026,
                256.00,
                205.00,
                30.00
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
