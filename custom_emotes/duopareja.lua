-- duopareja -- poses de pareja/duo (Shared) del pack DUOPAREJA.
-- Dict y clip tomados de los README de cada pack; los .ycd no se tocan.
-- Cada pareja lleva su propio SyncOffset en vez del 1.0 m por defecto que
-- aplica EmoteMenu cuando no se define ninguno.

local ENABLED = true -- ponlo en false para desactivar el pack
if not ENABLED then return end

---@type AnimationListConfig
---@diagnostic disable-next-line: missing-fields
local CustomDP = {}

CustomDP.Shared = {}

-- El offset lo aplica quien INICIA la emote, y puede iniciarla cualquiera de los
-- dos lados: el juego usa el SyncOffset de la entrada que se elige en el menu.
-- Por eso cada lado lleva el suyo. Los cuatro numeros de B son opcionales; sin
-- ellos, lanzar la pose desde ese lado usa el metro por defecto de DWK.
local function addPair(a, dictA, clipA, b, dictB, clipB, label,
                       front, side, height, heading,
                       bFront, bSide, bHeight, bHeading, attach)
    local optionsA = {
        EmoteLoop = true,
        EmoteMoving = false,
        SyncOffsetFront = front,
        SyncOffsetSide = side,
        SyncOffsetHeight = height,
        SyncOffsetHeading = heading,
    }

    if attach then
        -- Piloto Attachto: el iniciador se engancha a su pareja y asi la
        -- posicion la reproduce la red en todas las pantallas. El pos/rot del
        -- enganche lo deriva Syncing de estos mismos SyncOffset (GetAttachTransform),
        -- con lo que /emoteoffset sigue sirviendo para calibrar la pose.
        optionsA.Attachto = true
        optionsA.bone = 0 -- SKEL_ROOT
        optionsA.pos = vector3(front, side, height)
        optionsA.rot = vector3(0.0, 0.0, -heading)
    end

    CustomDP.Shared[a] = {
        dictA, clipA, label .. ' (A)', b,
        AnimationOptions = optionsA
    }

    local optionsB = {
        EmoteLoop = true,
        EmoteMoving = false,
    }

    if bFront then
        optionsB.SyncOffsetFront = bFront
        optionsB.SyncOffsetSide = bSide
        optionsB.SyncOffsetHeight = bHeight
        optionsB.SyncOffsetHeading = bHeading

        if attach then
            optionsB.Attachto = true
            optionsB.bone = 0 -- SKEL_ROOT
            optionsB.pos = vector3(bFront, bSide, bHeight)
            optionsB.rot = vector3(0.0, 0.0, -bHeading)
        end
    end

    CustomDP.Shared[b] = { dictB, clipB, label .. ' (B)', a, AnimationOptions = optionsB }
end

