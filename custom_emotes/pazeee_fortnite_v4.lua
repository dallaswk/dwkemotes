-- Pazeee Fortnite Dance Pack V4
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
        "Fortnite Starlit",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfboneybounce"] = {
        "pazeeefortniteboneybounce@animations",
        "pazeeefortniteboneybounceclip",
        "Fortnite Boney Bounce",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfevilplan"] = {
        "pazeeefortniteevilplan@animations",
        "pazeeefortniteevilplanclip",
        "Fortnite Evil Plan",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfdancindomino"] = {
        "pazeeefortnitedancindomino@animations",
        "pazeeefortnitedancindominoclip",
        "Fortnite Dancin' Domino",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfpointandstrut"] = {
        "pazeeefortnitepointandstrut@animations",
        "pazeeefortnitepointandstrutclip",
        "Fortnite Point And Strut",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfthedancelaroi"] = {
        "pazeeefortnitethedancelaroi@animations",
        "pazeeefortnitethedancelaroiclip",
        "Fortnite The Dance Laroi",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfcopines"] = {
        "pazeeefortnitecopines@animations",
        "pazeeefortnitecopinesclip",
        "Fortnite Copines",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfmikubeam"] = {
        "pazeeefortnitemikubeam@animations",
        "pazeeefortnitemikubeamclip",
        "Fortnite Miku Miku Beam",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfitstrue"] = {
        "pazeeefortniteitstrue@animations",
        "pazeeefortniteitstrueclip",
        "Fortnite It's True",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfimout"] = {
        "pazeeefortniteimout@animations",
        "pazeeefortniteimoutclip",
        "Fortnite I'm Out",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfscenario"] = {
        "pazeeefortnitescenario@animations",
        "pazeeefortnitescenarioclip",
        "Fortnite Scenario",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfjabbaswitchway"] = {
        "pazeeefortnitejabbaswitchway@animations",
        "pazeeefortnitejabbaswitchwayclip",
        "Fortnite Jabba Switchway",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgomufasa"] = {
        "pazeeefortnitegomufasa@animations",
        "pazeeefortnitegomufasaclip",
        "Fortnite Go Mufasa",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgomufasamove"] = {
        "pazeeefortnitegomufasamove@animations",
        "pazeeefortnitegomufasamoveclip",
        "Fortnite Go Mufasa Move",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfeverybodylovesme"] = {
        "pazeeefortniteeverybodylovesme@animations",
        "pazeeefortniteeverybodylovesmeclip",
        "Fortnite Everybody Loves Me",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgetgriddy"] = {
        "pazeeefortnitegetgriddy@animations",
        "pazeeefortnitegetgriddyclip",
        "Fortnite Get Griddy",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfgetgriddymove"] = {
        "pazeeefortnitegetgriddymove@animations",
        "pazeeefortnitegetgriddymoveclip",
        "Fortnite Get Griddy Move",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pflofiheadbang"] = {
        "pazeeefortnitelofiheadbang@animations",
        "pazeeefortnitelofiheadbangclip",
        "Fortnite Lo-Fi Headbang",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfrebellious"] = {
        "pazeeefortniterebellious@animations",
        "pazeeefortniterebelliousclip",
        "Fortnite Rebellious",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfbackon74"] = {
        "pazeeefortnitebackon74@animations",
        "pazeeefortnitebackon74clip",
        "Fortnite Back On 74",
        AnimationOptions = { EmoteLoop = true },
    },
    ["pfbackon74move"] = {
        "pazeeefortnitebackon74move@animations",
        "pazeeefortnitebackon74moveclip",
        "Fortnite Back On 74 Move",
        AnimationOptions = { EmoteLoop = true },
    },
}

RegisterAddonEmotes(CustomDP)
