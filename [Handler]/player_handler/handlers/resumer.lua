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
    json = json,
    table = table,
    string = string,
    thread = thread
}


-------------------
--[[ Variables ]]--
-------------------

local resumeTicks = {}


------------------------------------------
--[[ Player: On Delete/Save Character ]]--
------------------------------------------

imports.addEvent("Player:onDeleteCharacter", true)
imports.addEventHandler("Player:onDeleteCharacter", root, function(characterID)
    imports.thread:create(function(self)
        self:await(CInventory.delete(self, CCharacter.CBuffer[characterID].inventory))
        self:await(CCharacter.delete(self, characterID))
    end):resume()
end)

imports.addEvent("Player:onSaveCharacter", true)
imports.addEventHandler("Player:onSaveCharacter", root, function(character, characters)
    if not character or not characters or not characters[character] or characters[character].id then return false end
    local serial = CPlayer.getSerial(source)

    imports.thread:create(function(self)
        local characterID = self:await(CCharacter.create(self, serial))
        local inventoryID = self:await(CInventory.create(self))
        local bool = await(self, CCharacter.setData(self, characterID, {
            {"identity", imports.json.encode(characters[character].identity)},
            {"inventory", inventoryID}
        }))
        if bool then CCharacter.CBuffer[characterID].identity = characters[character].identity end
        imports.triggerClientEvent(source, "Client:onSaveCharacter", source, (bool and true) or false, character, (bool and {id = characterID, identity = characters[character].identity}) or nil)
    end):resume()
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

    imports.thread:create(function(self)
        local DPlayer = self:await(self, CPlayer.fetch(serial))
        DPlayer = DPlayer[1]
        DPlayer.character = imports.tonumber(DPlayer.character)
        CPlayer.CBuffer[serial] = DPlayer
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            CPlayer.CBuffer[serial][j] = imports.string.parse(CPlayer.CBuffer[serial][j])
        end
        DPlayer = imports.table.clone(DPlayer, true)
        DPlayer.character = DPlayer.character or 0
        DPlayer.characters = {}
        DPlayer.vip = (DPlayer.vip and true) or false

        local DCharacter = self:await(self, CCharacter.fetchOwned(serial))
        if DCharacter and (#DCharacter > 0) then
            for i = 1, #DCharacter, 1 do
                local j = DCharacter[i]
                j.inventory = imports.tonumber(j.inventory)
                j.identity = imports.json.decode(j.identity)
                DPlayer.characters[i] = {
                    id = j.id,
                    identity = j.identity
                }
                CCharacter.CBuffer[(j.id)] = j
                for k = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
                    local v = FRAMEWORK_CONFIGS["Character"]["Datas"][k]
                    CCharacter.CBuffer[(j.id)][v] = imports.string.parse(CCharacter.CBuffer[(j.id)][v])
                end
                CCharacter.CBuffer[(j.id)].location = (CCharacter.CBuffer[(j.id)].location and imports.json.decode(CCharacter.CBuffer[(j.id)].location)) or false
            end
            if not DPlayer.characters[(DPlayer.character)] then DPlayer.character = 0 end
        else
            DPlayer.character = 0
        end
        imports.triggerClientEvent(source, "Client:onToggleLoginUI", source, true, {
            character = DPlayer.character,
            characters = DPlayer.characters,
            vip = DPlayer.vip
        })
    end):resume()
end)


---------------------------
--[[ Player: On Resume ]]--
---------------------------

function getResumeTick(player) return resumeTicks[player] or false end

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
    CCharacter.loadInventory(source, {
        characterID = characters[character].id,
        inventoryID = CCharacter.CBuffer[(characters[character].id)].inventory
    }, function(result, player, data)
        if not result then
            imports.triggerEvent("Player:onToggleLoginUI", player)
            return false
        end

        local serial = CPlayer.getSerial(player)
        local characterIdentity = CCharacter.CBuffer[(data.characterID)].identity
        imports.setElementData(player, "Character:ID", data.characterID)
        imports.setElementData(player, "Character:Identity", characterIdentity)
        CPlayer.setData(serial, {
            {"character", character}
        })
        resumeTicks[player] = imports.getTickCount()
        CPlayer.setChannel(player, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Default_Channel"])
        imports.bindKey(player, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Channel_ShuffleKey"], "down", shufflePlayerChannel)
        imports.triggerClientEvent(player, "Client:onSyncInventoryBuffer", player, CInventory.CBuffer[(data.inventoryID)])
        imports.triggerClientEvent(player, "Client:onSyncWeather", player, CGame.getNativeWeather())
        imports.triggerEvent("Player:onSpawn", player, CCharacter.CBuffer[(data.characterID)].location, data.characterID)
    end)
end)