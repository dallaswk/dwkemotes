fx_version 'cerulean'
game 'gta5'

name 'dwkemotes'
author 'dwk'
description 'Menu de emotes NUI para FiveM. Fork mejorado de rpemotes-reborn.'
version '1.0.0'
repository 'https://github.com/Jerrys-C/rpemotes-reborn-nui'

use_experimental_fxv2_oal 'yes'

-- Otros recursos declaran dependencia de estos nombres; los seguimos cubriendo.
provide 'rpemotes'
provide 'rpemotes-reborn'

dependencies {
    '/server:6683',
    '/onesync'
}

ui_page 'html/index.html'

files {
    'conditionalanims.meta',
    'locales/*.lua',
    'locales/emotes/*.lua',
    'html/index.html',
    'html/design-system/*.css',
    'html/css/*.css',
    'html/css/fonts/*.woff2',
    'html/js/*.js',
}

-- Unlocks idle Animations from GTA:O when using motorcycles, dirt bikes, etc
data_file 'CONDITIONAL_ANIMS_FILE' 'conditionalanims.meta'

shared_scripts {
    'types.lua',
    'locale.lua',
    'config.lua',
    'shared/ModelCompat.lua',
}

server_scripts {
    'server/Server.lua',
    'server/Updates.lua',
    'server/emojis.lua',
    'server/GroupEmote.lua'
}

client_scripts {
    'client/Utils.lua',
    'client/Migrate.lua',
    'client/Bridge.lua',
    'client/AnimationList.lua',
    'client/AnimationListCustom.lua',
    'custom_emotes/*.lua',
    'client/Binoculars.lua',
    'client/Crouch.lua',
    'client/Emote.lua',
    'client/GroupEmote.lua',
    'client/EmoteMenu.lua',
    'client/Expressions.lua',
    'client/Handsup.lua',
    'client/Keybinds.lua',
    'client/Favorites.lua',
    'client/NewsCam.lua',
    'client/NoIdleCam.lua',
    'client/Pointing.lua',
    'client/PTFX.lua',
    'client/Ragdoll.lua',
    'client/Syncing.lua',
    'client/Walk.lua',
    'client/Placement.lua',
    'client/emojis.lua',
    -- Usage.lua envuelve funciones definidas en Emote.lua y Walk.lua:
    -- tiene que cargarse despues de ambas.
    'client/Usage.lua',
    -- Compat.lua reexpone la API de scully_emotemenu; va al final para que use
    -- las funciones ya envueltas por Usage.lua y cuenten en el historial.
    'client/Compat.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/rpemotesreborn_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/brummie_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_camp_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/apple_1.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/kaykaymods_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/knjgh_pizzas.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/natty_props_lollipops.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ultra_ringcase.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pata_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/vedere_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pnwsigns.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pprp_icefishing.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/scully_props.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/samnick_prop_lighter01.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_murderpack.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/prop_protestsign_fh.ytyp'
