----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: wasted.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Wasted Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs,
    tonumber = tonumber,
    isElement = isElement,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementAlpha = setElementAlpha,
    setElementFrozen = setElementFrozen,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    getElementData = getElementData,
    setElementData = setElementData,
    setElementDimension = setElementDimension,
    setCameraTarget = setCameraTarget,
    setPedAnimation = setPedAnimation,
    setElementHealth = setElementHealth,
    setPedHeadless = setPedHeadless,
    createPed = createPed,
    createMarker = createMarker,
    spawnPlayer = spawnPlayer,
    loadProgress = CCharacter.loadProgress,
    killPed = killPed,
    setTimer = setTimer,
    showChat = showChat
}


-------------------
--[[ Variables ]]--
-------------------

local deathAnimations = {
    default = {"PED", "KO_skid_front"},
    [9] = {"PED", "KO_shot_face"},
    [3] = {"PED", "KO_shot_stom"},
    [8] = {"PED", "KD_right"},
    [7] = {"PED", "KD_left"},
    [6] = {"PED", "KO_spin_R"},
    [5] = {"PED", "KO_spin_L"},
    [4] = {"PED", "KO_skid_back"}
}


---------------------------------
--[[ Player: On Player Death ]]--
---------------------------------

CCharacter.loadProgress = function(player)
    if not CPlayer.isInitialized(player) then return false end
    imports.loadProgress(player)
    for i = 1, #FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic, 1 do
        local j = FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic[i]
        local value = j.amount
        if j.name == "Character:blood" then
            value = CCharacter.getMaxHealth(player)
        end
        imports.setElementData(player, j.name, value)
    end
    return true
end

local function destroyPedLoot(ped, marker)
    if ped and imports.isElement(ped) then imports.destroyElement(ped) end
    if marker and imports.isElement(marker) then imports.destroyElement(marker) end
    return true
end

--[[
imports.addEvent("Player:onDeath", true)
imports.addEventHandler("Player:onDeath", root, function(killer, headshot, weapon, bodypart)
    if not CPlayer.isInitialized(source) then return false end

    local characterID = source:getData("Character:ID")
    CCharacter.setData(characterID, "dead", true)
    imports.setElementCollisionsEnabled(source, false)
    imports.setElementAlpha(source, 0)
    local posVector = source:getPosition()
    local rotVector = source:getRotation()
    local currentTime = CGame.getTime()	
    local ped = imports.createPed(0, posVector.x, posVector.y, posVector.z, rotVector.z)
    local marker = imports.createMarker(0, 0, 0, "cylinder", 1.2, 0, 0, 0, 0)
    if headshot then imports.setPedHeadless(ped, true) end
    ped:setCollisionsEnabled(false)
    ped:setData("Element:Parent", marker)
    marker:setData("Loot:Type", "deadperson")
    marker:setData("Loot:Name", "Dead Body")
    marker:setData("Inventory:Slots", getElementMaxSlots(source))
    marker:setData("Element:Parent", ped)
    marker:attach(ped, 0, 0, -0.1)
    source:attach(ped, 0, 0, -2)
    imports.triggerClientEvent("Player:onSyncPedClothes", source, ped, getPlayerClothes(source))
    for i, j in imports.pairs(inventoryDatas) do
        if not j.saveOnWasted then
            for k, v in imports.ipairs(j) do
                local itemValue = imports.tonumber(source:getData("Item:"..v.dataName)) or 0
                if itemValue > 0 then
                    local isItemToBeAdded = true
                    if i == "Helmet" or i == "Armor" then
                        local shieldType = false
                        if i == "Helmet" then
                            shieldType = "helmet"
                        elseif i == "Armor" then
                            shieldType = "armor"
                        end
                        if shieldType then
                            local shieldHealth = getPlayerShieldHealth(source, shieldType)
                            if not shieldHealth or shieldHealth < 100 then
                                isItemToBeAdded = false
                            end
                        else
                            isItemToBeAdded = false
                        end
                    end
                    if isItemToBeAdded then
                        marker:setData("Item:"..v.dataName, itemValue)
                    end
                end
            end
        end
    end

    imports.killPed(source)
    imports.setTimer(function(ped, deathAnim)
        if ped and imports.isElement(ped) then
            imports.setPedAnimation(ped, deathAnim[1], deathAnim[2], -1, false, true, false)
        end
    end, 200, 1, ped, (bodypart and deathAnimations[bodypart]) or deathAnimations.default)
    imports.setTimer(function(ped)
        if ped and imports.isElement(ped) then
            imports.setElementHealth(ped, 0)
        end
    end, 500, 1, ped)
    imports.setTimer(function(ped, marker)
        destroyPedLoot(ped, marker)
    end, playerDeadLootDuration, 1, ped, marker)
end)
]]--


--------------------------
--[[ Player: On Spawn ]]--
--------------------------

imports.addEvent("Player:onSpawn", true)
imports.addEventHandler("Player:onSpawn", root, function(spawnpoint, reloadBuffer)
    spawnpoint = spawnpoint or CGame.generateSpawn()
    local characterID = imports.getElementData(source, "Character:ID")
    local characterIdentity = CCharacter.CBuffer[characterID].identity
    imports.spawnPlayer(source, spawnpoint.position[1], spawnpoint.position[2], spawnpoint.position[3] + 1, spawnpoint.rotation[3])
    imports.setElementAlpha(source, 255)
    imports.setElementDimension(source, 0)
    imports.setElementFrozen(source, false)
    imports.setElementCollisionsEnabled(source, true)
    imports.setCameraTarget(source, source)

    local resetProgress = true
    if reloadBuffer then
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            imports.setElementData(source, "Player:"..j, CPlayer.CBuffer[j])
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            imports.setElementData(source, "Character:"..j, CCharacter.CBuffer[j])
        end
        if spawnpoint then resetProgress = false end
    end
    if resetProgress then CCharacter.loadProgress(source) print("RESETTING") end
    CCharacter.setData(characterID, "dead", false)
    
    if (CCharacter.getHealth(source) <= 0) or CCharacter.CBuffer[characterID]["dead"] then
        print("TEST 1")
        CCharacter.setHealth(source, 0)
        --imports.triggerEvent("Player:onDeath", source, nil, false, nil, 3)
    else
        print("TEST 2")
        imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, false)
        imports.showChat(source, true)
    end
    --TODO: APPEND FUNCTION TO RETRIEVE CHARACTER'S CURRENT CLOTHES..
    --imports.triggerClientEvent("Player:onSyncPedClothes", source, source, getPlayerClothes(source))
    --triggerClientEvent(source, "onClientInventorySyncSlots", source, playerInventorySlots[source])
    --imports.triggerClientEvent(source, "Client:onRespawn", source)
    --imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, true)
end)
