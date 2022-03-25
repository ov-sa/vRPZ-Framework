local availableProps = {
    "Tree",
    "House_A",
    "House_B"
}


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
    mapperUI.propWnd.element = beautify.card.create(mapperUI.propWnd.startX, mapperUI.propWnd.startY, mapperUI.propWnd.width, mapperUI.propWnd.height)
    beautify.setUIVisible(mapperUI.propWnd.element, true)
    beautify.setUIDraggable(mapperUI.propWnd.element, true)
    mapperUI.propWnd.propLst.element = beautify.gridlist.create(0, 0, mapperUI.propWnd.width, mapperUI.propWnd.propLst.height, mapperUI.propWnd.element, false)
    beautify.setUIVisible(mapperUI.propWnd.propLst.element, true)
    beautify.gridlist.addColumn(mapperUI.propWnd.propLst.element, mapperUI.propWnd.propLst.text, mapperUI.propWnd.width)
    for i = 1, #availableProps, 1 do
        local j = availableProps[i]
        local rowIndex = beautify.gridlist.addRow(mapperUI.propWnd.propLst.element)
        beautify.gridlist.setRowData(mapperUI.propWnd.propLst.element, rowIndex, 1, j)
    end
    beautify.gridlist.setSelection(mapperUI.propWnd.propLst.element, 1)
    mapperUI.propWnd.spawnBtn.element = beautify.button.create(mapperUI.propWnd.spawnBtn.text, 0, mapperUI.propWnd.spawnBtn.startY, "default", mapperUI.propWnd.width, mapperUI.propWnd.spawnBtn.height, mapperUI.propWnd.element, false)
    beautify.setUIVisible(mapperUI.propWnd.spawnBtn.element, true)
end

mapperUI.sceneWnd.createUI = function()
    mapperUI.sceneWnd.element = beautify.card.create(mapperUI.sceneWnd.startX, mapperUI.sceneWnd.startY, mapperUI.sceneWnd.width, mapperUI.sceneWnd.height)
    beautify.setUIVisible(mapperUI.sceneWnd.element, true)
    beautify.setUIDraggable(mapperUI.sceneWnd.element, true)
    mapperUI.sceneWnd.propLst.element = beautify.gridlist.create(0, 0, mapperUI.sceneWnd.width, mapperUI.sceneWnd.propLst.height, mapperUI.sceneWnd.element, false)
    beautify.setUIVisible(mapperUI.sceneWnd.propLst.element, true)
    beautify.gridlist.addColumn(mapperUI.sceneWnd.propLst.element, mapperUI.sceneWnd.propLst.text, mapperUI.sceneWnd.width)
    for i = 1, #availableProps, 1 do
        local j = availableProps[i]
        local rowIndex = beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element)
        beautify.gridlist.setRowData(mapperUI.sceneWnd.propLst.element, rowIndex, 1, "#"..i.." ("..j..")")
    end
    mapperUI.sceneWnd.resetBtn.element = beautify.button.create(mapperUI.sceneWnd.resetBtn.text, 0, mapperUI.sceneWnd.resetBtn.startY, "default", mapperUI.sceneWnd.width, mapperUI.sceneWnd.resetBtn.height, mapperUI.sceneWnd.element, false)
    beautify.setUIVisible(mapperUI.sceneWnd.resetBtn.element, true)
    mapperUI.sceneWnd.saveBtn.element = beautify.button.create(mapperUI.sceneWnd.saveBtn.text, 0, mapperUI.sceneWnd.saveBtn.startY, "default", mapperUI.sceneWnd.width, mapperUI.sceneWnd.saveBtn.height, mapperUI.sceneWnd.element, false)
    beautify.setUIVisible(mapperUI.sceneWnd.saveBtn.element, true)
end

showChat(false)
showCursor(true)
mapperUI.propWnd.createUI()
mapperUI.sceneWnd.createUI()