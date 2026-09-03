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

data_file 'DLC_ITYP_REQUEST' 'stream/prop_protestsign_fh.ytyp'

-- Props del pack de Pazeee. Sin estas dos lineas los .ytyp viajan en el stream
-- pero el juego no registra sus arquetipos, asi que las emotes que los usan
-- (pegranga/pegrangb y pkingchaira-e) salen sin objeto en la mano.
data_file 'DLC_ITYP_REQUEST' 'stream/a3d_egrang1.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/paze_kingchair1.ytyp'

-- Props del MLO Midnight (custom_emotes/newmidnight_props.lua).
-- Los cuatro dwk_peluche_*.ydr los streamea el mapeado `newmidnight`; de aqui
-- solo salen sus archetypes, que es lo que hace falta para poder crearlos como
-- objeto en mano. Sin estas lineas el prop no aparece y no hay aviso ninguno.
data_file 'DLC_ITYP_REQUEST' 'stream/ityp_dwk_peluche_01.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_dwk_peluche_02.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_dwk_peluche_03.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_dwk_peluche_04.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_black.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_gold.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_pink.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_c.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_m.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_n.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_can_z.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_shaker.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ityp_mne_pops.ytyp'

