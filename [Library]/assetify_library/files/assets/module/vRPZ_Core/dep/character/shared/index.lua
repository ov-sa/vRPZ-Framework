-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    getElementsByType,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation,
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
                local _characterID = CPlayer.getCharacterID(j)
                if _characterID == characterID then
                    return j
                end
            end
        end
        return false
    end,

    getIdentity = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CGame.getEntityData(player, "Character:Identity")
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
        return CGame.setEntityData(player, "Character:Data:blood", imports.math.max(0, imports.math.min(amount, CCharacter.getMaxHealth(player))))
    end,

    getHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:Data:blood")) or 0
    end,

    getMaxHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return FRAMEWORK_CONFIGS["Game"]["Character"]["Max_Blood"]
    end,

    getLevel = function(player, fetchEXP)
        if not CPlayer.isInitialized(player) then return false end
        local characterLevel = imports.math.max(1, imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"], imports.tonumber(CGame.getEntityData(player, "Character:Data:level")) or 0))
        if not fetchEXP then
            return characterLevel
        else
            return characterLevel, imports.math.max(1, imports.math.min(CGame.getLevelEXP(characterLevel), imports.tonumber(CGame.getEntityData(player, "Character:Data:experience")) or 0))
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
        local genLevel, genLevelEXP = characterLevel, CGame.getLevelEXP(characterLevel)
        while(genLevelEXP and (characterEXP > genLevelEXP) and (characterLevel < FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"]) and (genLevel <= FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"])) do
            characterEXP = characterEXP - genLevelEXP
            genLevel = genLevel + 1
            genLevelEXP = CGame.getLevelEXP(genLevel)
        end
        genLevel = imports.math.max(1, imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"], genLevel))
        characterEXP = imports.math.min(CGame.getLevelEXP(genLevel), characterEXP)
        if characterLevel ~= genLevel then
            CGame.setEntityData(player, "Character:Data:level", genLevel)
        end
        CGame.setEntityData(player, "Character:Data:experience", characterEXP)
        return true
    end,

    getReputation = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Reputations"]["Max_Reputation"], imports.tonumber(CGame.getEntityData(player, "Character:Data:reputation")) or 0)
    end,

    giveReputation = function(player, reputation)
        reputation = imports.tonumber(reputation)
        if not reputation then return false end
        local characterReputation = CCharacter.getReputation(player)
        if not characterReputation then return false end
        local genReputation = imports.math.min(FRAMEWORK_CONFIGS["Templates"]["Reputations"]["Max_Reputation"], characterReputation + reputation)
        if characterReputation ~= genReputation then
            characterReputation = genReputation
            CGame.setEntityData(player, "Character:Data:reputation", characterReputation)
        end
        return true
    end,

    getKills = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:Data:kills")) or 0
    end,

    giveKills = function(player, kills)
        kills = imports.tonumber(kills)
        if not kills then return false end
        local characterKills = CCharacter.getKills(player)
        if not characterKills then return false end
        CGame.setEntityData(player, "Character:Data:kills", characterKills + kills)
        return true
    end,

    getDeaths = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:Data:deaths")) or 0
    end,

    giveDeaths = function(player, deaths)
        deaths = imports.tonumber(deaths)
        if not deaths then return false end
        local characterDeaths = CCharacter.getKills(player)
        if not characterDeaths then return false end
        CGame.setEntityData(player, "Character:Data:deaths", characterDeaths + deaths)
        return true
    end,

    getKD = function(player)
        local characterKills, characterDeaths = CCharacter.getKills(player), CCharacter.getDeaths(player)
        if not characterKills or not characterDeaths then return false end
        return characterKills/imports.math.max(1, characterDeaths)
    end,

    getSurvivalTime = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:Data:survival_time")) or 0
    end,

    giveSurvivalTime = function(player, time)
        time = imports.tonumber(time)
        if not time then return false end
        local characterSurvivalTime = CCharacter.getSurvivalTime(player)
        if not characterSurvivalTime then return false end
        CGame.setEntityData(player, "Character:Data:survival_time", characterSurvivalTime + time)
    end,

    getFaction = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CGame.getEntityData(player, "Character:Data:faction") or false
    end,

    getGroup = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CGame.getEntityData(player, "Character:Data:group") or false
    end,

    setMoney = function(player, amount)
        money = imports.tonumber(money)
        if not CPlayer.isInitialized(player) or not money then return false end
        return CGame.setEntityData(player, "Character:Data:money", imports.math.max(0, money))
    end,

    getMoney = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:Data:money")) or 0
    end,

    isKnocked = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CGame.getEntityData(player, "Character:Knocked") or false
    end,

    isReloading = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CGame.getEntityData(player, "Character:Reloading") or false
    end,

    isInLoot = function(player)
        if not CPlayer.isInitialized(player) then return false end
        if CGame.getEntityData(player, "Character:Looting") then
            local marker = CGame.getEntityData(player, "Loot:Marker")
            if marker and imports.isElement(marker) then
                return marker
            end
        end
        return false
    end
}