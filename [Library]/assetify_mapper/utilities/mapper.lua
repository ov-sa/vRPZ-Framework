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
    setElementLocation = setElementLocation,
    getElementLocation = getElementLocation,
    setElementAlpha = setElementAlpha,
    engineRequestModel = engineRequestModel,
    engineLoadTXD = engineLoadTXD,
    engineLoadDFF = engineLoadDFF,
    engineLoadCOL = engineLoadCOL,
    engineImportTXD = engineImportTXD,
    engineReplaceModel = engineReplaceModel,
    engineReplaceCOL = engineReplaceCOL,
    engineSetModelLODDistance = engineSetModelLODDistance,
    createObject = createObject,
    setLowLODElement = setLowLODElement,
    attachElements = attachElements,
    table = table,
    beautify = beautify
}


-----------------------
--[[ Class: Mapper ]]--
-----------------------

mapper = {
    assetPack = "object",
    rwAssets = {},
    axis = {
        validAxes = {
            x = {rotation = {0, 0, 0}},
            y = {rotation = {0, 90, 0}},
            z = {rotation = {90, 0, 0}}
        },
        validAxesTypes = {"slate", "ring"},
        --color = {x = imports.tocolor(255, 0, 0, 250), y = imports.tocolor(0, 255, 0, 250), z = imports.tocolor(0, 0, 255, 250)},
    },
    speed = {range = availableControlSpeeds},
    controls = availableControls,
    buffer = {
        index = {},
        element = {}
    }
}
mapper.__index = mapper

mapper.rwAssets.dict = imports.engineLoadTXD("utilities/rw/axis/dict.rw")
mapper.rwAssets.buffer = imports.engineLoadDFF("utilities/rw/axis/slate/buffer.rw")
mapper.rwAssets.collision = imports.engineLoadCOL("utilities/rw/axis/slate/collision.rw")
mapper.rwAssets.slate = imports.engineRequestModel("object", 16754)
imports.engineImportTXD(mapper.rwAssets.dict, mapper.rwAssets.slate)
imports.engineReplaceCOL(mapper.rwAssets.collision, mapper.rwAssets.slate)
imports.engineReplaceModel(mapper.rwAssets.buffer, mapper.rwAssets.slate, true)
imports.engineSetModelLODDistance(mapper.rwAssets.slate, 300)
mapper.rwAssets.buffer = imports.engineLoadDFF("utilities/rw/axis/ring/buffer.rw")
mapper.rwAssets.collision = imports.engineLoadCOL("utilities/rw/axis/ring/collision.rw")
mapper.rwAssets.ring = imports.engineRequestModel("object", 16754)
imports.engineImportTXD(mapper.rwAssets.dict, mapper.rwAssets.ring)
imports.engineReplaceCOL(mapper.rwAssets.collision, mapper.rwAssets.ring)
imports.engineReplaceModel(mapper.rwAssets.buffer, mapper.rwAssets.ring, true)
imports.engineSetModelLODDistance(mapper.rwAssets.ring, 300)
mapper.rwAssets.dict, mapper.rwAssets.buffer, mapper.rwAssets.collision = nil, nil, nil
for i = 1, #mapper.axis.validAxesTypes, 1 do
    local j = mapper.axis.validAxesTypes[i]
    mapper.axis[j] = {}
    for k, v in imports.pairs(mapper.axis.validAxes) do
        mapper.axis[j][k] = {
            instance = imports.createObject(mapper.rwAssets[j], 0, 0, 0),
            LODInstance = imports.createObject(mapper.rwAssets[j], 0, 0, 0, 0, 0, 0, true)
        }
        imports.setLowLODElement(mapper.axis[j][k].instance, mapper.axis[j][k].LODInstance)
        imports.attachElements(mapper.axis[j][k].LODInstance, mapper.axis[j][k].instance)
    end
end

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
    imports.beautify.gridlist.setRowData(mapper.ui.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapper.ui.sceneWnd.propLst.element), 1, "#"..(self.id).."  ━━  "..(self.assetName))
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
        local posX, posY, posZ, rotX, rotY, rotZ = imports.getElementLocation(mapper.isTargettingDummy)
        local isRotationMode = imports.getKeyState(mapper.controls.toggleRotation) or false
        for i = 1, #mapper.axis.validAxesTypes, 1 do
            local j = mapper.axis.validAxesTypes[i]
            for k, v in imports.pairs(mapper.axis.validAxes) do
                imports.setElementLocation(mapper.axis[j][k].instance, posX, posY, posZ, v.rotation[1], v.rotation[2], v.rotation[3])
                imports.setElementAlpha(mapper.axis[j][k].instance, 25)
                imports.setElementAlpha(mapper.axis[j][k].LODInstance, 25)
            end
        end
        --[[
        if camera.isCursorVisible and not imports.getKeyState(mapper.controls.controlAction) then
            local object_speed = ((imports.getKeyState(mapper.controls.speedUp) and mapper.speed.range.fast) or (imports.getKeyState(mapper.controls.speedDown) and mapper.speed.range.slow) or mapper.speed.range.normal)*((isRotationMode and 1) or 0.1)
            if imports.getPedControlState(mapper.controls.moveForwards) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX + object_speed, rotY, rotZ)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX + object_speed, posY, posZ)
                end
            elseif imports.getPedControlState(mapper.controls.moveBackwards) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX - object_speed, rotY, rotZ)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX - object_speed, posY, posZ)
                end
            end
            if imports.getPedControlState(mapper.controls.moveLeft) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX, rotY, rotZ + object_speed)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX, posY + object_speed, posZ)
                end
            elseif imports.getPedControlState(mapper.controls.moveRight) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX, rotY, rotZ - object_speed)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX, posY - object_speed, posZ)
                end
            end
            if imports.getKeyState(mapper.controls.moveUp) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX, rotY + object_speed, rotZ)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX, posY, posZ + object_speed)
                end
            elseif imports.getKeyState(mapper.controls.moveDown) then
                if isRotationMode then
                    imports.setElementLocation(mapper.isTargettingDummy, _, _, _, rotX, rotY - object_speed, rotZ)
                else
                    imports.setElementLocation(mapper.isTargettingDummy, posX, posY, posZ - object_speed)
                end
            end
        end
        ]]
    end
end

mapper.controlKey = function(button, state)
    if state then return false end
    if imports.getKeyState(mapper.controls.controlAction) then
    else
        if button == mapper.controls.cloneObject then
            if mapper.isTargettingDummy then
                local posX, posY, posZ, rotX, rotY, rotZ = imports.getElementLocation(mapper.isTargettingDummy)
                mapper:create(mapper.buffer.element[(mapper.isTargettingDummy)].assetName, {
                    position = {x = posX, y = posY, z = posZ},
                    rotation = {x = rotX, y = rotY, z = rotZ}
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