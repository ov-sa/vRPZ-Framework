----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: world: client.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: World APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    destroyElement = destroyElement,
    engineImportTXD = engineImportTXD,
    engineReplaceModel = engineReplaceModel,
    engineRestoreModel = engineRestoreModel,
    restoreAllWorldModels = restoreAllWorldModels,
    setOcclusionsEnabled = setOcclusionsEnabled,
    setWorldSpecialPropertyEnabled = setWorldSpecialPropertyEnabled,
}


--------------------
--[[ API: World ]]--
--------------------

manager.API.World = {}

function manager.API:restoreWorld()
    imports.destroyElement(streamer.waterBuffer)
    streamer.waterBuffer = nil
    imports.restoreAllWorldModels()
    imports.setOcclusionsEnabled(true)
    imports.setWorldSpecialPropertyEnabled("randomfoliage", true)
    return true
end

function manager.API:clearModel(modelID)
    modelID = imports.tonumber(modelID)
    if modelID then
        imports.engineImportTXD(asset.rwAssets.txd, modelID)
        imports.engineReplaceModel(asset.rwAssets.dff, modelID, false)
        return true
    end
    return false
end

function manager.API:restoreModel(modelID)
    modelID = imports.tonumber(modelID)
    if not modelID then return false end
    return imports.engineRestoreModel(modelID)
end