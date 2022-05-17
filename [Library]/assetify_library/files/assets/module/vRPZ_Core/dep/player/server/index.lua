-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getElementsByType = getElementsByType,
    getPlayerSerial = getPlayerSerial,
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent
}


----------------
--[[ Module ]]--
----------------

CPlayer.CBuffer = {}

CPlayer.fetch = function(serial, ...)
    dbify.serial.fetchAll({
        {dbify.serial.connection.keyColumn, serial}
    }, ...)
    return true
end

CPlayer.setData = function(serial, serialDatas, callback, ...)
    dbify.serial.setData(serial, serialDatas, function(result, args)
        if result and CPlayer.CBuffer[serial] then
            for i = 1, #serialDatas, 1 do
                local j = serialDatas[i]
                CPlayer.CBuffer[serial][(j[1])] = j[2]
            end
        end
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            imports.table.remove(args, 1)
            callbackReference(result, args)
        end
    end, serialDatas, ...)
    return true
end

CPlayer.getData = function(serial, serialDatas, callback, ...)
    dbify.serial.getData(serial, serialDatas, function(result, args)
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            callbackReference(result, args)
        end
        if result and CPlayer.CBuffer[serial] then
            for i, j in imports.pairs(serialDatas) do
                CPlayer.CBuffer[serial][j] = result[j]
            end
        end
    end, ...)
    return true
end

CPlayer.getSerial = function(player)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    return imports.getPlayerSerial(player)
end

CPlayer.getPlayer = function(serial)
    if not serial then return false end
    local players = imports.getElementsByType("player")
    for i = 1, #players, 1 do
        local j = players[i]
        if CPlayer.isInitialized(j) then
            if CPlayer.getSerial(j) == serial then
                return j
            end
        end
    end
    return false
end

CPlayer.getInventoryID = function(player)
    local characterID = CPlayer.getCharacterID(player)
    return (characterID and CCharacter.CBuffer[characterID] and CCharacter.CBuffer[characterID].inventory) or false
end

CPlayer.setLogged = function(player, state)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    if state then
        if CPlayer.CLogged[player] then return false end
        CPlayer.CLogged[player] = true
        for i, j in imports.pairs(CPlayer.CLogged) do
            imports.triggerClientEvent(i, "Player:onLogin", player)
            if i ~= player then
                imports.triggerClientEvent(player, "Player:onLogin", i)
            end
        end
        imports.triggerEvent("Player:onLogin", player)
    else
        if not CPlayer.CLogged[player] then return false end
        for i, j in imports.pairs(CPlayer.CLogged) do
            imports.triggerClientEvent(i, "Player:onLogout", player)
        end
        CPlayer.CLogged[player] = nil
        imports.triggerEvent("Player:onLogout", player)
    end
    return true
end

CPlayer.setChannel = function(player, channelIndex)
    channelIndex = imports.tonumber(channelIndex)
    if not CPlayer.isInitialized(player) or not channelIndex or not FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] then return false end
    imports.triggerClientEvent(player, "Client:onUpdateChannel", player, channelIndex)
    CPlayer.CChannel[player] = channelIndex
    return true 
end

CPlayer.setParty = function(player, partyData)
    if imports.type(player) == "table" then
        imports.triggerClientEvent(player, "Client:onUpdateParty", player[1], partyData)
        for i = 1, #player do
            CPlayer.CParty[player[i]] = partyData
        end
        return true
    else
        if not CPlayer.isInitialized(player) then return false end
        imports.triggerClientEvent(partyData.members, "Client:onUpdateParty", player, partyData)
        CPlayer.CParty[player] = partyData
        return true
    end
end