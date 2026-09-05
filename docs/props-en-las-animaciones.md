# Props en las animaciones

Inventario de props que usan las emotes de dwkemotes y de los modelos streameados.

## Resumen

- Props referenciados por las emotes (campos Prop/SecondProp + pasados por helpers): **293**
- Modelos de prop streameados en este recurso (.ydr/.yft dentro de stream/): **183**
- De esos, usados o citados: **138**, sin uso: **45**
- .ytyp de arquetipos: 32 en stream, 32 registrados con DLC_ITYP_REQUEST en fxmanifest.lua (OK)

Los props se adjuntan a la mano con AttachEntityToEntity (campo Prop de cada emote). Para que un prop custom se vea hace falta que el modelo (.ydr/.yft + texturas .ytd) viaje en el stream Y que el juego lo registre: los .ydr sueltos FiveM los auto-registra por nombre de fichero, pero los que vienen con .ytyp necesitan la linea data_file 'DLC_ITYP_REQUEST' 'stream/<nombre>.ytyp' en fxmanifest.lua. Sin esa linea el prop no aparece y no hay error en consola.

## Modelos streameados (por carpeta)

| Modelo | Carpeta | Estado |
|---|---|---|
| a3d_egrang1 | [Custom Emotes]\Pazeee | usado |
| paze_kingchair1 | [Custom Emotes]\Pazeee | usado |
| prop_amb_phone | [Props]\basegame | SIN USO |
| prop_cs_hand_radio | [Props]\basegame | usado |
| prop_phone_ing | [Props]\basegame | usado |
| brum_cherryshake_bubblegum | [Props]\Brummiee | usado |
| brum_cherryshake_cherry | [Props]\Brummiee | usado |
| brum_cherryshake_chocolate | [Props]\Brummiee | usado |
| brum_cherryshake_coffee | [Props]\Brummiee | usado |
| brum_cherryshake_doublechocolate | [Props]\Brummiee | usado |
| brum_cherryshake_frappe | [Props]\Brummiee | usado |
| brum_cherryshake_lemon | [Props]\Brummiee | usado |
| brum_cherryshake_mint | [Props]\Brummiee | usado |
| brum_cherryshake_raspberry | [Props]\Brummiee | usado |
| brum_cherryshake_salted | [Props]\Brummiee | usado |
| brum_cherryshake_strawberry | [Props]\Brummiee | usado |
| brum_cherryshake_vanilla | [Props]\Brummiee | usado |
| brum_heart | [Props]\Brummiee | usado |
| brum_heartfrappe | [Props]\Brummiee | usado |
| brum_shake_bubblegum | [Props]\Brummiee | SIN USO |
| brum_shake_cherry | [Props]\Brummiee | SIN USO |
| brum_shake_chocolate | [Props]\Brummiee | SIN USO |
| brum_shake_coffee | [Props]\Brummiee | SIN USO |
| brum_shake_doublechocolate | [Props]\Brummiee | SIN USO |
| brum_shake_frappe | [Props]\Brummiee | SIN USO |
| brum_shake_lemon | [Props]\Brummiee | SIN USO |
| brum_shake_mint | [Props]\Brummiee | SIN USO |
| brum_shake_raspberry | [Props]\Brummiee | SIN USO |
| brum_shake_rsaltedcaramel | [Props]\Brummiee | SIN USO |
| brum_shake_strawberry | [Props]\Brummiee | SIN USO |
| brum_shake_vanilla | [Props]\Brummiee | SIN USO |
| bzzz_camp_food_kebab | [Props]\BzzziProps | usado |
| bzzz_camp_food_marshmallow | [Props]\BzzziProps | usado |
| bzzz_camp_food_melloburnt | [Props]\BzzziProps | usado |
| bzzz_camp_food_mellopink | [Props]\BzzziProps | usado |
| bzzz_camp_stick_kebab | [Props]\BzzziProps | usado |
| bzzz_camp_stick_marshmallow | [Props]\BzzziProps | usado |
| bzzz_camp_stick_melloburnt | [Props]\BzzziProps | usado |
| bzzz_camp_stick_mellopink | [Props]\BzzziProps | usado |
| bzzz_event_easter_basket_b | [Props]\BzzziProps | SIN USO |
| bzzz_event_easter_bunny_a | [Props]\BzzziProps | SIN USO |
| bzzz_event_easter_egg_d | [Props]\BzzziProps | usado |
| bzzz_food_dessert_a | [Props]\BzzziProps | usado |
| bzzz_food_xmas_gingerbread_a | [Props]\BzzziProps | usado |
| bzzz_food_xmas_lollipop_a | [Props]\BzzziProps | usado |
| bzzz_food_xmas_lollipop_b | [Props]\BzzziProps | usado |
| bzzz_food_xmas_lollipop_c | [Props]\BzzziProps | usado |
| bzzz_food_xmas_lollipop_d | [Props]\BzzziProps | usado |
| bzzz_food_xmas_lollipop_e | [Props]\BzzziProps | usado |
| bzzz_food_xmas_macaroon_a | [Props]\BzzziProps | usado |
| bzzz_food_xmas_mug_a | [Props]\BzzziProps | usado |
| bzzz_food_xmas_mug_b | [Props]\BzzziProps | usado |
| bzzz_food_xmas_mulled_wine_a | [Props]\BzzziProps | usado |
| bzzz_foodpack_croissant001 | [Props]\BzzziProps | usado |
| bzzz_foodpack_donut001 | [Props]\BzzziProps | usado |
| bzzz_foodpack_donut002 | [Props]\BzzziProps | usado |
| bzzz_icecream_cherry | [Props]\BzzziProps | usado |
| bzzz_icecream_chocolate | [Props]\BzzziProps | usado |
| bzzz_icecream_lemon | [Props]\BzzziProps | usado |
| bzzz_icecream_pistachio | [Props]\BzzziProps | usado |
| bzzz_icecream_raspberry | [Props]\BzzziProps | usado |
| bzzz_icecream_stracciatella | [Props]\BzzziProps | usado |
| bzzz_icecream_strawberry | [Props]\BzzziProps | usado |
| bzzz_icecream_walnut | [Props]\BzzziProps | usado |
| bzzz_prop_cake_baby_001 | [Props]\BzzziProps | usado |
| bzzz_prop_cake_birthday_001 | [Props]\BzzziProps | usado |
| bzzz_prop_cake_casino001 | [Props]\BzzziProps | usado |
| bzzz_prop_cake_love_001 | [Props]\BzzziProps | usado |
| bzzz_prop_gift_bonbonier | [Props]\BzzziProps | SIN USO |
| bzzz_prop_gift_jewel | [Props]\BzzziProps | SIN USO |
| bzzz_prop_gift_orange | [Props]\BzzziProps | usado |
| bzzz_prop_gift_purple | [Props]\BzzziProps | usado |
| bzzz_prop_shop_basket_a | [Props]\BzzziProps | usado |
| bzzz_prop_shop_basket_b | [Props]\BzzziProps | usado |
| bzzz_prop_torch_fire001 | [Props]\BzzziProps | SIN USO |
| prop_bzzz_drugs_light001 | [Props]\BzzziProps | usado |
| prop_bzzz_elektro_powerhouse001 | [Props]\BzzziProps | usado |
| samnick_prop_lighter01 | [Props]\BzzziProps | usado |
| apple_1 | [Props]\CandyApple | SIN USO |
| prop_amb_handbag_01 | [Props]\Crowded1337 | usado |
| p_amb_coffeecup_01 | [Props]\deado | usado |
| prop_energy_drink | [Props]\deado | SIN USO |
| pprp_icefishing_augur | [Props]\EP | usado |
| pprp_icefishing_box_01 | [Props]\EP | usado |
| pprp_icefishing_box_02 | [Props]\EP | usado |
| beanmachine_cup | [Props]\KayKayMods | usado |
| beanmachine_cup2 | [Props]\KayKayMods | usado |
| beanmachine_cup3 | [Props]\KayKayMods | usado |
| dumbbitchjuice | [Props]\KayKayMods | usado |
| gremlin_plush | [Props]\KayKayMods | SIN USO |
| heart_balloon | [Props]\KayKayMods | SIN USO |
| pride_heart_balloon | [Props]\KayKayMods | SIN USO |
| knjgh_pizzaslice1 | [Props]\KnjghPizzaSlices | usado |
| knjgh_pizzaslice2 | [Props]\KnjghPizzaSlices | usado |
| knjgh_pizzaslice3 | [Props]\KnjghPizzaSlices | usado |
| knjgh_pizzaslice4 | [Props]\KnjghPizzaSlices | usado |
| knjgh_pizzaslice5 | [Props]\KnjghPizzaSlices | usado |
| mne_can_black | [Props]\Midnight | usado |
| mne_can_c | [Props]\Midnight | usado |
| mne_can_gold | [Props]\Midnight | usado |
| mne_can_m | [Props]\Midnight | usado |
| mne_can_n | [Props]\Midnight | usado |
| mne_can_pink | [Props]\Midnight | usado |
| mne_can_z | [Props]\Midnight | usado |
| mne_pops | [Props]\Midnight | usado |
| mne_shaker | [Props]\Midnight | usado |
| natty_lollipop_spin01 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop_spin02 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop_spin03 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop_spin04 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop_spin05 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop_spiral01 | [Props]\NattyLollipops | usado |
| natty_lollipop_spiral02 | [Props]\NattyLollipops | usado |
| natty_lollipop_spiral03 | [Props]\NattyLollipops | usado |
| natty_lollipop_spiral04 | [Props]\NattyLollipops | usado |
| natty_lollipop_spiral05 | [Props]\NattyLollipops | usado |
| natty_lollipop_spiral06 | [Props]\NattyLollipops | usado |
| natty_lollipop01 | [Props]\NattyLollipops | usado |
| natty_lollipop02 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop03 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop04 | [Props]\NattyLollipops | SIN USO |
| natty_lollipop05 | [Props]\NattyLollipops | SIN USO |
| pata_cake | [Props]\PataMods | usado |
| pata_cake2 | [Props]\PataMods | usado |
| pata_cake3 | [Props]\PataMods | usado |
| pata_christmasfood1 | [Props]\PataMods | usado |
| pata_christmasfood2 | [Props]\PataMods | usado |
| pata_christmasfood6 | [Props]\PataMods | usado |
| pata_christmasfood7 | [Props]\PataMods | SIN USO |
| pata_christmasfood8 | [Props]\PataMods | usado |
| pata_freevalentinesday | [Props]\PataMods | usado |
| pata_freevalentinesday2 | [Props]\PataMods | usado |
| pata_freevalentinesday3 | [Props]\PataMods | usado |
| prop_flagger_sign_01 | [Props]\PNWParksFan | usado |
| prop_flagger_sign_02 | [Props]\PNWParksFan | usado |
| prop_protestsign_01_fh | [Props]\protestsigns_fh | SIN USO |
| prop_protestsign_02_fh | [Props]\protestsigns_fh | SIN USO |
| prop_protestsign_03_fh | [Props]\protestsigns_fh | SIN USO |
| prop_protestsign_04_fh | [Props]\protestsigns_fh | SIN USO |
| lilprideflag1 | [Props]\rpemotesreborn | usado |
| lilprideflag2 | [Props]\rpemotesreborn | usado |
| lilprideflag3 | [Props]\rpemotesreborn | usado |
| lilprideflag4 | [Props]\rpemotesreborn | usado |
| lilprideflag5 | [Props]\rpemotesreborn | usado |
| lilprideflag6 | [Props]\rpemotesreborn | usado |
| lilprideflag7 | [Props]\rpemotesreborn | usado |
| lilprideflag8 | [Props]\rpemotesreborn | usado |
| lilprideflag9 | [Props]\rpemotesreborn | usado |
| p_amb_brolly_01 | [Props]\rpemotesreborn | usado |
| p_cs_clipboard | [Props]\rpemotesreborn | SIN USO |
| pride_sign_01 | [Props]\rpemotesreborn | SIN USO |
| prideflag1 | [Props]\rpemotesreborn | usado |
| prideflag2 | [Props]\rpemotesreborn | usado |
| prideflag3 | [Props]\rpemotesreborn | usado |
| prideflag4 | [Props]\rpemotesreborn | usado |
| prideflag5 | [Props]\rpemotesreborn | usado |
| prideflag6 | [Props]\rpemotesreborn | usado |
| prideflag7 | [Props]\rpemotesreborn | usado |
| prideflag8 | [Props]\rpemotesreborn | usado |
| prideflag9 | [Props]\rpemotesreborn | usado |
| prop_cop_badge | [Props]\rpemotesreborn | SIN USO |
| prop_lspd_badge | [Props]\rpemotesreborn | SIN USO |
| prop_rpemotesreborn_guitar_001 | [Props]\rpemotesreborn | usado |
| prop_rpemotesreborn_guitar_002 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_skateboard01 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_skateboard02 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_soda01 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_soda02 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_soda03 | [Props]\rpemotesreborn | usado |
| rpemotesreborn_soda04 | [Props]\rpemotesreborn | usado |
| scully_blm | [Props]\Scully | SIN USO |
| scully_boba | [Props]\Scully | usado |
| scully_boba2 | [Props]\Scully | usado |
| scully_boba3 | [Props]\Scully | usado |
| scully_pho | [Props]\Scully | SIN USO |
| scully_spoon_pho | [Props]\Scully | usado |
| ultra_ringcase | [Props]\UltraRingCase | usado |
| scarymask1 | [Props]\vedere | usado |
| scarymask2 | [Props]\vedere | usado |
| scarymask3 | [Props]\vedere | usado |
| p_ld_heist_bag_s_2 | [Props]\Whitecustom | SIN USO |
| prop_cs_protest_sign_01 | [Props]\Whitecustom | SIN USO |
| prop_police_id_board | [Props]\Whitecustom | usado |

