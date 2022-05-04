----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: resumer.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Resumer Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    getTickCount = getTickCount,
    collectgarbage = collectgarbage,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent,
    setElementFrozen = setElementFrozen,
    setElementData = setElementData,
    bindKey = bindKey,
    setPedStat = setPedStat,
    setPlayerNametagShowing = setPlayerNametagShowing,
    toJSON = toJSON,
    fromJSON = fromJSON,
    table = table,
    string = string,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    resumeTicks = {},
    indexedItems = {}
}

CGame.execOnModuleLoad(function()
    for i, j in imports.pairs(CInventory.CItems) do
        imports.table.insert(cache.indexedItems, i)
    end
end)


------------------------------------------
--[[ Player: On Delete/Save Character ]]--
------------------------------------------

imports.addEvent("Player:onDeleteCharacter", true)
imports.addEventHandler("Player:onDeleteCharacter", root, function(characterID)
    CInventory.delete(CCharacter.CBuffer[characterID].inventory)
    CCharacter.delete(characterID)
end)

imports.addEvent("Player:onSaveCharacter", true)
imports.addEventHandler("Player:onSaveCharacter", root, function(character, characters)
    if not character or not characters or not characters[character] or characters[character].id then return false end

    local serial = CPlayer.getSerial(source)
    CCharacter.create(serial, function(characterID, args)
        CInventory.create(function(inventoryID, args)
            CCharacter.setData(characterID, {
                {"identity", imports.toJSON(args[3])},
                {"inventory", inventoryID}
            }, function(result, args)
                if result then CCharacter.CBuffer[(args[3].id)].identity = args[3].identity end
                imports.triggerClientEvent(args[1], "Client:onSaveCharacter", args[1], (result and true) or false, args[2], (result and args[3]) or nil)
            end, args[1], args[2], {
                id = characterID,
                identity = args[3]
            })
        end, args[1], args[2], args[3])
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
                CPlayer.CBuffer[(args[2])][j] = imports.string.parse(CPlayer.CBuffer[(args[2])][j])
            end
            args[3] = imports.table.clone(args[3], true)
            args[3].character = args[3].character or 0
            args[3].characters = {}
            args[3].vip = (args[3].vip and true) or false

            if (result and (#result > 0)) then
                for i = 1, #result, 1 do
                    local j = result[i]
                    j.inventory = imports.tonumber(j.inventory)
                    j.identity = imports.fromJSON(j.identity)
                    args[3].characters[i] = {
                        id = j.id,
                        identity = j.identity
                    }
                    CCharacter.CBuffer[(j.id)] = j
                    for k = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
                        local v = FRAMEWORK_CONFIGS["Character"]["Datas"][k]
                        CCharacter.CBuffer[(j.id)][v] = imports.string.parse(CCharacter.CBuffer[(j.id)][v])
                    end
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

function getResumeTick(player) return cache.resumeTicks[player] or false end

imports.addEvent("Player:onResume", true)
imports.addEventHandler("Player:onResume", root, function(character, characters)
    if not character or not characters or not characters[character] or not characters[character].id then
        imports.triggerEvent("Player:onToggleLoginUI", source)
        return false
    end

    for i = 1, #characters, 1 do
        if i ~= character then
            local j = characters[i]
            CCharacter.CBuffer[(j.id)] = nil
        end
    end
    imports.collectgarbage()
    CInventory.getItemProperty(CCharacter.CBuffer[(characters[character].id)].inventory, cache.indexedItems, {dbify.inventory.connection.itemFormat.counter}, function(result, args)
        if not result then
            imports.triggerEvent("Player:onToggleLoginUI", args[1])
            return false
        end

        CInventory.getData(args[3], {"max_slots", "slots"}, function(result, args)
            result = result or {}
            result.max_slots, result.slots = imports.math.max(CInventory.fetchMaxSlotsMultiplier(), imports.tonumber(result.max_slots) or 0), (result.slots and imports.fromJSON(result.slots)) or {}
            local serverWeather, serverTime = CGame.getNativeWeather()
            local serial = CPlayer.getSerial(args[1])
            local characterIdentity = CCharacter.CBuffer[(args[2])].identity
            imports.setElementData(args[1], "Character:ID", args[2])
            imports.setElementData(args[1], "Character:Identity", characterIdentity)
            CPlayer.setData(serial, {
                {"character", character}
            })
            CInventory.CBuffer[(args[1])] = {
                maxSlots = result.max_slots,
                slots = result.slots
            }
            for i, j in imports.pairs(args[4]) do
                imports.setElementData(args[1], "Item:"..i, imports.tonumber(j[(dbify.inventory.connection.itemFormat.counter)]) or 0)
            end
            cache.resumeTicks[(args[1])] = imports.getTickCount()
            CPlayer.setChannel(args[1], FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Default_Channel"])
            imports.bindKey(args[1], FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Channel_ShuffleKey"], "down", shufflePlayerChannel)
            imports.triggerClientEvent(args[1], "Client:onSyncInventoryBuffer", args[1], CInventory.CBuffer[(args[1])])
            imports.triggerClientEvent(args[1], "Client:onSyncWeather", args[1], serverWeather, serverTime)
            imports.triggerEvent("Player:onSpawn", args[1], CCharacter.CBuffer[(args[2])].location, true)
        end, args[1], args[2], args[3], result)
    end, source, characters[character].id, CCharacter.CBuffer[(characters[character].id)].inventory, true)
end)