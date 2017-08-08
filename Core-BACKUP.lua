local scm = SendChatMessage;
local eventFrame = CreateFrame("FRAME");
local BotOwner = {"'The Air'", "Air", "Weldo"};
local BotCommands = {"showerthought", "color", "quote", "setquote", "randomquote", "uptime", "level", "leaderboard", "credit"};
local BotSoonStorage = {};
local BotCredit = {"Monty","Chase","Deramyr","Elaena"};
local refcd = true;
local trivia = false;

ABB = {};
ABB.xp = {};
ABB.color = {};
ABB.BQS = {};
ABB.cd = {};

local v = CreateFrame("Frame")
v:RegisterEvent("PLAYER_LOGIN")
v:SetScript("OnEvent", function(self)
	ABB.uptime = time()
end)

eventFrame:RegisterEvent("CHAT_MSG_GUILD", msg, sender)
eventFrame:RegisterEvent("CHAT_MSG_SYSTEM", msg)
eventFrame:SetScript("OnEvent", function(_, event, msg, sender)
	if event == "CHAT_MSG_GUILD" then tinsert(Coldeye,format("[(%s) %s]: %s",date(),sender,msg)) end;
	
	local sender = BotClearName(sender)
	local nmsg = msg	
	local msg = msg:lower();

	if string.find(msg, "bot") == nil and string.find(msg, "00ccff") == nil then
		if event == "CHAT_MSG_GUILD" then
			local Clevelup, Clevel = BotLevelPhase(msg, sender)
			
			if Clevelup == true then
				scm("|cff00ccff[BOT] |cff"..BotColor(sender)..sender.." just reached level "..Clevel.."!|r","GUILD")
			end
		end
	end
	
	if event == "CHAT_MSG_GUILD" and string.find(msg, "+") == 1 then
		if Bcd == nil then
			Bcd = time()
		
			local cmd = GuildResponseCheck(event, msg, sender);
			guildresponses[cmd](msg, sender, nmsg);
		elseif Bcd+3 < time() then
			Bcd = time()
		
			local cmd = GuildResponseCheck(event, msg, sender);
			guildresponses[cmd](msg, sender, nmsg);
		end
	elseif event == "CHAT_MSG_SYSTEM" then
		SystemResponseCheck(msg);
	end
end)

BotLevelPlayer = function(sender)
    if ABB.xp[sender] ~= nil then
        return floor(ABB.xp[sender] / 3185);
    else
		ABB.xp[sender] = 0
        return floor(ABB.xp[sender] / 3185);
    end
end

BotLevelXp = function(sender, sxp, msg)
		if ABB.cd[sender] == nil then
			ABB.cd[sender] = time()
		
			local Guildval, Timeval, Dayval, Kuuval = nil, nil, nil
	
			local a, b, c = GetNumGuildMembers()
			if c < 10 then Guildval = 0.9 else Guildval = 1.1 end
				local h,m = GetGameTime()
				local hour = tonumber(h..m)
			if hour >= 1759 then Timeval = 1.5 elseif hour >= 1159 then Timeval = 0.95 elseif hour >= 0559 then Timeval = 1.1 elseif hour >= 0000 then Timeval = 1.05 end
			if date("%A") == Saturday or date("%A") == Sunday then Dayval = 0.95 else Dayval = 1.05 end
			if sxp > 150 then Kuuval = 0.05 else Kuuval = 1 end
			if string.find(msg, "+") == 1 then sxp = 0 end
	
			local xp = ((((sxp * Guildval) * Timeval) * Dayval) * Kuuval);
			ABB.xp[sender] = ABB.xp[sender] + xp;
		elseif ABB.cd[sender]+2 < time() then
			ABB.cd[sender] = time()
		
			local Guildval, Timeval, Dayval, Kuuval = nil, nil, nil
	
			local a, b, c = GetNumGuildMembers()
			if c < 10 then Guildval = 0.9 else Guildval = 1.1 end
				local h,m = GetGameTime()
				local hour = tonumber(h..m)
			if hour >= 1759 then Timeval = 1.5 elseif hour >= 1159 then Timeval = 0.95 elseif hour >= 0559 then Timeval = 1.1 elseif hour >= 0000 then Timeval = 1.05 end
			if date("%A") == Saturday or date("%A") == Sunday then Dayval = 0.95 else Dayval = 1.05 end
			if sxp > 150 then Kuuval = 0.05 else Kuuval = 1 end
			if string.find(msg, "+") == 1 then sxp = 0 end
	
			local xp = ((((sxp * Guildval) * Timeval) * Dayval) * Kuuval);
			ABB.xp[sender] = ABB.xp[sender] + xp;
		end
end

