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

local imports = {}


----------------
--[[ Module ]]--
----------------

CGame = {
    isUIVisible = function()
        local uiStates = {
            not isPlayerInitialized(localPlayer),
            isLoginUIVisible()
        }
        local state = true
        for i = 1, #uiStates, 1 do
            local j = uiStates[i]
            if j then
                state = false
                break
            end
        end
        return state
    end
}