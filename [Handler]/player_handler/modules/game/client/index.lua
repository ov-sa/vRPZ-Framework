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
    pairs = pairs,
    tonumber = tonumber,
    destroyElement = destroyElement,
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
    if CGame.CFont[index] and CGame.CFont[index][size] then return CGame.CFont[index][size] end
    local cFont = imports.beautify.native.createFont(cPath, cSize)
    if not cFont then return false end
    CGame.CFont[index] = CGame.CFont[index] or {}
    CGame.CFont[index][size] = {instance = cFont}
    return CGame.CFont[index][size]
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
imports.addEventHandler("Client:onUpdateLanguage", root, function(prevLanguage, currLanguage)
    for i, j in imports.pairs(CGame.CFont) do
        for k, v in imports.pairs(j) do
            local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][i]
            if cData.alt then
                local cSettings = cData.alt[currLanguage]
                if cData.alt[prevLanguage] or cSettings then
                    local cPath, cSize = (cSettings and cSettings[1]) or cData.path, (cSettings and cSettings[2] and (cSettings[2]*k)) or k
                    local cFont = imports.beautify.native.createFont(cPath, cSize)
                    if cFont then
                        local __cFont = v.instance
                        v.instance = cFont
                        imports.destroyElement(__cFont)
                    end
                end
            end
        end
    end
end)
