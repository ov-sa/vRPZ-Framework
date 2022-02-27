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
    tocolor = tocolor,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    vignette = {
        bgTexture = imports.beautify.native.createTexture("files/images/hud/overlays/vignette.png", "dxt5", true, "clamp"), bgColor = imports.tocolor(0, 0, 0, 255)
    },

    startX = 5, startY = 50,
    smallSlotWidth = 70,
    bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG1.png", "dxt5", true, "clamp"),
    bgColor = tocolor(125, 125, 125, 150),
    primary = {
        width = 175, height = 53,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG1.png", "dxt5", true, "clamp"),
    },
    secondary = {
        width = 100*0.75,
        height = 50*0.75,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG2.png", "dxt5", true, "clamp")
    },

}
cache.startX, cache.startY = CLIENT_MTA_RESOLUTION[1] - (cache.startX + cache.primary.width), CLIENT_MTA_RESOLUTION[2] - (cache.startY + cache.primary.height)


--------------------------------
--[[ Functions: Renders HUD ]]--
--------------------------------

beautify.render.create(function()
    if not CPlayer.isInitialized(localPlayer) then return false end
    imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], cache.vignette.bgTexture, 0, 0, 0, cache.vignette.bgColor, false)
end, {
    renderType = "input"
})

beautify.render.create(function()
    --TODO: DRAW HUD HERE...
    imports.beautify.native.drawImage(cache.startX, cache.startY, cache.primary.width, cache.primary.height, cache.primary.bgTexture, 0, 0, 0, cache.bgColor, false)
    imports.beautify.native.drawImage(cache.startX + cache.primary.width - cache.secondary.width, cache.startY - cache.secondary.height - 10, cache.secondary.width, cache.secondary.height, cache.secondary.bgTexture, 0, 0, 0, cache.bgColor, false)
    --imports.beautify.native.drawRectangle(cache.startX + cache.width - cache.smallSlotWidth, cache.startY, cache.smallSlotWidth, cache.height, cache.bgColor, false)
    --imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, cache.bgTexture, 0, 0, 0, -1, false)
end)