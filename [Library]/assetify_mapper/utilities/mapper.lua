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
    getElementPosition = getElementPosition,
    table = table,
    beautify = beautify
}


-----------------------
--[[ Class: Mapper ]]--
-----------------------

mapper = {
    assetPack = "object",
    axis = {
        width = 7, length = 7,
        color = {x = imports.tocolor(255, 0, 0, 250), y = imports.tocolor(0, 255, 0, 250), z = imports.tocolor(0, 0, 255, 250)}
    },
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
        local posX, posY, posZ = imports.getElementPosition(mapper.isTargettingDummy)
        dxDrawLine3D(posX, posY, posZ, posX + imports.axis.length, posY, posZ, imports.axis.color.x, imports.axis.width)
        dxDrawLine3D(posX, posY, posZ, posX, posY + imports.axis.length, posZ, imports.axis.color.y, imports.axis.width)
        dxDrawLine3D(posX, posY, posZ, posX, posY, posZ + imports.axis.length, imports.axis.color.z, imports.axis.width)
        if camera.isCursorVisible then
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