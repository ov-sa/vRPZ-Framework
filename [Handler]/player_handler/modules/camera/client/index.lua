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
    setElementFrozen = setElementFrozen,
    setElementPosition = setElementPosition,
    setElementRotation = setElementRotation,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation,
    getElementMatrix = getElementMatrix,
    getElementVelocity = getElementVelocity,
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
    processLineOfSight = processLineOfSight,
    math = math,
    assetify = assetify
}


----------------
--[[ Module ]]--
----------------

CCamera = {
    CCache = {
        camera = {
            offX = {value = 0, animValue = 0}, offY = {value = 0, animValue = 0}, offZ = {value = 0, animValue = 0},
            rotX = {value = 0, animValue = 0, cameraValue = 0}, rotY = {value = 0, animValue = 0, cameraValue = 0}, rotZ = {value = 0, animValue = 0},
            velocity = {value = 0, animValue = 0}
        },
        controller = {
            front = {value = 0, animValue = 0}, right = {value = 0, animValue = 0}, up = {value = 0, animValue = 0}
        }
    },
    CInstance = {native = imports.getCamera(), dummy = imports.createObject(1866, 0, 0, 0), instance = imports.createObject(1866, 0, 0, 0)},
    CViews = {
        ["player"] = {
            FOV = 50, nearClip = 0.25, duckedY = 0.4,
            moveSpeed = 0.1, sprintSpeed = 2.5,
            attachOffsets = {0, -0.1, 0, 0, 0, 0},
        },
        ["vehicle"] = {
            FOV = 50, nearClip = 0.25,
            attachOffsets = {0, 0, 0, 0, 0, 0}
        }
    },
    CControls = {
        ADS = "capslock"
    },

    isClientAiming = function()
        return (CCamera.CView == "player") and imports.getPedControlState(localPlayer, "aim_weapon")
    end,

    isClientOnADS = function()
        return (CCamera.isClientAiming() and imports.getKeyState(CCamera.CControls.ADS)) or false
    end,

    isClientSprinting = function()
        return (CCamera.CView == "player") and not CCamera.isClientOnADS() and imports.getPedControlState(localPlayer, "sprint")
    end,

    isClientDucked = function()
        return imports.isPedDucked(localPlayer)
    end,

    updateTexClips = function(texList, state)
        for i = 1, #texList, 1 do
            local j = texList[i]
            if state then
                imports.assetify.createShader(localPlayer, "client-camera", "Assetify_TextureClearer", j, {}, {}, {}, {})
            end
        end
        return true
    end,

    updateCameraView = function(view)
        if not view then
            CCamera.CView = false
            imports.setCameraTarget(localPlayer)
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
        local bone_posX, bone_posY, bone_posZ = imports.getElementBonePosition(localPlayer, 7)
        rotZ = rotZ + __rotZ
        CCamera.updateEntityLocation(CCamera.CInstance.dummy, bone_posX, bone_posY, bone_posZ, rotX, rotY, rotZ)
        offX, offY, offZ = CCamera.fetchEntityPosition(CCamera.CInstance.dummy, offX, offY, offZ)
        CCamera.CCache.camera.location = CCamera.CCache.camera.location or {}
        CCamera.CCache.camera.location[1], CCamera.CCache.camera.location[2], CCamera.CCache.camera.location[3], CCamera.CCache.camera.location[4], CCamera.CCache.camera.location[5], CCamera.CCache.camera.location[6] = offX, offY, offZ, rotX, rotY, rotZ
        return true
    end,

    updateCameraTarget = function(posX, posY, posZ)
        posX, posY, posZ = posX or 0, posY or 0, posZ or 0
        return imports.setCameraTarget(posX, posY, posZ)
    end,

    updateCameraVelocity = function(velX, velY, velZ)
        CCamera.CCache.camera.velocity.x = velX or 0
        CCamera.CCache.camera.velocity.y = velY or 0
        CCamera.CCache.camera.velocity.z = velZ or 0
        return true
    end,

    updateCameraSway = function(swayType, swayValue)
        CCamera.CCache.camera.sway = CCamera.CCache.camera.sway or {}
        CCamera.CCache.camera.sway.type = swayType or "OutQuad"
        CCamera.CCache.camera.sway.value = swayValue or "0.25"
        return true
    end,

    updateCameraAim = function(offX, offY)
        CCamera.CCache.camera.aim = CCamera.CCache.camera.aim or {}
        CCamera.CCache.camera.aim.x = offX or 0
        CCamera.CCache.camera.aim.y = offY or 0
        return true
    end,

    updateEntityLocation = function(element, posX, posY, posZ, rotX, rotY, rotZ, warp, rotOrder)
        if posX and posY and posZ then
            imports.setElementPosition(element, posX, posY, posZ, warp)
        end
        if rotX and rotY and rotZ then
            imports.setElementRotation(element, rotX, rotY, rotZ, rotOrder)
        end
        return true
    end,

    updateControllerLocation = function(offX, offY, offZ)
        CCamera.CCache.controller.front.value = offX or 0
        CCamera.CCache.controller.right.value = offY or 0
        CCamera.CCache.controller.up.value = offZ or 0
        return true
    end,

    updateClientRotation = function(rotation)
        rotation = (rotation or 0)%360
        return imports.setElementRotation(localPlayer, 0, 0, rotation, "default", true)
    end,

    fetchEntityLocation = function(element, rotOrder)
        local posX, posY, posZ = imports.getElementPosition(element)
        local rotX, rotY, rotZ = imports.getElementRotation(element, rotOrder)
        return posX, posY, posZ, rotX, rotY, rotZ 
    end,
    
    fetchEntityPosition = function(entity, offX, offY, offZ)
        offX, offY, offZ = offX or 0, offY or 0, offZ or 0
        local cMatrix = imports.getElementMatrix(entity)
        return (offX*cMatrix[1][1]) + (offY*cMatrix[2][1]) + (offZ*cMatrix[3][1]) + cMatrix[4][1], (offX*cMatrix[1][2]) + (offY*cMatrix[2][2]) + (offZ*cMatrix[3][2]) + cMatrix[4][2], (offX*cMatrix[1][3]) + (offY*cMatrix[2][3]) + (offZ*cMatrix[3][3]) + cMatrix[4][3]
    end,

    updateMouseRotation = function(aX, aY)
        if CLIENT_MTA_WINDOW_ACTIVE or CLIENT_IS_CURSOR_SHOWING then return false end
        if not CPlayer.isInitialized(localPlayer) or not CCamera.CView then return false end
        aX, aY = aX - 0.5, aY - 0.5
        CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value = CCamera.CCache.camera.rotX.value - (aX*360), imports.math.max(-0.65, imports.math.min(0.9, CCamera.CCache.camera.rotY.value - aY))
        return true
    end,

    renderClient = function()
        if not CPlayer.isInitialized(localPlayer) or not CCamera.CView then return false end
        local camera_viewData = CCamera.CViews[(CCamera.CView)]
        local controller_front, controller_right, controller_up = nil, nil, nil

        if CCamera.CView == "player" then
            local isClientSprinting = CCamera.isClientSprinting()
            if imports.getPedControlState(localPlayer, "forwards") then
                controller_front = camera_viewData.moveSpeed
            elseif imports.getPedControlState(localPlayer, "backwards") then
                controller_front = -camera_viewData.moveSpeed
            end
            if imports.getPedControlState(localPlayer, "left") then
                controller_right = -camera_viewData.moveSpeed
            elseif imports.getPedControlState(localPlayer, "right") then
                controller_right = camera_viewData.moveSpeed
            end
            if isClientSprinting then
                controller_front = controller_front*camera_viewData.sprintSpeed
            end
            local posX, posY, posZ = CCamera.fetchEntityPosition(localPlayer, CCamera.CCache.controller.right.animValue, CCamera.CCache.controller.front.animValue, CCamera.CCache.controller.up.animValue)
            local hit, hitX, hitY, hitZ = imports.processLineOfSight(posX, posY, posZ, posX, posY, posZ - 50, false, false, false, true, false, false, false, false, weaponObject)
            if hit then hitZ = hitZ + 1 end
            imports.setElementFrozen(localPlayer, not isClientSprinting)
            CCamera.updateEntityLocation(localPlayer, posX, posY, hitZ or posZ, _, _, _, false)
        end
        CCamera.updateControllerLocation(controller_front, controller_right, controller_up)
        return true
    end,

    renderCamera = function()
        if not CPlayer.isInitialized(localPlayer) or not CCamera.CView then return false end
        local camera_viewData = CCamera.CViews[(CCamera.CView)]
        local isClientOnADS, isClientDucked = CCamera.isClientOnADS(), CCamera.isClientDucked()
        isClientOnADS = (isClientOnADS and weaponData and weaponData.ADS.offsets) or false
        local isCameraAimUpdated, isCameraSwayUpdated = false, false
        CCamera.updateCamera(camera_viewData.attachOffsets[1], camera_viewData.attachOffsets[2], camera_viewData.attachOffsets[3], camera_viewData.attachOffsets[4], camera_viewData.attachOffsets[5], camera_viewData.attachOffsets[6])
        
        if isClientOnADS then
            CCamera.updateCameraSway(_, 0.45)
            if isClientDucked then
                CCamera.updateCameraAim(_, camera_viewData.duckedY)
                isCameraAimUpdated = true
            end
            local camera_posX, camera_posY, camera_posZ = CCamera.fetchEntityLocation(CCamera.CInstance.instance)
            local camera_offsetX, camera_offsetY, camera_offsetZ = CCamera.fetchEntityPosition(weaponObject, isClientOnADS.x, isClientOnADS.y, isClientOnADS.z)
            CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value = camera_offsetX - camera_posX, camera_offsetY - camera_posY, camera_offsetZ - camera_posZ
            isCameraSwayUpdated = true
        else
            CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value = 0, 0, 0
        end
        if not isCameraAimUpdated then CCamera.updateCameraAim() end
        if not isCameraSwayUpdated then CCamera.updateCameraSway() end
        CCamera.renderClient()
        return true
    end,

    renderEntity = function()
        if not CPlayer.isInitialized(localPlayer) or not CCamera.CView then return false end
        local camera_viewData = CCamera.CViews[(CCamera.CView)]
        local isCameraVelocityUpdated = false
        CCamera.CCache.camera.offX.animValue, CCamera.CCache.camera.offY.animValue, CCamera.CCache.camera.offZ.animValue = imports.interpolateBetween(CCamera.CCache.camera.offX.animValue, CCamera.CCache.camera.offY.animValue, CCamera.CCache.camera.offZ.animValue, CCamera.CCache.camera.offX.value, CCamera.CCache.camera.offY.value, CCamera.CCache.camera.offZ.value, 0.25, "OutQuad")
        CCamera.CCache.camera.rotX.animValue, CCamera.CCache.camera.rotY.animValue, CCamera.CCache.camera.rotZ.animValue = imports.interpolateBetween(CCamera.CCache.camera.rotX.animValue, CCamera.CCache.camera.rotY.animValue, CCamera.CCache.camera.rotZ.animValue, CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value, CCamera.CCache.camera.rotZ.value, 0.45, "InQuad")
        CCamera.CCache.camera.rotX.cameraValue, CCamera.CCache.camera.rotY.cameraValue = imports.interpolateBetween(CCamera.CCache.camera.rotX.cameraValue, CCamera.CCache.camera.rotY.cameraValue, 0, CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value, 0, CCamera.CCache.camera.sway.value, CCamera.CCache.camera.sway.type)
        CCamera.CCache.camera.velocity.animValue = imports.interpolateBetween(CCamera.CCache.camera.velocity.animValue, 0, 0, CCamera.CCache.camera.velocity.value, 0, 0, 0.45, "InQuad")
        CCamera.CCache.controller.front.animValue, CCamera.CCache.controller.right.animValue, CCamera.CCache.controller.up.animValue = imports.interpolateBetween(CCamera.CCache.controller.front.animValue, CCamera.CCache.controller.right.animValue, CCamera.CCache.controller.up.animValue, CCamera.CCache.controller.front.value, CCamera.CCache.controller.right.value, CCamera.CCache.controller.up.value, 0.45, "InQuad")

        if CCamera.CView == "player" then
            local isClientSprinting = CCamera.isClientSprinting()
            local camera_velocityX, camera_velocityY, camera_velocityZ = imports.getElementVelocity(localPlayer)
            CCamera.CCache.camera.velocity.value = 3
            if imports.getPedControlState(localPlayer, "left") then
                CCamera.CCache.camera.velocity.value = CCamera.CCache.camera.velocity.value
            elseif imports.getPedControlState(localPlayer, "right") then
                CCamera.CCache.camera.velocity.value = CCamera.CCache.camera.velocity.value*0.65
            end
            if isClientSprinting then
                CCamera.CCache.camera.velocity.value = CCamera.CCache.camera.velocity.value*camera_viewData.sprintSpeed
            end
            CCamera.updateCameraVelocity(camera_velocityX*CCamera.CCache.camera.velocity.animValue, camera_velocityY*CCamera.CCache.camera.velocity.animValue, camera_velocityZ*CCamera.CCache.camera.velocity.animValue)
            CCamera.updateClientRotation(CCamera.CCache.camera.rotX.animValue)
            isCameraVelocityUpdated = true
        end
        if not isCameraVelocityUpdated then CCamera.updateCameraVelocity() end
        if CCamera.CCache.camera.location then
            CCamera.updateEntityLocation(CCamera.CInstance.instance, CCamera.CCache.camera.location[1] + CCamera.CCache.camera.velocity.x, CCamera.CCache.camera.location[2] + CCamera.CCache.camera.velocity.y, CCamera.CCache.camera.location[3] + CCamera.CCache.camera.velocity.z, CCamera.CCache.camera.location[4], CCamera.CCache.camera.location[5], CCamera.CCache.camera.location[6])
        end
        local camera_posX, camera_posY, camera_posZ, camera_rotX, camera_rotY, camera_rotZ = CCamera.fetchEntityLocation(CCamera.CInstance.instance)
        local cameraTarget_offZ = CCamera.CCache.camera.rotY.animValue + (CCamera.CCache.camera.rotY.animValue - CCamera.CCache.camera.rotY.cameraValue)
        local camera_forwardX, camera_forwardY, camera_forwardZ = CCamera.fetchEntityPosition(CCamera.CInstance.instance, 0, 1, 0)
        camera_posX, camera_posY, camera_posZ = camera_posX + CCamera.CCache.camera.offX.animValue, camera_posY + CCamera.CCache.camera.offY.animValue, camera_posZ + CCamera.CCache.camera.offZ.animValue
        CCamera.updateEntityLocation(CCamera.CInstance.native, camera_posX, camera_posY, camera_posZ, camera_rotX, camera_rotY, camera_rotZ)
        local camera_posX, camera_posY, camera_posZ, camera_lookX, camera_lookY, camera_lookZ, camera_roll = imports.getCameraMatrix()
        imports.setNearClipDistance(camera_viewData.nearClip)
        imports.setCameraTarget(camera_forwardX, camera_forwardY, camera_forwardZ + cameraTarget_offZ + CCamera.CCache.camera.aim.y)
        imports.setCameraMatrix(camera_posX, camera_posY, camera_posZ, camera_lookX, camera_lookY, camera_lookZ + cameraTarget_offZ, camera_roll, camera_viewData.FOV)
        return true
    end
}

for i, j in imports.pairs(CCamera.CInstance) do
    if i ~= "native" then
        imports.setObjectScale(j, 0)
        imports.setElementAlpha(j, 0)
        imports.setElementCollisionsEnabled(j, false)
    end
end
--[[
--TODO: DISABLE FOR NOW..
CCamera.updateCameraSway()
imports.addEventHandler("onClientCursorMove", root, CCamera.updateMouseRotation)
imports.addEventHandler("onClientPedsProcessed", root, CCamera.renderCamera)
imports.addEventHandler("onClientPreRender", root, CCamera.renderEntity)
]]