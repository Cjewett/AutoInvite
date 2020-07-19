local addonName, addonTable = ...
AutoInvite = addonTable

AutoInvite.autoInviteFrame = CreateFrame("Frame", "AutoInvite", UIParent)
AutoInvite.autoInviteFrame:RegisterEvent("PLAYER_LOGIN")
AutoInvite.autoInviteFrame:RegisterEvent("CHAT_MSG_WHISPER")
AutoInvite.autoInviteFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		AutoInvite:Initialize()
	end

	if event == "CHAT_MSG_WHISPER" then
		AutoInvite:ProcessWhisper(...)
	end
end)

function AutoInvite:Initialize()
	if AutoInviteSettings == nil then
		AutoInvite:LoadDefaults()
	else
		AutoInvite:ApplySavedVariables()
	end
end

function AutoInvite:ApplySavedVariables()
	AutoInvite:SetEnableDisable(AutoInviteSettings.AutoInviteEnabled)
	AutoInvite:SetInviteKeyword(AutoInviteSettings.AutoInviteKeyword, 0)
	AutoInvite:SetInviteChannel(AutoInviteSettings.AutoInviteChannel, 0)
end

function AutoInvite:ProcessWhisper(text, playerName)
	if not AutoInviteSettings.AutoInviteEnabled then
		return
	end

	if text == AutoInviteSettings.AutoInviteKeyword then
		InviteUnit(playerName)
	end
end

SLASH_AUTOINVITE1 = "/autoinvite"
SLASH_AUTOINVITE2 = "/autoinvite help"
SLASH_AUTOINVITE3 = "/autoinvite enable"
SLASH_AUTOINVITE4 = "/autoinvite disable"
SLASH_AUTOINVITE5 = "/autoinvite toggle"
SLASH_AUTOINVITE6 = "/autoinvite b"
SLASH_AUTOINVITE7 = "/autoinvite broadcast"
SLASH_AUTOINVITE8 = "/autoinvite k"
SLASH_AUTOINVITE9 = "/autoinvite keyword"
SLASH_AUTOINVITE10 = "/autoinvite c"
SLASH_AUTOINVITE11 = "/autoinvite channel"

SlashCmdList["AUTOINVITE"] = function(msg)
	if AutoInvite:StringIsNullOrEmpty(msg) then
		AutoInvite:PrintHelpInformation()
	end

	local slashCommandMsg = AutoInvite:SplitString(msg, " ")
	local subCommand = slashCommandMsg[1]
	local subCommandMsg = nil

	if table.getn(slashCommandMsg) > 1 then
		subCommandMsg = slashCommandMsg[2]
	end

	if subCommand == "help" then
		AutoInvite:PrintHelpInformation()
	end

	if subCommand == "toggle" then
		if AutoInviteSettings.AutoInviteEnabled then
			subCommand = "disable"
		else
			subCommand = "enable"
		end
	end

	if subCommand == "enable" then
		AutoInvite:SetEnableDisable(true)
		print("AutoInvite enabled.")
	end

	if subCommand == "disable" then
		AutoInvite:SetEnableDisable(false)
		print("AutoInvite disabled.")
	end

	if subCommand == "broadcast" or subCommand == "b" then
		AutoInvite:ProcessBroadcast(subCommandMsg, AutoInviteSettings.AutoInviteChannel)
	end

	if subCommand == "keyword" or subCommand == "k" then
		AutoInvite:ProcessKeyword(subCommandMsg)
	end

	if subCommand == "channel" or subCommand == "c" then
		AutoInvite:ProcessChannel(subCommandMsg)
	end
end

function AutoInvite:PrintHelpInformation()
	print("AutoInvite Help Information")
	print("/autoinvite, /autoinvite help -- Displays help information for AutoInvite addon.")
	print("/autoinvite enable -- Turns on the AutoInvite functionality.")
	print("/autoinvite disable -- Turns off the AutoInvite functionality.")
	print("/autoinvite toggle -- Toggles AutoInvite functionality.")
	print("/autoinvite broadcast [keyword], /autoinvite b [keyword] -- Broadcasts the invite keyword to the guild channel and enables addon if it is disabled.")
	print("/autoinvite keyword [keyword], /autoinvite k [keyword] -- Changes the invite keyword.")
	print("/autoinvite channel [channel], /autoinvite c [channel] -- Changes the invite channel. Possible examples: 'SAY', 'YELL', 'PARTY', 'GUILD', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'")
end

function AutoInvite:ProcessBroadcast(subCommandMsg, chatChannel)
	AutoInvite:SetEnableDisable(true)

	if not AutoInvite:StringIsNullOrEmpty(subCommandMsg) then
		AutoInvite:SetInviteKeyword(subCommandMsg, 0)	
	end

	if AutoInvite:StringIsNullOrEmpty(AutoInviteSettings.AutoInviteKeyword) then
		print("AutoInvite keyword is not set.")
		return
	end

	if AutoInvite:StringIsNullOrEmpty(AutoInviteSettings.AutoInviteChannel) then
		print("AutoInvite channel is not set.")
		return
	end

	SendChatMessage("Whisper me '" .. AutoInviteSettings.AutoInviteKeyword .. "' for invite.", chatChannel)
end

function AutoInvite:ProcessKeyword(keyword)
	if not AutoInvite:StringIsNullOrEmpty(keyword) then
		AutoInvite:SetInviteKeyword(keyword, 0)
	end

	if AutoInvite:StringIsNullOrEmpty(AutoInviteSettings.AutoInviteKeyword) then
		print("AutoInvite keyword is not set.")
	else
		print("AutoInvite keyword is set to '" .. AutoInviteSettings.AutoInviteKeyword .. "'.")
	end
end

function AutoInvite:ProcessChannel(channel)
	if not AutoInvite:StringIsNullOrEmpty(channel) then
		AutoInvite:SetInviteChannel(channel, 0)
	end

	if AutoInvite:StringIsNullOrEmpty(AutoInviteSettings.AutoInviteChannel) then
		print("AutoInvite channel is not set.")
	else
		print("AutoInvite channel is set to '" .. AutoInviteSettings.AutoInviteChannel .. "'.")
	end
end

function AutoInvite:StringIsNullOrEmpty(s)
	if s == nil or s == '' then
		return true
	end
end

function AutoInvite:SplitString(slashCommand, delimiter)
	result = {}

	for match in (slashCommand .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end

	return result
end