BotLevelPhase = function(msg, sender)
		local oldLevel = BotLevelPlayer(sender);
		BotLevelXp(sender, #msg, msg);
		local newLevel = BotLevelPlayer(sender);
		if oldLevel < newLevel then
			return true, newLevel;
		else
			return false;
		end
end

BotLevelLeaderboard = function()
	local first = true
	local k,v = nil, nil
	local bookmark = nil

	for x=1,BotTableSize(ABB.xp) do
	
		if first then
			k,v = next(ABB.xp)
			bookmark = k
			first = false
		else
			local newk, newv = next(ABB.xp, bookmark)
			
			if	v < newv then
				k,v = next(ABB.xp, bookmark)
			else
				bookmark = newk
			end
		end
	end

	return k,v
end

BotColor = function(sender)
	if ABB.color[sender] ~= nil then
		return ABB.color[sender]
	else
		return "ffffff"
	end
end

BotSetColor = function(msg, sender)
	local msg = gsub(msg, "+color ", "")
	local c = string.match(msg, "([%da-f][%da-f][%da-f][%da-f][%da-f][%da-f])")
	if c ~= nil then
		ABB.color[sender] = c
		return true
	else
		return false
	end
end

BotUpTime = function()
	local x = string.match((((time()-ABB.uptime)/3600)*60),"(%d*)").." Minutes (/reloads counts as relogs)"
	return x
end

BotTable = function(tab)
	local x = "";
	local temptrue = true;
	
	if not next(tab) then
		return nil
	else
		for k,v in pairs(tab) do
		
			if temptrue then
				x = v
				temptrue = false
			else
				if string.find(x,v) == nil then
					x = x..", "..v
				end
			end
		end
	
		return x
	end
end

BotOwnerCheck = function(sender)
	local t = false;
	for k,v in pairs(BotOwner) do
		if v == sender then
			t = true;
		end
	end
	
	return t;
end

BotTableSize = function(tab)
	local count = 0
	for _ in pairs(tab) do count = count + 1 end
	return count
end

BotRandomQuote = function()
	if BotTableSize(ABB.BQS) ~= 0 then
		local first = true
		local k,v = nil, nil
	
		for x=1,math.random(1,BotTableSize(ABB.BQS)) do
	
			if first then
				k,v = next(ABB.BQS)
				first = false
			else
				k,v = next(ABB.BQS, k)
			end
		end

		return v
	else
		return "No quotes found!"
	end
end

BotQuote = function(msg, sender, nmsg)
	local player = string.match(nmsg, "+%a* (.*)")
	
	if player == nil then
		if ABB.BQS[sender] ~= nil then 
			return ABB.BQS[sender] 
		else 
			return "No quote found for you, "..sender
		end
	else
		if ABB.BQS[player] ~= nil then 
			return ABB.BQS[player] 
		else 
			return "No quote found for you, "..player
		end
	end
end

BotSetQuote = function(msg, sender, nmsg)
	local quote = string.match(nmsg, "+%a+%s+(.*)")
	local quotecheck = false
	
	if quote ~= nil then
		for k,v in pairs(ABB.BQS) do
			if quote:lower() == v:lower() then
				quotecheck = true
				break
			end
		end
	
		if quotecheck == false then
			if quote ~= nil then
				if not string.find(quote:lower(), "traps") and not string.find(quote:lower(), "gay") and not string.find(quote:lower(), "arent") or not string.find(quote:lower(), "not") and not string.find(quote:lower(), "traps") and not string.find(quote:lower(), "gay") then
					ABB.BQS[sender] = quote
					scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Quote set for: "..sender.."|r", "GUILD")
				else
					ABB.BQS[sender] = "Traps are gay"
					scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Quote set for: "..sender.."|r", "GUILD")
				end
			else
				scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Missing value.|r", "GUILD")
			end
		else
			scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Someone is already using that quote!|r", "GUILD")
		end
	else
		scm("|cff00ccff[BOT] |cff"..BotColor(sender).."No quote to be found. (*setquote QUOTE)|r", "GUILD")
	end
end

BotShowerthought = function(msg)
	local x = ABB.STR[math.random(1,#ABB.STR)]
	local c = string.match(msg, "+%a+%s+(%d*)")
	local m = tonumber(c)
	local n = tonumber(#ABB.STR)

	if c == nil then
		return x
	else
		if m <= n then
			return ABB.STR[m]
		else
			return "Too high number! Possible showerthought quotes: "..#ABB.STR
		end
	end
end

BotAddShower = function(msg, sender, nmsg)
	if sender == "Weldo" then
		local quote = string.match(nmsg, "+%a* (.*)")
	
		if quote ~= nil then
			ABB.STR[#ABB.STR+1] = quote
			scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Added quote at"..#ABB.STR.."|r", "GUILD")
		else
			scm("|cff00ccff[BOT] |cff"..BotColor(sender).."No quote to set! (*addshowerthought QUOTE)|r", "GUILD")
		end
	else
		scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Only the owner may use this command. (Weldo)|r", "GUILD")
	end
end

BotShortenXp = function(v)
	local t = string.match(v, "(%d*).%d?%d?")

	if string.len(t) > 4 then
		t = (string.match(v, "(%d*).%d?%d?")/1000)
		t = string.match(t, "%d*.%d?").."k"
	end
	
	return t
end

BotLevelBoard = function()
	local k,v = BotLevelLeaderboard()
	
	return k.." with level "..floor(v / 3185).." ("..BotShortenXp(v).." Xp)"
end

BotClearName = function(sender)
	if string.find(sender, "-Apertus") then
		return string.match(sender, "(.*)-Apertus")
	else 
		return sender
	end
end

BotColorSequence = function(msg, sender)
	local k = BotSetColor(msg, sender)
	
	if k == true then
		BotSetColor(msg, sender) scm("|cff00ccff[BOT] |cffffffff"..sender.."'s color set to: |cff"..BotColor(sender)..BotColor(sender).."|r", "GUILD")
	else
		scm("|cff00ccff[BOT] |cff"..BotColor(sender).."No color found. Try again. (*color HEXID)|r", "GUILD")
	end
end

BotLevel = function(msg, sender, nmsg)
	if string.find(msg, "+level%s+(.*)") then
		local x = string.match(nmsg, "+%a*%s?(.*)")
		
		scm("|cff00ccff[BOT] |cff"..BotColor(sender)..x.." is level: "..BotLevelPlayer(x).." ("..string.match(ABB.xp[x], "(%d*.%d?%d?)").." Xp)|r", "GUILD")
	else
		scm("|cff00ccff[BOT] |cff"..BotColor(sender)..sender.." is level: "..BotLevelPlayer(sender).." ("..string.match(ABB.xp[sender], "(%d*.%d?%d?)").." Xp)|r", "GUILD")
	end
end

guildresponses = {
	showerthoughts = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender)..BotShowerthought(msg).."|r", "GUILD") end,
	showerthought = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender)..BotShowerthought(msg).."|r", "GUILD") end,
	addshowerthought = function(msg, sender, nmsg) BotAddShower(msg, sender, nmsg) end,
	color = function(msg, sender) BotColorSequence(msg, sender) end,
	quote = function(msg, sender, nmsg) scm("|cff00ccff[BOT] |cff"..BotColor(sender)..BotQuote(msg, sender, nmsg).."|r", "GUILD") end,
	randomquote = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender)..BotRandomQuote().."|r", "GUILD") end,
	setquote = function(msg, sender, nmsg) BotSetQuote(msg, sender, nmsg) end,
	ERROR = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender).."No command like that exists!|r", "GUILD") end,
	help = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Commands available: "..BotTable(BotCommands).."|r", "GUILD")  if BotTable(BotSoonStorage) ~= nil then scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Coming soon: "..BotTable(BotSoonStorage).."|r", "GUILD") end end,
	uptime = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender).."I have been online for: "..BotUpTime(msg, sender).."!|r", "GUILD") end,
	level = function(msg, sender, nmsg) BotLevel(msg, sender, nmsg) end,
	leaderboard = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender).."The highest level is: "..BotLevelBoard().."|r", "GUILD") end,
	credit = function(msg, sender) scm("|cff00ccff[BOT] |cff"..BotColor(sender).."Special thanks to: "..BotTable(BotCredit).."!|r", "GUILD") end
}

