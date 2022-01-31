----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: settings: shared.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

--[[
serverFPSLimit = exports.config_loader:getConfig("server_fpsLimit")
serverDrawDistanceLimit = exports.config_loader:getConfig("server_drawDistanceLimit")
serverFogDistanceLimit = exports.config_loader:getConfig("server_fogDistanceLimit")
serverGameType = exports.config_loader:getConfig("server_gameType")
serverMapName = exports.config_loader:getConfig("server_mapName")
serverWaterLevel = exports.config_loader:getConfig("server_waterLevel")
serverAircraftMaxHeight = exports.config_loader:getConfig("server_aircraftMaxHeight")
serverJetpackMaxHeight = exports.config_loader:getConfig("server_jetpackMaxHeight")
serverMinuteDuration = exports.config_loader:getConfig("server_minuteDuration")
serverLogoutCoolDownDuration = exports.config_loader:getConfig("server_logoutCoolDownDuration")
serverDisabledCMDs = exports.config_loader:getConfig("server_disabledCMDs")
serverWeaponFakeAmmoAmount = exports.config_loader:getConfig("server_weaponFakeAmmoAmount")
serverWaterTemperature = exports.config_loader:getConfig("server_waterTemperature")
serverSprintTemperature = exports.config_loader:getConfig("server_sprintTemperature")
serverRoleplayCursorBindKey = exports.config_loader:getConfig("server_roleplayCursorBindKey")
serverNPCInteractionRange = exports.config_loader:getConfig("server_npcInteractionRange")
serverVehicleInteractionRange = exports.config_loader:getConfig("server_vehicleInteractionRange")
serverPickupInteractionRange = exports.config_loader:getConfig("server_pickupInteractionRange")
serverWeather = exports.config_loader:getConfig("server_weather")

lobbyDatas = exports.config_loader:getConfig("lobby_datas")
taskDatas = exports.config_loader:getConfig("task_datas")
factionDatas = exports.config_loader:getConfig("faction_datas")
inventoryDatas = exports.config_loader:getConfig("inventory_datas")
maximumInventorySlots = exports.config_loader:getConfig("inventory_maxSlots")

playerCharacterLimit = exports.config_loader:getConfig("player_characterLimit")
playerRaces = exports.config_loader:getConfig("player_races")
playerModels = exports.config_loader:getConfig("player_models")
playerOccupations = exports.config_loader:getConfig("player_occupations")
characterSlots = exports.config_loader:getConfig("character_slots")
playerDatas = exports.config_loader:getConfig("player_datas")
characterDatas = exports.config_loader:getConfig("character_datas")
playerSpawnPoints = exports.config_loader:getConfig("player_spawnpoints")
characterMaximumBlood = exports.config_loader:getConfig("character_maxBlood")
characterBloodGroups = exports.config_loader:getConfig("character_bloodGroup")
playerDefaultDamage = exports.config_loader:getConfig("player_defaultDamage")
playerWaterDamage = exports.config_loader:getConfig("player_waterDamage")
playerExplosionDamage = exports.config_loader:getConfig("player_explosionDamage")
playerRanoverDamage = exports.config_loader:getConfig("player_ranoverDamage")
playerFallDamage = exports.config_loader:getConfig("player_fallDamage")
playerRamDamage = exports.config_loader:getConfig("player_ramDamage")
playerWeaponReloadDelayDuration = exports.config_loader:getConfig("player_weaponReloadDelayDuration")
playerknockDownHealthPercent = exports.config_loader:getConfig("player_knockDownHealthPercent")
playerknockDownDuration = exports.config_loader:getConfig("player_knockDownDuration")
playerDeadLootDuration = exports.config_loader:getConfig("player_deadLootExpireDuration")

occupationDutyModeCMD = exports.config_loader:getConfig("occupation_dutyModeCMD")
availableOccupationNPCs = exports.config_loader:getConfig("occupation_npcs")
availableWeaponSlots = exports.config_loader:getConfig("weapon_slots")
availableVehicleComponents = exports.config_loader:getConfig("vehicle_components")
weaponOffsets = exports.config_loader:getConfig("weapon_offsets")
backpackOffsets = exports.config_loader:getConfig("backpack_offsets")
]]--