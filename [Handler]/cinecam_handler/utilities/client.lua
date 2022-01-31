----------------------------------------------------------------
--[[ Resource: Cinematic Camera Handler
     Script: settings: client.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 13/10/2019 (OvileAmriam)
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

sX, sY = GuiElement.getScreenSize()
sX = sX/1366; sY = sY/768;


------------------------------------------------------
--[[ Function: Retrieves Interpolation's Progress ]]--
------------------------------------------------------

function getInterpolationProgress(tickCount, delay)

    if not tickCount or not delay then return false end

    local now = getTickCount()
    local endTime = tickCount + delay
    local elapsedTime = now - tickCount
    local duration = endTime - tickCount
    local progress = elapsedTime / duration
    return progress

end


---------------------------------------------
--[[ Function: Reverses Cinemation Point ]]--
---------------------------------------------

function reverseCinemationPoint(cinemationPoint)

    if not cinemationPoint then return false end

    return {
        cameraStart = cinemationPoint.cameraEnd,
        cameraStartLook = cinemationPoint.cameraEndLook,
        cameraEnd = cinemationPoint.cameraStart,
        cameraEndLook = cinemationPoint.cameraStartLook,
        cinemationDuration = cinemationPoint.cinemationDuration
    }

end