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
    pairs = pairs,
    tocolor = tocolor,
    getPlayerName = getPlayerName,
    addEventHandler = addEventHandler,
    dxGetMaterialSize = dxGetMaterialSize,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    startX = 5, startY = 60, padding = 10,
    vignette = {
        bgTexture = imports.beautify.native.createTexture("files/images/hud/overlays/vignette.rw", "dxt5", true, "clamp"), bgColor = imports.tocolor(0, 0, 0, 255)
    },
    status = {
        thirst = {
            paddingX = 15, paddingY = 10,
            size = 32,
            borderTexture = imports.beautify.native.createTexture("files/images/hud/player/thirst/border.rw", "dxt5", true, "clamp"),
            iconTexture = imports.beautify.native.createTexture("files/images/hud/player/thirst/icon.rw", "dxt5", true, "clamp")
        },
        hunger = {
            paddingX = 57, paddingY = 10,
            size = 32,
            borderTexture = imports.beautify.native.createTexture("files/images/hud/player/hunger/border.rw", "dxt5", true, "clamp"),
            iconTexture = imports.beautify.native.createTexture("files/images/hud/player/hunger/icon.rw", "dxt5", true, "clamp")
        },
        blood = {
            paddingX = 99, paddingY = 10,
            size = 32,
            borderTexture = imports.beautify.native.createTexture("files/images/hud/player/blood/border.rw", "dxt5", true, "clamp"),
            iconTexture = imports.beautify.native.createTexture("files/images/hud/player/blood/icon.rw", "dxt5", true, "clamp")
        }
    },
    primary = {
        paddingX = 5, paddingY = 0,
        width = 175, height = 53,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG1.png", "dxt5", true, "clamp"),
        ammo = {
            font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 23), fontColor = imports.tocolor(255, 255, 255, 255),
            mag = {
                paddingX = 2,
                font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 15), fontColor = imports.tocolor(150, 150, 150, 255)
            }
        }
    },
    secondary = {
        paddingX = 5, paddingY = 0,
        width = 100*0.75, height = 50*0.75,
        bgTexture = imports.beautify.native.createTexture("files/images/hud/player/slotBG2.png", "dxt5", true, "clamp"),
        ammo = {
            font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 23), fontColor = imports.tocolor(255, 255, 255, 255),
            mag = {
                paddingX = 2,
                font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 15), fontColor = imports.tocolor(150, 150, 150, 255)
            }
        }
    },
    party = nil
}

for i, j in imports.pairs(cache.status) do
    j.startX, j.startY = CLIENT_MTA_RESOLUTION[1] - (cache.startX + j.paddingX + j.size), CLIENT_MTA_RESOLUTION[2] - (cache.startY - j.paddingY)
    j.texWidth, j.texHeight = imports.beautify.native.getMaterialSize(j.borderTexture)
end
cache.primary.startX, cache.primary.startY = CLIENT_MTA_RESOLUTION[1] - (cache.startX + cache.primary.width), CLIENT_MTA_RESOLUTION[2] - (cache.startY + cache.primary.height)
cache.secondary.startX, cache.secondary.startY = cache.primary.startX + cache.primary.width - cache.secondary.width, cache.primary.startY - cache.secondary.height - cache.padding
cache.primary.ammo.startX, cache.primary.ammo.startY = cache.primary.startX + cache.primary.paddingX, cache.primary.startY
cache.primary.ammo.endX, cache.primary.ammo.endY = cache.primary.ammo.startX, cache.primary.startY + cache.primary.height + cache.primary.paddingY
cache.primary.ammo.mag.startX, cache.primary.ammo.mag.startY = cache.primary.ammo.startX + cache.primary.ammo.mag.paddingX, cache.primary.ammo.startY
cache.primary.ammo.mag.endX, cache.primary.ammo.mag.endY = cache.primary.ammo.mag.startX, cache.primary.ammo.endY
cache.secondary.ammo.startX, cache.secondary.ammo.startY = cache.secondary.startX + cache.secondary.paddingX, cache.secondary.startY
cache.secondary.ammo.endX, cache.secondary.ammo.endY = cache.secondary.ammo.startX, cache.secondary.startY + cache.secondary.height + cache.secondary.paddingY
cache.secondary.ammo.mag.startX, cache.secondary.ammo.mag.startY = cache.secondary.ammo.startX + cache.secondary.ammo.mag.paddingX, cache.secondary.ammo.startY
cache.secondary.ammo.mag.endX, cache.secondary.ammo.mag.endY = cache.secondary.ammo.mag.startX, cache.secondary.ammo.endY


