-- scully_port -- emotes recuperadas de scully_emotemenu.
--
-- scully_emotemenu se aparto el 2026-08-30 (ver desactivados/LEEME.md) y con el
-- se fueron sus animaciones. Aqui vuelven las que dwkemotes no tenia, con el
-- mismo nombre de comando que tenian alli salvo cuando ese nombre ya estaba
-- cogido, en cuyo caso se numera a continuacion de la serie.
--
-- Quedan fuera a proposito las que se limpiaron en el commit "Clean troll
-- animations" (zombies, murder, fspose...) y la libreria vanilla de discoteca
-- (dance...dance1500), que solo inflaba el menu sin traer nada nuevo.
--
-- Los .ycd de estas animaciones estan en stream/[Custom Emotes]/.

local ENABLED = true -- ponlo en false para desactivar el pack
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local Scully = {}


-- Emotes sueltas
Scully.Emotes = {
    ["bow3"] = {
        "anim@arena@celeb@podium@no_prop@",
        "regal_b_1st",
        "Bow 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["chill2"] = {
        "anim@sw_chill_pose",
        "chill_pose_clip",
        "Chill 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["chill3"] = {
        "anim@sw_sit_chill",
        "sit_chill_clip",
        "Chill 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["dab2"] = {
        "custom@dab",
        "dab",
        "Dab 2"
    },
    ["fightme3"] = {
        "anim@deathmatch_intros@1hmale",
        "intro_male_1h_a_trevor",
        "Fight Me 3"
    },
    ["fightme4"] = {
        "anim@deathmatch_intros@1hmale",
        "intro_male_1h_e_trevor",
        "Fight Me 4"
    },
    ["finger3"] = {
        "fuckyou@joker",
        "fuckyou_clip",
        "Finger 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["fingerguns"] = {
        "anim@arena@celeb@podium@no_prop@",
        "finger_guns_a_1st",
        "Finger Guns"
    },
    ["fingerguns2"] = {
        "anim@arena@celeb@podium@no_prop@",
        "finger_guns_b_1st",
        "Finger Guns 2"
    },
    ["flipoff3"] = {
        "anim@arena@celeb@podium@no_prop@",
        "flip_off_b_1st",
        "Flip Off 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign5"] = {
        "qpacc@gangsign1",
        "gangsign1_clip",
        "Gang Sign 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign6"] = {
        "qpacc@gangsign2",
        "gangsign2_clip",
        "Gang Sign 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign7"] = {
        "qpacc@gangsign3",
        "gangsign3_clip",
        "Gang Sign 7",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign8"] = {
        "qpacc@gangsign4",
        "gangsign4_clip",
        "Gang Sign 8",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign9"] = {
        "qpacc@gangsign5",
        "gangsign5_clip",
        "Gang Sign 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign10"] = {
        "qpacc@gangsign6",
        "gangsign6_clip",
        "Gang Sign 10",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign11"] = {
        "qpacc@gangsign7",
        "gangsign7_clip",
        "Gang Sign 11",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign12"] = {
        "qpacc@gangsign8",
        "gangsign8_clip",
        "Gang Sign 12",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign13"] = {
        "anim@gang_pistol_westside",
        "pistol_westside_clip",
        "Gang Sign 13",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign14"] = {
        "anim@gang_one",
        "gang_one_clip",
        "Gang Sign 14",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign15"] = {
        "anim@gang_two",
        "gang_two_clip",
        "Gang Sign 15",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign16"] = {
        "devil@ierrorr",
        "devil_clip",
        "Gang Sign 16",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign17"] = {
        "emoo@ierrorr",
        "emoo_clip",
        "Gang Sign 17",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["gangsign18"] = {
        "gang_2@ierrorr",
        "gang_2_clip",
        "Gang Sign 18",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["gangsign19"] = {
        "gingging2@sharror",
        "gingging2_clip",
        "Gang Sign 19",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["guntohead"] = {
        "gun_head@sharror",
        "gun_head_clip",
        "Gun To Head",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["handsontits"] = {
        "luxurymods@hands_on_tits",
        "hands_on_tits_clip",
        "Hands on Tits",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        },
        AdultAnimation = true
    },
    ["handsinpockets"] = {
        "bzzz@animations@hands",
        "bz_hands",
        "Hands in Pockets",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["handsinpockets2"] = {
        "handinpocket@sharror",
        "handinpocket_clip",
        "Hands in Pockets 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["handsup6"] = {
        "anim@mp_rollarcoaster",
        "hands_up_idle_a_player_one",
        "Hands Up 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["hhands2"] = {
        "heart@hands1",
        "base",
        "Heart Hands 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["hhands3"] = {
        "heart@hands2",
        "base",
        "Heart Hands 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["hidegun2"] = {
        "fin_a_int-3",
        "player_one_dual-3",
        "Hide Gun 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["lean7"] = {
        "amb@world_human_leaning@male@wall@back@hands_together@idle_b",
        "idle_b",
        "Lean 7",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["lean8"] = {
        "leaning_wall@holding_knee",
        "base",
        "Lean 8",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["lean9"] = {
        "leaning_wall@touching_hair",
        "base",
        "Lean 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["magic"] = {
        "magic@dark_spell",
        "base",
        "Magic",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            EmoteDuration = 1000
        }
    },
    ["modelpose2"] = {
        "fmodelpose1@sharror",
        "fmodelpose1_clip",
        "Model Pose 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["modelpose3"] = {
        "fmodelpose2@sharror",
        "fmodelpose2_clip",
        "Model Pose 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["modelpose4"] = {
        "fmodelpose3@sharror",
        "fmodelpose3_clip",
        "Model Pose 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose"] = {
        "lucio_01@sharror",
        "lucio_01",
        "Pose",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose2"] = {
        "female_pose_03@sharror",
        "female_pose_03",
        "Pose 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose3"] = {
        "female_pose_02@sharror",
        "female_pose_02",
        "Pose 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose4"] = {
        "female_pose_01@sharror",
        "female_pose_01",
        "Pose 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose5"] = {
        "m_stand_hands@sharror",
        "m_stand_hands",
        "Pose 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose6"] = {
        "fgunpose@sharror",
        "fgunpose_clip",
        "Pose 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose7"] = {
        "mmodelpose1@sharror",
        "mmodelpose1_clip",
        "Pose 7",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose8"] = {
        "drill_hands@sharror",
        "drill_hands_clip",
        "Pose 8",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose9"] = {
        "lookdown@sharror",
        "lookdown_clip",
        "Pose 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose10"] = {
        "perspective1@sharror",
        "perspective1_clip",
        "Pose 10",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose11"] = {
        "perspective2@sharror",
        "perspective2_clip",
        "Pose 11",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose12"] = {
        "stairpose1@sharror",
        "stairpose1_clip",
        "Pose 12",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["pose13"] = {
        "stairpose2@sharror",
        "stairpose2_clip",
        "Pose 13",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["relax3"] = {
        "lying@on_couch_legs_crossed2",
        "base",
        "Relax 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["relax4"] = {
        "lying@on_couch_legs_crossed3",
        "base",
        "Relax 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["rps"] = {
        "baspel@rock@animation",
        "rock_clip",
        "Rock Paper Scissors (Rock)"
    },
    ["rps2"] = {
        "baspel@paper@animation",
        "paper_clip",
        "Rock Paper Scissors (Paper)"
    },
    ["rps3"] = {
        "baspel@scissors@animation",
        "scissors_clip",
        "Rock Paper Scissors (Scissors)"
    },
    ["scratchass"] = {
        "anim@heists@team_respawn@respawn_01",
        "heist_spawn_01_ped_d",
        "Scratch Ass"
    },
    ["signofhorns"] = {
        "luxurymods@animation_male_3",
        "animation_male_3_clip",
        "Sign of The Horns",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["sit11"] = {
        "amb@world_human_picnic@male@idle_a",
        "idle_a",
        "Sit 11",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            ExitEmote = "getup"
        }
    },
    ["sit12"] = {
        "amb@world_human_picnic@female@idle_a",
        "idle_a",
        "Sit 12",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            ExitEmote = "getup"
        }
    },
    ["sit13"] = {
        "s_sit_01@sharror",
        "s_sit_01_clip",
        "Sit 13",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["sit14"] = {
        "sitonwhip@joker",
        "sitonwhip_clip",
        "Sit 14",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["sit15"] = {
        "sitonground1@sharror",
        "sitonground1_clip",
        "Sit 15",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["sitchair9"] = {
        "sitcouch@joker",
        "sitcouch_clip",
        "Sit Chair 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            ExitEmote = "offchair"
        }
    },
    ["sleep3"] = {
        "anim@amb@nightclub@lazlow@lo_sofa@",
        "lowsofa_dlg_crying_laz",
        "Sleep 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            ExitEmote = "getup"
        }
    },
    ["standsick"] = {
        "standfemale_sick@joker",
        "standfemale_sick_clip",
        "Stand Sick",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["standsick2"] = {
        "femalestand3@joker",
        "femalestand3_clip",
        "Stand Sick 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical"] = {
        "anim@tactical_kneel_walkie",
        "kneel_walkie_clip",
        "Tactical",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical2"] = {
        "anim@tactical_kneel_aiming",
        "kneel_aiming_clip",
        "Tactical 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical3"] = {
        "anim@tactical_highlow_high_leftlean",
        "high_leftlean_clip",
        "Tactical 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical4"] = {
        "anim@tactical_highlow_low_leftlean",
        "low_leftlean_clip",
        "Tactical 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical5"] = {
        "anim@male_tactical_collapsed_lowready",
        "collapsed_lowready_clip",
        "Tactical 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical6"] = {
        "anim@male_tactical_highready_relaxed",
        "highready_relaxed_clip",
        "Tactical 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical7"] = {
        "anim@fog_rifle_relaxed",
        "rifle_relaxed_clip",
        "Tactical 7",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical8"] = {
        "anim@shooter_stance",
        "stance_clip",
        "Tactical 8",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical9"] = {
        "anim@stance_handgun",
        "handgun_clip",
        "Tactical 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical10"] = {
        "anim@stack_pointman",
        "pointman_clip",
        "Tactical 10",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical11"] = {
        "anim@stack_two_man",
        "two_man_clip",
        "Tactical 11",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical12"] = {
        "anim@stack_three_man",
        "three_man_clip",
        "Tactical 12",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical13"] = {
        "anim@highlow_low_lean",
        "low_lean_clip",
        "Tactical 13",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["tactical14"] = {
        "anim@highlow_high_lean",
        "high_lean_clip",
        "Tactical 14",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["wave10"] = {
        "posing@with_car",
        "base",
        "Wave 10",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
}


-- Emotes con prop
Scully.PropEmotes = {
    ["bsfries"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger_fp",
        "Burger Shot Fries",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_food_bs_chips",
            PropBone = 18905,
            PropPlacement = {
                0.09,
                -0.06,
                0.05,
                300.0,
                150.0,
                0.0
            }
        }
    },
    ["pineapple2"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger_fp",
        "Pineapple 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_pineapple",
            PropBone = 18905,
            PropPlacement = {
                0.1,
                0.038,
                0.03,
                15.0,
                50.0,
                0.0
            }
        }
    },
    ["pizza"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger_fp",
        "Pizza",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "v_res_tt_pizzaplate",
            PropBone = 18905,
            PropPlacement = {
                0.2,
                0.038,
                0.051,
                15.0,
                155.0,
                0.0
            }
        }
    },
    ["torpedo"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger_fp",
        "Torpedo",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_food_bs_burger2",
            PropBone = 18905,
            PropPlacement = {
                0.1,
                -0.07,
                0.091,
                15.0,
                135.0,
                0.0
            }
        }
    },
    ["circularsaw"] = {
        "anim@heists@fleeca_bank@drilling",
        "drill_straight_fail",
        "Circular Saw",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_tool_consaw",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                90.0
            }
        }
    },
    ["digiscan4"] = {
        "weapons@misc@digi_scanner",
        "aim_med_loop",
        "Digiscan 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "w_am_digiscanner",
            PropBone = 28422,
            PropPlacement = {
                0.048,
                0.078,
                0.004,
                -81.6893,
                2.5616,
                -15.7909
            }
        }
    },
    ["digiscan5"] = {
        "weapons@misc@digi_scanner",
        "aim_low_loop",
        "Digiscan 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "w_am_digiscanner",
            PropBone = 28422,
            PropPlacement = {
                0.048,
                0.078,
                0.004,
                -81.6893,
                2.5616,
                -15.7909
            }
        }
    },
    ["digiscan6"] = {
        "weapons@misc@digi_scanner",
        "aim_high_loop",
        "Digiscan 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "w_am_digiscanner",
            PropBone = 28422,
            PropPlacement = {
                0.048,
                0.078,
                0.004,
                -81.6893,
                2.5616,
                -15.7909
            }
        }
    },
    ["gift3"] = {
        "bz@give_love@anim",
        "bz_give",
        "Gift 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "bzzz_prop_gift_purple",
            PropBone = 57005,
            PropPlacement = {
                0.15,
                -0.03,
                -0.14,
                -77.0,
                -120.0,
                40.0
            }
        }
    },
    ["gift4"] = {
        "bz@give_love@anim",
        "bz_give",
        "Gift 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "bzzz_prop_gift_orange",
            PropBone = 57005,
            PropPlacement = {
                0.15,
                -0.03,
                -0.14,
                -77.0,
                -120.0,
                40.0
            }
        }
    },
    ["gift5"] = {
        "bz@give_love@anim",
        "bz_give",
        "Gift 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "bzzz_prop_gift_jewel",
            PropBone = 57005,
            PropPlacement = {
                0.12,
                0.0,
                -0.19,
                -41.0,
                -120.0,
                40.0
            }
        }
    },
    ["gift6"] = {
        "bz@give_love@anim",
        "bz_give",
        "Gift 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "bzzz_prop_gift_bonbonier",
            PropBone = 57005,
            PropPlacement = {
                0.12,
                0.0,
                -0.19,
                -41.0,
                -120.0,
                40.0
            }
        }
    },
    ["guitarback"] = {
        "amb@bagels@male@walking@",
        "idle_a",
        "Guitar Back",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_acc_guitar_01",
            PropBone = 24818,
            PropPlacement = {
                0.2,
                -0.17,
                0.05,
                0.0,
                70.0,
                0.0
            }
        }
    },
    ["guitarback2"] = {
        "amb@bagels@male@walking@",
        "idle_a",
        "Guitar Back 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_el_guitar_01",
            PropBone = 24818,
            PropPlacement = {
                0.25,
                -0.15,
                0.05,
                -5.0,
                70.0,
                0.0
            }
        }
    },
    ["guitarback3"] = {
        "amb@bagels@male@walking@",
        "idle_a",
        "Guitar Back 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_el_guitar_02",
            PropBone = 24818,
            PropPlacement = {
                0.2,
                -0.17,
                0.05,
                0.0,
                70.0,
                0.0
            }
        }
    },
    ["guitarback4"] = {
        "amb@bagels@male@walking@",
        "idle_a",
        "Guitar Back 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_el_guitar_03",
            PropBone = 24818,
            PropPlacement = {
                0.2,
                -0.15,
                0.05,
                -5.0,
                70.0,
                0.0
            }
        }
    },
    ["idcard7"] = {
        "amb@code_human_wander_clipboard@male@base",
        "static",
        "ID Card 7 - Passport",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "bkr_prop_fakeid_openpassport",
            PropBone = 60309,
            PropPlacement = {
                -0.023,
                0.033,
                -0.06,
                -80.7083,
                90.867,
                41.4814
            }
        }
    },
    ["jackhammer"] = {
        "amb@world_human_const_drill@male@drill@base",
        "base",
        "JackHammer",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_tool_jackham",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
            }
        }
    },
    ["megaphone4"] = {
        "amb@world_human_mobile_film_shocking@female@base",
        "base",
        "Megaphone 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_megaphone_01",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                80.0
            }
        }
    },
    ["walkingstick2"] = {
        "missbigscore2aleadinout@bs_2a_2b_int",
        "lester_base_idle",
        "Walking Stick 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_cs_walking_stick",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
            },
            SecondProp = "prop_phone_ing",
            SecondPropBone = 60309,
            SecondPropPlacement = {
                0.08,
                0.03,
                0.01,
                -107.9999,
                0.0,
                -4.6003
            }
        }
    },
    ["selfiehb2"] = {
        "anim@female_selfie_cute",
        "selfie_cute_clip",
        "Selfie Hand Bag 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            Prop = "prop_ld_handbag",
            PropBone = 28422,
            PropPlacement = {
                0.09,
                -0.019,
                -0.03,
                -112.8023,
                -171.7831,
                -56.8195
            },
            SecondProp = "prop_phone_ing",
            SecondPropBone = 4185,
            SecondPropPlacement = {
                0.02,
                -0.025,
                0.0,
                -8.5947,
                30.6141,
                -5.1311
            },
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = Translate('camera'),
            PtfxWait = 200
        }
    },
    ["umbrella5"] = {
        "luxurymods@animation_female_12",
        "animation_female_12_clip",
        "Umbrella 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "p_amb_brolly_01",
            PropBone = 57005,
            PropPlacement = {
                0.15,
                0.005,
                0.0,
                87.0,
                -20.0,
                180.0
            }
        }
    },
    ["umbrella6"] = {
        "raini@sharror",
        "raini_clip",
        "Umbrella 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "p_amb_brolly_01",
            PropBone = 57005,
            PropPlacement = {
                0.15,
                0.005,
                0.0,
                87.0,
                -20.0,
                180.0
            }
        }
    },
    ["wt6"] = {
        "ultra@walkie_talkie",
        "walkie_talkie",
        "Walkie Talkie 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING,
            Prop = "prop_cs_hand_radio",
            PropBone = 18905,
            PropPlacement = {
                0.14,
                0.03,
                0.03,
                -105.877,
                -10.9432,
                -33.7212
            }
        }
    },
}


