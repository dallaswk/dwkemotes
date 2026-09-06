-- noVa Mods Skateboards (Francis / Missi / Michyrou)
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/150147-Skateboards)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    -- skatesit3, no skatesit2: ese nombre ya lo ocupa la pose de Chocoholic
    -- que vive en RP.PropEmotes (AnimationList.lua). Con las dos registradas
    -- el menu avisaba del duplicado y se quedaba con una u otra segun el orden
    -- en que Lua recorriese las tablas, que no es estable entre reinicios.
}

CustomDP.PropEmotes = {
    ["skatesit3"] = {
        "female_sitting_skateboard2@francis",
        "female_sitting_skateboard2_clip",
        "Skateboard Sit 3",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'rpemotesreborn_skateboard02',
            PropBone = 28422,
            PropPlacement = {
                -0.284,
                -0.130,
                -0.276,
                39.00,
                15.00,
                283.00
            },
            SecondProp = 'mne_can_n',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.266,
                0.088,
                0.106,
                9.00,
                335.00,
                17.00
            },
        },
    },
    ["skatessmoke"] = {
        "f_sb_smoking@missi",
        "f_sb_smoking_clip",
        "Skateboard Smoke",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'rpemotesreborn_skateboard01',
            PropBone = 28422,
            PropPlacement = {
                -0.028,
                -0.026,
                0.080,
                186.00,
                0.00,
                100.00
            },
            SecondProp = 'mne_can_n',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                -0.204,
                -0.486,
                -0.402,
                30.00,
                0.00,
                355.00
            },
        },
    },
    ["skateholdgirl"] = {
        "skateboard_holding_girl@michyrou",
        "skateboard_holding_girl_clip",
        "Skateboard Hold Girl",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'rpemotesreborn_skateboard02',
            PropBone = 28422,
            PropPlacement = {
                0.090,
                0.014,
                0.030,
                207.00,
                0.00,
                80.00
            },
        },
    },
    ["skatestandmale"] = {
        "skateboard_standup_male@michyrou",
        "skateboard_standup_male_clip",
        "Skateboard Stand Male",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'v_res_skateboard',
            PropBone = 52301,
            PropPlacement = {
                0.092,
                0.186,
                0.006,
                151.00,
                326.00,
                286.00
            },
        },
    },
    ["skatesassy"] = {
        "skateboard_sassy@francis",
        "skateboard_sassy_clip",
        "Skateboard Sassy",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'rpemotesreborn_skateboard01',
            PropBone = 28422,
            PropPlacement = {
                0.040,
                0.116,
                -0.130,
                8.00,
                339.00,
                64.00
            },
        },
    },
    ["skatecool"] = {
        "f_cool_skateboard@missi",
        "f_cool_skateboard_clip",
        "Skateboard Cool",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'v_res_skateboard',
            PropBone = 52301,
            PropPlacement = {
                0.026,
                -0.200,
                -0.144,
                261.00,
                104.00,
                1.00
            },
        },
    },
}

RegisterAddonEmotes(CustomDP)
