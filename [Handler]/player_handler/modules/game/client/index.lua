----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: client: index.lua
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
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    beautify = beautify
}


----------------------
--[[ Module: Game ]]--
----------------------

CGame.CFont = {}

CGame.createFont = function(index, size)
    if not index or not size then return false end
    local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][index]
    if not cData then return false end
    local cLanguage = CPlayer.getLanguage()
    local cSettings = cData.alt and cData.alt[cLanguage]
    local cPath, cSize = (cSettings and cSettings[1]) or cData.path, (cSettings and cSettings[2] and (cSettings[2]*size)) or size
    if CGame.CFont[cPath] and CGame.CFont[cPath][cSize] then return CGame.CFont[cPath][cSize] end
    local cFont = imports.beautify.native.createFont(cPath, cSize)
    if not cFont then return false end
    CGame.CFont[index] = CGame.CFont[index] or {}
    CGame.CFont[index][cSize] = {instance = cFont}
    return CGame.CFont[index][cSize]
end

CGame.isUIVisible = function()
    local uiStates = {
        not isPlayerInitialized(localPlayer),
        isLoginUIVisible(),
        isInventoryUIVisible(),
        isScoreboardUIVisible()
    }
    local state = false
    for i = 1, #uiStates, 1 do
        local j = uiStates[i]
        if j then
            state = true
            break
        end
    end
    return state
end

imports.addEvent("Client:onUpdateLanguage", false)
imports.addEventHandler("Client:onUpdateLanguage", root, function(language)
    print("UPDATED LANGUAGE: "..language)
end)
