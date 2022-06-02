-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    table = table,
    dbify = dbify
}


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter.CBuffer = {}

CCharacter.fetch = function(cThread, characterID, ...)
    if not cThread then return false end
    cThread:await(imports.dbify.character.fetchAll(cThread, {
        {imports.dbify.character.connection.keyColumn, characterID}
    }, ...))
    return true
end

CCharacter.fetchOwned = function(cThread, serial, ...)
    if not cThread then return false end
    cThread:await(imports.dbify.character.fetchAll(cThread, {
        {"owner", serial}
    }, ...))
    return true
end

CCharacter.create = function(cThread, serial, callback, ...)
    if not cThread then return false end
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    cThread:await(imports.dbify.character.create(cThread, function(characterID, args)
        CCharacter.CBuffer[characterID] = {
            {"owner", args[1]}
        }
        imports.dbify.character.setData(characterID, CCharacter.CBuffer[characterID])
        local cbRef = callback
        if (cbRef and (imports.type(cbRef) == "function")) then
            imports.table.remove(args, 1)
            cbRef(characterID, args)
        end
    end, serial, ...))
    return true
end

CCharacter.delete = function(cThread, characterID, callback, ...)
    if not cThread then return false end
    cThread:await(imports.dbify.character.delete(cThread, characterID, function(result, args)
        if result then
            CCharacter.CBuffer[characterID] = nil
        end
        local cbRef = callback
        if (cbRef and (imports.type(cbRef) == "function")) then
            cbRef(result, args)
        end
    end, ...))
    return true
end

CCharacter.setData = function(cThread, characterID, characterDatas, callback, ...)
    if not cThread then return false end
    cThread:await(imports.dbify.character.setData(cThread, characterID, characterDatas, function(result, args)
        if result and CCharacter.CBuffer[characterID] then
            for i = 1, #characterDatas, 1 do
                local j = characterDatas[i]
                CCharacter.CBuffer[characterID][(j[1])] = j[2]
            end
        end
        local cbRef = callback
        if (cbRef and (imports.type(cbRef) == "function")) then
            imports.table.remove(args, 1)
            cbRef(result, args)
        end
    end, characterDatas, ...))
    return true
end

CCharacter.getData = function(cThread, characterID, characterDatas, callback, ...)
    if not cThread then return false end
    cThread:await(imports.dbify.character.getData(cThread, characterID, characterDatas, function(result, args)
        local cbRef = callback
        if (cbRef and (imports.type(cbRef) == "function")) then
            cbRef(result, args)
        end
        if result and CCharacter.CBuffer[characterID] then
            for i, j in imports.pairs(characterDatas) do
                CCharacter.CBuffer[characterID][j] = result[j]
            end
        end
    end, ...))
    return true
end