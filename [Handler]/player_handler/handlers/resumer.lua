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
    tonumber = tonumber,
    tostring = tostring,
    getTickCount = getTickCount,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
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
    local serial = CPlayer.getSerial(source)
    for i = 69, 79, 1 do
        imports.setPedStat(source, i, 1000)
    end
    imports.setPlayerNametagShowing(source, false)
    imports.setElementFrozen(source, true)

    CPlayer.fetch(serial, function(result, args)
        result = result[1]
        CCharacter.fetchOwned(args[2], function(result, args)
            args[3].character = imports.tonumber(args[3].character)
            CPlayer.CBuffer[(args[2])] = args[3]
            for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
                local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
                local value = CPlayer.CBuffer[(args[2])][j]
                if imports.tostring(value) == "nil" then value = nil end
                if imports.tostring(value) == "false" then value = false end
                if value then value = imports.tonumber(value) or value end
                CPlayer.CBuffer[(args[2])][j] = value
            end
            args[3] = imports.table.clone(args[3], true) --TODO: LATER MERGE THIS W/ BEAUTIFY'S SHARED APIS
            args[3].character = args[3].character or 0
            args[3].characters = {}
            args[3].vip = (args[3].vip and true) or false

            if (result and (#result > 0)) then
                for i = 1, #result, 1 do
                    local j = result[i]
                    j.identity = imports.fromJSON(j.identity)
                    args[3].characters[i] = {
                        id = j.id,
                        identity = j.identity
                    }
                    CCharacter.CBuffer[(j.id)] = j
                    for k = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
                        local v = FRAMEWORK_CONFIGS["Character"]["Datas"][k]
                        local value = CCharacter.CBuffer[(j.id)][v]
                        if imports.tostring(value) == "nil" then value = nil end
                        if imports.tostring(value) == "false" then value = false end
                        if value then value = imports.tonumber(value) or value end
                        CCharacter.CBuffer[(j.id)][v] = value
                    end
                    CCharacter.CBuffer[(j.id)].dead = (CCharacter.CBuffer[(j.id)].dead == "true" and true) or false
                    CCharacter.CBuffer[(j.id)].location = (CCharacter.CBuffer[(j.id)].location and imports.fromJSON(CCharacter.CBuffer[(j.id)].location)) or false
                end
                if not args[3].characters[(args[3].character)] then args[3].character = 0 end
            else
                args[3].character = 0
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

    local serverWeather, serverTime = CGame.getNativeWeather()
    local serial = CPlayer.getSerial(source)
    local characterID = characters[character].id
    local characterIdentity = CCharacter.CBuffer[characterID].identity
    imports.setElementData(source, "Character:ID", characterID)
    imports.setElementData(source, "Character:Identity", characterIdentity)
    imports.setElementData(source, "Player:Initialized", true)
    CPlayer.setData(serial, {
        {"character", character}
    })

    --[[
    --TODO: INIT ALL THIS
    playerAttachments[source] = {}
    playerInventorySlots[source] = {
        maxSlots = maximumInventorySlots,
        slots = {}
    }
    ]]
    cache.resumeBuffer[source] = imports.getTickCount()
    imports.triggerClientEvent(source, "Player:onSyncWeather", source, serverWeather, serverTime)
    imports.triggerEvent("Player:onSpawn", source, (CCharacter.CBuffer[characterID].location, true)
end)