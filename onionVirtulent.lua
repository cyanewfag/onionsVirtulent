--
-- Discord
-- https://discord.gg/8UQ2qQ5
--

--
-- Variables
--

-- Window
local onion_window = gui.Tab(gui.Reference("Settings"), 'onion_window_virulent', "Onion's Virulent")

-- Groupboxes
local onion_window_groupbox_1 = gui.Groupbox(onion_window, 'Settings', 15, 15)
local onion_window_groupbox_2 = gui.Groupbox(onion_window, 'Killsay Settings', 15, 185)
local onion_window_groupbox_3 = gui.Groupbox(onion_window, 'Deathsay Settings', 15, 365)
local onion_window_groupbox_4 = gui.Groupbox(onion_window, 'HUD Settings', 15, 545)

-- Settings Groupbox
local onion_killsay_enable = gui.Checkbox( onion_window_groupbox_1, "onion_killsay_enable", "Enable Killsay", true)
local onion_deathsay_enable = gui.Checkbox( onion_window_groupbox_1, "onion_deathsay_enable", "Enable Deathsay", true)
local onion_hud_enable = gui.Checkbox( onion_window_groupbox_1, "onion_hud_enable", "Enable HUD", true)

-- Killsay Groupbox
local onion_killsay_settings_toxicity_enable = gui.Checkbox( onion_window_groupbox_2, "onion_killsay_settings_toxicity_enable", "Toxicity Levels", true)
local onion_killsay_settings_toxicity_amount = gui.Slider( onion_window_groupbox_2, "onion_killsay_settings_toxicity_amount", "Toxicity Amount (Lower is nicer)", 3, 1, 3 )
local onion_killsay_settings_bot = gui.Checkbox( onion_window_groupbox_2, "onion_killsay_settings_bot", "Bot Check", true)

-- Deathsay Groupbox
local onion_deathsay_settings_toxicity_enable = gui.Checkbox( onion_window_groupbox_3, "onion_deathsay_settings_toxicity_enable", "Toxicity Levels", true)
local onion_deathsay_settings_toxicity_amount = gui.Slider( onion_window_groupbox_3, "onion_deathsay_settings_toxicity_amount", "Toxicity Amount (Lower is nicer)", 3, 1, 3 )
local onion_deathsay_settings_bot = gui.Checkbox( onion_window_groupbox_3, "onion_deathsay_settings_bot", "Bot Check", true)

-- HUD Groupbox
local onion_hud_killsay_enable = gui.Checkbox( onion_window_groupbox_4, "onion_hud_killsay_enable", "Killsay HUD", true)
local onion_hud_deathsay_enable = gui.Checkbox( onion_window_groupbox_4, "onion_hud_deathsay_enable", "Deathsay HUD", true)
local onion_hud_style = gui.Combobox(onion_window_groupbox_4, 'onion_hud_style', 'HUD Style', "Skeet", "Onetap")
local onion_hud_color_text = gui.ColorPicker(onion_window_groupbox_4, 'onion_hud_color_text', 'HUD Text Color', 255, 255, 255, 255)
local onion_hud_color_gradient_1 = gui.ColorPicker(onion_window_groupbox_4, 'onion_hud_color_gradient_1', 'First Gradient Color', 0, 183, 255, 255)
local onion_hud_color_gradient_2 = gui.ColorPicker(onion_window_groupbox_4, 'onion_hud_color_gradient_2', 'Second Gradient Color', 0, 137, 191, 255)

-- Misc Variables
local killMessages = { }
local deathMessages = { }
local allMessages
local initialize = false
local scrW, scrH
local localPlayer

--
-- Misc Functions
--

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function getPropFloat(lp, wat)
    return lp:GetPropFloat("localdata", wat)
end

function getPropInt(lp, wat)
    return lp:GetPropInt("localdata", wat)
end

function split(delimiter, string)
    local t = {}

    for substr in string.gmatch(string, "[^".. delimiter.. "]*") do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(t,substr)
        end
    end

    return t
end

--
-- Drawing Functions
--

function drawFilledRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.FilledRect(x, y, x + width, y + height)
end

function drawOutlineRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.OutlinedRect(x, y, x + width, y + height)
end

function drawRoundedFilledRect(r, g, b, a, x, y, width, height, radius)
	draw.Color(r, g, b, a)
	draw.RoundedRectFill(x, y, x + width, y + height, radius)
end

function drawRoundedOutlineRect(r, g, b, a, x, y, width, height, radius)
	draw.Color(r, g, b, a)
	draw.RoundedRect(x, y, x + width, y + height, radius)
end

