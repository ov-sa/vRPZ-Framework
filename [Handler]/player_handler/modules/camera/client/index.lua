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
    pairs = pairs,
    addEventHandler = addEventHandler,
    getCamera = getCamera,
    createObject = createObject,
    getElementBonePosition = getElementBonePosition,
    setElementPosition = setElementPosition,
    setElementRotation = setElementRotation,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation,
    getElementMatrix = getElementMatrix,
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
    interpolateBetween = interpolateBetween,
    math = math
}


----------------
--[[ Module ]]--
----------------

CCamera = {
    CCache = {
        camera = {
            offX = {value = 0, animValue = 0}, offY = {value = 0, animValue = 0}, offZ = {value = 0, animValue = 0},
            rotX = {value = 0, animValue = 0, cameraValue = 0}, rotY = {value = 0, animValue = 0, cameraValue = 0}, rotZ = {value = 0, animValue = 0}
        }
    },
    CInstance = {native = imports.getCamera(), dummy = imports.createObject(1866, 0, 0, 0), instance = imports.createObject(1866, 0, 0, 0)},
    CViews = {
        ["player"] = {
            FOV = 50, nearClip = 0.25, duckedY = 0.4,
            attachOffsets = {0, -0.1, 0, 0, 0, 0},
        },
        ["vehicle"] = {
            FOV = 50, nearClip = 0.25,
            attachOffsets = {0, -0.1, 0, 0, 0, 0}
        }
    },
    CControls = {
        movement = {"forwards", "backwards", "left", "right"},
        ADS = "capslock"
    },

    isClientAiming = function()
        return (CCamera.CView == "player") and imports.getPedControlState(localPlayer, "aim_weapon")
    end,

    isClientOnADS = function()
        return (CCamera.isClientAiming() and imports.getKeyState(CCamera.CControls.ADS)) or false
    end,

    isClientDucked = function()
        return imports.isPedDucked(localPlayer)
    end,

    isClientMoving = function()
        for i = 1, 4, 1 do
            local j = CCamera.CControls.movement[i]
            if imports.getPedControlState(localPlayer, j) then
                return j
            end
        end
        return false
    end,

    updateTexClips = function(texList, state)
        for i = 1, #texList, 1 do
            local j = texList[i]
            if state then
                assetify.createShader(localPlayer, "client-camera", "Assetify_TextureClearer", j, {}, {}, {}, {})
            end
        end
        return true
    end,

    updateCameraView = function(view)
        if not view then
            CCamera.CView = false
        else
            if not CCamera.CViews[view] or (CCamera.CView == view) then return false end
            CCamera.CView = view
        end
        return true
    end,

    updateCamera = function(offX, offY, offZ, rotX, rotY, rotZ)
        offX, offY, offZ = offX or 0, offY or 0, offZ or 0
        rotX, rotY, rotZ = rotX or 0, rotY or 0, rotZ or 0
        local _, _, __rotZ = imports.getElementRotation(localPlayer)
        imports.setElementPosition(CCamera.CInstance.dummy, imports.getElementBonePosition(localPlayer, 7))
        imports.setElementRotation(CCamera.CInstance.dummy, rotX, rotY, rotZ + __rotZ)
        imports.attachElements(CCamera.CInstance.instance, CCamera.CInstance.dummy, offX, offY, offZ, rotX, rotY, rotZ)
        return true
    end,

    updateCameraTarget = function(posX, posY, posZ)
        posX, posY, posZ = posX or 0, posY or 0, posZ or 0
        return imports.setCameraTarget(posX, posY, posZ)
    end,

    updateClientRotation = function(rotation)
        rotation = (rotation or 0)%360
        return imports.setElementRotation(localPlayer, 0, 0, rotation, "default", true)
    end,

    updateCameraSway = function(swayType, swayValue)
        CCamera.CCache.cameraSway = CCamera.CCache.cameraSway or {}
        CCamera.CCache.cameraSway.type = swayType or "OutQuad"
        CCamera.CCache.cameraSway.value = swayValue or "0.25"
        return true
    end,

    updateCameraAim = function(offX, offY)
        CCamera.CCache.cameraAim = CCamera.CCache.cameraAim or {}
        CCamera.CCache.cameraAim.x = offX or 0
        CCamera.CCache.cameraAim.y = offY or 0
        return true
    end,

    updateEntityLocation = function(element, posX, posY, posZ, rotX, rotY, rotZ, rotOrder)
        if posX and posY and posZ then
            imports.setElementPosition(element, posX, posY, posZ)
        end
        if rotX and rotY and rotZ then
            imports.setElementRotation(element, rotX, rotY, rotZ, rotOrder)
        end
        return true
    end,

    fetchEntityLocation = function(element, rotOrder)
        local posX, posY, posZ = imports.getElementPosition(element)
        local rotX, rotY, rotZ = imports.getElementRotation(element, rotOrder)
        return posX, posY, posZ, rotX, rotY, rotZ 
    end,
    
    fetchEntityPosition = function(entity, offX, offY, offZ)
        if not offX or not offY or not offZ then return false end
        local cMatrix = imports.getElementMatrix(entity)
        return (offX*cMatrix[1][1]) + (offY*cMatrix[2][1]) + (offZ*cMatrix[3][1]) + cMatrix[4][1], (offX*cMatrix[1][2]) + (offY*cMatrix[2][2]) + (offZ*cMatrix[3][2]) + cMatrix[4][2], (offX*cMatrix[1][3]) + (offY*cMatrix[2][3]) + (offZ*cMatrix[3][3]) + cMatrix[4][3]
    end,

    updateMouseRotation = function(aX, aY)
        if CLIENT_MTA_WINDOW_ACTIVE or CLIENT_IS_CURSOR_SHOWING then return false end
        --if not camera.isCursorVisible or not camera.cursorTick or ((CLIENT_CURRENT_TICK - camera.cursorTick) <= 500) then return false end
        aX, aY = aX - 0.5, aY - 0.5
        CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value = CCamera.CCache.camera.rotX.value - (aX*360), imports.math.max(-0.65, imports.math.min(0.9, CCamera.CCache.camera.rotY.value - aY))
        return true
    end,

    renderCamera = function()
        if not CCamera.CView then return false end
        local camera_viewData = CCamera.CViews[(CCamera.CView)]
        local isClientOnADS, isClientDucked = CCamera.isClientOnADS(), CCamera.isClientDucked()
        isClientOnADS = (isClientOnADS and weaponData.ADS.offsets) or false
        CCamera.updateCamera(camera_viewData.attachOffsets[1], camera_viewData.attachOffsets[2], camera_viewData.attachOffsets[3], camera_viewData.attachOffsets[4], camera_viewData.attachOffsets[5], camera_viewData.attachOffsets[6])
        CCamera.updateCameraAim()
        CCamera.updateCameraSway()
    
        if isClientOnADS then
            CCamera.updateCameraSway(_, 0.45)
            if isClientDucked then
                CCamera.updateCameraAim(_, camera_viewData.duckedY)
            end
            CCamera.updateClientRotation(CCamera.CCache.camera.rotX.animValue)
            local camera_posX, camera_posY, camera_posZ = CCamera.fetchEntityLocation(CCamera.CInstance.instance)
            local camera_offsetX, camera_offsetY, camera_offsetZ = CCamera.fetchEntityPosition(weaponObject, isClientOnADS.x, isClientOnADS.y, isClientOnADS.z)
            CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value = camera_offsetX - camera_posX, camera_offsetY - camera_posY, camera_offsetZ - camera_posZ
        else
            CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value = 0, 0, 0
        end
        if CCamera.CView == "player" then
            CCamera.updateClientRotation(CCamera.CCache.camera.rotX.animValue)
        end
        CCamera.CCache.camera.offX.animValue, CCamera.CCache.camera.offY.animValue, CCamera.CCache.camera.offZ.animValue = imports.interpolateBetween(CCamera.CCache.camera.offX.animValue, CCamera.CCache.camera.offY.animValue, CCamera.CCache.camera.offZ.animValue, CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value, 0.25, "OutQuad")
        CCamera.CCache.camera.rotX.animValue, CCamera.CCache.camera.rotY.animValue, CCamera.CCache.camera.rotZ.animValue = imports.interpolateBetween(CCamera.CCache.camera.rotX.animValue, CCamera.CCache.camera.rotY.animValue, CCamera.CCache.camera.rotZ.animValue, CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value, CCamera.CCache.camera.rotZ.value, 0.45, "InQuad")
        CCamera.CCache.camera.rotX.cameraValue, CCamera.CCache.camera.rotY.cameraValue = imports.interpolateBetween(CCamera.CCache.camera.rotX.cameraValue, CCamera.CCache.camera.rotY.cameraValue, 0, CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value, 0, CCamera.CCache.cameraSway.value, CCamera.CCache.cameraSway.type)
        local camera_posX, camera_posY, camera_posZ, camera_rotX, camera_rotY, camera_rotZ = CCamera.fetchEntityLocation(CCamera.CInstance.instance)
        local cameraTarget_offZ = CCamera.CCache.camera.rotY.animValue + (CCamera.CCache.camera.rotY.animValue - CCamera.CCache.camera.rotY.cameraValue)
        local camera_forwardX, camera_forwardY, camera_forwardZ = CCamera.fetchEntityPosition(CCamera.CInstance.instance, 0, 1, 0)
        camera_posX, camera_posY, camera_posZ = camera_posX + CCamera.CCache.camera.offX.animValue, camera_posY + CCamera.CCache.camera.offY.animValue, camera_posZ + CCamera.CCache.camera.offZ.animValue
        CCamera.updateEntityLocation(CCamera.CInstance.native, camera_posX, camera_posY, camera_posZ, camera_rotX, camera_rotY, camera_rotZ)
        local camera_posX, camera_posY, camera_posZ, camera_lookX, camera_lookY, camera_lookZ, camera_roll = imports.getCameraMatrix()
        imports.setNearClipDistance(camera_viewData.nearClip)
        imports.setCameraTarget(camera_forwardX, camera_forwardY, camera_forwardZ + cameraTarget_offZ + CCamera.CCache.cameraAim.y)
        imports.setCameraMatrix(camera_posX, camera_posY, camera_posZ, camera_lookX, camera_lookY, camera_lookZ + cameraTarget_offZ, camera_roll, camera_viewData.FOV)
    end
}

for i, j in imports.pairs(CCamera.CInstance) do
    if i ~= "native" then
        imports.setObjectScale(j, 0)
        imports.setElementAlpha(j, 0)
        imports.setElementCollisionsEnabled(j, false)
    end
end
CCamera.updateCameraView("player")
imports.addEventHandler("onClientCursorMove", root, CCamera.updateMouseRotation)
imports.addEventHandler("onClientPedsProcessed", root, CCamera.renderCamera)