systemreponses = {
	refresh = function() scm(".ph ann |cff00ccff[BOT] |cff"..BotColor(nil).."Refreshed!|r", "GUILD") scm(".ph ref","GUILD") end,
	welcome = function() scm("|cff33ccff[BOT] |cff"..BotColor(nil).."Welcome to the guild!|r","GUILD") end,
}

GuildResponseCheck = function(event, msg, sender)
		local cmd = string.match(msg, "+(%a*)%s*", 1)
	
		if guildresponses[cmd] ~= nil then
			return cmd
		--elseif guildresponses[cmd] == nil and string.find(msg, "+") == 1 then
			return "ERROR"
		end
end

SystemResponseCheck = function(msg)
	local x = nil 
	if string.find(msg, "rosehearth") then
		if string.find(msg, "ref")
		and not string.find(msg, "have a refresh love")
		and not string.find(msg, "have a colorful refresh")
		and string.len(string.match(msg, "[rosehearth - 29602] .*:.*ff[%da-f][%da-f][%da-f][%da-f][%da-f][%da-f](.*)")) < 35
		and	refcd == true then
		refcd = false
		C_Timer.After(30, function() refcd = true; end)
		x = "refresh"
		end
	elseif string.find(msg, " has joined the guild.") then
		x = "welcome"
	else
		x = nil
	end
	
	if x ~= nil then
		systemreponses[x](msg)
	end
	
end