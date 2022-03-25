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
    isElement = isElement,
    addEventHandler = addEventHandler,
    table = table,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

Assetify_Cache = {
    instances = {},
    indexes = {}
}


---------------------------------
--[[ Function: Creates Dummy ]]--
---------------------------------

function createDummy(assetName, ...)
    local cDummy = assetify.createDummy("object", assetName, ...)
    if cDummy then
        imports.table.insert(Assetify_Cache.indexes, cDummy)
        Assetify_Cache.instances[cDummy] = #cDummy
        local rowIndex = imports.beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element)
        imports.beautify.gridlist.setRowData(mapperUI.sceneWnd.propLst.element, imports.beautify.gridlist.addRow(mapperUI.sceneWnd.propLst.element), 1, "#"..(Assetify_Cache.instances[cDummy]).." ("..assetName..")")
        return Assetify_Cache.instances[cDummy]
    end
    return false
end

function destroyDummy(dummy)
    if not dummy or not imports.isElement(dummy) or not Assetify_Cache.instances[dummy] then return false end
    imports.table.remove(Assetify_Cache.indexes, Assetify_Cache.instances[dummy])
    Assetify_Cache.instances[dummy] = nil
    return true
end
imports.addEventHandler("onClientElementDestroy", root, function() destroyDummy(source) end)