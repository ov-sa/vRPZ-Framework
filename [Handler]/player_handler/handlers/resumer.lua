----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: resumer.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Resumer Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    toJSON = toJSON,
    fromJSON = fromJSON
}


------------------------------------------
--[[ Player: On Delete/Save Character ]]--
------------------------------------------

imports.addEvent("Player:onDeleteCharacter", true)
imports.addEventHandler("Player:onDeleteCharacter", root, function(characterID)
    CCharacter.delete(characterID)
end)

imports.addEvent("Player:onSaveCharacter", true)
imports.addEventHandler("Player:onSaveCharacter", root, function(character, characters)
    if not character or not characters or not characters[character] or characters[character].id then return false end

    local serial = CPlayer.getSerial(source)
    CCharacter.create(serial, function(characterID, args)
        CCharacter.setData(characterID, {
            {"identity", imports.toJSON(args[3])}
        }, function(result, args)
            if result then CCharacter.CBuffer[(args[3].id)].identity = args[3].identity end
            imports.triggerClientEvent(args[1], "Client:onSaveCharacter", args[1], (result and true) or false, args[2], (result and args[3]) or nil)
        end, args[1], args[2], {
            id = characterID,
            identity = args[3]
        })
    end, source, character, characters[character].identity)
end)


------------------------------------
--[[ Player: On Toggle Login UI ]]--
------------------------------------

imports.addEvent("Player:onToggleLoginUI", true)
imports.addEventHandler("Player:onToggleLoginUI", root, function()
    local serial = CPlayer.getSerial(source)
    CPlayer.fetch(serial, function(result, args)
        CCharacter.fetchOwned(args[2], function(result, args)
            args[3].character = args[3].character or 0
            args[3].vip = (args[3].vip and true) or false
            if (result and (#result > 0)) then
                args[3].characters, isCharacterSelected = {}, false
                for i = 1, #result, 1 do
                    local j = result[i]
                    j.identity = imports.fromJSON(j.identity)
                    if not isCharacterSelected and (j.id == args[3].character) then isCharacterSelected = true end
                    args[3].characters[i] = {
                        id = j.id,
                        identity = j.identity
                    }
                    CCharacter.CBuffer[(j[(dbify.character.__connection__.keyColumn)])] = j
                    CCharacter.CBuffer[(j[(dbify.character.__connection__.keyColumn)])][(dbify.character.__connection__.keyColumn)] = nil
                end
                if not isCharacterSelected then args[3].character = 0 end
            else
                args[3].character = 0
                args[3].characters = {}
            end
            imports.triggerClientEvent(args[1], "Client:onToggleLoginUI", args[1], true, {
                character = args[3].character,
                characters = args[3].characters,
                vip = args[3].vip
            })
        end, args[1], args[2], result)
    end, source, serial)
end)


---------------------------
--[[ Player: On Resume ]]--
---------------------------

imports.addEvent("Player:onResume", true)
imports.addEventHandler("Player:onResume", root, function(character, characters)
    if not character or not characters or not characters[character] or not characters[character]._id then
        imports.triggerEvent("Player:onToggleLoginUI", source)
        return false
    end

    print("RESUMING..")
    print(character)
    print(toJSON(characters))
    --[[
    local serial = source:getSerial()
    local characterID = characters[character]._id
    local characterIdentity = getCharacterData(characterID, "identity")
    local characterName = characterIdentity.name:gsub(" ", "_")
    local characterLastLocation = getCharacterData(characterID, "location")
    local serverWeather, serverTime = getWeather(), {getTime()}
    if characterLastLocation then
        characterLastLocation = fromJSON(characterLastLocation)
        if characterLastLocation then
            for i, j in pairs(characterLastLocation) do
                i = tonumber(j)
            end
        end
    end

    source:setBlurLevel(0)
    source:setDimension(0)
    for i = 69, 79, 1 do
        source:setStat(i, 1000)
    end
    setCameraTarget(source, source)
    source:setFrozen(false)
    source:setNametagShowing(false)
    source:setCollisionsEnabled(true)
    source:setData("Character:ID", characterID)
    source:setName(characterName)

    for i, j in pairs(characterIdentity) do
        source:setData("Character:"..i, j)
    end
    source:setData("Player:Initialized", true)
    playerAttachments[source] = {}
    playerInventorySlots[source] = {
        maxSlots = maximumInventorySlots,
        slots = {}
    }
    local rangedPlayers = false
    if characterLastLocation and characterLastLocation.x and characterLastLocation.y and characterLastLocation.z and characterLastLocation.rotation then
        source:spawn(characterLastLocation.x, characterLastLocation.y, characterLastLocation.z + 1, characterLastLocation.rotation, playerClothes["Gender"][(characterIdentity["gender"])].modelSkin)
        for i, j in ipairs(playerDatas) do
            local data = exports.serials_library:getSerialData(serial, j)
            if tostring(data) == "nil" then data = nil end
            if tostring(data) == "false" then data = false end
            if data then
                local isNum = tonumber(data)
                if isNum then data = isNum else data = tostring(data) end
                source:setData("Player:"..j, data)
            end
        end
        for i, j in ipairs(characterDatas) do
            local data = getCharacterData(characterID, j)
            if data then
                source:setData("Character:"..j, data)
            end
        end
        rangedPlayers = Element.getWithinRange(characterLastLocation.x, characterLastLocation.y, characterLastLocation.z, playerRangedNotificationDistance, "player")
    else
        if playerSpawnPoints and type(playerSpawnPoints) == "table" then
            local playerSpawnPoint = playerSpawnPoints[(characters[character].spawn)]
            if not playerSpawnPoint or type(playerSpawnPoint) ~= "table" or #playerSpawnPoint <= 0 then
                playerSpawnPoint = playerSpawnPoints["East"]
            end
            local generatedSpawnPoint = playerSpawnPoint[math.random(1, #playerSpawnPoint)]
            source:spawn(generatedSpawnPoint.x, generatedSpawnPoint.y, generatedSpawnPoint.z + 1, math.random(0, 360), playerClothes["Gender"][(characterIdentity["gender"])].modelSkin)
            loadPlayerDefaultDatas(source)
            rangedPlayers = Element.getWithinRange(generatedSpawnPoint.x, generatedSpawnPoint.y, generatedSpawnPoint.z, playerRangedNotificationDistance, "player")
        end
    end

    loginTickCache[source] = getTickCount()
    exports.serials_library:setSerialData(serial, "character", character)
    triggerClientEvent("onSyncPedClothes", source, source, getPlayerClothes(source))
    for i, j in ipairs(rangedPlayers) do
        triggerClientEvent(j, "onDisplayNotification", source, characterIdentity.name.." joined!", {255, 255, 255, 255})
    end
    triggerClientEvent(source, "onPlayerSyncServerWeather", source, serverWeather, serverTime)
    triggerClientEvent(source, "onClientInventorySyncSlots", source, playerInventorySlots[source])
    if getPlayerHealth(source) <= 0 or getCharacterData(characterID, "dead") then
        source:setData("Character:blood", 0)
        triggerEvent("onPlayerDeath", source, nil, false, nil, 3)
    else
        triggerClientEvent(source, "onPlayerHideLoadingScreen", source)
        showChat(source, true)
    end
    ]]--
end)