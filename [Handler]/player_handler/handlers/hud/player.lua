----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: player.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Player HUD Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tocolor = tocolor,
    addEventHandler = addEventHandler,
    beautify = beautify,
    assetify = assetify
}


CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local hudUI = {
        startX = 5, startY = 60, padding = 10,
        overlay = {
            vignette = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "overlay:vignette")
        },
        status = {
            thirst = {
                paddingX = 15, paddingY = 10,
                size = 32,
                borderTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:thirst_border"),
                iconTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:thirst_icon")
            },
            hunger = {
                paddingX = 57, paddingY = 10,
                size = 32,
                borderTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:hunger_border"),
                iconTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:hunger_icon")
            },
            blood = {
                paddingX = 99, paddingY = 10,
                size = 32,
                borderTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:blood_border"),
                iconTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "status:blood_icon")
            }
        },
        primary = {
            paddingX = 5, paddingY = 0,
            width = 175, height = 53,
            bgTexture = imports.beautify.native.createTexture("files/images/hud/status/slotBG1.png", "dxt5", true, "clamp"),
            ammo = {
                font = CGame.createFont(1, 23), fontColor = imports.tocolor(255, 255, 255, 255),
                mag = {
                    paddingX = 2,
                    font = CGame.createFont(1, 15), fontColor = imports.tocolor(150, 150, 150, 255)
                }
            }
        },
        secondary = {
            paddingX = 5, paddingY = 0,
            width = 100*0.75, height = 50*0.75,
            bgTexture = imports.beautify.native.createTexture("files/images/hud/status/slotBG2.png", "dxt5", true, "clamp"),
            ammo = {
                font = CGame.createFont(1, 23), fontColor = imports.tocolor(255, 255, 255, 255),
                mag = {
                    paddingX = 2,
                    font = CGame.createFont(1, 15), fontColor = imports.tocolor(150, 150, 150, 255)
                }
            }
        },
        party = nil
    }

    for i, j in imports.pairs(hudUI.status) do
        j.startX, j.startY = CLIENT_MTA_RESOLUTION[1] - (hudUI.startX + j.paddingX + j.size), CLIENT_MTA_RESOLUTION[2] - (hudUI.startY - j.paddingY)
        j.texWidth, j.texHeight = imports.beautify.native.getMaterialSize(j.borderTexture)
    end
    hudUI.primary.startX, hudUI.primary.startY = CLIENT_MTA_RESOLUTION[1] - (hudUI.startX + hudUI.primary.width), CLIENT_MTA_RESOLUTION[2] - (hudUI.startY + hudUI.primary.height)
    hudUI.secondary.startX, hudUI.secondary.startY = hudUI.primary.startX + hudUI.primary.width - hudUI.secondary.width, hudUI.primary.startY - hudUI.secondary.height - hudUI.padding
    hudUI.primary.ammo.startX, hudUI.primary.ammo.startY = hudUI.primary.startX + hudUI.primary.paddingX, hudUI.primary.startY
    hudUI.primary.ammo.endX, hudUI.primary.ammo.endY = hudUI.primary.ammo.startX, hudUI.primary.startY + hudUI.primary.height + hudUI.primary.paddingY
    hudUI.primary.ammo.mag.startX, hudUI.primary.ammo.mag.startY = hudUI.primary.ammo.startX + hudUI.primary.ammo.mag.paddingX, hudUI.primary.ammo.startY
    hudUI.primary.ammo.mag.endX, hudUI.primary.ammo.mag.endY = hudUI.primary.ammo.mag.startX, hudUI.primary.ammo.endY
    hudUI.secondary.ammo.startX, hudUI.secondary.ammo.startY = hudUI.secondary.startX + hudUI.secondary.paddingX, hudUI.secondary.startY
    hudUI.secondary.ammo.endX, hudUI.secondary.ammo.endY = hudUI.secondary.ammo.startX, hudUI.secondary.startY + hudUI.secondary.height + hudUI.secondary.paddingY
    hudUI.secondary.ammo.mag.startX, hudUI.secondary.ammo.mag.startY = hudUI.secondary.ammo.startX + hudUI.secondary.ammo.mag.paddingX, hudUI.secondary.ammo.startY
    hudUI.secondary.ammo.mag.endX, hudUI.secondary.ammo.mag.endY = hudUI.secondary.ammo.mag.startX, hudUI.secondary.ammo.endY


    ----------------------------------
    --[[ Functions: Party Handler ]]--
    ----------------------------------

    imports.addEventHandler("Client:onPartyUpdate", root, function(partyData)
        if partyData then
            hudUI.party = {
                startX = hudUI.primary.startX,
                endX = hudUI.primary.startX + hudUI.primary.width,
                startY = hudUI.secondary.startY + hudUI.secondary.height,
                endY = hudUI.secondary.startY + (hudUI.secondary.height * 2),
                font = CGame.createFont(1, 15),
                names = {}
            }
            for i, j in imports.pairs(partyData.members) do
                hudUI.party.names[i] = CPlayer.getName(j)
            end
        else
            if hudUI.party then
                hudUI.party = nil
                return
            end
        end
    end, true, "low")


    --------------------------------
    --[[ Functions: Renders HUD ]]--
    --------------------------------

    imports.beautify.render.create(function()
        imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], hudUI.overlay.vignette, 0, 0, 0, -1, false)
    end, {
        renderType = "input"
    })

    imports.beautify.render.create(function()
        if not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) then return false end
        --Status--
        for i, j in imports.pairs(hudUI.status) do
            local percent = 0.75
            percent = 1 - percent
            local iconSize, nativeSize = j.size*percent, j.texHeight*percent
            imports.beautify.native.drawImage(j.startX, j.startY, j.size, j.size, j.borderTexture, 0, 0, 0, -1, false)
            imports.beautify.native.drawImageSection(j.startX, j.startY + iconSize, j.size, j.size - iconSize, 0, nativeSize, j.texWidth, j.texHeight - nativeSize, j.iconTexture, 0, 0, 0, tocolor(200, 200, 200, 255), false)
        end
        --Primary Equipment--
        imports.beautify.native.drawImage(hudUI.primary.startX, hudUI.primary.startY, hudUI.primary.width, hudUI.primary.height, hudUI.primary.bgTexture, 0, 0, 0, -1, false)
        imports.beautify.native.drawText("01", hudUI.primary.ammo.startX, hudUI.primary.ammo.startY, hudUI.primary.ammo.endX, hudUI.primary.ammo.endY, hudUI.primary.ammo.fontColor, 1, hudUI.primary.ammo.font.instance, "right", "bottom", false, false, false)
        imports.beautify.native.drawText("999", hudUI.primary.ammo.mag.startX, hudUI.primary.ammo.mag.startY, hudUI.primary.ammo.mag.endX, hudUI.primary.ammo.mag.endY, hudUI.primary.ammo.mag.fontColor, 1, hudUI.primary.ammo.mag.font.instance, "left", "bottom", false, false, false)
        --Secondary Equipment--
        imports.beautify.native.drawImage(hudUI.secondary.startX, hudUI.secondary.startY, hudUI.secondary.width, hudUI.secondary.height, hudUI.secondary.bgTexture, 0, 0, 0, -1, false)
        imports.beautify.native.drawText("01", hudUI.secondary.ammo.startX, hudUI.secondary.ammo.startY, hudUI.secondary.ammo.endX, hudUI.secondary.ammo.endY, hudUI.secondary.ammo.fontColor, 1, hudUI.secondary.ammo.font.instance, "right", "bottom", false, false, false)
        imports.beautify.native.drawText("999", hudUI.secondary.ammo.mag.startX, hudUI.secondary.ammo.mag.startY, hudUI.secondary.ammo.mag.endX, hudUI.secondary.ammo.mag.endY, hudUI.secondary.ammo.mag.fontColor, 1, hudUI.secondary.ammo.mag.font.instance, "left", "bottom", false, false, false)
        --Party List--
        if hudUI.party then
            for i = #hudUI.party.names, 1, -1 do
                local j = hudUI.party.names[i]
                if not j then break end
                imports.beautify.native.drawText(j, hudUI.party.startX, hudUI.party.startY, hudUI.party.endX, hudUI.party.endY, -1, 1, hudUI.party.font.instance, "right", "center", false, false, false)
            end
        end
    end)
end)