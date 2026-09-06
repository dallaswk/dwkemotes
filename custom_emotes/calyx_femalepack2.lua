-- Calyx Female Pack 2
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/ff7a37-femalepack2@calyx)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["calyxf6"] = {
        "female006@calyx",
        "female006_clip",
        "Calyx Female 6",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["calyxf7"] = {
        "female007@calyx",
        "female007_clip",
        "Calyx Female 7",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["calyxf7hh"] = {
        "female007_hh@calyx",
        "female007_hh_clip",
        "Calyx Female 7 HH",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["calyxf8"] = {
        "female008@calyx",
        "female008_clip",
        "Calyx Female 8",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["calyxf9"] = {
        "female009@calyx",
        "female009_clip",
        "Calyx Female 9",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["calyxf10"] = {
        "female010@calyx",
        "female010_clip",
        "Calyx Female 10",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