-- Bailes con animacion propia
Scully.Dances = {
    ["fortnite"] = {
        "custom@downward_fortnite",
        "Downward_fortnite",
        "Fortnite - Downward",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["fortnite2"] = {
        "custom@pullup",
        "pullup",
        "Fortnite - Pullup",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["fortnite3"] = {
        "custom@rollie",
        "rollie",
        "Fortnite - Rollie",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["fortnite4"] = {
        "custom@wanna_see_me",
        "wanna_see_me",
        "Fortnite - Wanna See Me",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["fortnite5"] = {
        "custom@billybounce",
        "billybounce",
        "Fortnite - Billy Bounce",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["gangnamstyle"] = {
        "custom@gangnamstyle",
        "gangnamstyle",
        "Gangnam Style",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["dancethriller"] = {
        "mj_thriller",
        "mj_thriller_dance",
        "Dance - MJ Thriller",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["makarena"] = {
        "custom@makarena",
        "makarena",
        "Makarena",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["salsa2"] = {
        "custom@salsa",
        "salsa",
        "Salsa 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer"] = {
        "jazzrockabillybluesetc_singer@anim",
        "sing_a_song_1",
        "Singer",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer2"] = {
        "jazzrockabillybluesetc_singer@anim",
        "sing_a_song_2",
        "Singer 2",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer3"] = {
        "jazzrockabillybluesetc_singer@anim",
        "sing_a_song_3",
        "Singer 3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer4"] = {
        "jazzrockabillybluesetc_singer@anim",
        "sing_a_song_4",
        "Singer 4",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer5"] = {
        "jazzrockabillybluesetc_singer@anim",
        "sing_a_song_5",
        "Singer 5",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer6"] = {
        "jazzrockabillybluesetc_singer@anim",
        "up_beat_1",
        "Singer 6",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer7"] = {
        "jazzrockabillybluesetc_singer@anim",
        "up_beat_2",
        "Singer 7",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer8"] = {
        "jazzrockabillybluesetc_singer@anim",
        "up_beat_3",
        "Singer 8",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer9"] = {
        "jazzrockabillybluesetc_singer@anim",
        "up_beat_4",
        "Singer 9",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
    ["singer10"] = {
        "jazzrockabillybluesetc_singer@anim",
        "up_beat_5",
        "Singer 10",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP
        }
    },
}


-- Emotes compartidas
Scully.Shared = {
    ["sgiveblowjob"] = {
        "misscarsteal2pimpsex",
        "pimpsex_hooker",
        "Give Blowjob",
        "sreceiveblowjob",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            SyncOffsetFront = 0.63
        },
        AdultAnimation = true
    },
    ["pback3"] = {
        "anim@arena@celeb@flat@paired@no_props@",
        "piggyback_c_player_a",
        "Piggy Back 3",
        "pback4",
        AnimationOptions = {
            onFootFlag = AnimFlag.MOVING
        }
    },
    ["pback4"] = {
        "anim@arena@celeb@flat@paired@no_props@",
        "piggyback_c_player_b",
        "Piggy Back 4",
        "pback3",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            Attachto = true,
            bone = 0,
            pos = vector3(0.0, -0.7, 0.4),
            rot = vector3(0.0, 0.0, 0.0)
        }
    },
    ["sreceiveblowjob"] = {
        "misscarsteal2pimpsex",
        "pimpsex_punter",
        "Receive Blowjob",
        "sgiveblowjob",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            SyncOffsetFront = 0.63
        },
        AdultAnimation = true
    },
    ["sstreetsexfemale"] = {
        "misscarsteal2pimpsex",
        "shagloop_hooker",
        "Street Sex Female",
        "sstreetsexmale",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            SyncOffsetFront = 0.5
        },
        AdultAnimation = true
    },
    ["sstreetsexmale"] = {
        "misscarsteal2pimpsex",
        "shagloop_pimp",
        "Street Sex Male",
        "sstreetsexfemale",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            SyncOffsetFront = 0.5
        },
        AdultAnimation = true
    },
}


RegisterAddonEmotes(Scully)
