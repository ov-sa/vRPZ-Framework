----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: handlers: loader.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Loader Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    setElementAlpha = setElementAlpha,
    setElementFrozen = setElementFrozen,
    getElementLocation = getElementLocation,
    bindKey = bindKey,
    unbindKey = unbindKey,
    showChat = showChat,
    quat = quat,
    assetify = assetify,
    beautify = beautify
}


----------------------------------
--[[ Function: Toggles Mapper ]]--
----------------------------------

function mapper:toggle(state)
    if mapper.state == state then return false end
    if state then
        mapper.ui.create()
        camera:create()
        imports.bindKey(availableControls.toggleCursor, "down", camera.controlCursor)
        imports.beautify.render.create(mapper.render)
        imports.beautify.render.create(mapper.render, {renderType = "input"})
        imports.addEventHandler("onClientKey", root, mapper.controlKey)
        imports.addEventHandler("onClientClick", root, mapper.controlClick)
    else
        imports.removeEventHandler("onClientClick", root, mapper.controlClick)
        imports.removeEventHandler("onClientKey", root, mapper.controlKey)
        imports.beautify.render.remove(mapper.render)
        imports.beautify.render.remove(mapper.render, {renderType = "input"})
        imports.unbindKey(availableControls.toggleCursor, "down", camera.controlCursor)
        mapper.ui.destroy()
        camera:destroy()
    end
    mapper.state = state
    mapper.isSpawningDummy = false
    imports.setElementAlpha(localPlayer, (mapper.state and 0) or 255)
    imports.setElementFrozen(localPlayer, (mapper.state and true) or false)
    imports.showChat((not mapper.state and true) or false)
    camera.controlCursor(_, _, (not mapper.state and true) or false)
    return true
end


-----------------------------------------------
--[[ Events: On Client Resource Start/Stop ]]--
-----------------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    for i, j in imports.pairs(availableTemplates) do
        imports.beautify.setUITemplate(i, j)
    end
    if imports.assetify.isLoaded() then
        Assetify_Props = imports.assetify.getAssets(mapper.assetPack) or {}
        mapper:toggle(true)
        mapper:enable(true)
    else
        local booterWrapper = nil
        booterWrapper = function()
            Assetify_Props = imports.assetify.getAssets(mapper.assetPack) or {}
            mapper:toggle(true)
            mapper:enable(true)
            imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
        end
        imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
    end
end)

imports.addEventHandler("onClientResourceStop", resource, function()
    mapper.isLibraryStopping = true
    mapper:reset()
end)