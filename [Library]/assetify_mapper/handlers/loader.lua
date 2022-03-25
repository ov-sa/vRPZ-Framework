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
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    setElementAlpha = setElementAlpha,
    setElementFrozen = setElementFrozen,
    bindKey = bindKey,
    unbindKey = unbindKey,
    showChat = showChat,
    assetify = assetify
}


----------------------------------
--[[ Function: Toggles Mapper ]]--
----------------------------------

function mapper:toggle(state)
    if state then
        mapper.ui.create()
        camera:create()
        imports.bindKey("mouse_wheel_up", "down", camera.controlCursor)
        imports.bindKey("mouse_wheel_down", "down", camera.controlCursor)
    else
        mapper.ui.destroy()
        camera:destroy()
        imports.unbindKey("mouse_wheel_up", "down", camera.controlCursor)
        imports.unbindKey("mouse_wheel_down", "down", camera.controlCursor)
    end
    imports.setElementAlpha(localPlayer, (state and 0) or 255)
    imports.setElementFrozen(localPlayer, (state and true) or false)
    imports.showChat((not state and true) or false)
    camera.controlCursor(_, _, (not state and true) or false)
    return true
end


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

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