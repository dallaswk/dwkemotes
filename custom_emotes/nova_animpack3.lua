-- noVa Mods Animationpack3 (Cosmo / t4x4k)
-- Source files: stream/[Custom Emotes]/ (HABBO NUEVAS/41680b-Animationpack3)

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Emotes = {
    ["nova_fcar001"] = {
        "f_car_001@cosmo",
        "f_car_001_clip",
        "F Car 001",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_girlpistol"] = {
        "girlpistol@cosmo",
        "girlpistol_clip",
        "Girl Pistol",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_gunface"] = {
        "gun_face@cosmo",
        "gun_face_clip",
        "Gun Face",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_sitbourbonsolo"] = {
        "t4x4k@sitbourbonsolo",
        "t4x4k_clip",
        "Sit Bourbon Solo",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
    ["nova_sitburbonsolof"] = {
        "t4x4k@sitburbonsolof",
        "t4x4k_clip",
        "Sit Bourbon Solo F",
        AnimationOptions = { EmoteLoop = true, EmoteMoving = false },
    },
}

RegisterAddonEmotes(CustomDP)