----------------------------------
--[[ Functions: Party Handler ]]--
----------------------------------


imports.addEventHandler("Client:onPartyUpdate", localPlayer, function(partyData)
    if partyData then
        cache.party = {
            startX = cache.primary.startX,
            endX = cache.primary.startX + cache.primary.width,
            startY = cache.secondary.startY + cache.secondary.height,
            endY = cache.secondary.startY + (cache.secondary.height * 2),
            font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 15),
            names = {}
        }
        for i, j in imports.pairs(partyData.members) do
            cache.party.names[i] = imports.getPlayerName(j)
        end
    else
        if cache.party then
            cache.party = nil
            return
        end
    end
end)


--------------------------------
--[[ Functions: Renders HUD ]]--
--------------------------------

beautify.render.create(function()
    if not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) then return false end
    imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], cache.vignette.bgTexture, 0, 0, 0, cache.vignette.bgColor, false)
end, {
    renderType = "input"
})

beautify.render.create(function()
    if not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) then return false end
    --Status--
    for i, j in imports.pairs(cache.status) do
        local percent = 0.75
        percent = 1 - percent
        local iconSize, nativeSize = j.size*percent, j.texHeight*percent
        imports.beautify.native.drawImage(j.startX, j.startY, j.size, j.size, j.borderTexture, 0, 0, 0, -1, false)
        imports.beautify.native.drawImageSection(j.startX, j.startY + iconSize, j.size, j.size - iconSize, 0, nativeSize, j.texWidth, j.texHeight - nativeSize, j.iconTexture, 0, 0, 0, tocolor(200, 200, 200, 255), false)
    end
    --Primary Equipment--
    imports.beautify.native.drawImage(cache.primary.startX, cache.primary.startY, cache.primary.width, cache.primary.height, cache.primary.bgTexture, 0, 0, 0, -1, false)
    imports.beautify.native.drawText("01", cache.primary.ammo.startX, cache.primary.ammo.startY, cache.primary.ammo.endX, cache.primary.ammo.endY, cache.primary.ammo.fontColor, 1, cache.primary.ammo.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", cache.primary.ammo.mag.startX, cache.primary.ammo.mag.startY, cache.primary.ammo.mag.endX, cache.primary.ammo.mag.endY, cache.primary.ammo.mag.fontColor, 1, cache.primary.ammo.mag.font, "left", "bottom", false, false, false)
    --Secondary Equipment--
    imports.beautify.native.drawImage(cache.secondary.startX, cache.secondary.startY, cache.secondary.width, cache.secondary.height, cache.secondary.bgTexture, 0, 0, 0, -1, false)
    imports.beautify.native.drawText("01", cache.secondary.ammo.startX, cache.secondary.ammo.startY, cache.secondary.ammo.endX, cache.secondary.ammo.endY, cache.secondary.ammo.fontColor, 1, cache.secondary.ammo.font, "right", "bottom", false, false, false)
    imports.beautify.native.drawText("999", cache.secondary.ammo.mag.startX, cache.secondary.ammo.mag.startY, cache.secondary.ammo.mag.endX, cache.secondary.ammo.mag.endY, cache.secondary.ammo.mag.fontColor, 1, cache.secondary.ammo.mag.font, "left", "bottom", false, false, false)
    --Party List--
    if cache.party then
        for i = #cache.party.names, 1, -1 do
            local j = cache.party.names[i]
            if not j then break end
            imports.beautify.native.drawText(j, cache.party.startX, cache.party.startY, cache.party.endX, cache.party.endY, -1, 1, cache.party.font, "right", "center", false, false, false)
        end
    end
end)