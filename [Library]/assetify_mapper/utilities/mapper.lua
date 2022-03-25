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
    setmetatable = setmetatable,
    addEventHandler = addEventHandler,
    table = table,
    beautify = beautify
}


-----------------------
--[[ Class: Mapper ]]--
-----------------------

mapper = {
    assetPack = "object",
    buffer = {
        index = {},
        element = {}
    }
}
mapper.__index = mapper

function mapper:create(...)
    local cmapper = imports.setmetatable({}, {__index = self})
    if not cmapper:load(...) then
        cmapper = nil
        return false
    end
    return cmapper
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
    mapper.buffer.element[(self.element)] = self
    imports.beautify.gridlist.setRowData(mapperUI.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element), 1, "#"..(self.id).." ("..(self.assetName)..")")
    return true
end

function mapper:unload()
    if not self or (self == mapper) then return false end
    for i = self.id + 1, #mapper.buffer.index, 1 do
        mapper.buffer.index[(self.id)].id = mapper.buffer.index[(self.id)].id - 1
    end
    imports.table.remove(mapper.buffer.index, self.id)
    mapper.buffer.element[(self.element)] = nil
    imports.beautify.gridlist.removeRow(mapperUI.sceneWnd.propLst.element, self.id)
    self = nil
    return true
end

imports.addEventHandler("onClientElementDestroy", root, function()
    if not mapper.buffer.element[dummy] then return false end
    mapper.buffer.element[dummy]:destroy()
end)