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
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    createObject = createObject,
    setLowLODElement = setLowLODElement,
    attachElements = attachElements,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    isMouseClicked = isMouseClicked,
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
        validAxesTypes = {"slate", "ring"},
        validAxes = {
            x = {color = {255, 0, 0}, rotation = {slate = {0, 0, 90}, ring = {0, 0, 0}}},
            y = {color = {0, 255, 0}, rotation = {slate = {0, 0, 0}, ring = {0, 90, 0}}},
            z = {color = {0, 0, 255}, rotation = {slate = {90, 0, 0}, ring = {90, 0, 0}}}
        }
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
            LODInstance = imports.createObject(mapper.rwAssets[j], 0, 0, 0, 0, 0, 0, true),
            shader = imports.beautify.native.createShader(shaderRW["Assetify_AxisMapper"](), 10001, 0, false, "all")
        }
        imports.setLowLODElement(mapper.axis[j][k].instance, mapper.axis[j][k].LODInstance)
        imports.attachElements(mapper.axis[j][k].LODInstance, mapper.axis[j][k].instance)
        imports.beautify.native.setShaderValue(mapper.axis[j][k].shader, "baseColor", v.color[1], v.color[2], v.color[3], 255)
        imports.engineApplyShaderToWorldTexture(mapper.axis[j][k].shader, "assetify_axis", mapper.axis[j][k].instance)
        imports.engineApplyShaderToWorldTexture(mapper.axis[j][k].shader, "assetify_axis", mapper.axis[j][k].LODInstance)
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

mapper.render = function(renderData)
    if renderData.renderType == "input" then
        mapper.cache.keys.mouse = imports.isMouseClicked()
        mapper.cache.keys.mouseLMBHold = (mapper.cache.keys.mouse ~= "mouse1") and imports.isKeyOnHold("mouse1")
        --prevMouseKeyClickState = mapper.cache.keys.mouse
    elseif renderData.renderType == "render" then
        mapper.ui.renderToolWnd()
        mapper.translationMode = (mapper.isTargettingDummy and (mapper.translationMode or {})) or false
        local isCursorTranslation = false
        if mapper.translationMode then
            mapper.translationMode.element = mapper.isTargettingDummy
            mapper.translationMode.type = mapper.translationMode.type or "slate"
            mapper.translationMode.axis = mapper.translationMode.axis or "x"
            mapper.translationMode.posX, mapper.translationMode.posY, mapper.translationMode.posZ, mapper.translationMode.rotX, mapper.translationMode.rotY, mapper.translationMode.rotZ = imports.getElementLocation(mapper.translationMode.element)
            if not CLIENT_MTA_WINDOW_ACTIVE then
                local isSlateTranslation = mapper.translationMode.type == "slate"
                local translationIndex = ((mapper.translationMode.axis == "x") and ((isSlateTranslation and "posX") or "rotX")) or ((mapper.translationMode.axis == "y") and ((isSlateTranslation and "posY") or "rotY")) or ((mapper.translationMode.axis == "z") and ((isSlateTranslation and "posZ") or "rotZ")) or false
                if translationIndex then
                    local translationSpeed = (imports.getKeyState(mapper.controls.speedUp) and mapper.speed.range.fast) or (imports.getKeyState(mapper.controls.speedDown) and mapper.speed.range.slow) or mapper.speed.range.normal
                    local cursorX, cursorY = CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2]
                    if camera.isCursorVisible then
                        if mapper.cache.keys.mouseLMBHold then
                            isCursorTranslation = true
                            mapper.prevCursorOffset = mapper.prevCursorOffset or {cursorX, cursorY}
                            CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = CLIENT_CURSOR_OFFSET[1] - mapper.prevCursorOffset[1], CLIENT_CURSOR_OFFSET[2] - mapper.prevCursorOffset[2]
                            if isSlateTranslation then
                                CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = CLIENT_CURSOR_OFFSET[1]*CLIENT_MTA_RESOLUTION[1], CLIENT_CURSOR_OFFSET[2]*CLIENT_MTA_RESOLUTION[2]
                            else
                                CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = (CLIENT_CURSOR_OFFSET[1]*360)%360, (CLIENT_CURSOR_OFFSET[2]*360)%360
                            end
                        end
                    end
                    if not isCursorTranslation then
                        mapper.translationMode[translationIndex] = mapper.translationMode[translationIndex] + ((imports.getKeyState(mapper.controls.valueUp) and translationSpeed) or (imports.getKeyState(mapper.controls.valueDown) and -translationSpeed) or 0)
                    else
                        mapper.translationMode[("__"..translationIndex)] = cursorY*translationSpeed
                    end
                    imports.setElementLocation(mapper.translationMode.element, mapper.translationMode.posX + (mapper.translationMode.__posX or 0), mapper.translationMode.posY + (mapper.translationMode.__posY or 0), mapper.translationMode.posZ + (mapper.translationMode.__posZ or 0), mapper.translationMode.rotX + (mapper.translationMode.__rotX or 0), mapper.translationMode.rotY + (mapper.translationMode.__rotY or 0), mapper.translationMode.rotZ + (mapper.translationMode.__rotZ or 0))
                end
            end
        end
        for i = 1, #mapper.axis.validAxesTypes, 1 do
            local j = mapper.axis.validAxesTypes[i]
            local typeAlpha = (not mapper.translationMode and 0) or ((mapper.translationMode.type ~= j) and 0) or nil
            for k, v in imports.pairs(mapper.axis.validAxes) do
                local axisAlpha = typeAlpha or ((mapper.translationMode.axis == k) and 100) or 10
                local isCollisionEnabled = axisAlpha > 0
                if mapper.translationMode then
                    imports.setElementLocation(mapper.axis[j][k].instance, mapper.translationMode.posX, mapper.translationMode.posY, mapper.translationMode.posZ, v.rotation[j][1], v.rotation[j][2], v.rotation[j][3])
                end
                imports.setElementAlpha(mapper.axis[j][k].instance, axisAlpha)
                imports.setElementAlpha(mapper.axis[j][k].LODInstance, axisAlpha)
                imports.setElementCollisionsEnabled(mapper.axis[j][k].instance, isCollisionEnabled)
                imports.setElementCollisionsEnabled(mapper.axis[j][k].LODInstance, isCollisionEnabled)
            end
        end
        mapper.isCursorTranslation = isCursorTranslation
        mapper.prevCursorOffset = (mapper.isCursorTranslation and mapper.prevCursorOffset) or false
    end
