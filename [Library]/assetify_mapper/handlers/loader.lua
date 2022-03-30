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
    triggerEvent = triggerEvent,
    triggerServerEvent = triggerServerEvent,
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
        imports.addEventHandler("onClientUIClick", mapper.ui.propWnd.spawnBtn.element, function()
            local assetName = imports.beautify.gridlist.getRowData(mapper.ui.propWnd.propLst.element, imports.beautify.gridlist.getSelection(mapper.ui.propWnd.propLst.element), 1)
            if not assetName then return false end
            mapper.isSpawningDummy = {assetName = assetName}
        end)
        imports.addEventHandler("onClientUIClick", mapper.ui.sceneWnd.resetBtn.element, function()
            mapper:reset()
        end)
        imports.addEventHandler("onClientUIClick", mapper.ui.sceneWnd.saveBtn.element, function()
            local sceneIPL = ""
            for i = 1, #mapper.buffer.index, 1 do
                local j = mapper.buffer.index[i]
                local posX, posY, posZ, rotX, rotY, rotZ = imports.getElementLocation(j.element)
                local rotW = 0
                rotW, rotX, rotY, rotZ = imports.quat.fromEuler(rotX, rotY, rotZ)
                sceneIPL = sceneIPL..(i - 1)..", "..(j.assetName)..", 0, "..posX..", "..posY..", "..posZ..", "..rotX..", "..rotY..", "..rotZ..", "..rotW..", -1\n"
            end
            imports.triggerServerEvent("Assetify:Mapper:onSaveScene", localPlayer, _, sceneIPL)
        end)
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
    mapper:reset()
end)