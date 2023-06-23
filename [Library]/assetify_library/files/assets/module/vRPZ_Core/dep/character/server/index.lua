-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    table = table,
    assetify = assetify,
    dbify = dbify
}


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter.CBuffer = {}

CCharacter.fetch = function(characterID)
    if not imports.assetify.thread:getThread() then return false end
    local result = imports.dbify.module.character.fetchAll({
        {dbify.module.character.__TMP.structure[(dbify.module.character.__TMP.structure.key)][1], characterID}
    })
    return result
end

CCharacter.fetchOwned = function(serial)
    if not imports.assetify.thread:getThread() then return false end
    local result = imports.dbify.module.character.fetchAll({
        {"owner", serial}
    })
    return result
end

CCharacter.create = function(serial)
    if not imports.assetify.thread:getThread() then return false end
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    local characterID = imports.dbify.module.character.create()
    CCharacter.CBuffer[characterID] = {
        {"owner", serial}
    }
    imports.dbify.module.character.setData(characterID, CCharacter.CBuffer[characterID])
    return characterID
end

CCharacter.delete = function(characterID)
    if not imports.assetify.thread:getThread() then return false end
    local result = imports.dbify.module.character.delete(characterID)
    if result then CCharacter.CBuffer[characterID] = nil end
    return result
end

CCharacter.setData = function(characterID, characterDatas)
    if not imports.assetify.thread:getThread() then return false end
    local result = imports.dbify.module.character.setData(characterID, characterDatas)
    if result and CCharacter.CBuffer[characterID] then
        for i = 1, #characterDatas, 1 do
            local j = characterDatas[i]
            CCharacter.CBuffer[characterID][(j[1])] = j[2]
        end
    end
    return result
end

CCharacter.getData = function(characterID, characterDatas)
    if not imports.assetify.thread:getThread() then return false end
    local result = imports.dbify.module.character.getData(characterID, characterDatas)
    if result and CCharacter.CBuffer[characterID] then
        for i = 1, #characterDatas, 1 do
            local j = characterDatas[i]
            CCharacter.CBuffer[characterID][j] = result[j]
        end
    end
    return result
end