end

mapper.controlKey = function(button, state)
    if CLIENT_MTA_WINDOW_ACTIVE or state then return false end
    if button == mapper.controls.switchTranslation then
        local selectedMode = 0
        for i, j in imports.pairs(mapper.axis.validAxesTypes) do
            if mapper.translationMode.type == j then
                selectedMode = i
            end
        end
        mapper.translationMode.type = mapper.axis.validAxesTypes[(selectedMode + 1)] or mapper.axis.validAxesTypes[1]
    elseif button == mapper.controls.switchAxis then
        if mapper.translationMode then
            local selectedAxis, validAxes = 0, {}
            for i, j in imports.pairs(mapper.axis.validAxes) do
                imports.table.insert(validAxes, i)
                if mapper.translationMode.axis == i then
                    selectedAxis = #validAxes
                end
            end
            mapper.translationMode.axis = validAxes[(selectedAxis + 1)] or validAxes[1]
        end
    elseif button == mapper.controls.cloneObject then
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
            local isAxisClicked = false
            if mapper.translationMode then
                for i = 1, #mapper.axis.validAxesTypes, 1 do
                    local j = mapper.axis.validAxesTypes[i]
                    for k, v in imports.pairs(mapper.axis.validAxes) do
                        if (targetElement == mapper.axis[j][k].instance) or (targetElement == mapper.axis[j][k].LODInstance) then
                            isAxisClicked = true
                            mapper.translationMode.axis = k
                            break
                        end
                    end
                    if isAxisClicked then break end
                end
            end
            if not isAxisClicked then
                mapper.isTargettingDummy = (targetElement and mapper.buffer.element[targetElement] and targetElement) or false
            end
        end
    end
end

imports.addEventHandler("onClientElementDestroy", root, function()
    if mapper.isLibraryStopping or not mapper.buffer.element[source] then return false end
    if mapper.isTargettingDummy == source then mapper.isTargettingDummy = false end
    mapper.buffer.element[source]:destroy()
end)