----------------------------------------------------------------
--[[ Resource: Cinematic Camera Handler
     Script: exports: client.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 13/10/2019 (vStudio)
     Desc: Client Sided Exports ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local _screenSource = DxScreenSource(sX*1366, sY*768)
local _blurShader = DxShader("files/shaders/blur.fx")
local cinemationStatus = false
local _customCinemationPoint = false
local _customCinemationLoop = false
local _cinemationBlur = true
local _customCinemationFOV = false
local _reverseCinemationLoop = false
local _animateFOV = false
local _freezeLastFrame = false


---------------------------------------------
--[[ Function: Retrieves Cinemation Data ]]--
---------------------------------------------

function getCinemationData()

    if not cinemationStatus then return false end
    local _interpolationStatus, _interpolationElapsedDuration = getInterpolationStatus()
    if not _interpolationStatus or not _interpolationElapsedDuration then return false end

    local cameraMatrix = {getCameraMatrix()}
    local cameraLooping, cameraFrozen = false, false
    if not _customCinemationPoint then
        cameraLooping = true
    else
        if _customCinemationLoop then
            if _customCinemationLoop ~= -1 then
                cameraLooping = true
            else
                if _freezeLastFrame then
                    if _interpolationElapsedDuration <= 0 then
                        cameraFrozen = true
                    end
                end
            end
        end
    end
    return {
        cameraPosition = {x = cameraMatrix[1], y = cameraMatrix[2], z = cameraMatrix[3]},
        cameraLookPosition = {x = cameraMatrix[4], y = cameraMatrix[5], z = cameraMatrix[6]},
        cameraFOV = cameraMatrix[8],
        cameraLooping = cameraLooping,
        cameraFrozen = cameraFrozen
    }

end


---------------------------------
--[[ Event: On Client Render ]]--
---------------------------------

addEventHandler("onClientRender", root, function()

    if not cinemationStatus then return false end

    local _interpolationStatus = getInterpolationStatus()
    if not _interpolationStatus then
        if not _customCinemationPoint then
            if (#availableCinemationPoints) > 0 then
                startCameraMovement(availableCinemationPoints[math.random(#availableCinemationPoints)], _customCinemationFOV)
            end
        else
            if _customCinemationLoop then
                if _reverseCinemationLoop then
                    _customCinemationPoint = reverseCinemationPoint(_customCinemationPoint)
                end
            elseif not _customCinemationLoop then
                _customCinemationLoop = -1
            elseif _customCinemationLoop == -1 then
                stopCinemation()
                return false
            end
            startCameraMovement(_customCinemationPoint, _customCinemationFOV, _animateFOV, _freezeLastFrame)
        end
    end

    dxUpdateScreenSource(_screenSource)
    if _cinemationBlur and _blurShader and isElement(_blurShader) then
        dxSetShaderValue(_blurShader, "ScreenSource", _screenSource)
        dxSetShaderValue(_blurShader, "BlurStrength", blurStrength)
        dxSetShaderValue(_blurShader, "UVSize", sX*1366, sY*768)
        dxDrawImage(0, 0, sX*1366, sY*768, _blurShader)
    else
        dxDrawImage(0, 0, sX*1366, sY*768, _screenSource)
    end

end)


--------------------------------------------
--[[ Functions: Starts/Stops Cinemation ]]--
--------------------------------------------

function startCinemation(customCinemationPoint, customCinemationLoop, skipCinemationBlur, customCinemationFOV, reverseCinemationLoop, forceStart, animateFOV, freezeLastFrame)

    if cinemationStatus and not forceStart then return false end
    if customCinemationPoint and type(customCinemationPoint) ~= "table" then return false end

    _customCinemationPoint = customCinemationPoint
    _customCinemationLoop = customCinemationLoop
    if skipCinemationBlur then
        _cinemationBlur = false
    else
        _cinemationBlur = true
    end
    _customCinemationFOV = customCinemationFOV
    _reverseCinemationLoop = reverseCinemationLoop
    _animateFOV = animateFOV
    _freezeLastFrame = freezeLastFrame
    if _customCinemationPoint and _customCinemationLoop and _reverseCinemationLoop then
        _customCinemationPoint = reverseCinemationPoint(_customCinemationPoint)
    end
    if not cinemationStatus then
        cinemationStatus = true
    else
        stopCameraMovement()
    end
    return true

end

function stopCinemation()

    if not cinemationStatus then return false end

    stopCameraMovement()
    cinemationStatus = false
    _customCinemationPoint = false
    _customCinemationLoop = false
    _cinemationBlur = true
    _customCinemationFOV = false
    _reverseCinemationLoop = false
    _animateFOV = false
    _freezeLastFrame = false
    setCameraTarget(localPlayer)
    return true
    
end