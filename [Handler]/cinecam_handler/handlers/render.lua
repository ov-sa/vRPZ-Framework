----------------------------------------------------------------
--[[ Resource: Cinematic Camera Handler
     Script: handlers: render.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 13/10/2019 (vStudio)
     Desc: Cinematic Camera Renderer ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local prevCameraFOV = false
local interpolationStatus = false
local interpolationPoint = false
local interpolationFOV = false
local interpolateFOV = false
local interpolationFreezeLastFrame = false
local interpolationTickCounter = getTickCount()


--------------------------------------------------
--[[ Function: Retrieves Interpolation Status ]]--
--------------------------------------------------

function getInterpolationStatus()

    if interpolationStatus then
        return true, math.max(0, interpolationPoint.cinemationDuration - (getTickCount() - interpolationTickCounter))
    else
        return false, false
    end

end


-------------------------------------
--[[ Event: On Client Pre Render ]]--
-------------------------------------

addEventHandler("onClientPreRender", root, function()

    local _interpolationStatus, _interpolationElapsedDuration = getInterpolationStatus()
    if _interpolationStatus and _interpolationElapsedDuration then
        if _interpolationElapsedDuration <= 0 then
            if not interpolationFreezeLastFrame then
                stopCameraMovement()
                return false
            end
        end
        local cameraPositionX, cameraPositionY, cameraPositionZ = interpolateBetween(interpolationPoint.cameraStart.x, interpolationPoint.cameraStart.y, interpolationPoint.cameraStart.z, interpolationPoint.cameraEnd.x, interpolationPoint.cameraEnd.y, interpolationPoint.cameraEnd.z, getInterpolationProgress(interpolationTickCounter, interpolationPoint.cinemationDuration), "InOutQuad")
        local cameraLookPositionX, cameraLookPositionY, cameraLookPositionZ = interpolateBetween(interpolationPoint.cameraStartLook.x, interpolationPoint.cameraStartLook.y, interpolationPoint.cameraStartLook.z, interpolationPoint.cameraEndLook.x, interpolationPoint.cameraEndLook.y, interpolationPoint.cameraEndLook.z, getInterpolationProgress(interpolationTickCounter, interpolationPoint.cinemationDuration), "InOutQuad")
        local cameraFOV = (interpolateFOV and interpolateBetween(prevCameraFOV, 0, 0, interpolationFOV, 0, 0, getInterpolationProgress(interpolationTickCounter, interpolationPoint.cinemationDuration), "InOutQuad")) or interpolationFOV
        setCameraMatrix(cameraPositionX, cameraPositionY, cameraPositionZ, cameraLookPositionX, cameraLookPositionY, cameraLookPositionZ, 0, cameraFOV)
    end

end)


-------------------------------------------------
--[[ Functions: Starts/Stops Camera Movement ]]--
-------------------------------------------------

function startCameraMovement(cinemationPoint, cinemationFOV, animateFOV, freezeLastFrame)

    if interpolationStatus then return false end
    if not cinemationPoint or type(cinemationPoint) ~= "table" then return false end
    if not cinemationPoint.cameraStart or type(cinemationPoint.cameraStart) ~= "table" or not cinemationPoint.cameraStartLook or type(cinemationPoint.cameraStartLook) ~= "table" or not cinemationPoint.cameraEnd or type(cinemationPoint.cameraEnd) ~= "table" or not cinemationPoint.cameraEndLook or type(cinemationPoint.cameraEndLook) ~= "table" or not cinemationPoint.cinemationDuration then return false end
    cinemationPoint.cameraStart.x = tonumber(cinemationPoint.cameraStart.x); cinemationPoint.cameraStart.y = tonumber(cinemationPoint.cameraStart.y); cinemationPoint.cameraStart.z = tonumber(cinemationPoint.cameraStart.z);
    cinemationPoint.cameraStartLook.x = tonumber(cinemationPoint.cameraStartLook.x); cinemationPoint.cameraStartLook.y = tonumber(cinemationPoint.cameraStartLook.y); cinemationPoint.cameraStartLook.z = tonumber(cinemationPoint.cameraStartLook.z);
    cinemationPoint.cameraEnd.x = tonumber(cinemationPoint.cameraEnd.x); cinemationPoint.cameraEnd.y = tonumber(cinemationPoint.cameraEnd.y); cinemationPoint.cameraEnd.z = tonumber(cinemationPoint.cameraEnd.z);
    cinemationPoint.cameraEndLook.x = tonumber(cinemationPoint.cameraEndLook.x); cinemationPoint.cameraEndLook.y = tonumber(cinemationPoint.cameraEndLook.y); cinemationPoint.cameraEndLook.z = tonumber(cinemationPoint.cameraEndLook.z);
    cinemationPoint.cinemationDuration = tonumber(cinemationPoint.cinemationDuration);
    if not cinemationPoint.cameraStart.x or not cinemationPoint.cameraStart.y or not cinemationPoint.cameraStart.z or not cinemationPoint.cameraStartLook.x or not cinemationPoint.cameraStartLook.y or not cinemationPoint.cameraStartLook.z or not cinemationPoint.cameraEnd.x or not cinemationPoint.cameraEnd.y or not cinemationPoint.cameraEnd.z or not cinemationPoint.cameraEndLook.x or not cinemationPoint.cameraEndLook.y or not cinemationPoint.cameraEndLook.z or not cinemationPoint.cinemationDuration then return false end

    local _camerMatrix = {getCameraMatrix()}
    prevCameraFOV = _camerMatrix[8]
    interpolationPoint = cinemationPoint
    interpolationFOV = tonumber(cinemationFOV) or 70
    interpolateFOV = animateFOV
    interpolationFreezeLastFrame = freezeLastFrame
    interpolationTickCounter = getTickCount()
    interpolationStatus = true
    return true

end

function stopCameraMovement()

    if not interpolationStatus then return false end

    interpolationStatus = false
    interpolationPoint = false
    interpolationFOV = false
    interpolateFOV = false
    interpolationFreezeLastFrame = false
    return true
    
end