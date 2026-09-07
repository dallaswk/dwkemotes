-- DRX Couple Animation Pack #5 (with 2x Female Anims)
-- Source files: stream/[Custom Emotes]/ (COMPARTIDAS/f398a6-Couple Animation Pack #5 (with 2x Female Anims))
-- Dict/clip tomados del favanims.txt del pack (clip = "drx").
-- Las posiciones "luvlook" son duo sin genero definido; en "romantic/gethug/getkiss"
-- se mapea la variante _f con su pareja _m.

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

-- Singles (2x female anims independientes)
CustomDP.Emotes = {
    ["drxval_rosehead"] = {
        "drx@valentine_f_rosehead",
        "drx",
        "Valentine Rosehead",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

CustomDP.Shared = {
    ["drxval_romantic_f"] = {
        "drx@c_valentine_f_romantic",
        "drx",
        "Valentine Romantic (F)",
        "drxval_romantic_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_romantic_m"] = {
        "drx@c_valentine_m_romantic",
        "drx",
        "Valentine Romantic (M)",
        "drxval_romantic_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_gethug_f"] = {
        "drx@c_valentine_f_gethug",
        "drx",
        "Valentine Get Hug (F)",
        "drxval_gethug_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_gethug_m"] = {
        "drx@c_valentine_m_huggirl",
        "drx",
        "Valentine Get Hug (M)",
        "drxval_gethug_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_luvlook_f"] = {
        "drx@c_valentine_f_luvlook",
        "drx",
        "Valentine Love Look (F)",
        "drxval_luvlook_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_luvlook_m"] = {
        "drx@c_valentine_m_luvlook",
        "drx",
        "Valentine Love Look (M)",
        "drxval_luvlook_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_getkiss_f"] = {
        "drx@c_valentine_f_getkiss",
        "drx",
        "Valentine Get Kiss (F)",
        "drxval_getkiss_m",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
    ["drxval_getkiss_m"] = {
        "drx@c_valentine_m_kissgirl",
        "drx",
        "Valentine Get Kiss (M)",
        "drxval_getkiss_f",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false, SyncOffsetFront = 0.5 },
    },
}

RegisterAddonEmotes(CustomDP)