## Props referenciados por las emotes

| Prop | Veces | Origen | Estado |
|---|---|---|---|
| a3d_egrang1 | 4 | pazeee_animations.lua | custom + stream (OK) |
| apa_mp_h_stn_chairarm_23 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_champ_open | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_club_chair_02 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_glowstick_01 | 10 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_sports_helmet | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_vape_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_whiskey_bottle_2_s | 4 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_battle_whiskey_opaque_s | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ba_prop_club_laptop_dj_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| beanmachine_cup | 1 | AnimationList.lua | custom + stream (OK) |
| beanmachine_cup2 | 1 | AnimationList.lua | custom + stream (OK) |
| beanmachine_cup3 | 1 | AnimationList.lua | custom + stream (OK) |
| bkr_prop_money_sorted_01 | 1 | pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| bkr_prop_money_wrapped_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| bkr_prop_scrunched_moneypage | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| brum_cherryshake_bubblegum | 1 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_cherry | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_chocolate | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_coffee | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_doublechocolate | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_frappe | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_lemon | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_mint | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_raspberry | 3 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_salted | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_strawberry | 2 | AnimationList.lua | custom + stream (OK) |
| brum_cherryshake_vanilla | 2 | AnimationList.lua | custom + stream (OK) |
| brum_heart | 1 | AnimationList.lua | custom + stream (OK) |
| brum_heartfrappe | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_food_kebab | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_food_marshmallow | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_food_melloburnt | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_food_mellopink | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_stick_kebab | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_stick_marshmallow | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_stick_melloburnt | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_camp_stick_mellopink | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_event_easter_egg_d | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_dessert_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_gingerbread_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_lollipop_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_lollipop_b | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_lollipop_c | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_lollipop_d | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_lollipop_e | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_macaroon_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_mug_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_mug_b | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_food_xmas_mulled_wine_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_foodpack_croissant001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_foodpack_donut001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_foodpack_donut002 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_cherry | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_chocolate | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_lemon | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_pistachio | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_raspberry | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_stracciatella | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_strawberry | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_icecream_walnut | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_cake_baby_001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_cake_birthday_001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_cake_casino001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_cake_love_001 | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_gift_orange | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_gift_purple | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_shop_basket_a | 1 | AnimationList.lua | custom + stream (OK) |
| bzzz_prop_shop_basket_b | 1 | AnimationList.lua | custom + stream (OK) |
| ch_prop_ch_moneybag_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| dumbbitchjuice | 1 | AnimationList.lua | custom + stream (OK) |
| h4_prop_h4_can_beer_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| h4_prop_h4_caviar_spoon_01a | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| h4_prop_h4_coke_spoon_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| hei_heist_stn_chairstrip_01 | 1 | newpack.lua | nativo / no en este stream -> verificar en servidor |
| hei_prop_dlc_tablet | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ind_prop_firework_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| knjgh_pizzaslice1 | 2 | AnimationList.lua | custom + stream (OK) |
| knjgh_pizzaslice2 | 1 | AnimationList.lua | custom + stream (OK) |
| knjgh_pizzaslice3 | 1 | AnimationList.lua | custom + stream (OK) |
| knjgh_pizzaslice4 | 1 | AnimationList.lua | custom + stream (OK) |
| knjgh_pizzaslice5 | 1 | AnimationList.lua | custom + stream (OK) |
| lilprideflag1 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag2 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag3 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag4 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag5 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag6 | 8 | AnimationList.lua | custom + stream (OK) |
| lilprideflag7 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag8 | 7 | AnimationList.lua | custom + stream (OK) |
| lilprideflag9 | 6 | AnimationList.lua | custom + stream (OK) |
| lux_prop_lighter_luxe | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| m23_2_prop_m32_milkncookies_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| mne_can_black | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_c | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_gold | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_m | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_n | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_pink | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_can_z | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| mne_pops | 2 | newmidnight_props.lua | custom + stream (OK) |
| mne_shaker | 0 | newmidnight_props.lua (helper) | custom + stream (OK) |
| natty_lollipop_spiral01 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop_spiral02 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop_spiral03 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop_spiral04 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop_spiral05 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop_spiral06 | 1 | AnimationList.lua | custom + stream (OK) |
| natty_lollipop01 | 1 | AnimationList.lua | custom + stream (OK) |
| ng_proc_cigarette01a | 9 | AnimationList.lua, pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| ng_proc_cigpak01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ng_proc_paper_news_quik | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ng_proc_paper_news_rag | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ng_proc_sodacan_01b | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_amb_brolly_01 | 3 | AnimationList.lua | custom + stream (OK) |
| p_amb_clipboard_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_amb_coffeecup_01 | 1 | AnimationList.lua | custom + stream (OK) |
| p_banknote_onedollar_s | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_champ_flute_s | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_cs_bbbat_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_cs_bottle_01 | 4 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_cs_joint_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_ing_bagel_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_ing_coffeecup_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_ing_microphonel_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_ld_frisbee_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_ld_sax | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_michael_backpack_s | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| p_wine_glass_s | 8 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| pata_cake | 1 | AnimationList.lua | custom + stream (OK) |
| pata_cake2 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_cake3 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_christmasfood1 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_christmasfood2 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_christmasfood6 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_christmasfood8 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_freevalentinesday | 1 | AnimationList.lua | custom + stream (OK) |
| pata_freevalentinesday2 | 1 | AnimationList.lua | custom + stream (OK) |
| pata_freevalentinesday3 | 1 | AnimationList.lua | custom + stream (OK) |
| paze_kingchair1 | 5 | pazeee_animations.lua | custom + stream (OK) |
| pprp_icefishing_augur | 1 | AnimationList.lua | custom + stream (OK) |
| pprp_icefishing_box_01 | 1 | AnimationList.lua | custom + stream (OK) |
| pprp_icefishing_box_02 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag1 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag2 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag3 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag4 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag5 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag6 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag7 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag8 | 1 | AnimationList.lua | custom + stream (OK) |
| prideflag9 | 1 | AnimationList.lua | custom + stream (OK) |
| prop_acc_guitar_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_amb_beer_bottle | 7 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_amb_donut | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_amb_handbag_01 | 2 | AnimationList.lua | custom + stream (OK) |
| prop_anim_cash_pile_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_aviators_01 | 4 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_100kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_10kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_20kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_30kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_40kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_50kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_60kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_barbell_80kg | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beer_amopen | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beer_logopen | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beggers_sign_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beggers_sign_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beggers_sign_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_beggers_sign_04 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_bong_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_bzzz_drugs_light001 | 1 | AnimationList.lua | custom + stream (OK) |
| prop_bzzz_elektro_powerhouse001 | 1 | AnimationList.lua | custom + stream (OK) |
| prop_candy_pqs | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_carrier_bag_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cash_pile_02 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_champ_cool | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_champ_flute | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_choc_ego | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cigar_01 | 4 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cigar_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cliff_paper | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_controller_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cranial_saw | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_book_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_bowie_knife | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_bs_cup | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_burger_01 | 5 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_dildo_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_hand_radio | 1 | AnimationList.lua | custom + stream (OK) |
| prop_cs_hotdog_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_hotdog_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_magazine | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_newspaper | 1 | pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_police_torch_02 | 9 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_sol_glasses | 13 | AnimationList.lua, pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_steak | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_stock_book | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_cs_walking_stick | 2 | AnimationList.lua, pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_drink_champ | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_drink_redwine | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_drink_whisky | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_ecola_can | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_el_guitar_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_el_guitar_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_fishing_rod_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_flagger_sign_01 | 2 | AnimationList.lua | custom + stream (OK) |
| prop_flagger_sign_02 | 2 | AnimationList.lua | custom + stream (OK) |
| prop_food_bs_tray_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_food_cb_tray_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_food_tray_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_food_tray_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_freeweight_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_ghettoblast_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_hard_hat_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_ing_camera_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_ld_shovel_dirt | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_med_bag_01b | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_michael_backpack | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_mojito | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_mr_raspberry_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_notepad_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_novel_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_orang_can_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_pap_camera_01 | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_pencil_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_phone_ing | 18 | AnimationList.lua | custom + stream (OK) |
| prop_plastic_cup_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_player_phone_02 | 1 | pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_police_id_board | 1 | AnimationList.lua | custom + stream (OK) |
| prop_pool_cue | 5 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_porn_mag_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_porn_mag_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_proxy_hat_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_rpemotesreborn_guitar_001 | 2 | AnimationList.lua | custom + stream (OK) |
| prop_rpemotesreborn_guitar_002 | 2 | AnimationList.lua | custom + stream (OK) |
| prop_sandwich_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_single_rose | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_skid_chair_03 | 2 | pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_snow_flower_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_suitcase_03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_taco_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tennis_ball | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tennis_rack_01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tequila | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_toilet_01 | 3 | pazeee_animations.lua | nativo / no en este stream -> verificar en servidor |
| prop_tool_fireaxe | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tool_mallet | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tool_pickaxe | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_tourist_map_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| prop_wine_rose | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| rpemotesreborn_skateboard01 | 2 | AnimationList.lua | custom + stream (OK) |
| rpemotesreborn_skateboard02 | 1 | AnimationList.lua | custom + stream (OK) |
| rpemotesreborn_soda01 | 2 | AnimationList.lua | custom + stream (OK) |
| rpemotesreborn_soda02 | 2 | AnimationList.lua | custom + stream (OK) |
| rpemotesreborn_soda03 | 2 | AnimationList.lua | custom + stream (OK) |
| rpemotesreborn_soda04 | 2 | AnimationList.lua | custom + stream (OK) |
| samnick_prop_lighter01 | 1 | AnimationList.lua | custom + stream (OK) |
| scarymask1 | 2 | AnimationList.lua | custom + stream (OK) |
| scarymask2 | 2 | AnimationList.lua | custom + stream (OK) |
| scarymask3 | 2 | AnimationList.lua | custom + stream (OK) |
| scully_boba | 1 | AnimationList.lua | custom + stream (OK) |
| scully_boba2 | 1 | AnimationList.lua | custom + stream (OK) |
| scully_boba3 | 1 | AnimationList.lua | custom + stream (OK) |
| scully_spoon_pho | 1 | AnimationList.lua | custom + stream (OK) |
| sf_prop_sf_apple_01b | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| sf_prop_sf_mic_01a | 5 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| ultra_ringcase | 1 | AnimationList.lua | custom + stream (OK) |
| v_ilev_mp_bedsidebook | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_ilev_mr_rasberryclean | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_d_zimmerframe | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tre_weight | 4 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_can01 | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_can02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_pornmag01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_pornmag02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_pornmag03 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_res_tt_pornmag04 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_ret_fh_bscup | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| v_ret_ps_bag_02 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| w_am_baseball | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| w_am_digiscanner | 3 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| w_pi_pistol_luxe | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| w_pi_pistolsmg_m31 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| w_pi_stungun | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| xm_prop_x17_laptop_lester_01 | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| xm3_prop_xm3_bong_01a | 2 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| xm3_prop_xm3_toy_dog_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| xm3_prop_xm3_vape_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
| xs_prop_trinket_cup_01a | 1 | AnimationList.lua | nativo / no en este stream -> verificar en servidor |
