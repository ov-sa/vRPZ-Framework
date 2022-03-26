----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: utilities: mapper.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Mapper Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    setmetatable = setmetatable,
    addEventHandler = addEventHandler,
    getPedControlState = getPedControlState,
    Vector3 = Vector3,
    table = table,
    beautify = beautify
}


-----------------------
--[[ Class: Mapper ]]--
-----------------------

mapper = {
    assetPack = "object",
    axis = {
        width = 15, length = 10,
        color = {x = imports.tocolor(255, 0, 0, 250), y = imports.tocolor(0, 255, 0, 250), z = imports.tocolor(0, 0, 255, 250)}
    },
    controls = availableControls,
    buffer = {
        index = {},
        element = {}
    }
}
mapper.__index = mapper

function mapper:create(...)
    local cMapper = imports.setmetatable({}, {__index = self})
    if not cMapper:load(...) then
        cMapper = nil
        return false
    end
    return cMapper
end

function mapper:destroy(...)
    if not self or (self == mapper) then return false end
    return self:unload(...)
end

function mapper:load(assetName, ...)
    if not self or (self == mapper) then return false end
    local cDummy = assetify.createDummy(mapper.assetPack, assetName, ...)
    if not cDummy then return false end
    self.id = #mapper.buffer.index + 1
    self.element = cDummy
    self.assetName = assetName
    imports.table.insert(mapper.buffer.index, self.id)
    mapper.buffer.index[(self.id)] = self
    print(self.element)
    mapper.buffer.element[(self.element)] = self
    imports.beautify.gridlist.setRowData(mapper.ui.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapper.ui.sceneWnd.propLst.element), 1, "#"..(self.id).." ("..(self.assetName)..")")
    return true
end

function mapper:unload()
    if not self or (self == mapper) then return false end
    for i = self.id + 1, #mapper.buffer.index, 1 do
        mapper.buffer.index[(self.id)].id = mapper.buffer.index[(self.id)].id - 1
    end
    imports.table.remove(mapper.buffer.index, self.id)
    mapper.buffer.element[(self.element)] = nil
    imports.beautify.gridlist.removeRow(mapper.ui.sceneWnd.propLst.element, self.id)
    self = nil
    return true
end

mapper.render = function()
    if mapper.isTargettingDummy then
        local cMatrix, cPosition = mapper.isTargettingDummy.matrix, mapper.isTargettingDummy.position
        local vectorX, vectorY, vectorZ = cMatrix:transformPosition(imports.Vector3(mapper.axis.length, 0, 0)), cMatrix:transformPosition(imports.Vector3(0, mapper.axis.length, 0)), cMatrix:transformPosition(imports.Vector3(0, 0, mapper.axis.length))
        imports.beautify.native.drawLine3D(cPosition.x, cPosition.y, cPosition.z, vectorX.x, vectorX.y, vectorX.z, mapper.axis.color.x, mapper.axis.width)
        imports.beautify.native.drawLine3D(cPosition.x, cPosition.y, cPosition.z, vectorY.x, vectorY.y, vectorY.z, mapper.axis.color.y, mapper.axis.width)
        imports.beautify.native.drawLine3D(cPosition.x, cPosition.y, cPosition.z, vectorZ.x, vectorZ.y, vectorZ.z, mapper.axis.color.z, mapper.axis.width)
        if camera.isCursorVisible then
            if imports.getPedControlState(mapper.controls.moveForwards) then
                mapper.isTargettingDummy.position = cMatrix.position + cMatrix.forward*2
            elseif imports.getPedControlState(mapper.controls.moveBackwards) then
                mapper.isTargettingDummy.position = cMatrix.position - cMatrix.forward*2
            end
            if imports.getPedControlState(mapper.controls.moveLeft) then
                mapper.isTargettingDummy.position = cMatrix.position + cMatrix.right*2
            elseif imports.getPedControlState(mapper.controls.moveRight) then
                mapper.isTargettingDummy.position = cMatrix.position - cMatrix.right*2
            end
        end
    end
end

mapper.controlClick = function(button, state, _, _, worldX, worldY, worldZ, targetElement)
    if state == "down" then return false end
    if button == "left" then
        if mapper.isSpawningDummy then
            mapper.isTargettingDummy = false
            if not mapper.isSpawningDummy.isScheduled then
                mapper.isSpawningDummy.isScheduled = true
            else
                mapper:create(mapper.isSpawningDummy.assetName, {
                    position = {x = worldX, y = worldY, z = worldZ},
                    rotation = {x = 0, y = 0, z = 0},
                    dimension = 0,
                    interior = 0
                })
                mapper.isSpawningDummy = false
            end
        else
            mapper.isTargettingDummy = (targetElement and mapper.buffer.element[targetElement] and targetElement) or false
        end
    end
end

imports.addEventHandler("onClientElementDestroy", root, function()
    if mapper.isLibraryStopping or not mapper.buffer.element[dummy] then return false end
    mapper.buffer.element[dummy]:destroy()
end)