function drawFilledCircle(r, g, b, a, x, y, r)
	draw.Color(r, g, b, a)
	draw.FilledCircle(x, y, r)
end

function drawOutlinedCircle(r, g, b, a, x, y, r)
	draw.Color(r, g, b, a)
	draw.OutlinedCircle(x, y, r)
end

function drawText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	draw.Text(x, y, str)
end

function drawCenteredText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	local textW, textH = draw.GetTextSize(str)
	draw.Text(x - (textW / 2), y - (textH / 2), str)
end

function drawGradient( color1, color2, x, y, w, h, vertical )
	local r2, g2, b2 = color1[1], color1[2], color1[3]
	local r, g, b = color2[1], color2[2], color2[3]
	
    drawFilledRect( r2, g2, b2, 255, x, y, w, h )

    if vertical then
        for i = 1, h do
            local a = i / h * 255
            drawFilledRect( r, g, b, a, x, y + i, w, 1)
        end
    else
        for i = 1, w do
            local a = i / w * 255
            drawFilledRect( r, g, b, a, x + i, y, 1, h)
        end
    end
end

function drawOutlineGradient( outlineColor, color1, color2, x, y, w, h, vertical, thickness )
	local r, g, b, a = outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4]

	drawFilledRect(r, g, b, a, x, y, w, h)
	drawGradient( color1, color2, x + thickness, y + thickness, w - (thickness * 2), h - (thickness * 2), vertical )
end

--
-- Callback Functions
--

function drawShit()
    if (initialize == false) then
		initialize = true
        scrW, scrH = draw.GetScreenSize()
        allMessages = split("|", http.Get("https://raw.githubusercontent.com/cyanewfag/onionsVirtulent/master/messages"))

        for i, name in ipairs(allMessages) do
            local cacheTable = split( "}", allMessages[i])

            if (cacheTable[2] == "1") then
                table.insert(killMessages, allMessages[i])
            elseif (cacheTable[2] == "2") then
                table.insert(deathMessages, allMessages[i])
            end
        end

        for i, name in ipairs(killMessages) do
            print("Kill Message: " .. killMessages[i] .. '\n')
        end

        for i, name in ipairs(deathMessages) do
            print("Death Message: " .. deathMessages[i] .. '\n')
        end
	end

    localPlayer = entities.GetLocalPlayer()

    drawHUD()
end

function drawHUD()

end

function chatMessage( triggeredEvent )
    if (triggeredEvent:GetName() == "player_death") then
        if (localPlayer == nil) then
            return
        end

        local localPlayerIndex = client.GetLocalPlayerIndex()
        local deadPlayer = client.GetPlayerIndexByUserID(triggeredEvent:GetInt('userid'))
        local killerPlayer = client.GetPlayerIndexByUserID(triggeredEvent:GetInt('attacker'))
        local messageCache = { }
        
        if (killerPlayer == localPlayerIndex and deadPlayer ~= localPlayerIndex) then
            if (onion_killsay_settings_bot:GetValue()) then
                local playerInfo = client.GetPlayerInfo(deadPlayer)

                if (playerInfo["IsBot"]) then
                    return
                end
            end

            if (onion_killsay_enable:GetValue()) then
                for i, name in ipairs(killMessages) do
                    if (string.match(killMessages[i], ";" .. onion_killsay_settings_toxicity_amount:GetValue())) then
                        local replace = ";" .. onion_killsay_settings_toxicity_amount:GetValue() .. "}1"
                        local messageInsert = killMessages[i]:gsub(replace, "")
                        table.insert(messageCache, messageInsert)
                    end
                end

                client.ChatSay(messageCache[math.random(#messageCache)])
            end
        elseif (killerPlayer ~= localPlayerIndex and deadPlayer == localPlayerIndex) then
            if (onion_deathsay_settings_bot:GetValue()) then
                local playerInfo = client.GetPlayerInfo(killerPlayer)

                if (playerInfo["IsBot"]) then
                    return
                end
            end

            if (onion_deathsay_enable:GetValue()) then
                for i, name in ipairs(deathMessages) do
                    if (string.match(deathMessages[i], ";" .. onion_deathsay_settings_toxicity_amount:GetValue())) then
                        local replace = ";" .. onion_deathsay_settings_toxicity_amount:GetValue() .. "}2"
                        local messageInsert = deathMessages[i]:gsub(replace, "")
                        table.insert(messageCache, messageInsert)
                    end
                end

                client.ChatSay(messageCache[math.random(#messageCache)])
            end
        end
    end
end

--
-- Callbacks / Listeners
--

callbacks.Register('Draw', drawShit);

client.AllowListener( 'player_death' );
callbacks.Register( 'FireGameEvent', chatMessage );
