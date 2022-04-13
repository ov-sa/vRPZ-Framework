----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: camera: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Camera Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEventHandler = addEventHandler,
    getCamera = getCamera,
    createObject = createObject,
    getElementBonePosition = getElementBonePosition,
    setElementPosition = setElementPosition,
    setElementRotation = setElementRotation,
    getElementRotation = getElementRotation,
    attachElements = attachElements,
    setObjectScale = setObjectScale,
    setElementAlpha = setElementAlpha,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    setNearClipDistance = setNearClipDistance,
    setCameraTarget = setCameraTarget,
    setCameraMatrix = setCameraMatrix,
    getCameraMatrix = getCameraMatrix,
    isPedDucked = isPedDucked,
    getKeyState = getKeyState,
    getPedControlState = getPedControlState,
    interpolateBetween = interpolateBetween
}


----------------
--[[ Module ]]--
----------------

CCamera = {
    CInstance = {native = imports.getCamera(), dummy = imports.createObject(1866, 0, 0, 0)},
    CControls = {"forwards", "backwards", "left", "right"},

    isClientAiming = function()
        return imports.getPedControlState(localPlayer, "aim_weapon")
    end,

    isClientOnADS = function()
        return imports.getKeyState(CCamera.CControls.ADS)
    end,

    isClientDucked = function()
        return imports.isPedDucked(localPlayer)
    end,

    isClientMoving = function()
        for i = 1, 4, 1 do
            local j = CCamera.CControls[i]
            if imports.getPedControlState(localPlayer, j) then
                return j
            end
        end
        return false
    end,

    updateCamera = function(offX, offY, offZ, rotX, rotY, rotZ)
        offX, offY, offZ = offX or 0, offY or 0, offZ = offZ or 0
        rotX, rotY, rotZ = rotX or 0, rotY or 0, rotZ or 0
        imports.setElementPosition(CCamera.CInstance.dummy, imports.getElementBonePosition(localPlayer, 7))
        imports.setElementRotation(CCamera.CInstance.dummy, imports.getElementRotation(localPlayer))
        imports.attachElements(cameraCache.cameraElement, CCamera.CInstance.dummy, offX, offY, offZ, rotX, rotY, rotZ)
        return true
    end,

    updateClientRotation = function(rotation)
        rotation = (rotation or 0)%360
        return imports.setElementRotation(localPlayer, 0, 0, rotation, "default", true)
    end,

    updateClientTarget = function(posX, posY, posZ)
        posX, posY, posZ = posX or 0, posY or 0, posz or 0
        return imports.setCameraTarget(posX, posY, posZ)
    end
}

imports.setObjectScale(CCamera.CInstance.dummy, 0)
imports.setElementAlpha(CCamera.CInstance.dummy, 0)
imports.setElementCollisionsEnabled(CCamera.CInstance.dummy, false)