-- noVa Mods Skateboards (Francis / Missi / Michyrou)
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/150147-Skateboards)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["skatesit2"] = {
        "female_sitting_skateboard2@francis",
        "female_sitting_skateboard2_clip",
        "Skateboard Sit 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["skatessmoke"] = {
        "f_sb_smoking@missi",
        "f_sb_smoking_clip",
        "Skateboard Smoke",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["skateholdgirl"] = {
        "skateboard_holding_girl@michyrou",
        "skateboard_holding_girl_clip",
        "Skateboard Hold Girl",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["skatestandmale"] = {
        "skateboard_standup_male@michyrou",
        "skateboard_standup_male_clip",
        "Skateboard Stand Male",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["skatesassy"] = {
        "skateboard_sassy@francis",
        "skateboard_sassy_clip",
        "Skateboard Sassy",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["skatecool"] = {
        "f_cool_skateboard@missi",
        "f_cool_skateboard_clip",
        "Skateboard Cool",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
