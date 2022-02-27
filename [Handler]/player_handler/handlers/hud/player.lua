----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: player.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player HUD Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local hudUI = {
    startX = 20, startY = 60,
    width = 325, height = 75,
    bgTexture = "texturePath",
    bgColor = tocolor(255, 255, 255, 255)
}
hudUI.startX, hudUI.startY = CLIENT_MTA_RESOLUTION[1] - (hudUI.startX + hudUI.width), CLIENT_MTA_RESOLUTION[2] - (hudUI.startY + hudUI.height)


---------------------
--[[ Renders HUD ]]--
---------------------

beautify.render.create(function()
    --TODO: DRAW HUD HERE...
    imports.beautify.native.drawRectangle(hudUI.startX, hudUI.startY, hudUI.width, hudUI.height, hudUI.bgColor, false)
end)