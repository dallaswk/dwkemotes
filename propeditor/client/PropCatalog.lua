-- ─── Catalogo de props para el buscador ──────────────────────────────────────
--
-- Dos fuentes, y las dos se filtran con IsModelInCdimage() antes de llegar a la
-- interfaz, asi que nunca se ofrece un modelo que este servidor no tenga:
--
--   1. Los props que ya usan las emotes del pack (Prop/SecondProp). Salen de
--      recorrer EmoteData en caliente, asi que se actualizan solos cuando se
--      anade un pack nuevo y ademas viajan garantizado en el stream.
--   2. Esta lista de props de base del juego, para tener de donde tirar cuando
--      lo que se busca no lo usa ninguna emote todavia.
--
-- La lista no aspira a estar completa (el juego tiene miles de modelos): es un
-- punto de partida. Cualquier otro modelo se puede escribir a mano en el campo
-- de texto, que valida contra el juego mientras se teclea.

---@type table<string, string[]>
PropEditorCatalog = {
    ['Bebida'] = {
        'prop_cs_beer_bot_01', 'prop_beer_am', 'prop_beer_bar', 'prop_beer_bison',
        'prop_beer_blr', 'prop_beer_box', 'prop_beer_jakey', 'prop_beer_logger',
        'prop_beer_neon', 'prop_beer_patriot', 'prop_beer_pissh', 'prop_beer_stz',
        'prop_champ_01', 'prop_champ_02', 'prop_champ_flute', 'prop_champ_open',
        'ba_prop_battle_champ_open', 'prop_cocktail', 'prop_drink_champ',
        'prop_drink_redwine', 'prop_drink_whtwine', 'prop_wine_rose', 'prop_wine_white',
        'prop_cs_whiskey_bottle', 'ba_prop_battle_whiskey_bottle_2_s',
        'ba_prop_battle_whiskey_opaque_s', 'prop_shot_glass', 'prop_plastic_cup_02',
        'prop_ecola_can', 'prop_energy_drink', 'p_amb_coffeecup_01',
    },
    ['Comida'] = {
        'prop_cs_burger_01', 'prop_food_bs_burger1', 'prop_food_burg2', 'prop_food_burg3',
        'prop_cs_hotdog_01', 'prop_cs_hotdog_02', 'prop_taco_01', 'prop_food_bs_chips',
        'prop_cs_sandwich_01', 'prop_donut_01', 'prop_donut_02', 'prop_amb_donut',
        'prop_pizza_box_01', 'prop_pizza_box_02', 'v_res_tt_pizzaplate',
        'prop_cs_burger_02', 'prop_food_bs_bagel',
    },
    ['Tabaco'] = {
        'prop_cs_ciggy_01', 'ng_proc_cigarette01a', 'prop_cigar_01', 'prop_cigar_02',
        'prop_cigar_03', 'prop_cs_lighter_01', 'ba_prop_battle_vape_01',
        'prop_ashtray_01',
    },
    ['Electronica'] = {
        'prop_npc_phone', 'prop_npc_phone_02', 'prop_phone_ing', 'prop_amb_phone',
        'prop_player_phone_01', 'prop_player_phone_02', 'prop_player_phone_03',
        'prop_player_phone_04', 'prop_cs_tablet', 'prop_laptop_01a', 'prop_laptop_lester',
        'ba_prop_club_laptop_dj_02', 'prop_cs_hand_radio', 'prop_cs_walkie_talkie',
        'prop_ing_camera_01', 'prop_pap_camera_01', 'p_ing_microphonel_01',
        'prop_boombox_01', 'prop_v_cam_01', 'prop_cctv_pole_04',
    },
    ['Papel y oficina'] = {
        'prop_notepad_01', 'prop_pencil_01', 'prop_cs_clipboard', 'prop_clipboard',
        'prop_paper_bag_01', 'prop_paper_bag_small', 'prop_novel_01',
        'prop_cs_protest_sign_01', 'prop_police_id_board', 'prop_cs_documents_01',
        'prop_fib_folder_01',
    },
    ['Dinero'] = {
        'prop_cash_case_01', 'prop_cash_case_02', 'prop_cash_pile_01', 'prop_cash_pile_02',
        'prop_anim_cash_pile_01', 'bkr_prop_money_wrapped_01', 'bkr_prop_scrunched_moneypage',
        'prop_money_bag_01', 'prop_cash_dep_bag_01',
    },
    ['Bolsas y maletas'] = {
        'prop_ld_case_01', 'p_ld_heist_bag_s_1', 'p_ld_heist_bag_s_2',
        'prop_cs_heist_bag_01', 'prop_michael_backpack', 'prop_cs_shopping_bag',
        'prop_amb_handbag_01',
    },
    ['Herramientas'] = {
        'prop_tool_hammer', 'prop_tool_screwdvr01', 'prop_tool_wrench', 'prop_tool_shovel',
        'prop_tool_broom', 'prop_tool_pickaxe', 'prop_tool_adjspanner',
        'prop_cs_fork', 'prop_cs_knife', 'prop_cs_spoon',
    },
    ['Deporte y ocio'] = {
        'prop_golf_ball', 'prop_golf_iron_01', 'prop_golf_driver', 'prop_pool_cue',
        'prop_fishing_rod_01', 'ba_prop_battle_sports_helmet', 'prop_snow_ball_01',
        'prop_beach_fire', 'prop_binoc_01',
    },
    ['Musica'] = {
        'prop_acc_guitar_01', 'prop_el_guitar_01', 'prop_el_guitar_02', 'prop_el_guitar_03',
        'ba_prop_battle_glowstick_01',
    },
    ['Asientos'] = {
        'ba_prop_battle_club_chair_02', 'apa_mp_h_stn_chairarm_23', 'prop_chair_01a',
        'prop_chair_02', 'prop_chair_04a', 'prop_bench_01a', 'prop_table_03',
    },
}

--- Aplana el catalogo a una lista de nombres, sin repetidos.
---@return string[]
function PropEditorCatalogNames()
    local seen, names = {}, {}
    for _, models in PairsByKeys(PropEditorCatalog) do
        for _, model in ipairs(models) do
            if not seen[model] then
                seen[model] = true
                names[#names + 1] = model
            end
        end
    end
    return names
end
