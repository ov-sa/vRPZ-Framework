----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: nametag.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Nametag HUD Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    camera = getCamera(),
    collectgarbage = collectgarbage,
    isElement = isElement,
    destroyElement = destroyElement,
    getElementPosition = getElementPosition,
    getScreenFromWorldPosition = getScreenFromWorldPosition,
    interpolateBetween = interpolateBetween,
    beautify = beautify
}

CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local nametagUI = {
        buffer = {},
        padding = 5, iconSize = 20,
        clipRange = {4, 6},
        font = CGame.createFont(1, 15, true),
        fontColor = tocolor(150, 150, 150, 250)
    }
    
    local roleIcon = assetify.getAssetDep("module", "vRPZ_HUD", "texture", "role:developer")
    local rtWidth, rtHeight = 300, 500
    
    nametagUI.createTag = function(player)
        if not player or nametagUI.buffer[player] then return false end
        nametagUI.createBuffer(player)
        nametagUI.updateTag(player)
        return true
    end
    
    nametagUI.updateTag = function(player)
        if not player or not nametagUI.buffer[player] then return false end
        local playerID = 0
        local playerName = getPlayerName(player)
        local playerGroup = "Aviation"
        local playerRank = "Survivor"
        local playerLevel = 200
        local nameTag = "["..playerID.."]  ━  "..((playerGroup and ""..playerGroup.." |") or "").."  "..playerName
        local rankTag = playerRank.." - "..playerLevel
        --Drawing
        imports.beautify.native.setRenderTarget(nametagUI.buffer[player].rt, true)
        local startX, startY = rtWidth*0.5 + (nametagUI.iconSize*0.5), 0
        local rankZ = startY + nametagUI.iconSize + (nametagUI.padding*0.5)
        local nametagWidth, ranktagWidth = imports.beautify.native.getTextWidth(nameTag, 1, nametagUI.font.instance), imports.beautify.native.getTextWidth(rankTag, 1, nametagUI.font.instance)
        imports.beautify.native.drawText(nameTag, startX, startY, startX, startY, nametagUI.fontColor, 1, nametagUI.font.instance, "center", "top")
        imports.beautify.native.drawText(rankTag, startX, rankZ, startX, rankZ, nametagUI.fontColor, 1, nametagUI.font.instance, "center", "top")
        --Reputation Icon
        imports.beautify.native.drawImage(startX - (nametagWidth*0.5) - nametagUI.iconSize - nametagUI.padding, startY, nametagUI.iconSize, nametagUI.iconSize, roleIcon, 0, 0, 0, -1)
        --Level Icon
        imports.beautify.native.drawImage(startX - (ranktagWidth*0.5) - nametagUI.iconSize - nametagUI.padding, rankZ, nametagUI.iconSize, nametagUI.iconSize, roleIcon, 0, 0, 0, -1)
        imports.beautify.native.setRenderTarget()
        return true
    end
    
    nametagUI.createBuffer = function(player)
        if not player or nametagUI.buffer[player] then return false end
        nametagUI.buffer[player] = {
            rt = imports.beautify.native.createRenderTarget(300, 500, true),
            shader = imports.beautify.native.createShader("fx/nametag.fx")
        }
        imports.beautify.native.setShaderValue(nametagUI.buffer[player].shader, "baseTexture", nametagUI.buffer[player].rt)
        return true
    end
    
    nametagUI.destroyBuffer = function(player)
        if not nametagUI.buffer[player] then return false end
        if imports.isElement(nametagUI.buffer[player].rt) then
            imports.destroyElement(nametagUI.buffer[player].rt)
        end
        if imports.isElement(nametagUI.buffer[player].shader) then
            imports.destroyElement(nametagUI.buffer[player].shader)
        end
        nametagUI.buffer[player] = nil
        imports.collectgarbage()
        return true
    end


    -------------------------------
    --[[ Function: Renders HUD ]]--
    -------------------------------

    imports.beautify.render.create(function()
        if not CPlayer.isInitialized(localPlayer) then return false end --TODO: REMOVE & ENABLE LATER
        --if not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) then return false end
        local serverPlayers = getElementsByType("player")
        local cameraX, cameraY, cameraZ = imports.getElementPosition(imports.camera)
        for k, v in ipairs(serverPlayers) do
            nametagUI.createTag(v)
            if nametagUI.buffer[v] then
                local boneX, boneY, boneZ = getPedBonePosition(v, 7)
                boneZ = boneZ + 0.25
                local cameraDistance = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, boneX, boneY, boneZ)
                local nearClipDistance, farClipDistance = ((cameraDistance <= nametagUI.clipRange[2]) and (cameraDistance/nametagUI.clipRange[2])) or 1, ((cameraDistance >= nametagUI.clipRange[1]) and ((cameraDistance/nametagUI.clipRange[1]) - 1)) or 1
                local tagAlpha = nearClipDistance*farClipDistance
                local isAlphaChanged = nametagUI.buffer[v].alpha ~= tagAlpha
                nametagUI.buffer[v].alpha = (isAlphaChanged and imports.interpolateBetween(nametagUI.buffer[v].alpha or 0, 0, 0, tagAlpha, 0, 0, 0.25, "InQuad")) or nametagUI.buffer[v].alpha
                if nametagUI.buffer[v].alpha > 0 then
                    local screenX, screenY = imports.getScreenFromWorldPosition(boneX, boneY, boneZ)
                    if screenX and screenY then
                        if isAlphaChanged then imports.beautify.native.setShaderValue(nametagUI.buffer[v].shader, "baseColor", 1.25, 1.25, 1.25, nametagUI.buffer[v].alpha) end
                        imports.beautify.native.drawImage(screenX - (rtWidth*0.5), screenY, rtWidth, rtHeight, nametagUI.buffer[v].shader, 0, 0, 0, -1)
                    end
                end
            end
        end
    end)
end)