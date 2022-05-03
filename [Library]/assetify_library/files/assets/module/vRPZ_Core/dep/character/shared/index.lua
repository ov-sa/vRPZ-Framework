-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    getElementsByType,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation,
    getElementData = getElementData,
    setElementData = setElementData,
    math = math
}


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter = {
    getPlayer = function(characterID)
        characterID = imports.tonumber(characterID)
        if not characterID then return false end
        local players = imports.getElementsByType("player")
        for i = 1, #players, 1 do
            local j = players[i]
            if CPlayer.isInitialized(j) then
                local _characterID = imports.getElementData(j, "Character:ID")
                if _characterID == characterID then
                    return j
                end
            end
        end
        return false
    end,

    getLocation = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return {
            position = {imports.getElementPosition(player)},
            rotation = {imports.getElementRotation(player)}
        }
    end,

    generateClothing = function(characterIdentity)
        if not characterIdentity then return false end
        local clothingData, clothingTextures = {
            gender = FRAMEWORK_CONFIGS["Character"]["Identity"]["Gender"][(characterIdentity.gender)],
            hair = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Facial"]["Hair"][(characterIdentity.gender)][(characterIdentity.hair)],
            face = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Facial"]["Face"][(characterIdentity.gender)][(characterIdentity.face)],
            upper = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Upper"][(characterIdentity.gender)][(characterIdentity.upper)],
            lower = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Lower"][(characterIdentity.gender)][(characterIdentity.lower)],
            shoes = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Shoes"][(characterIdentity.gender)][(characterIdentity.shoes)]
        }, {}
        if clothingData.hair.clumpTexture then
            clothingTextures[(clothingData.hair.clumpTexture[1])] = clothingData.hair.clumpTexture[2]
        end
        if clothingData.face.clumpTexture then
            clothingTextures[(clothingData.face.clumpTexture[1])] = clothingData.face.clumpTexture[2]
        end
        if clothingData.upper.clumpTexture then
            clothingTextures[(clothingData.upper.clumpTexture[1])] = clothingData.upper.clumpTexture[2]
        end
        if clothingData.lower.clumpTexture then
            clothingTextures[(clothingData.lower.clumpTexture[1])] = clothingData.lower.clumpTexture[2]
        end
        if clothingData.shoes.clumpTexture then
            clothingTextures[(clothingData.shoes.clumpTexture[1])] = clothingData.shoes.clumpTexture[2]
        end
        return clothingData.gender.assetName, (clothingData.hair.clumpName or "")..(clothingData.face.clumpName or "")..(clothingData.upper.clumpName or "")..(clothingData.lower.clumpName or "")..(clothingData.shoes.clumpName or ""), clothingTextures
    end,

    setHealth = function(player, amount)
        amount = imports.tonumber(amount)
        if not CPlayer.isInitialized(player) or not amount then return false end
        return imports.setElementData(player, "Character:Data:blood", imports.math.max(0, imports.math.min(amount, CCharacter.getMaxHealth(player))))
    end,

    getHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(imports.getElementData(player, "Character:Data:blood")) or 0
    end,

    getMaxHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return FRAMEWORK_CONFIGS["Game"]["Character"]["Max_Blood"]
    end,

    getLevel = function(player, fetchEXP)
        if not CPlayer.isInitialized(player) then return false end
        local characterLevel = imports.math.max(1, imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"], imports.tonumber(imports.getElementData(player, "Character:Data:level")) or 0))
        if not fetchEXP then
            return characterLevel
        else
            return characterLevel, imports.math.max(1, imports.math.min(CGame.getLevelEXP(characterLevel), imports.tonumber(imports.getElementData(player, "Character:Data:experience")) or 0))
        end
    end,

    getRank = function(player)
        local characterLevel = CCharacter.getLevel(player)
        if not characterLevel then return false end
        return CGame.getLevelRank(characterLevel)
    end,

    giveEXP = function(player, experience)
        experience = imports.tonumber(experience)
        if not experience then return false end
        local characterLevel, characterEXP = CCharacter.getLevel(player, true)
        if not characterLevel or not characterEXP then return false end
        characterEXP = characterEXP + experience
        local __characterLevel, __characterEXP = characterLevel, CGame.getLevelEXP(characterLevel)
        while (__characterEXP and (characterEXP > __characterEXP) and (characterLevel < FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"]) and (__characterLevel <= FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"])) do
            characterEXP = characterEXP - __characterEXP
            __characterLevel = __characterLevel + 1
            __characterEXP = CGame.getLevelEXP(__characterLevel)
        end
        __characterLevel = imports.math.max(1, imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"], __characterLevel))
        if __characterLevel ~= characterLevel then
            characterLevel = __characterLevel
            characterEXP = imports.math.min(CGame.getLevelEXP(characterLevel), characterEXP)
            imports.setElementData(player, "Character:Data:level", characterLevel)
            imports.setElementData(player, "Character:Data:experience", characterEXP)
        end
        return true
    end,

    getReputation = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Reputations"]["Max_Reputation"], imports.tonumber(imports.getElementData(player, "Character:Data:reputation")) or 0)
    end,

    giveReputation = function(player, reputation)
        reputation = imports.tonumber(reputation)
        if not reputation then return false end
        local characterReputation = CCharacter.getReputation(player)
        if not characterReputation then return false end
        local __characterReputation = imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Reputations"]["Max_Reputation"], characterReputation + reputation)
        if __characterReputation ~= characterReputation then
            characterReputation = __characterReputation
            imports.setElementData(player, "Character:Data:reputation", characterReputation)
        end
        return true
    end,

    getFaction = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getElementData(player, "Character:Data:faction") or false
    end,

    getGroup = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getElementData(player, "Character:Data:group") or false
    end,

    setMoney = function(player, amount)
        money = imports.tonumber(money)
        if not CPlayer.isInitialized(player) or not money then return false end
        return imports.setElementData(player, "Character:Data:money", imports.math.max(0, money))
    end,

    getMoney = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(imports.getElementData(player, "Character:Data:money")) or 0
    end,

    isKnocked = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getElementData(player, "Character:Knocked") or false
    end,

    isReloading = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getElementData(player, "Character:Reloading") or false
    end,

    isInLoot = function(player)
        if not CPlayer.isInitialized(player) then return false end
        if imports.getElementData(player, "Character:Looting") then
            local marker = imports.getElementData(player, "Loot:Marker")
            if marker and imports.isElement(marker) then
                return marker
            end
        end
        return false
    end
}