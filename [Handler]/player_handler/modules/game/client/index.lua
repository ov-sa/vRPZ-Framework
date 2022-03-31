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
    beautify = beautify
}


----------------------
--[[ Module: Game ]]--
----------------------

CGame.CFont = {}

CGame.createFont = function(path, size)
    if CGame.CFont[path] and CGame.CFont[path][size] then return CGame.CFont[path][size] end
    local cFont = imports.beautify.native.createFont(path, size)
    if not cFont then return false end
    CGame.CFont[path] = CGame.CFont[path] or {}
    CGame.CFont[path][size] = cFont
    return CGame.CFont[path][size]
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