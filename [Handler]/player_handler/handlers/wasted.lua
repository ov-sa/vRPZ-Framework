----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: wasted.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
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
    setElementData = setElementData,
    setElementDimension = setElementDimension,
    setCameraTarget = setCameraTarget,
    setPedAnimation = setPedAnimation,
    setElementHealth = setElementHealth,
    setPedHeadless = setPedHeadless,
    createPed = createPed,
    createMarker = createMarker,
    spawnPlayer = spawnPlayer,
    killPed = killPed,
    setTimer = setTimer,
    showChat = showChat,
    assetify = assetify
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

local function destroyPedLoot(ped, marker)
    if ped and imports.isElement(ped) then imports.destroyElement(ped) end
    if marker and imports.isElement(marker) then imports.destroyElement(marker) end
    return true
end

--[[
imports.addEvent("Player:onDeath", true)
imports.addEventHandler("Player:onDeath", root, function(killer, headshot, weapon, bodypart)
    if not CPlayer.isInitialized(source) then return false end

    local characterID = getElementData(source, "Character:ID")
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
    marker:setData("Inventory:MaxSlots", CInventory.fetchParentMaxSlots(source))
    marker:setData("Element:Parent", ped)
    marker:attach(ped, 0, 0, -0.1)
    source:attach(ped, 0, 0, -2)
    for i, j in imports.pairs(inventoryDatas) do
        if not j.saveOnWasted then
            for k, v in imports.ipairs(j) do
                local itemValue = imports.tonumber(getElementData(source, "Item:"..v.dataName)) or 0
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
imports.addEventHandler("Player:onSpawn", root, function(spawnpoint, loadCharacterID)
    spawnpoint = spawnpoint or CGame.generateSpawn()
    local characterID = loadCharacterID or CPlayer.getCharacterID(source, true)
    local characterIdentity = CCharacter.CBuffer[characterID].identity
    local characterClothing = {CCharacter.generateClothing(characterIdentity)}
    imports.spawnPlayer(source, spawnpoint.position[1], spawnpoint.position[2], spawnpoint.position[3] + 1, spawnpoint.rotation[3])
    imports.assetify.setElementAsset(source, "character", characterClothing[1], characterClothing[2], characterClothing[3])
    imports.setElementAlpha(source, 255)
    imports.setElementDimension(source, 0)
    imports.setElementFrozen(source, false)
    imports.setElementCollisionsEnabled(source, true)
    imports.setCameraTarget(source, source)
    CCharacter.loadProgress(source, loadCharacterID, ((not loadCharacterID or ((loadCharacterID and not spawnpoint and true) or false)) and true) or false)

    if CCharacter.getHealth(source) <= 0 then
        --TODO: NEEDS TO BE IMPLEMENTED..
        --imports.triggerEvent("Player:onDeath", source, nil, false, nil, 3)
        imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, false, FRAMEWORK_CONFIGS["Spawns"]["Hint"])
    else
        --triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])
        imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, false)
        imports.showChat(source, true)
    end
end)
