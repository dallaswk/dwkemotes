-- MrWitt Biker Pose Pack #1
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/773605-Biker Pose Pack #1)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["mrwittbikerhighfivef"] = {
        "mrwitt@motorcycle_high_five_female",
        "mrwitt",
        "Biker High Five F",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikerhighfivem"] = {
        "mrwitt@motorcycle_high_five_male",
        "mrwitt",
        "Biker High Five M",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikerprovocative"] = {
        "mrwitt@provocative_biker_girl",
        "mrwitt",
        "Biker Provocative",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikerrelaxed"] = {
        "mrwitt@relaxed_motorcycle_girl",
        "mrwitt",
        "Biker Relaxed",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikerbreak"] = {
        "mrwitt@relaxing_break",
        "mrwitt",
        "Biker Relaxing Break",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikergaze"] = {
        "mrwitt@seductive_biker_gaze",
        "mrwitt",
        "Biker Seductive Gaze",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittbikerflair"] = {
        "mrwitt@seductive_motorcycle_flair",
        "mrwitt",
        "Biker Seductive Flair",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
