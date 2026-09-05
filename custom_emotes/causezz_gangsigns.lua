-- Causezz 2nd Animation Pack
-- Source files: stream/[NUEVOS EMOTES]/causezz*@gangsign.ycd

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["causezz1"] = {
        "causezz1@gangsign",
        "barriosign_clip",
        "Causezz Sign 1",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["causezzsign1"] = {
        "causezzsign1@gangsign",
        "barrio_clip",
        "Causezz Sign 2",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["causezzsign2"] = {
        "causezzsign2@gangsign",
        "barrio_clip",
        "Causezz Sign 3",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["causezzgangsign3"] = {
        "causezzgangsin3@gangsign",
        "barrio_clip",
        "Causezz Sign 4",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["causezzgangsign5"] = {
        "causezzgangsign5@gangsign",
        "mexican_clip",
        "Causezz Sign 5",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
