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
    getWeather = getWeather,
    getTime = getTime,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementPosition = setElementPosition,
    setElementDimension = setElementDimension,
    setElementFrozen = setElementFrozen,
    setElementData = setElementData,
    setPedStat = setPedStat,
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
    imports.setElementFrozen(source, true)
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
    if not character or not characters or not characters[character] or not characters[character].id then
        imports.triggerEvent("Player:onToggleLoginUI", source)
        return false
    end

    local serial = CPlayer.getSerial(source)
    local serverWeather, serverTime = imports.getWeather(), {imports.getTime()}
    local characterID = characters[character].id
    local characterIdentity = CCharacter.CBuffer[characterID]["identity"]
    local characterLocation = CCharacter.CBuffer[characterID]["location"]
    characterLocation = (characterLocation and imports.fromJSON(characterLocation)) or false

    print("RESUMING...")
    for i = 69, 79, 1 do
        imports.setPedStat(source, i, 1000)
    end
    imports.setElementDimension(source, 0)
    setCameraTarget(source, source)
    imports.setElementFrozen(source, false)
    --source:setCollisionsEnabled(true)
    source:setData("Character:ID", characterID)
    source:setData("Character:Identity", characterIdentity, false)
    imports.setElementData(localPlayer, "Player:Initialized", true)
    --[[
    playerAttachments[source] = {}
    playerInventorySlots[source] = {
        maxSlots = maximumInventorySlots,
        slots = {}
    }
    if characterLocation and characterLocation.x and characterLocation.y and characterLocation.z and characterLocation.rotation then
        source:spawn(characterLocation.x, characterLocation.y, characterLocation.z + 1, characterLocation.rotation, playerClothes["Gender"][(characterIdentity["gender"])].modelSkin)
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
    else
        if playerSpawnPoints and type(playerSpawnPoints) == "table" then
            local playerSpawnPoint = playerSpawnPoints[(characters[character].spawn)]
            if not playerSpawnPoint or type(playerSpawnPoint) ~= "table" or #playerSpawnPoint <= 0 then
                playerSpawnPoint = playerSpawnPoints["East"]
            end
            local generatedSpawnPoint = playerSpawnPoint[math.random(1, #playerSpawnPoint)]
            source:spawn(generatedSpawnPoint.x, generatedSpawnPoint.y, generatedSpawnPoint.z + 1, math.random(0, 360), playerClothes["Gender"][(characterIdentity["gender"])].modelSkin)
            loadPlayerDefaultDatas(source)
        end
    end
    ]]--

    --[[
    loginTickCache[source] = getTickCount()
    exports.serials_library:setSerialData(serial, "character", character)
    triggerClientEvent("onSyncPedClothes", source, source, getPlayerClothes(source))
    triggerClientEvent(source, "onPlayerSyncServerWeather", source, serverWeather, serverTime)
    triggerClientEvent(source, "onClientInventorySyncSlots", source, playerInventorySlots[source])
    if getPlayerHealth(source) <= 0 or getCharacterData(characterID, "dead") then
        source:setData("Character:blood", 0)
        triggerEvent("onPlayerDeath", source, nil, false, nil, 3)
    else
        triggerClientEvent(source, "onPlayerHideLoadingScreen", source)
        showChat(source, true)
    end
    ]]
end)