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
    pairs = pairs,
    tocolor = tocolor,
    isElement = isElement,
    destroyElement = destroyElement,
    setmetatable = setmetatable,
    addEventHandler = addEventHandler,
    getKeyState = getKeyState,
    getPedControlState = getPedControlState,
    setElementPosition = setElementPosition,
    setElementRotation = setElementRotation,
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
    speed = {range = availableControlSpeeds},
    controls = availableControls,
    buffer = {
        index = {},
        element = {}
    }
}
mapper.__index = mapper

function mapper:create(...)
    local cMapper = imports.setmetatable({}, {__index = self})
    local cInstance = cMapper:load(...)
    if not cInstance then
        cMapper = nil
        return false
    end
    return cMapper, cInstance
end

function mapper:destroy(...)
    if not self or (self == mapper) then return false end
    return self:unload(...)
end

function mapper:reset()
    for i, j in imports.pairs(mapper.buffer.element) do
        if i and imports.isElement(i) then
            imports.destroyElement(i)
        end
    end
    return true
end

function mapper:load(assetName, dummyData, retargetFocus)
    if not self or (self == mapper) then return false end
    local cDummy = assetify.createDummy(mapper.assetPack, assetName, dummyData)
    if not cDummy then return false end
    self.id = #mapper.buffer.index + 1
    self.element = cDummy
    self.assetName = assetName
    imports.table.insert(mapper.buffer.index, self)
    mapper.buffer.element[(self.element)] = self
    imports.beautify.gridlist.setRowData(mapper.ui.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapper.ui.sceneWnd.propLst.element), 1, "#"..(self.id).." ("..(self.assetName)..")")
    if retargetFocus then mapper.isTargettingDummy = self.element end
    return self.element
end

function mapper:unload()
    if not self or (self == mapper) then return false end
    for i = self.id + 1, #mapper.buffer.index, 1 do
        mapper.buffer.index[i].id = mapper.buffer.index[i].id - 1
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
        if camera.isCursorVisible and not imports.getKeyState(mapper.controls.controlAction) then
            local isRotationMode = imports.getKeyState(mapper.controls.toggleRotation) or false
            local object_speed = ((imports.getKeyState(mapper.controls.speedUp) and mapper.speed.range.fast) or (imports.getKeyState(mapper.controls.speedDown) and mapper.speed.range.slow) or mapper.speed.range.normal)*((isRotationMode and 1) or 0.1)
            if imports.getPedControlState(mapper.controls.moveForwards) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x + object_speed, cMatrix.rotation.y, cMatrix.rotation.z)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position + (cMatrix.forward*object_speed))
                end
            elseif imports.getPedControlState(mapper.controls.moveBackwards) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x - object_speed, cMatrix.rotation.y, cMatrix.rotation.z)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position - (cMatrix.forward*object_speed))
                end
            end
            if imports.getPedControlState(mapper.controls.moveLeft) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x, cMatrix.rotation.y, cMatrix.rotation.z + object_speed)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position + (cMatrix.right*object_speed))
                end
            elseif imports.getPedControlState(mapper.controls.moveRight) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x, cMatrix.rotation.y, cMatrix.rotation.z - object_speed)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position - (cMatrix.right*object_speed))
                end
            end
            if imports.getKeyState(mapper.controls.moveUp) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x, cMatrix.rotation.y + object_speed, cMatrix.rotation.z)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position + (cMatrix.up*object_speed))
                end
            elseif imports.getKeyState(mapper.controls.moveDown) then
                if isRotationMode then
                    imports.setElementRotation(mapper.isTargettingDummy, cMatrix.rotation.x, cMatrix.rotation.y - object_speed, cMatrix.rotation.z)
                else
                    imports.setElementPosition(mapper.isTargettingDummy, cMatrix.position - (cMatrix.up*object_speed))
                end
            end
        end
    end
end

mapper.controlKey = function(button, state)
    if state then return false end
    if imports.getKeyState(mapper.controls.controlAction) then
    else
        if button == mapper.controls.cloneObject then
            if mapper.isTargettingDummy then
                local cPosition, cRotation = mapper.isTargettingDummy.position, mapper.isTargettingDummy.rotation
                mapper:create(mapper.buffer.element[(mapper.isTargettingDummy)].assetName, {
                    position = {x = cPosition.x, y = cPosition.y, z = cPosition.z},
                    rotation = {x = cRotation.x, y = cRotation.y, z = cRotation.z}
                }, true)
            end
        elseif button == mapper.controls.deleteObject then
            if mapper.isTargettingDummy then
                imports.destroyElement(mapper.isTargettingDummy)
            end
        end
    end
end

mapper.controlClick = function(button, state, _, _, worldX, worldY, worldZ, targetElement)
    if state == "down" then return false end
    if button == "left" then
        if mapper.isSpawningDummy then
            if not mapper.isSpawningDummy.isScheduled then
                mapper.isSpawningDummy.isScheduled = true
                mapper.isTargettingDummy = false
            else
                mapper:create(mapper.isSpawningDummy.assetName, {
                    position = {x = worldX, y = worldY, z = worldZ},
                    rotation = {x = 0, y = 0, z = 0}
                }, true)
                mapper.isSpawningDummy = false
            end
        else
            mapper.isTargettingDummy = (targetElement and mapper.buffer.element[targetElement] and targetElement) or false
        end
    end
end

imports.addEventHandler("onClientElementDestroy", root, function()
    if mapper.isLibraryStopping or not mapper.buffer.element[source] then return false end
    if mapper.isTargettingDummy == source then mapper.isTargettingDummy = false end
    mapper.buffer.element[source]:destroy()
end)