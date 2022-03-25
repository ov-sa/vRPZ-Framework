----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: utilities: camera.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Camera Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    getCameraMatrix = getCameraMatrix,
    setCameraMatrix = setCameraMatrix,
    getKeyState = getKeyState,
    getPedControlState = getPedControlState,
    math = math
}


-----------------------
--[[ Class: camera ]]--
-----------------------

camera = {
    speed = 0, strafespeed = 0,
    rotation = {x = 0, y = 0},
    options = {
        normalMaxSpeed = 2,
        slowMaxSpeed = 0.2,
        fastMaxSpeed = 12,
        key_fastMove = "lshift",
        key_slowMove = "lalt",
        key_forward = "forwards",
        key_backward = "backwards",
        key_left = "left",
        key_right = "right"
    }
}
camera.__index = camera

local function freecamFrame ()
    local freeModeAngleX, freeModeAngleY, freeModeAngleZ = imports.math.cos(camera.rotation.y)*imports.math.sin(camera.rotation.x), imports.math.cos(camera.rotation.y)*imports.math.cos(camera.rotation.x), imports.math.sin(camera.rotation.y)
    local camPosX, camPosY, camPosZ = imports.getCameraMatrix()
    local camTargetX, camTargetY, camTargetZ = camPosX + (freeModeAngleX*100), camPosY + (freeModeAngleY*100)
    local mspeed = (imports.getPedControlState(camera.options.key_fastMove) and camera.options.fastMaxSpeed) or (imports.getPedControlState(camera.options.key_slowMove) and camera.options.slowMaxSpeed) or camera.options.normalMaxSpeed

    camera.speed = 0
    camera.strafespeed = 0
    if imports.getPedControlState(camera.options.key_forward) then
        camera.speed = mspeed
    elseif imports.getPedControlState(camera.options.key_backward) then
        camera.speed = -mspeed
    end
    if imports.getPedControlState(camera.options.key_left) then
        camera.strafespeed = mspeed
    elseif imports.getPedControlState(camera.options.key_right) then
        camera.strafespeed = -mspeed
    end
    local angleX, angleY, angleZ = camPosX - camTargetX, camPosY - camTargetY, 0
    local angleLength = imports.math.sqrt((angleX*angleX) + (angleY*angleY) + (angleZ*angleZ))
    local normalX, normalY, normalZ = angleY/angleLength, -angleX/angleLength, 0
    camPosX, camPosY, camPosZ = camPosX + (freeModeAngleX*camera.speed) + (normalX*camera.strafespeed), camPosY + (freeModeAngleY*camera.speed) + (normalY*camera.strafespeed), camPosZ + (freeModeAngleZ*camera.speed) + (normalZ*camera.strafespeed)
    camTargetX, camTargetY, camTargetZ = camPosX + (freeModeAngleX*100), camPosY + (freeModeAngleY*100), camPosZ + (freeModeAngleZ*100)
    imports.setCameraMatrix(camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, 0, 45)
end

camera.controlMouse = function(_, _, aX, aY)
    if CLIENT_MTA_WINDOW_ACTIVE or CLIENT_IS_CURSOR_SHOWING then return false end
    aX, aY = aX - CLIENT_MTA_RESOLUTION[1]*0.5, aY - CLIENT_MTA_RESOLUTION[2]*0.5
    camera.rotation.x, camera.rotation.y = camera.rotation.x + (aX*0.05*0.01745), camera.rotation.y - (aY*0.05*0.01745)
    local mulX, mulY = 2*imports.math.pi, imports.math.pi/2.05
	if camera.rotation.x > imports.math.pi then
        camera.rotation.x = camera.rotation.x - mulX
	elseif camera.rotation.x < -imports.math.pi then
        camera.rotation.x = camera.rotation.x + mulX
	end
	if camera.rotation.y > imports.math.pi then
        camera.rotation.y = camera.rotation.y - mulX
	elseif camera.rotation.y < -imports.math.pi then
        camera.rotation.y = camera.rotation.y + mulX
	end
    if camera.rotation.y < -mulY then
        camera.rotation.y = -mulY
    elseif camera.rotation.y > mulY then
        camera.rotation.y = mulY
    end
end

function camera:enable()
    if camera.isEnabled then return false end
    camera.speed, camera.strafespeed = 0, 0
	imports.addEventHandler("onClientRender", root, freecamFrame)
	imports.addEventHandler("onClientCursorMove", root, camera.controlMouse)
    camera.isEnabled = true
	return true
end

function camera:disable()
    if not camera.isEnabled then return false end
	imports.removeEventHandler("onClientRender", root, freecamFrame)
    imports.removeEventHandler("onClientCursorMove", root, camera.controlMouse)
    camera.isEnabled = false
	return true
end