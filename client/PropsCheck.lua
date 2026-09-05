-- ─── Diagnostico de props (/propscheck) ─────────────────────────────────────
--
-- Recorre todas las emotes (normales y compartidas) y comprueba con
-- IsModelInCdimage que el modelo de cada prop existe en el juego o en el stream
-- del servidor. Un prop que no este en la imagen no se vera nunca, y FiveM no
-- avisa de ello: la emote se reproduce sin el objeto en la mano.
--
-- El resultado son las emotes cuyos props el servidor NO tiene, para saber que
-- modelos hacen falta anadir/streamear.

local function collectMissingProps()
    ---@type table<string, string[]>
    local missing = {}
    local total = 0

    local function scan(source)
        if type(source) ~= "table" then return end
        for name, emote in pairs(source) do
            if type(emote) == "table" then
                local opts = emote.AnimationOptions
                if type(opts) == "table" then
                    for _, field in ipairs({ "Prop", "SecondProp" }) do
                        local prop = opts[field]
                        if type(prop) == "string" and prop ~= "" then
                            total += 1
                            local model = GetHashKey(prop)
                            if model ~= 0 and not IsModelInCdimage(model) then
                                missing[prop] = missing[prop] or {}
                                table.insert(missing[prop], name)
                            end
                        end
                    end
                end
            end
        end
    end

    scan(EmoteData)
    scan(SharedEmoteData)

    return missing, total
end

RegisterCommand('propscheck', function()
    if not Config.PropsCheckEnabled then return end

    local missing, total = collectMissingProps()

    local names = {}
    for prop in pairs(missing) do names[#names + 1] = prop end
    table.sort(names)

    -- Consola del cliente (F8): lista completa sin limites.
    if #names == 0 then
        print(('propscheck: %d props revisados (normales + compartidas), ninguno falta en el servidor'):format(total))
    else
        print(('propscheck: %d de %d props NO estan en el servidor (IsModelInCdimage = false)'):format(#names, total))
        for _, prop in ipairs(names) do
            print(('  %s  <-  %s'):format(prop, table.concat(missing[prop], ', ')))
        end
    end

    if #names == 0 then
        return SimpleNotify(('propscheck: %d props revisados, ninguno falta en el servidor'):format(total), 'success')
    end

    SimpleNotify(('propscheck: %d de %d props NO estan en el servidor (lista en chat)'):format(#names, total), 'error')

    -- Chat: resumen + lista, acotada para no inundar el feed (lo completo queda
    -- en la consola de F8).
    local lines = { ('propscheck: %d de %d props faltan en el servidor:'):format(#names, total) }
    local CHAT_LIMIT = 40
    for i, prop in ipairs(names) do
        if i <= CHAT_LIMIT then
            lines[#lines + 1] = ('  ~r~%s~w~ (emotes: %s)'):format(prop, table.concat(missing[prop], ', '))
        elseif i == CHAT_LIMIT + 1 then
            lines[#lines + 1] = ('  ... y %d mas (ver en la consola F8)'):format(#names - CHAT_LIMIT)
        end
    end
    EmoteChatMessage(table.concat(lines, '\n'), true)
end, false)