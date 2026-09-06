-- Pazeee Royale Dance Pack V4 (antes "Fortnite")
-- Source files: stream/[Custom Emotes]/Pazeee Fortnite V4/

local ENABLED = true
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Dances = {
    ["pfstarlit"] = {
        "pazeeefortnitestarlit@animations",
        "pazeeefortnitestarlitclip",
        "Royale Starlit",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfboneybounce"] = {
        "pazeeefortniteboneybounce@animations",
        "pazeeefortniteboneybounceclip",
        "Royale Boney Bounce",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfevilplan"] = {
        "pazeeefortniteevilplan@animations",
        "pazeeefortniteevilplanclip",
        "Royale Evil Plan",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfdancindomino"] = {
        "pazeeefortnitedancindomino@animations",
        "pazeeefortnitedancindominoclip",
        "Royale Dancin' Domino",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfpointandstrut"] = {
        "pazeeefortnitepointandstrut@animations",
        "pazeeefortnitepointandstrutclip",
        "Royale Point And Strut",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfthedancelaroi"] = {
        "pazeeefortnitethedancelaroi@animations",
        "pazeeefortnitethedancelaroiclip",
        "Royale The Dance Laroi",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfcopines"] = {
        "pazeeefortnitecopines@animations",
        "pazeeefortnitecopinesclip",
        "Royale Copines",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfmikubeam"] = {
        "pazeeefortnitemikubeam@animations",
        "pazeeefortnitemikubeamclip",
        "Royale Miku Miku Beam",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfitstrue"] = {
        "pazeeefortniteitstrue@animations",
        "pazeeefortniteitstrueclip",
        "Royale It's True",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfimout"] = {
        "pazeeefortniteimout@animations",
        "pazeeefortniteimoutclip",
        "Royale I'm Out",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfscenario"] = {
        "pazeeefortnitescenario@animations",
        "pazeeefortnitescenarioclip",
        "Royale Scenario",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfjabbaswitchway"] = {
        "pazeeefortnitejabbaswitchway@animations",
        "pazeeefortnitejabbaswitchwayclip",
        "Royale Jabba Switchway",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgomufasa"] = {
        "pazeeefortnitegomufasa@animations",
        "pazeeefortnitegomufasaclip",
        "Royale Go Mufasa",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfeverybodylovesme"] = {
        "pazeeefortniteeverybodylovesme@animations",
        "pazeeefortniteeverybodylovesmeclip",
        "Royale Everybody Loves Me",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgetgriddy"] = {
        "pazeeefortnitegetgriddy@animations",
        "pazeeefortnitegetgriddyclip",
        "Royale Get Griddy",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pflofiheadbang"] = {
        "pazeeefortnitelofiheadbang@animations",
        "pazeeefortnitelofiheadbangclip",
        "Royale Lo-Fi Headbang",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfrebellious"] = {
        "pazeeefortniterebellious@animations",
        "pazeeefortniterebelliousclip",
        "Royale Rebellious",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfbackon74"] = {
        "pazeeefortnitebackon74@animations",
        "pazeeefortnitebackon74clip",
        "Royale Back On 74",
        AnimationOptions = { EmoteLoop = true },
    },
}

RegisterAddonEmotes(CustomDP)