addPair("couple76f", "smo@couple_76", "f_couple_76_clip", "couple76m", "smo@couple_76", "m_couple_76_clip", "Couple Pose 76 (Smos)", 0.69, 0.00, 0.00, 6.00, -0.72, 0.08, 0.00, 355.00, true)
addPair("couple77f", "smo@couple_77", "f_couple_77_clip", "couple77m", "smo@couple_77", "m_couple_77_clip", "Couple Pose 77 (Smos)", 0.06, 0.42, 0.00, 0.00, 0.05, -0.48, 0.00, 13.00, true)
addPair("couple78f", "smo@couple_78", "f_couple_78_clip", "couple78m", "smo@couple_78", "m_couple_78_clip", "Couple Pose 78 (Smos)", 0.12, 0.20, 0.00, 0.00, true)
addPair("couple82f", "smo@couple_82", "f_couple_82_clip", "couple82m", "smo@couple_82", "m_couple_82_clip", "Couple Pose 82 (Smos)", 0.02, -0.39, 0.00, 0.00, -0.02, 0.40, 0.00, 359.00, true)
addPair("couple83f", "smo@couple_83", "f_couple_83_clip", "couple83m", "smo@couple_83", "m_couple_83_clip", "Couple Pose 83 (Smos)", 0.06, 0.41, 0.00, 0.00, -0.21, -0.28, 0.00, 323.00, true)
addPair("couple84f", "smo@couple_84", "f_couple_84_clip", "couple84m", "smo@couple_84", "m_couple_84_clip", "Couple Pose 84 (Smos)", -0.33, -0.02, 0.00, 0.00, 0.29, 0.00, 0.00, 355.00, true)
addPair("couple85f", "smo@couple_85", "f_couple_85_clip", "couple85m", "smo@couple_85", "m_couple_85_clip", "Couple Pose 85 (Smos)", 0.02, 0.28, 0.00, 0.00, true)
addPair("couple86f", "smo@couple_86", "f_couple_86_clip", "couple86m", "smo@couple_86", "m_couple_86_clip", "Couple Pose 86 (Smos)", 0.45, -0.05, 0.00, 0.00, -0.44, 0.03, 0.00, 356.00, true)
addPair("couple87f", "smo@couple_87", "f_couple_87_clip", "couple87m", "smo@couple_87", "m_couple_87_clip", "Couple Pose 87 (Smos)", 0.08, 0.00, 0.00, 180.00, true)
addPair("couple88f", "smo@couple_88", "f_couple_88_clip", "couple88m", "smo@couple_88", "m_couple_88_clip", "Couple Pose 88 (Smos)", 0.05, 0.00, 0.00, 180.00, -0.35, -0.02, 0.00, 14.00, true)
addPair("couple89f", "smo@couple_89", "f_couple_89_clip", "couple89m", "smo@couple_89", "m_couple_89_clip", "Couple Pose 89 (Smos)", 0.05, 0.00, 0.00, 0.00, true)
addPair("couple90f", "smo@couple_90", "f_couple_90_clip", "couple90m", "smo@couple_90", "m_couple_90_clip", "Couple Pose 90 (Smos)", 0.10, 0.00, 0.00, 180.00, true)
addPair("couple115a", "smo@couple_115", "couple_115_a_clip", "couple115b", "smo@couple_115", "couple_115_b_clip", "Couple Pose 115 (Smos)", 0.08, 0.18, 0.00, 180.00, true)
addPair("couple116a", "smo@couple_116", "couple_116_a_clip", "couple116b", "smo@couple_116", "couple_116_b_clip", "Couple Pose 116 (Smos)", 0.23, -1.12, -0.11, 179.00, -0.15, -0.39, 0.00, 314.00, true)
addPair("couple117a", "smo@couple_117", "couple_117_a_clip", "couple117b", "smo@couple_117", "couple_117_b_clip", "Couple Pose 117 (Smos)", -1.10, 0.52, 0.11, 26.00, 0.47, -0.08, 0.18, 17.00, true)
addPair("couple118a", "smo@couple_118", "couple_118_a_clip", "couple118b", "smo@couple_118", "couple_118_b_clip", "Couple Pose 118 (Smos)", -0.21, 0.76, 0.00, 0.00, 0.24, -0.79, -0.37, 352.00, true)
addPair("couple119a", "smo@couple_119", "couple_119_a_clip", "couple119b", "smo@couple_119", "couple_119_b_clip", "Couple Pose 119 (Smos)", 0.00, 0.30, 0.00, 0.00, 0.04, -0.36, 0.00, 11.00, true)
addPair("couple120a", "smo@couple_120", "couple_120_a_clip", "couple120b", "smo@couple_120", "couple_120_b_clip", "Couple Pose 120 (Smos)", 0.02, 0.00, 0.00, 180.00, true)
addPair("couple121a", "smo@couple_121", "couple_121_a_clip", "couple121b", "smo@couple_121", "couple_121_b_clip", "Couple Pose 121 (Smos)", 0.22, 0.01, 0.05, 4.00, -0.12, 0.03, 0.00, 0.00, true)
addPair("couple122a", "smo@couple_122", "couple_122_a_clip", "couple122b", "smo@couple_122", "couple_122_b_clip", "Couple Pose 122 (Smos)", -0.19, 0.00, 0.00, 358.00, 0.22, 0.00, 0.00, 5.00, true)
addPair("couple123a", "smo@couple_123", "couple_123_a_clip", "couple123b", "smo@couple_123", "couple_123_b_clip", "Couple Pose 123 (Smos)", 0.05, 0.00, 0.00, 180.00, true)
addPair("couple124a", "smo@couple_124", "couple_124_a_clip", "couple124b", "smo@couple_124", "couple_124_b_clip", "Couple Pose 124 (Smos)", 0.12, -0.54, 0.00, 0.00, -0.02, 0.44, 0.00, 2.00, true)
addPair("couple125a", "smo@couple_125", "couple_125_a_clip", "couple125b", "smo@couple_125", "couple_125_b_clip", "Couple Pose 125 (Smos)", 0.07, 0.19, 0.00, 308.00, 0.07, -0.27, 0.02, 50.00, true)
addPair("couple126a", "smo@couple_126", "couple_126_a_clip", "couple126b", "smo@couple_126", "couple_126_b_clip", "Couple Pose 126 (Smos)", 0.00, 0.00, 0.00, 0.00, -0.02, 0.00, 0.00, 3.00, true)
addPair("couple127a", "smo@couple_127", "couple_127_a_clip", "couple127b", "smo@couple_127", "couple_127_b_clip", "Couple Pose 127 (Smos)", 0.00, 0.00, 0.00, 180.00, true)
addPair("couple128a", "smo@couple_128", "couple_128_a_clip", "couple128b", "smo@couple_128", "couple_128_b_clip", "Couple Pose 128 (Smos)", 0.05, 0.00, 0.00, 180.00, true)
addPair("couple129a", "smo@couple_129", "couple_129_a_clip", "couple129b", "smo@couple_129", "couple_129_b_clip", "Couple Pose 129 (Smos)", 0.05, 0.00, 0.00, 180.00, true)
addPair("couple130a", "smo@couple_130", "couple_130_a_clip", "couple130b", "smo@couple_130", "couple_130_b_clip", "Couple Pose 130 (Smos)", 0.00, 0.25, 0.00, 0.00, true)
addPair("couple131a", "smo@couple_131", "couple_131_a_clip", "couple131b", "smo@couple_131", "couple_131_b_clip", "Couple Pose 131 (Smos)", 0.00, 0.14, 0.23, 23.00, true)
addPair("couple132a", "smo@couple_132", "couple_132_a_clip", "couple132b", "smo@couple_132", "couple_132_b_clip", "Couple Pose 132 (Smos)", 0.00, 0.00, 0.00, 180.00, true)
addPair("couple133a", "smo@couple_133", "couple_133_a_clip", "couple133b", "smo@couple_133", "couple_133_b_clip", "Couple Pose 133 (Smos)", 0.26, -0.06, 0.00, 0.00, -0.25, 0.05, 0.00, 14.00, true)
addPair("homie1a", "smo@homie_pose_01", "homie_pose_01_a_clip", "homie1b", "smo@homie_pose_01", "homie_pose_01_b_clip", "Homie Pose 1 (Smos)", -0.03, 0.38, 0.00, 6.00, 0.06, -0.34, 0.00, 1.00, true)
addPair("homie2a", "smo@homie_pose_02", "homie_pose_02_a_clip", "homie2b", "smo@homie_pose_02", "homie_pose_02_b_clip", "Homie Pose 2 (Smos)", 0.00, 0.30, 0.00, 0.00, true)
addPair("homie3a", "smo@homie_pose_03", "homie_pose_03_a_clip", "homie3b", "smo@homie_pose_03", "homie_pose_03_b_clip", "Homie Pose 3 (Smos)", 0.00, -0.43, 0.00, 0.00, -0.02, 0.50, 0.00, 1.00, true)
addPair("ffriend10a", "smo@friend_female_10", "f_friend_10_a_clip", "ffriend10b", "smo@friend_female_10", "f_friend_10_b_clip", "Friend Pose 10 (Smos)", 0.00, 0.28, 0.00, 0.00, true)
addPair("ffriend11a", "smo@friend_female_11", "f_friend_11_a_clip", "ffriend11b", "smo@friend_female_11", "f_friend_11_b_clip", "Friend Pose 11 (Smos)", 0.08, 0.50, 0.00, 0.00, 0.05, -0.50, 0.00, 25.00, true)
addPair("ffriend12a", "smo@friend_female_12", "f_friend_12_a_clip", "ffriend12b", "smo@friend_female_12", "f_friend_12_b_clip", "Friend Pose 12 (Smos)", 0.00, 0.28, 0.00, 0.00, true)
addPair("ffriend13a", "smo@friend_female_13", "f_friend_13_a_clip", "ffriend13b", "smo@friend_female_13", "f_friend_13_b_clip", "Friend Pose 13 (Smos)", 0.00, 0.52, 0.00, 0.00, 0.06, -0.51, 0.00, 4.00, true)
addPair("ffriend14a", "smo@friend_female_14", "f_friend_14_a_clip", "ffriend14b", "smo@friend_female_14", "f_friend_14_b_clip", "Friend Pose 14 (Smos)", -0.10, 0.39, 0.00, 317.00, 0.25, -0.22, 0.00, 77.00, true)
addPair("ffriend15a", "smo@friend_female_15", "f_friend_15_a_clip", "ffriend15b", "smo@friend_female_15", "f_friend_15_b_clip", "Friend Pose 15 (Smos)", -0.18, 0.41, 0.00, 0.00, 0.25, -0.38, 0.00, 8.00, true)
addPair("fcouple5", "anim@female_couple_05", "f_couple_05_clip", "mcouple5", "anim@male_couple_05", "m_couple_05_clip", "Couple Pose 5 (MrWitt)", 0.05, 0.00, 0.00, 8.00, -0.08, -0.02, 0.00, 358.00, true)
addPair("fcouple6", "anim@female_couple_06", "f_couple_06_clip", "mcouple6", "anim@male_couple_06", "m_couple_06_clip", "Couple Pose 6 (MrWitt)", 0.55, 0.00, 0.00, 357.00, -0.59, 0.00, 0.00, 3.00, true)
addPair("fcouple7", "anim@female_couple_07", "f_couple_07_clip", "mcouple7", "anim@male_couple_07", "m_couple_07_clip", "Couple Pose 7 (MrWitt)", 0.05, 0.00, 0.00, 180.00, true)
addPair("floeckchen_couple3_f", "floeckchen@couple_3_f", "couple_3_f_clip", "floeckchen_couple3_m", "floeckchen@couple_3_m", "couple_3_m_clip", "Floeckchen Couple 3", -0.04, 0.19, 0.00, 37.00, -0.01, -1.23, 0.00, 348.00, true)
addPair("perlenfuchs_couple5_f", "perlenfuchs@couple5_f", "couple5_f_clip", "perlenfuchs_couple5_m", "perlenfuchs@couple5_m", "couple5_m_clip", "Perlenfuchs Couple 5", 0.05, 0.00, 0.00, 180.00, true)
addPair("perlenfuchs_couple7_f", "perlenfuchs@couple7_f", "couple7_f_clip", "perlenfuchs_couple7_m", "perlenfuchs@couple7_m", "couple7_m_clip", "Perlenfuchs Couple 7", 0.05, 0.00, 0.00, 180.00, true)

RegisterAddonEmotes(CustomDP)
