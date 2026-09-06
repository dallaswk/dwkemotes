-- Poppin R40s Pose Pack
-- Source files: stream/NUEVOS EMOTES/af3f03-poppinr40s/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["poppinr40s1"] = {
        "poppinr40s1@anim",
        "poppinr40s1_clip",
        "Poppin R40s 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["poppin40s2"] = {
        "poppin40s2@anim",
        "poppin40s2_clip",
        "Poppin 40s 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["poppinr40s3"] = {
        "poppinr40s3@anim",
        "poppinr40s3_clip",
        "Poppin R40s 3",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            Prop = 'p_cs_joint_02',
            PropBone = 28422,
            PropPlacement = {
                0.116,
                0.026,
                -0.026,
                69.00,
                107.00,
                18.00
            },
            SecondProp = 'prop_phone_ing',
            SecondPropBone = 60309,
            SecondPropPlacement = {
                0.080,
                0.026,
                0.000,
                71.00,
                158.00,
                177.00
            },
        },
    },
    ["poppinr40s5"] = {
        "poppinr40s5@anim",
        "poppinr40s5_clip",
        "Poppin R40s 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["traykpoppin"] = {
        "traykpoppin@anim",
        "traykpoppin_clip",
        "Trayk Poppin",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
