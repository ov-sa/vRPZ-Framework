-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    network = network
}


----------------
--[[ Module ]]--
----------------

CPlayer.CLanguage = nil
CPlayer.CChannel = nil
CPlayer.CParty = nil

CPlayer.setLanguage = function(language, isLangCode)
    if language and isLangCode then
        local isCodeValid = false
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Game"]["Game_Languages"]) do
            if i ~= "default" then
                if language == j.code then
                    language = i
                    isCodeValid = true
                    break
                end
            end
        end
        language = (isCodeValid and language) or false
    end
    if not language or not FRAMEWORK_CONFIGS["Game"]["Game_Languages"][language] or (CPlayer.CLanguage == language) then return false end
    imports.network:emit("Client:onUpdateLanguage", false, CPlayer.CLanguage, language)
    CPlayer.CLanguage = language
    return true 
end

CPlayer.getLanguage = function()
    return CPlayer.CLanguage or FRAMEWORK_CONFIGS["Game"]["Game_Languages"].default
end

CPlayer.setChannel = function(channelIndex)
    channelIndex = imports.tonumber(channelIndex)
    if not CPlayer.isInitialized(localPlayer) or not channelIndex or not FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] then return false end
    CPlayer.CChannel = channelIndex
    return true 
end

CPlayer.getChannel = function()
    if not CPlayer.isInitialized(localPlayer) then return false end
    return CPlayer.CChannel or false
end

CPlayer.setParty = function(partyData)
    if not CPlayer.isInitialized(localPlayer) then return false end
    CPlayer.CParty = partyData
    return true
end