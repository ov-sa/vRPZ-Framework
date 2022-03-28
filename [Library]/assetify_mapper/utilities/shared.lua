----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: utilities: shared.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

if localPlayer then
    loadstring(exports.beautify_library:fetchImports())()
end
loadstring(exports.assetify_library:fetchImports())()
loadstring(exports.assetify_library:fetchThreader())()

local imports = {
    isElement = isElement,
    fileExists = fileExists,
    fileCreate = fileCreate,
    fileDelete = fileDelete,
    fileOpen = fileOpen,
    fileRead = fileRead,
    fileWrite = fileWrite,
    fileGetSize = fileGetSize,
    fileClose = fileClose,
    setElementPosition = setElementPosition,
    getElementPosition = getElementPosition,
    setElementRotation = setElementRotation,
    getElementRotation = getElementRotation
}


---------------------
--[[ Class: File ]]--
---------------------

file = {
    exists = imports.fileExists,
    delete = imports.fileDelete,
    read = function(path)
        if not path or not imports.fileExists(path) then return false end
        local cFile = imports.fileOpen(path, true)
        if not cFile then return false end
        local data = imports.fileRead(cFile, imports.fileGetSize(cFile))
        imports.fileClose(cFile)
        return data
    end,
    write = function(path, data)
        if not path or not data then return false end
        local cFile = imports.fileCreate(path)
        if not cFile then return false end
        imports.fileWrite(cFile, data)
        imports.fileClose(cFile)    
        return true
    end
}


-------------------------------------------------
--[[ Functions: Sets/Gets Element's Location ]]--
-------------------------------------------------

function setElementLocation(element, posX, posY, posZ, rotX, rotY, rotZ)
    if not element or not imports.isElement(element) then return false end
    if posX and posY and posZ then
        imports.setElementPosition(element, posX, posY, posZ)
    end
    if rotX and rotY and rotZ then
        imports.setElementRotation(element, rotX, rotY, rotZ)
    end
    return true
end

function getElementLocation(element)
    if not element or not imports.isElement(element) then return false end
    local posX, posY, posZ = imports.getElementPosition(element)
    local rotX, rotY, rotZ = imports.getElementRotation(element)
    return posX, posY, posZ, rotX, rotY, rotZ 
end