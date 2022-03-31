----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: scoreboard.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Scoreboard UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    unpackColor = unpackColor,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    math = math,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local scoreboardUI = {
    animStatus = "backward",
    width = 300, height = 200
}

scoreboardUI.startX = scoreboardUI.startX + ((CLIENT_MTA_RESOLUTION[1] - scoreboardUI.width)*0.5)
scoreboardUI.startY = scoreboardUI.startY + ((CLIENT_MTA_RESOLUTION[2] - scoreboardUI.height)*0.5)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

scoreboardUI.renderUI = function()

end


------------------------------
--[[ Function: Toggles UI ]]--
------------------------------

scoreboardUI.toggleUI = function()

end