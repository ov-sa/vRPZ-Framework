----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: handlers: loader.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Mapper Loader ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    setmetatable = setmetatable,
    addEventHandler = addEventHandler,
    beautify = beautify
}


-----------------------
--[[ Class: Mapper ]]--
-----------------------

mapper = {
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
    local cDummy = assetify.createDummy("object", assetName, ...)
    if not cDummy then return false end
    self.id = #mapper.buffer.index + 1
    self.element = cDummy
    self.assetName = assetName
    mapper.buffer.index[(self.id)] = self
    mapper.buffer.element[(self.element)] = self
    imports.beautify.gridlist.setRowData(mapperUI.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element), 1, "#"..(self.id).." ("..(self.assetName)..")")
    return true
end

function mapper:unload()
    if not self or (self == mapper) then return false end
    mapper.buffer.index[(self.id)] = nil
    mapper.buffer.element[(self.element)] = nil
    self = nil
    return true
end

imports.addEventHandler("onClientElementDestroy", root, function()
    if not mapper.buffer.element[dummy] then return false end
    mapper.buffer.element[dummy]:destroy()
end)