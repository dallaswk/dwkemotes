-- noVa Mods Animationspack 4 (Cosmo / Francis / Layla)
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/20eb10-Animationspack 4)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["nova_skatercap"] = {
        "skatergirl_cap@francis",
        "skatergirl_cap_clip",
        "Skater Girl Cap",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
            PedHeightOffset = 1.05,
        },
    },
    ["nova_standduo1a"] = {
        "stand_duo1a@cosmo",
        "stand_duo1a_clip",
        "Stand Duo 1A",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_standduo1b"] = {
        "stand_duo1b@cosmo",
        "stand_duo1b_clip",
        "Stand Duo 1B",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_m007l"] = {
        "m_007l@layla",
        "m_007l_clip",
        "M 007L",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_malepose"] = {
        "male_posing@cosmo",
        "male_posing_clip",
        "Male Posing",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_selfie007"] = {
        "selfiepose_007@cosmo",
        "selfiepose_007_clip",
        "Selfie Pose 007",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
