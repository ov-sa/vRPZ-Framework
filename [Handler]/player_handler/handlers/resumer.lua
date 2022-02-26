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
    getTickCount = getTickCount,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementFrozen = setElementFrozen,
    setElementData = setElementData,
    setPedStat = setPedStat,
    setPlayerNametagShowing = setPlayerNametagShowing,
    toJSON = toJSON,
    fromJSON = fromJSON,
    showChat = showChat,
    table = table
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    resumeBuffer = {}
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
    for i = 69, 79, 1 do
        imports.setPedStat(source, i, 1000)
    end
    imports.setPlayerNametagShowing(source, false)
    imports.setElementFrozen(source, true)

    local serial = CPlayer.getSerial(source)
    CPlayer.fetch(serial, function(result, args)
        CCharacter.fetchOwned(args[2], function(result, args)
            CPlayer.CBuffer[(args[2])] = args[3]
            args[3] = imports.table.clone(args[3], true) --TODO: LATER MERGE THIS W/ BEAUTIFY'S SHARED APIS
            args[3].character = args[3].character or 0
            args[3].vip = (args[3].vip and true) or false
            --TODO: ..
            --[[
            if tostring(data) == "nil" then data = nil end
            if tostring(data) == "false" then data = false end
            if data then
                local isNum = tonumber(data)
                if isNum then data = isNum else data = tostring(data) end
                source:setData("Player:"..j, data)
            end
            ]]--
        
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

function getResumeTick(player) return cache.resumeBuffer[player] or false end

imports.addEvent("Player:onResume", true)
imports.addEventHandler("Player:onResume", root, function(character, characters)
    if not character or not characters or not characters[character] or not characters[character].id then
        imports.triggerEvent("Player:onToggleLoginUI", source)
        return false
    end

    local serial = CPlayer.getSerial(source)
    local serverWeather, serverTime = CGame.getNativeWeather()
    local characterID = characters[character].id
    local characterIdentity = CCharacter.CBuffer[characterID].identity
    imports.setElementData(source, "Character:ID", characterID)
    imports.setElementData(source, "Character:Identity", characterIdentity)
    imports.setElementData(source, "Player:Initialized", true)
    CPlayer.setData(serial, {
        {"character", character}
    })

    imports.triggerClientEvent(source, "Player:onSyncWeather", source, serverWeather, serverTime)
    imports.triggerEvent("Player:onSpawn", source, (CCharacter.CBuffer[characterID]["location"] and imports.fromJSON(CCharacter.CBuffer[characterID]["location"])) or nil)
    --[[
    playerAttachments[source] = {}
    playerInventorySlots[source] = {
        maxSlots = maximumInventorySlots,
        slots = {}
    }
    ]]
    CCharacter.setHealth(source, 10000) --TODO: REMOVE LATER..
    cache.resumeBuffer[source] = imports.getTickCount()
    --triggerClientEvent(source, "onClientInventorySyncSlots", source, playerInventorySlots[source])
    if (CCharacter.getHealth(source) <= 0) or CCharacter.CBuffer[characterID]["dead"] then
        print("TEST 1")
        CCharacter.setHealth(source, 0)
        --imports.triggerEvent("onPlayerDeath", source, nil, false, nil, 3)
    else
        print("TEST 2")
        imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, false)
        imports.showChat(source, true)
    end
end)