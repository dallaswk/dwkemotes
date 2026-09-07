-- ============================================================================
--  Midnight - Emotes con props del MLO
--  --------------------------------------------------------------------------
--  Traidos del recurso `newmidnight_emotes`, que los registraba desde fuera con
--  exports.dwkemotes:AddEmote. Aqui van nativos, asi que ese recurso ya no hace
--  falta para esto: si sigue arrancado, sus registros se rechazaran por nombre
--  duplicado y lo dira en consola. Quitalo del server.cfg.
--
--  Assets: stream/[Props]/Midnight/
--    - Los nueve mne_*.ydr (latas, shaker y palomitas) viajan aqui.
--    - Los cuatro dwk_peluche_*.ydr NO: los streamea el mapeado `newmidnight`,
--      porque ademas estan colocados como decoracion dentro del MLO y duplicar
--      un modelo del mapa da problemas. De aqui solo salen sus archetypes.
--      => Los peluches necesitan que `newmidnight` este arrancado.
--
--  Las catorce van con HideFromMenu: existen y se lanzan con /e, con una tecla,
--  desde una playlist o desde otro recurso, pero no se listan en el menu. Son props
--  del MLO y fuera de el no pintan nada; en la rejilla solo estorbarian a todos.
--
--  Los trece .ytyp estan declarados como DLC_ITYP_REQUEST en el fxmanifest.
--  Sin esa declaracion el archetype no se registra y el prop no aparece, ademas
--  SIN aviso ninguno en la consola del cliente.
-- ============================================================================

local ENABLED = true -- Set to false to disable this pack

if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local Midnight = {}

Midnight.PropEmotes = {}

--- Peluche en la mano: se sostiene contra el pecho y deja andar.
---@param index integer numero del emote (/e dwk_peluche<index>)
---@param model string archetype del prop
---@param label string texto visible en el menu
local function peluche(index, model, label)
    Midnight.PropEmotes[('dwk_peluche%d'):format(index)] = {
        "impexp_int-0", "mp_m_waremech_01_dual-0", label,
        HideFromMenu = true,
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
            Prop = model,
            PropBone = 24817, -- mano izquierda
            PropPlacement = {
                -0.2, 0.46, -0.016,
                -180.0, -90.0, 0.0
            },
        }
    }
end

peluche(1, 'dwk_peluche_01', 'Peluche 1 (Midnight)')
peluche(2, 'dwk_peluche_02', 'Peluche 2 (Midnight)')
peluche(3, 'dwk_peluche_03', 'Peluche 3 (Midnight)')
peluche(4, 'dwk_peluche_04', 'Peluche 4 (Midnight)')

--- Beber de una lata. Misma animacion que el `ecola` de siempre.
---@param name string clave del emote (/e <name>)
---@param model string archetype del prop
---@param label string texto visible en el menu
local function bebida(name, model, label)
    Midnight.PropEmotes[name] = {
        "mp_player_intdrink", "loop_bottle", label,
        HideFromMenu = true,
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
            Prop = model,
            PropBone = 18905, -- mano derecha
            PropPlacement = {
                0.12, 0.008, 0.03,
                240.0, -60.0, 0.0
            },
        }
    }
end

bebida('dwk_lata_black', 'mne_can_black', 'Lata negra (Midnight)')
bebida('dwk_lata_gold',  'mne_can_gold',  'Lata dorada (Midnight)')
bebida('dwk_lata_pink',  'mne_can_pink',  'Lata rosa (Midnight)')
bebida('dwk_lata_c',     'mne_can_c',     'Lata C (Midnight)')
bebida('dwk_lata_m',     'mne_can_m',     'Lata M (Midnight)')
bebida('dwk_lata_n',     'mne_can_n',     'Lata N (Midnight)')
bebida('dwk_lata_z',     'mne_can_z',     'Lata Z (Midnight)')
bebida('dwk_shaker',     'mne_shaker',    'Shaker (Midnight)')

-- Picar de un envase que se sostiene. No hay animacion propia de palomitas: la
-- que se usa para eso aguanta el envase a la altura del pecho y va llevando la
-- mano a la boca. La segunda es la de las patatas fritas, mas inclinada.
Midnight.PropEmotes['dwk_pops'] = {
    "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Palomitas (Midnight)",
    HideFromMenu = true,
    AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        Prop = 'mne_pops',
        PropBone = 28422, -- mano derecha
        PropPlacement = {
            0.01, -0.05, -0.1,
            0.0, 0.0, 90.0
        },
    }
}

-- El original usaba el clip `mp_player_int_eat_burger_fp`. Ese es la variante de
-- primera persona (solo brazos) y no la reproduce ningun emote de la lista base:
-- las 47 entradas de este diccionario en AnimationList.lua usan la de tercera
-- persona. Se corrige aqui; si de verdad querias la _fp, es cambiar la palabra.
Midnight.PropEmotes['dwk_pops2'] = {
    "mp_player_inteat@burger", "mp_player_int_eat_burger", "Palomitas 2 (Midnight)",
    HideFromMenu = true,
    AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        Prop = 'mne_pops',
        PropBone = 18905, -- mano derecha
        PropPlacement = {
            0.09, -0.06, 0.05,
            300.0, 150.0, 0.0
        },
    }
}

RegisterAddonEmotes(Midnight)
