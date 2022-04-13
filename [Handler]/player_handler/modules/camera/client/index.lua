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
    interpolateBetween = interpolateBetween,
    math = math
}


----------------
--[[ Module ]]--
----------------

CCamera = {
    CCache = {
        camera = {
            offX = {value = 0, animValue = 0}, posY = {value = 0, animValue = 0}, posZ = {value = 0, animValue = 0},
            rotX = {value = 0, animValue = 0, cameraValue = 0}, rotY = {value = 0, animValue = 0, cameraValue = 0}, rotZ = {value = 0, animValue = 0}
        }
    },
    CInstance = {native = imports.getCamera(), dummy = imports.createObject(1866, 0, 0, 0), instance = imports.createObject(1866, 0, 0, 0)},
    CView = {
        ["player"] = {},
        ["vehicle"] = {}
    },
    CControl = {
        movement = {"forwards", "backwards", "left", "right"},
        ADS = "lshift"
    }

    isClientAiming = function()
        return imports.getPedControlState(localPlayer, "aim_weapon")
    end,

    isClientOnADS = function()
        return imports.getKeyState(CCamera.CControl.ADS)
    end,

    isClientDucked = function()
        return imports.isPedDucked(localPlayer)
    end,

    isClientMoving = function()
        for i = 1, 4, 1 do
            local j = CCamera.CControl.movement[i]
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
        if not CCamera.CView[view] or (CCamera.CView == view) then return false end
        CCamera.CView = view
        return true
    end,

    updateCamera = function(offX, offY, offZ, rotX, rotY, rotZ)
        offX, offY, offZ = offX or 0, offY or 0, offZ = offZ or 0
        rotX, rotY, rotZ = rotX or 0, rotY or 0, rotZ or 0
        imports.setElementPosition(CCamera.CInstance.dummy, imports.getElementBonePosition(localPlayer, 7))
        imports.setElementRotation(CCamera.CInstance.dummy, imports.getElementRotation(localPlayer))
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

    updateMouseRotation = function(_, _, aX, aY)
        --if CLIENT_MTA_WINDOW_ACTIVE or CLIENT_IS_CURSOR_SHOWING then return false end
        --if camera.isCursorVisible or not camera.cursorTick or ((CLIENT_CURRENT_TICK - camera.cursorTick) <= 500) then return false end
        aX, aY = aX - CLIENT_MTA_RESOLUTION[1]*0.5, aY - CLIENT_MTA_RESOLUTION[2]*0.5
        CCamera.CCache.camera.rotX.value, CCamera.CCache.camera.rotY.value = CCamera.CCache.camera.rotX.value + (aX*0.05*0.01745), CCamera.CCache.camera.rotY.value - (aY*0.05*0.01745)
        local mulX, mulY = 2*imports.math.pi, imports.math.pi/2.05
        if CCamera.CCache.camera.rotX.value > imports.math.pi then
            CCamera.CCache.camera.rotX.value = CCamera.CCache.camera.rotX.value - mulX
        elseif CCamera.CCache.camera.rotX.value < -imports.math.pi then
            CCamera.CCache.camera.rotX.value = CCamera.CCache.camera.rotX.value + mulX
        end
        if CCamera.CCache.camera.rotY.value > imports.math.pi then
            CCamera.CCache.camera.rotY.value = CCamera.CCache.camera.rotY.value - mulX
        elseif CCamera.CCache.camera.rotY.value < -imports.math.pi then
            CCamera.CCache.camera.rotY.value = CCamera.CCache.camera.rotY.value + mulX
        end
        if CCamera.CCache.camera.rotY.value < -mulY then
            CCamera.CCache.camera.rotY.value = -mulY
        elseif CCamera.CCache.camera.rotY.value > mulY then
            CCamera.CCache.camera.rotY.value = mulY
        end
    end
}

for i, j in imports.pairs(CCamera.CInstance) do
    if i ~= "native" then
        imports.setObjectScale(j, 0)
        imports.setElementAlpha(j, 0)
        imports.setElementCollisionsEnabled(j, false)
    end
end