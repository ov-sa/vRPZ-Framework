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
    assetify = assetify,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local mapperUI = {
    propWnd = {
        startX = 5, startY = 5,
        width = 225, height = 231,
        propLst = {
            text = "ASSETS",
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
            text = "PROPS",
            height = 300
        },
        resetBtn = {
            text = "Reset Scene",
            startY = 300 + 5,
            height = 24
        },
        saveBtn = {
            text = "Save Scene",
            startY = 300 + 5 + 24 + 5,
            height = 24
        }
    }
}

mapperUI.propWnd.createUI = function()
    mapperUI.propWnd.element = imports.beautify.card.create(mapperUI.propWnd.startX, mapperUI.propWnd.startY, mapperUI.propWnd.width, mapperUI.propWnd.height)
    imports.beautify.setUIVisible(mapperUI.propWnd.element, true)
    imports.beautify.setUIDraggable(mapperUI.propWnd.element, true)
    mapperUI.propWnd.propLst.element = imports.beautify.gridlist.create(0, 0, mapperUI.propWnd.width, mapperUI.propWnd.propLst.height, mapperUI.propWnd.element, false)
    imports.beautify.setUIVisible(mapperUI.propWnd.propLst.element, true)
    imports.beautify.gridlist.addColumn(mapperUI.propWnd.propLst.element, mapperUI.propWnd.propLst.text, mapperUI.propWnd.width)
    for i = 1, #Assetify_Props, 1 do
        local j = Assetify_Props[i]
        local rowIndex = imports.beautify.gridlist.addRow(mapperUI.propWnd.propLst.element)
        imports.beautify.gridlist.setRowData(mapperUI.propWnd.propLst.element, rowIndex, 1, j)
    end
    imports.beautify.gridlist.setSelection(mapperUI.propWnd.propLst.element, 1)
    mapperUI.propWnd.spawnBtn.element = imports.beautify.button.create(mapperUI.propWnd.spawnBtn.text, 0, mapperUI.propWnd.spawnBtn.startY, "default", mapperUI.propWnd.width, mapperUI.propWnd.spawnBtn.height, mapperUI.propWnd.element, false)
    imports.beautify.setUIVisible(mapperUI.propWnd.spawnBtn.element, true)
end

mapperUI.sceneWnd.createUI = function()
    mapperUI.sceneWnd.element = imports.beautify.card.create(mapperUI.sceneWnd.startX, mapperUI.sceneWnd.startY, mapperUI.sceneWnd.width, mapperUI.sceneWnd.height)
    imports.beautify.setUIVisible(mapperUI.sceneWnd.element, true)
    imports.beautify.setUIDraggable(mapperUI.sceneWnd.element, true)
    mapperUI.sceneWnd.propLst.element = imports.beautify.gridlist.create(0, 0, mapperUI.sceneWnd.width, mapperUI.sceneWnd.propLst.height, mapperUI.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapperUI.sceneWnd.propLst.element, true)
    imports.beautify.gridlist.addColumn(mapperUI.sceneWnd.propLst.element, mapperUI.sceneWnd.propLst.text, mapperUI.sceneWnd.width)
    for i = 1, #Assetify_Props, 1 do
        local j = Assetify_Props[i]
        local rowIndex = imports.beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element)
        imports.beautify.gridlist.setRowData(mapperUI.sceneWnd.propLst.element, rowIndex, 1, "#"..i.." ("..j..")")
    end
    mapperUI.sceneWnd.resetBtn.element = imports.beautify.button.create(mapperUI.sceneWnd.resetBtn.text, 0, mapperUI.sceneWnd.resetBtn.startY, "default", mapperUI.sceneWnd.width, mapperUI.sceneWnd.resetBtn.height, mapperUI.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapperUI.sceneWnd.resetBtn.element, true)
    mapperUI.sceneWnd.saveBtn.element = imports.beautify.button.create(mapperUI.sceneWnd.saveBtn.text, 0, mapperUI.sceneWnd.saveBtn.startY, "default", mapperUI.sceneWnd.width, mapperUI.sceneWnd.saveBtn.height, mapperUI.sceneWnd.element, false)
    imports.beautify.setUIVisible(mapperUI.sceneWnd.saveBtn.element, true)
end


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    local booter = function()
        Assetify_Props = assetify.getAssets("props")
        showChat(false)
        --showCursor(true)
        mapperUI.propWnd.createUI()
        mapperUI.sceneWnd.createUI()
    end

    if imports.assetify.isLoaded() then
        booter()
    else
        local booterWrapper = nil
        booterWrapper = function()
            booter()
            imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
        end
        imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
    end
end)