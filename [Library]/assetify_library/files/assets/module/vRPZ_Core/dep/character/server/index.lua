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
    local result = cThread:await(imports.dbify.character.fetchAll(cThread, {
        {imports.dbify.character.connection.key, characterID}
    }))
    return result
end

CCharacter.fetchOwned = function(cThread, serial)
    if not cThread then return false end
    local result = cThread:await(imports.dbify.character.fetchAll(cThread, {
        {"owner", serial}
    }))
    return result
end

CCharacter.create = function(cThread, serial)
    if not cThread then return false end
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    local characterID = cThread:await(imports.dbify.character.create(cThread))
    CCharacter.CBuffer[characterID] = {
        {"owner", serial}
    }
    cThread:await(imports.dbify.character.setData(cThread, characterID, CCharacter.CBuffer[characterID]))
    return characterID
end

CCharacter.delete = function(cThread, characterID)
    if not cThread then return false end
    local result = cThread:await(imports.dbify.character.delete(cThread, characterID))
    if result then CCharacter.CBuffer[characterID] = nil end
    return result
end

CCharacter.setData = function(cThread, characterID, characterDatas)
    if not cThread then return false end
    local result = cThread:await(imports.dbify.character.setData(cThread, characterID, characterDatas))
    if result and CCharacter.CBuffer[characterID] then
        for i = 1, #characterDatas, 1 do
            local j = characterDatas[i]
            CCharacter.CBuffer[characterID][(j[1])] = j[2]
        end
    end
    return result
end

CCharacter.getData = function(cThread, characterID, characterDatas)
    if not cThread then return false end
    local result = cThread:await(imports.dbify.character.getData(cThread, characterID, characterDatas))
    if result and CCharacter.CBuffer[characterID] then
        for i = 1, #characterDatas, 1 do
            local j = characterDatas[i]
            CCharacter.CBuffer[characterID][j] = result[j]
        end
    end
    return result
end