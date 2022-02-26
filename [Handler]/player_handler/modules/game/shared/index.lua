----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Game Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementsByType = getElementsByType,
    getElementData = getElementData,
    getWeather = getWeather,
    getTime = getTime,
    math = math,
    string = string
}


----------------
--[[ Module ]]--
----------------

CGame = {
    CTickSyncer = nil,

    getServerTick = function()
        local currentTick = 0
        if not CGame.CTickSyncer or not imports.isElement(CGame.CTickSyncer) then
            local tickSyncer = imports.getElementsByType("Server:TickSyncer", resourceRoot)
            CGame.CTickSyncer = tickSyncer[1]
        end
        if CGame.CTickSyncer and imports.isElement(CGame.CTickSyncer) then
            currentTick = imports.tonumber(imports.getElementData(CGame.CTickSyncer, "Server:TickSyncer")) or 0
        end
        return currentTick
    end,

    getNativeWeather = function()
        return imports.getWeather(), {imports.getTime()}
    end,

    getTime = function()
        local time = {imports.getTime()}
        return imports.string.format("%02d:%02d", time[1], time[2])
    end,

    formatMS = function(milliseconds)
        milliseconds = imports.tonumber(milliseconds)
        if not milliseconds then return false end
        local totalseconds = imports.math.floor(milliseconds/1000)
        local seconds = totalseconds%60
        local minutes = imports.math.floor(totalseconds/60)
        local hours = imports.math.floor(minutes/60)
        minutes = minutes%60
        return imports.string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end,

    generateSpawn = function()
        local point = FRAMEWORK_CONFIGS["Spawns"][(imports.math.random(1, #FRAMEWORK_CONFIGS["Spawns"]))]
        return {
            position = {point.x, point.y, point.z},
            rotation = {0, 0, imports.math.random(0, 360)}
        }
    end,
}