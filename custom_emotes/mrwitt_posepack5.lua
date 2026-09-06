-- MrWitt Posepack #5 (Anna Female)
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/b5ecee-Posepack #5)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["mrwittanna1"] = {
        "mrwitt@anna_female_01",
        "mrwitt",
        "MrWitt Anna 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittanna2"] = {
        "mrwitt@anna_female_02",
        "mrwitt",
        "MrWitt Anna 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittanna3"] = {
        "mrwitt@anna_female_03",
        "mrwitt",
        "MrWitt Anna 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittanna4"] = {
        "mrwitt@anna_female_04",
        "mrwitt",
        "MrWitt Anna 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["mrwittanna5"] = {
        "mrwitt@anna_female_05",
        "mrwitt",
        "MrWitt Anna 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
