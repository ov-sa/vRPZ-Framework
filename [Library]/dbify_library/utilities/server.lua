----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: utilities: server.lua
     Server: -
     Author: vStudio
     Developer: Aviril
     DOC: 09/10/2021
     Desc: Server Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    fileExists = fileExists,
    fileOpen = fileOpen,
    fileRead = fileRead,
    fileGetSize = fileGetSize,
    fileClose = fileClose
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