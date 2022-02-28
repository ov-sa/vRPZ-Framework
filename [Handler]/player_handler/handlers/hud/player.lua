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
        paddingX = 5, paddingY = 0,
        width = 175, height = 53,
        font = FRAMEWORK_FONTS[7], fontColor = imports.tocolor(255, 255, 255, 255),
        altfont = FRAMEWORK_FONTS[8], altfontColor = imports.tocolor(150, 150, 150, 255),
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG1.png", "dxt5", true, "clamp"),
    },
    secondary = {
        paddingX = 5, paddingY = 0,
        width = 100*0.75,
        height = 50*0.75,
        font = FRAMEWORK_FONTS[7], fontColor = imports.tocolor(255, 255, 255, 255),
        altfont = FRAMEWORK_FONTS[8], altfontColor = imports.tocolor(150, 150, 150, 255),
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
    imports.beautify.native.drawText("01", cache.startX, cache.startY, cache.startX + cache.primary.paddingX, cache.startY + cache.primary.height + cache.primary.paddingY, cache.primary.fontColor, 1, cache.primary.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", cache.startX + (cache.primary.paddingX*2), cache.startY, cache.startX + (cache.primary.paddingX*2), cache.startY + cache.primary.height + cache.primary.paddingY, cache.primary.altfontColor, 1, cache.primary.altfont, "left", "bottom", false, false, false)

    local startX, startY = cache.startX + cache.primary.width - cache.secondary.width, cache.startY - cache.secondary.height - 10
    local width, height = cache.secondary.width, cache.secondary.height
    imports.beautify.native.drawImage(startX, startY, width, height, cache.secondary.bgTexture, 0, 0, 0, cache.bgColor, false)
    imports.beautify.native.drawText("01", startX, startY, startX + cache.primary.paddingX, startY + height + cache.secondary.paddingY, cache.secondary.fontColor, 1, cache.secondary.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", startX + (cache.primary.paddingX*2), startY, startX + (cache.primary.paddingX*2), startY + height + cache.primary.paddingY, cache.primary.altfontColor, 1, cache.primary.altfont, "left", "bottom", false, false, false)

    --imports.beautify.native.drawRectangle(cache.startX + cache.width - cache.smallSlotWidth, cache.startY, cache.smallSlotWidth, cache.height, cache.bgColor, false)
    --imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, cache.bgTexture, 0, 0, 0, -1, false)
end)