----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: client.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.beautify_library:fetchImports())()
local imports = {
    pairs = pairs,
    tonumber = tonumber,
    addEventHandler = addEventHandler,
    getElementType = getElementType,
    getElementsByType = getElementsByType,
    guiSetInputMode = guiSetInputMode,
    setWeather = setWeather,
    setTime = setTime,
    setBlurLevel = setBlurLevel,
    toggleControl = toggleControl,
    setCloudsEnabled = setCloudsEnabled,
    setTrafficLightState = setTrafficLightState,
    setPedTargetingMarkerEnabled = setPedTargetingMarkerEnabled,
    setPlayerHudComponentVisible = setPlayerHudComponentVisible,
    setCameraFieldOfView = setCameraFieldOfView,
    showChat = showChat,
    showCursor = showCursor,
    assetify = assetify
}
imports.assetify.scheduler.execOnModuleLoad(function()
    imports.assetify.loadModule("vRPZ_Config", {"shared", "client"})
    imports.assetify.loadModule("vRPZ_Core", {"shared", "client"})
    imports.assetify.scheduler.boot()
end)


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

function showChat(bool, isForced)
    return ((isForced or not bool or not CGame.isUIVisible()) and imports.showChat(bool)) or false
end
function showCursor(bool, isForced)
    return ((isForced or bool or not CGame.isUIVisible()) and imports.showCursor(bool)) or false
end
imports.assetify.network:create("Client:onToggleChat"):on(showChat)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

CGame.execOnModuleLoad(function()
    showChat(false, true)
    CGame.loadLanguage()
    imports.setBlurLevel(0)
    imports.toggleControl("fire", true)
    imports.toggleControl("action", false)
    imports.toggleControl("radar", false)
    imports.setCloudsEnabled(false)
    imports.setTrafficLightState("disabled")
    imports.setPedTargetingMarkerEnabled(false)
    imports.setPlayerHudComponentVisible("all", false)
    imports.setPlayerHudComponentVisible("crosshair", true)
    for i = 1, #FRAMEWORK_CONFIGS["Weapons"].clearModels, 1 do
        imports.assetify.clearModel(FRAMEWORK_CONFIGS["Weapons"].clearModels[i])
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Game"]["Camera_FOV"]) do
        imports.setCameraFieldOfView(i, j)
    end

    imports.addEventHandler("onClientGUIClick", root, function()
        local guiElement = imports.getElementType(source)
        if ((guiElement == "gui-edit") or (guiElement == "gui-memo")) then
            imports.guiSetInputMode("no_binds_when_editing")
        else
            imports.guiSetInputMode("allow_binds")
        end
    end)
    imports.assetify.network:create("Client:onSyncWeather"):on(function(serverWeather, serverTime)
        serverWeather = imports.tonumber(serverWeather)
        if not serverWeather or not serverTime then return false end
        imports.setWeather(serverWeather)
        imports.setTime(serverTime[1], serverTime[2])
        return true
    end)

    CGame.execOnLoad(function()
        local serverPlayers = imports.getElementsByType("player")
        for i = 1, #serverPlayers, 1 do
            CGame.loadAnim(serverPlayers[i], "Character")
        end
        imports.addEventHandler("onClientPlayerJoin", root, function()
            CGame.loadAnim(source, "Character")
        end)
    end)
end)
