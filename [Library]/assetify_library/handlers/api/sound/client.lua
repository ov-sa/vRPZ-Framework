----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: sound: client.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Sound APIs ]]--
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


---------------------
--[[ APIs: Sound ]]--
---------------------

function manager.API.Sound:restoreWorld()
    imports.destroyElement(streamer.waterBuffer)
    streamer.waterBuffer = nil
    imports.restoreAllWorldModels()
    imports.setOcclusionsEnabled(true)
    imports.setWorldSpecialPropertyEnabled("randomfoliage", true)
    return true
end

function manager.API.Sound:clearModel(modelID)
    modelID = imports.tonumber(modelID)
    if modelID then
        imports.engineImportTXD(asset.rwAssets.txd, modelID)
        imports.engineReplaceModel(asset.rwAssets.dff, modelID, false)
        return true
    end
    return false
end

function manager.API.Sound:restoreModel(modelID)
    modelID = imports.tonumber(modelID)
    if not modelID then return false end
    return imports.engineRestoreModel(modelID)
end