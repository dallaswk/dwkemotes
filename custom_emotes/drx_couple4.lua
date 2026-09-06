-- DRX Couple Animations Pack #4 (Shared)
-- Source files: stream/[Custom Emotes]/ (COMPARTIDAS/8e5299-Couple Animations Pack #4)
-- Dict/clip tomados del favanims.txt del pack (clip = "drx").

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Shared = {
    ["drxcouple7f"] = {
        "drx@couple_female7",
        "drx",
        "DRX Couple 7 (F)",
        "drxcouple7m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxcouple7m"] = {
        "drx@couple_male7",
        "drx",
        "DRX Couple 7 (M)",
        "drxcouple7f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxcouple6f"] = {
        "drx@couple_female6",
        "drx",
        "DRX Couple 6 (F)",
        "drxcouple6m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxcouple6m"] = {
        "drx@couple_male6",
        "drx",
        "DRX Couple 6 (M)",
        "drxcouple6f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxcouple5f"] = {
        "drx@couple_female5",
        "drx",
        "DRX Couple 5 (F)",
        "drxcouple5m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxcouple5m"] = {
        "drx@couple_male5",
        "drx",
        "DRX Couple 5 (M)",
        "drxcouple5f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
}

RegisterAddonEmotes(CustomDP)
