----------------------------------------------------------------
--[[ Resource: -
     Script: -
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 09/08/2020 (OvileAmriam)
     Desc: - ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local clearanceTimers = {}
local createdAnimations = {}


---------------------------------------
--[[ Event: On Sync Ped Animations ]]--
---------------------------------------

addEvent("onSyncPedAnimations", true)
addEventHandler("onSyncPedAnimations", root, function(ped, blockName, animName, animDuration, isInterruptable)

    if not ped or not isElement(ped) or (ped:getType() ~= "ped" and ped:getType() ~= "player") then return false end

    if blockName == nil or animName == nil then
        for i, j in pairs(availableAnimations) do
            if not createdAnimations[i] and File.exists(i) then
                createdAnimations[i] = engineLoadIFP(i, i)
            end
            for k, v in ipairs(j) do
                engineReplaceAnimation(ped, v.defaultBlockName, v.defaultAnimName, i, v.customAnimName)
            end
        end
    else
        if not blockName or not animName then
            ped:setAnimation("ped", "factalk", 1, false, true, true)
        else
            animDuration = math.max(100, tonumber(animDuration) or 0)
            if isInterruptable ~= false then isInterruptable = true end
            if clearanceTimers[ped] and clearanceTimers[ped]:isValid() then clearanceTimers[ped]:destroy() end
            ped:setAnimation(blockName, animName, -1, false, false, isInterruptable)
            clearanceTimers[ped] = Timer(function(ped)
                if ped and isElement(ped) then
                    triggerEvent("onSyncPedAnimations", localPlayer, ped, false, false)
                end
            end, animDuration, 1, ped)
        end
    end

end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

resource = getResourceRootElement(getThisResource())
addEventHandler("onClientResourceStart", resource, function()

    for i, j in ipairs(Element.getAllByType("player", root, true)) do
        triggerEvent("onSyncPedAnimations", localPlayer, j)
    end
    for i, j in ipairs(Element.getAllByType("ped", root, true)) do
        triggerEvent("onSyncPedAnimations", localPlayer, j)
    end
    addEventHandler("onClientPlayerJoin", root, function()
        triggerEvent("onSyncPedAnimations", localPlayer, source)
    end)

end)