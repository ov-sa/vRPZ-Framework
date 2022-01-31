----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: respawner.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Player Respawner ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementAlpha = setElementAlpha,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    setCameraTarget = setCameraTarget,
    spawnPlayer= spawnPlayer,
    showChat = showChat
}


---------------------------
--[[ Event: On Respawn ]]--
---------------------------

imports.addEvent("Player:onRespawn", true)
imports.addEventHandler("Player:onRespawn", root, function(spawnPoint)
    if not spawnPoint then return false end

    local characterID = source:getData("Character:ID")
    local characterIdentity = CCharacter.getData(characterID, "identity")
    imports.spawnPlayer(source, spawnPoint.x, spawnPoint.y, spawnPoint.z + 1, 0, playerClothes["Gender"][(characterIdentity["gender"])].modelSkin)
    imports.setElementAlpha(255)
    imports.setElementCollisionsEnabled(source, true)
    imports.setCameraTarget(source, source)
    loadPlayerDefaultDatas(source)
    CCharacter.setData(characterID, "dead", false)
    --TODO: APPEND FUNCTION TO RETRIEVE CHARACTER'S CURRENT CLOTHES..
    imports.triggerClientEvent("onSyncPedClothes", source, source, getPlayerClothes(source))
    imports.triggerClientEvent(source, "Player:onClientRespawn", source)
    imports.triggerClientEvent(source, "Player:onHideLoadingUI", source)
    imports.showChat(source, true)
end)
