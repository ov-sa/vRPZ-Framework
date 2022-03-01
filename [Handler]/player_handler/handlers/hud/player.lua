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
    startX = 5, startY = 50, padding = 10,
    vignette = {
        bgTexture = imports.beautify.native.createTexture("files/images/hud/overlays/vignette.png", "dxt5", true, "clamp"), bgColor = imports.tocolor(0, 0, 0, 255)
    },
    primary = {
        paddingX = 5, paddingY = 0,
        width = 175, height = 53,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG1.png", "dxt5", true, "clamp"),
        ammo = {
            font = FRAMEWORK_FONTS[7], fontColor = imports.tocolor(255, 255, 255, 255),
            mag = {
                font = FRAMEWORK_FONTS[8], fontColor = imports.tocolor(150, 150, 150, 255)
            }
        }
    },
    secondary = {
        paddingX = 5, paddingY = 0,
        width = 100*0.75, height = 50*0.75,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG2.png", "dxt5", true, "clamp"),
        ammo = {
            font = FRAMEWORK_FONTS[7], fontColor = imports.tocolor(255, 255, 255, 255),
            mag = {
                font = FRAMEWORK_FONTS[8], fontColor = imports.tocolor(150, 150, 150, 255)
            }
        }
    }
}

cache.primary.startX, cache.primary.startY = CLIENT_MTA_RESOLUTION[1] - (cache.startX + cache.primary.width), CLIENT_MTA_RESOLUTION[2] - (cache.startY + cache.primary.height)
cache.secondary.startX, cache.secondary.startY = cache.primary.startX + cache.primary.width - cache.secondary.width, cache.primary.startY - cache.secondary.height - cache.padding
cache.primary.ammo.startX, cache.primary.ammo.startY = cache.primary.startX + cache.primary.paddingX, cache.primary.startY
cache.primary.ammo.endX, cache.primary.ammo.endY = cache.primary.ammo.startX, cache.primary.startY + cache.primary.height + cache.primary.paddingY
cache.primary.ammo.mag.startX, cache.primary.ammo.mag.startY = cache.primary.ammo.startX + cache.primary.paddingX, cache.primary.ammo.startY
cache.primary.ammo.mag.endX, cache.primary.ammo.mag.endY = cache.primary.ammo.mag.startX, cache.primary.ammo.endY
cache.secondary.ammo.startX, cache.secondary.ammo.startY = cache.secondary.startX + cache.secondary.paddingX, cache.secondary.startY
cache.secondary.ammo.endX, cache.secondary.ammo.endY = cache.secondary.ammo.startX, cache.secondary.startY + cache.secondary.height + cache.secondary.paddingY
cache.secondary.ammo.mag.startX, cache.secondary.ammo.mag.startY = cache.secondary.ammo.startX + cache.primary.paddingX, cache.secondary.ammo.startY
cache.secondary.ammo.mag.endX, cache.secondary.ammo.mag.endY = cache.secondary.ammo.mag.startX, cache.secondary.ammo.endY


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
    --Primary Equipment--
    imports.beautify.native.drawImage(cache.primary.startX, cache.primary.startY, cache.primary.width, cache.primary.height, cache.primary.bgTexture, 0, 0, 0, cache.bgColor, false)
    imports.beautify.native.drawText("01", cache.primary.ammo.startX, cache.primary.ammo.startY, cache.primary.ammo.endX, cache.primary.ammo.endY, cache.primary.ammo.fontColor, 1, cache.primary.ammo.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", cache.primary.ammo.mag.startX, cache.primary.ammo.mag.startY, cache.primary.ammo.mag.endX, cache.primary.ammo.mag.endY, cache.primary.ammo.mag.fontColor, 1, cache.primary.ammo.mag.font, "left", "bottom", false, false, false)
    
    --Secondary Equipment--
    imports.beautify.native.drawImage(cache.secondary.startX, cache.secondary.startY, cache.secondary.width, cache.secondary.height, cache.secondary.bgTexture, 0, 0, 0, cache.bgColor, false)
    imports.beautify.native.drawText("01", cache.secondary.ammo.startX, cache.secondary.ammo.startY, cache.secondary.ammo.endX, cache.secondary.ammo.endY, cache.secondary.ammo.fontColor, 1, cache.secondary.ammo.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", cache.secondary.ammo.mag.startX, cache.secondary.ammo.mag.startY, cache.secondary.ammo.mag.endX, cache.secondary.ammo.mag.endY, cache.secondary.ammo.mag.fontColor, 1, cache.secondary.ammo.mag.font, "left", "bottom", false, false, false)
end)