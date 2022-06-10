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
    triggerClientEvent = triggerClientEvent,
    setElementFrozen = setElementFrozen,
    setElementData = setElementData,
    bindKey = bindKey,
    setPedStat = setPedStat,
    setPlayerNametagShowing = setPlayerNametagShowing,
    json = json,
    table = table,
    string = string,
    thread = thread,
    network = network
}


-------------------
--[[ Variables ]]--
-------------------

local resumeTicks = {}


------------------------------------------
--[[ Player: On Delete/Save Character ]]--
------------------------------------------

imports.network:create("Player:onDeleteCharacter"):on(function(characterID)
    imports.thread:create(function(self)
        CInventory.delete(self, CCharacter.CBuffer[characterID].inventory)
        CCharacter.delete(self, characterID)
    end):resume()
end)

imports.network:create("Player:onSaveCharacter"):on(function(source, character, characters)
    if not character or not characters or not characters[character] or characters[character].id then return false end

    local serial = CPlayer.getSerial(source)
    local __source = source
    imports.thread:create(function(self)
        local source = __source
        local characterID = CCharacter.create(self, serial)
        local inventoryID = CInventory.create(self)
        local bool = CCharacter.setData(self, characterID, {
            {"identity", imports.json.encode(characters[character].identity)},
            {"inventory", inventoryID}
        })
        if bool then CCharacter.CBuffer[characterID].identity = characters[character].identity end
        imports.triggerClientEvent(source, "Client:onSaveCharacter", source, (bool and true) or false, character, (bool and {id = characterID, identity = characters[character].identity}) or nil)
    end):resume()
end)


------------------------------------
--[[ Player: On Toggle Login UI ]]--
------------------------------------

imports.network:create("Player:onToggleLoginUI"):on(function(source)
    local serial = CPlayer.getSerial(source)
    for i = 69, 79, 1 do
        imports.setPedStat(source, i, 1000)
    end
    imports.setPlayerNametagShowing(source, false)
    imports.setElementFrozen(source, true)

    local __source = source
    imports.thread:create(function(self)
        local source = __source
        local DPlayer = CPlayer.fetch(self, serial)
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

        local DCharacter = CCharacter.fetchOwned(self, serial)
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

imports.network:create("Player:onResume"):on(function(source, character, characters)
    if not character or not characters or not characters[character] or not characters[character].id then
        imports.network:emit("Player:onToggleLoginUI", false, source)
        return false
    end

    local serial = CPlayer.getSerial(source)
    for i = 1, #characters, 1 do
        if i ~= character then
            local j = characters[i]
            CCharacter.CBuffer[(j.id)] = nil
        end
    end
    imports.collectgarbage()

    local __source = source
    imports.thread:create(function(self)
        local source = __source
        local characterID, inventoryID = characters[character].id, CCharacter.CBuffer[(characters[character].id)].inventory
        if not CCharacter.loadInventory(self, source, {characterID = characterID, inventoryID = inventoryID}) then
            imports.network:emit("Player:onToggleLoginUI", false, source)
            return false
        end

        local characterIdentity = CCharacter.CBuffer[characterID].identity
        imports.setElementData(source, "Character:ID", characterID)
        imports.setElementData(source, "Character:Identity", characterIdentity)
        CPlayer.setData(self, serial, {
            {"character", character}
        })
        resumeTicks[source] = imports.getTickCount()
        CPlayer.setChannel(source, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Default_Channel"])
        imports.bindKey(source, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Channel_ShuffleKey"], "down", shufflePlayerChannel)
        imports.network:emit("Client:onSyncInventoryBuffer", true, false, source, CInventory.CBuffer[inventoryID])
        imports.network:emit("Client:onSyncWeather", true, false, source, CGame.getNativeWeather())
        imports.network:emit("Player:onSpawn", false, source, CCharacter.CBuffer[characterID].location, characterID)
    end):resume()
end)