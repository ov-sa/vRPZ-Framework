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
    isElement = isElement,
    destroyElement = destroyElement,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    setElementAlpha = setElementAlpha,
    setElementFrozen = setElementFrozen,
    bindKey = bindKey,
    unbindKey = unbindKey,
    showChat = showChat,
    assetify = assetify,
    beautify = beautify
}


----------------------------------
--[[ Function: Toggles Mapper ]]--
----------------------------------

function mapper:toggle(state)
    if state then
        mapper.ui.create()
        camera:create()
        imports.bindKey(camera.controls.toggleCursor, "down", camera.controlCursor)
        imports.addEventHandler("onClientUIClick", mapper.ui.propWnd.spawnBtn.element, function()
            local assetName = imports.beautify.gridlist.getRowData(mapper.ui.propWnd.propLst.element, imports.beautify.gridlist.getSelection(mapper.ui.propWnd.propLst.element), 1)
            if not assetName then return false end
            mapper.isSpawningDummy = {assetName = assetName}
        end)
        imports.addEventHandler("onClientRender", root, mapper.render)
        imports.addEventHandler("onClientClick", root, mapper.controlClick)
    else
        imports.removeEventHandler("onClientClick", root, mapper.controlClick)
        imports.removeEventHandler("onClientRender", root, mapper.render)
        imports.unbindKey(camera.controls.toggleCursor, "down", camera.controlCursor)
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
    if imports.assetify.isLoaded() then
        Assetify_Props = imports.assetify.getAssets(mapper.assetPack) or {}
        mapper:toggle(true)
    else
        local booterWrapper = nil
        booterWrapper = function()
            Assetify_Props = imports.assetify.getAssets(mapper.assetPack) or {}
            mapper:toggle(true)
            imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
        end
        imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
    end
end)

imports.addEventHandler("onClientResourceStop", resource, function()
    mapper.isLibraryStopping = true
    for i, j in imports.pairs(mapper.buffer.element) do
        if i and imports.isElement(i) then
            imports.destroyElement(i)
        end
    end
end)