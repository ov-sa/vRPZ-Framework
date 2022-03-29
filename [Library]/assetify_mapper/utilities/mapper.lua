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
    isKeyOnHold = isKeyOnHold,
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
    cache = {keys = {}},
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
    elseif renderData.renderType == "render" then
        mapper.ui.renderToolWnd()
        mapper.ui.renderNotif()
        mapper.translationMode = (mapper.isTargettingDummy and (mapper.translationMode or {})) or false
        local isCursorTranslation = false
        if mapper.translationMode then
            mapper.translationMode.element = mapper.isTargettingDummy
            mapper.translationMode.type = mapper.translationMode.type or 1
            mapper.translationMode.axis = mapper.translationMode.axis or "x"
            mapper.translationMode.posX, mapper.translationMode.posY, mapper.translationMode.posZ, mapper.translationMode.rotX, mapper.translationMode.rotY, mapper.translationMode.rotZ = imports.getElementLocation(mapper.translationMode.element)
            if not CLIENT_MTA_WINDOW_ACTIVE then
                local isSlateTranslation = mapper.axis.validAxesTypes[(mapper.translationMode.type)] == "slate"
                local translationIndex = ((mapper.translationMode.axis == "x") and ((isSlateTranslation and "posX") or "rotX")) or ((mapper.translationMode.axis == "y") and ((isSlateTranslation and "posY") or "rotY")) or ((mapper.translationMode.axis == "z") and ((isSlateTranslation and "posZ") or "rotZ")) or false
                if translationIndex then
                    local translationSpeed, translationValue = (imports.getKeyState(mapper.controls.speedUp) and mapper.speed.range.fast) or (imports.getKeyState(mapper.controls.speedDown) and mapper.speed.range.slow) or mapper.speed.range.normal, nil
                    if camera.isCursorVisible then
                        if mapper.cache.keys.mouseLMBHold then
                            isCursorTranslation = true
                            translationValue = CLIENT_CURSOR_OFFSET[2]
                            mapper.cache.prevCursorY = mapper.cache.prevCursorY or translationValue
                            translationValue = translationValue - mapper.cache.prevCursorY
                            if isSlateTranslation then
                                translationValue = translationValue*CLIENT_MTA_RESOLUTION[2]*0.75
                            else
                                translationValue = (translationValue*360)%360
                            end
                        end
                    end
                    if not isCursorTranslation then
                        translationValue = ((imports.getKeyState(mapper.controls.valueUp) and translationSpeed) or (imports.getKeyState(mapper.controls.valueDown) and -translationSpeed) or 0)
                        if isSlateTranslation then translationValue = translationValue*0.75 end
                        mapper.translationMode[translationIndex] = mapper.translationMode[translationIndex] + translationValue
                    else
                        mapper.translationMode[("__"..translationIndex)] = mapper.translationMode[("__"..translationIndex)] or {
                            native = mapper.translationMode[translationIndex],
                            previous = 0, current = 0, offset = translationValue,
                            speed = translationSpeed
                        }
                        if mapper.translationMode[("__"..translationIndex)].speed ~= translationSpeed then
                            mapper.translationMode[("__"..translationIndex)].speed = translationSpeed
                            mapper.translationMode[("__"..translationIndex)].previous = mapper.translationMode[("__"..translationIndex)].previous + mapper.translationMode[("__"..translationIndex)].current
                            mapper.translationMode[("__"..translationIndex)].offset = translationValue
                        end
                        mapper.translationMode[("__"..translationIndex)].current = (translationValue - mapper.translationMode[("__"..translationIndex)].offset)*translationSpeed
                        mapper.translationMode[translationIndex] = mapper.translationMode[("__"..translationIndex)].native + mapper.translationMode[("__"..translationIndex)].previous + mapper.translationMode[("__"..translationIndex)].current
                    end
                    imports.setElementLocation(mapper.translationMode.element, mapper.translationMode.posX, mapper.translationMode.posY, mapper.translationMode.posZ, mapper.translationMode.rotX, mapper.translationMode.rotY, mapper.translationMode.rotZ)
                end
            end
        end
        for i = 1, #mapper.axis.validAxesTypes, 1 do
            local j = mapper.axis.validAxesTypes[i]
            local typeAlpha = (not mapper.translationMode and 0) or ((mapper.axis.validAxesTypes[(mapper.translationMode.type)] ~= j) and 0) or nil
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
        mapper.cache.prevCursorY = (mapper.isCursorTranslation and mapper.cache.prevCursorY) or false
        if mapper.translationMode and not mapper.isCursorTranslation then
            mapper.translationMode.__posX, mapper.translationMode.__posY, mapper.translationMode.__posZ, mapper.translationMode.__rotX, mapper.translationMode.__rotY, mapper.translationMode.__rotZ = nil, nil, nil, nil, nil, nil
        end
    end
end

mapper.controlKey = function(button, state)
    if CLIENT_MTA_WINDOW_ACTIVE or state then return false end
    if button == mapper.controls.switchTranslation then
        local selectedMode = mapper.translationMode.type + 1
        mapper.translationMode.type = (mapper.axis.validAxesTypes[selectedMode] and selectedMode) or 1
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
            mapper.clickTick = CLIENT_CURRENT_TICK
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