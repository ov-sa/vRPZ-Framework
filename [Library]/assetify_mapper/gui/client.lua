----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: gui: client.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Mapper UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    setElementAlpha = setElementAlpha,
    setElementFrozen = setElementFrozen,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
    assetify = assetify,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

mapper.ui = {
    propWnd = {
        startX = 5, startY = 5,
        width = 225, height = 231,
        propLst = {
            text = imports.string.upper(imports.string.spaceChars("Assets")),
            height = 200
        },
        spawnBtn = {
            text = "Spawn Asset",
            startY = 200 + 5,
            height = 24
        }
    },

    sceneWnd = {
        startX = 5, startY = 5 + 231 + 10 + 5,
        width = 225, height = 360,
        propLst = {
            text = imports.string.upper(imports.string.spaceChars("Props")),
            height = 271
        },
        loadBtn = {
            text = "Load Scene",
            startY = 271 + 5,
            height = 24
        },
        resetBtn = {
            text = "Reset Scene",
            startY = 271 + 5 + 24 + 5,
            height = 24
        },
        saveBtn = {
            text = "Save Scene",
            startY = 271 + 5 + 24 + 5 + 24 + 5,
            height = 24
        }
    }
}

mapper.ui.propWnd.createUI = function()
    mapper.ui.propWnd.element = imports.beautify.card.create(mapper.ui.propWnd.startX, mapper.ui.propWnd.startY, mapper.ui.propWnd.width, mapper.ui.propWnd.height)
    imports.beautify.setUIVisible(mapper.ui.propWnd.element, true)
    imports.beautify.setUIDraggable(mapper.ui.propWnd.element, true)
    mapper.ui.propWnd.propLst.element = imports.beautify.gridlist.create(0, 0, mapper.ui.propWnd.width, mapper.ui.propWnd.propLst.height, mapper.ui.propWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.propWnd.propLst.element, true)
    imports.beautify.gridlist.addColumn(mapper.ui.propWnd.propLst.element, mapper.ui.propWnd.propLst.text, mapper.ui.propWnd.width)
    for i = 1, #Assetify_Props, 1 do
        local j = Assetify_Props[i]
        local rowIndex = imports.beautify.gridlist.addRow(mapper.ui.propWnd.propLst.element)
        imports.beautify.gridlist.setRowData(mapper.ui.propWnd.propLst.element, rowIndex, 1, j)
    end
    imports.beautify.gridlist.setSelection(mapper.ui.propWnd.propLst.element, 1)
    mapper.ui.propWnd.spawnBtn.element = imports.beautify.button.create(mapper.ui.propWnd.spawnBtn.text, 0, mapper.ui.propWnd.spawnBtn.startY, "default", mapper.ui.propWnd.width, mapper.ui.propWnd.spawnBtn.height, mapper.ui.propWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.propWnd.spawnBtn.element, true)
end

mapper.ui.sceneWnd.createUI = function()
    mapper.ui.sceneWnd.element = imports.beautify.card.create(mapper.ui.sceneWnd.startX, mapper.ui.sceneWnd.startY, mapper.ui.sceneWnd.width, mapper.ui.sceneWnd.height)
    imports.beautify.setUIVisible(mapper.ui.sceneWnd.element, true)
    imports.beautify.setUIDraggable(mapper.ui.sceneWnd.element, true)
    mapper.ui.sceneWnd.propLst.element = imports.beautify.gridlist.create(0, 0, mapper.ui.sceneWnd.width, mapper.ui.sceneWnd.propLst.height, mapper.ui.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.sceneWnd.propLst.element, true)
    imports.beautify.gridlist.addColumn(mapper.ui.sceneWnd.propLst.element, mapper.ui.sceneWnd.propLst.text, mapper.ui.sceneWnd.width)
    mapper.ui.sceneWnd.loadBtn.element = imports.beautify.button.create(mapper.ui.sceneWnd.loadBtn.text, 0, mapper.ui.sceneWnd.loadBtn.startY, "default", mapper.ui.sceneWnd.width, mapper.ui.sceneWnd.loadBtn.height, mapper.ui.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.sceneWnd.loadBtn.element, true)
    mapper.ui.sceneWnd.resetBtn.element = imports.beautify.button.create(mapper.ui.sceneWnd.resetBtn.text, 0, mapper.ui.sceneWnd.resetBtn.startY, "default", mapper.ui.sceneWnd.width, mapper.ui.sceneWnd.resetBtn.height, mapper.ui.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.sceneWnd.resetBtn.element, true)
    mapper.ui.sceneWnd.saveBtn.element = imports.beautify.button.create(mapper.ui.sceneWnd.saveBtn.text, 0, mapper.ui.sceneWnd.saveBtn.startY, "default", mapper.ui.sceneWnd.width, mapper.ui.sceneWnd.saveBtn.height, mapper.ui.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapper.ui.sceneWnd.saveBtn.element, true)
end


------------------------------
--[[ Function: Creates UI ]]--
------------------------------

mapper.ui.createUI = function()
    Assetify_Props = imports.assetify.getAssets(mapper.assetPack) or {}
    imports.setElementAlpha(localPlayer, 0)
    imports.setElementFrozen(localPlayer, true)
    camera:enable()
    imports.showChat(false)
    --imports.showCursor(true)
    mapper.ui.propWnd.createUI()
    mapper.ui.sceneWnd.createUI()
end

imports.addEventHandler("onClientResourceStart", resource, function()
    if imports.assetify.isLoaded() then
        mapper.ui.createUI()
    else
        local booterWrapper = nil
        booterWrapper = function()
            mapper.ui.createUI()
            imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
        end
        imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
    end
end)