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

CCharacter.fetch = function(cThread, characterID)
    if not cThread then return false end
    return cThread:await(imports.dbify.character.fetchAll(cThread, {
        {imports.dbify.character.connection.keyColumn, characterID}
    }))
end

CCharacter.fetchOwned = function(cThread, serial)
    if not cThread then return false end
    return cThread:await(imports.dbify.character.fetchAll(cThread, {
        {"owner", serial}
    }))
end

CCharacter.create = function(cThread, serial)
    if not cThread then return false end
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    local characterID = cThread:await(imports.dbify.character.create(cThread)
    CCharacter.CBuffer[characterID] = {
        {"owner", serial}
    }
    cThread:await(imports.dbify.character.setData(cThread, characterID, CCharacter.CBuffer[characterID]))
    return characterID
end

CCharacter.delete = function(cThread, characterID)
    if not cThread then return false end
    cThread:await(imports.dbify.character.delete(cThread, characterID))
    CCharacter.CBuffer[characterID] = nil
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