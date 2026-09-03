-- Pazeee Animation Pack - Custom Category
-- Groups all pazeee emotes under a single menu category.
--
-- Desactivado: agrupaba las ~200 animaciones de pazeee en una seccion propia
-- ("New Roleplay Emotes") en vez de dejarlas caer en la categoria que les toca
-- por tipo. Con esto apagado, cada una va a su sitio:
--   EmoteType.SHARED      -> Compartidas
--   EmoteType.PROP_EMOTES -> Objetos
--   EmoteType.EMOTES      -> Animaciones
-- Ponlo en true para recuperar la seccion agrupada.

local ENABLED = false -- Set to false to disable this category
if not ENABLED then return end

Config.CustomCategories[('New Roleplay Emotes')] = {
    [EmoteType.SHARED] = {
        "pmotorb", "pmotorc", "pholdlega", "pholdlegb", "pstucklega", "pstucklegb",
        "pfunnypuncha", "pfunnypunchb"
    },
    [EmoteType.EMOTES] = {
        "parroganta", "parrogantb", "parrogantc", "pbravea", "pbraveb", "pbravec", "pbraved",
        "pcheckpocketsa", "pdeadb", "penjoyviewa", "penjoyviewb", "pfisthandskya", "pfisthandskyb",
        "pgamehanda", "pgamehandb", "phideandseeka", "phideandseekb", "pinhalea", "pmotord",
        "pmotore", "pmotorf", "ppalmfistsalutea", "ppalmfistsaluteb", "ppickupa", "ppickupb", "ppickupd",
        "ppickupe", "ppickuph", "ppickupi", "ppickupj", "ppickupm", "psada", "psadb", "psadc", "psadd", "pteamdisc2a", "pteamdisc2b", "pteamdisc2c",
        "ptherea", "pwhatsthata", "pyappinga", "pyappingb", "pyappingc", "pyappingd",
        "pmonggoa", "pmonggob", "pmonggoc", "pmonggod", "pmonggoe", "pmonggof", "ppoopa", "psitgrounda",
        "psitgroundd", "psitgrounde", "pmonkeya", "pmonkeyb", "pmonkeyc"
    },
    [EmoteType.PROP_EMOTES] = {
        "pcheckpocketsb", "pegranga", "pegrangb", "penjoyviewc", "penjoyviewd", "pfakeblinda",
        "pkingchaira", "pkingchairb", "pkingchairc", "pkingchaird", "pkingchaire", "ppoopb", "ppoopc", "ppoopd", "psitgroundf", "psitgroundg", "psitgroundh"
    }
}
