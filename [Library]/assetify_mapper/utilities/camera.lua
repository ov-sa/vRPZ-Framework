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
    math = math
}


-----------------------
--[[ Class: camera ]]--
-----------------------

camera = {
    speed = 0, strafespeed = 0,
    rotX = 0, rotY = 0,
    velocityX = 0, velocityY = 0, velocityZ = 0
}
camera.__index = camera


local options = {
	normalMaxSpeed = 2,
	slowMaxSpeed = 0.2,
	fastMaxSpeed = 12,
	smoothMovement = true,
	acceleration = 0.3,
	decceleration = 0.15,
	mouseSensitivity = 0.3,
	maxYAngle = 188,
	key_fastMove = "lshift",
	key_slowMove = "lalt",
	key_forward = "forwards",
	key_backward = "backwards",
	key_left = "left",
	key_right = "right"
}

local function freecamFrame ()
    local freeModeAngleX, freeModeAngleY, freeModeAngleZ = imports.math.cos(camera.rotY)*imports.math.sin(camera.rotX), imports.math.cos(camera.rotY)*imports.math.cos(camera.rotX), imports.math.sin(camera.rotY)
    local camPosX, camPosY, camPosZ = getCameraMatrix()
    local camTargetX, camTargetY, camTargetZ = camPosX + (freeModeAngleX*100), camPosY + (freeModeAngleY*100)
    local mspeed = (getPedControlState(options.key_fastMove) and options.fastMaxSpeed) or (getPedControlState(options.key_slowMove) and options.slowMaxSpeed) or options.normalMaxSpeed

	if options.smoothMovement then
		local acceleration, decceleration = options.acceleration, options.decceleration

	    -- Check to see if the forwards/backwards keys are pressed
	    local speedKeyPressed = false
	    if getPedControlState(options.key_forward) and not getKeyState("arrow_u") then
			camera.speed = camera.speed + acceleration
	        speedKeyPressed = true
	    end
		if getPedControlState(options.key_backward) and not getKeyState("arrow_d") then
			camera.speed = camera.speed - acceleration
	        speedKeyPressed = true
	    end

	    -- Check to see if the strafe keys are pressed
	    local strafeSpeedKeyPressed = false
		if getPedControlState(options.key_right) and not getKeyState("arrow_r") then
	        if camera.strafespeed > 0 then -- for instance response
	            camera.strafespeed = 0
	        end
	        camera.strafespeed = camera.strafespeed - acceleration / 2
	        strafeSpeedKeyPressed = true
	    end
		if getPedControlState(options.key_left) and not getKeyState("arrow_l") then
	        if camera.strafespeed < 0 then -- for instance response
	            camera.strafespeed = 0
	        end
	        camera.strafespeed = camera.strafespeed + acceleration / 2
	        strafeSpeedKeyPressed = true
	    end

	    -- If no forwards/backwards keys were pressed, then gradually slow down the movement towards 0
	    if speedKeyPressed ~= true then
			if camera.speed > 0 then
				camera.speed = camera.speed - decceleration
			elseif camera.speed < 0 then
				camera.speed = camera.speed + decceleration
			end
	    end

	    -- If no strafe keys were pressed, then gradually slow down the movement towards 0
	    if strafeSpeedKeyPressed ~= true then
			if camera.strafespeed > 0 then
				camera.strafespeed = camera.strafespeed - decceleration
			elseif camera.strafespeed < 0 then
				camera.strafespeed = camera.strafespeed + decceleration
			end
	    end

	    -- Check the ranges of values - set the camera.speed to 0 if its very close to 0 (stops jittering), and limit to the maximum camera.speed
	    if camera.speed > -decceleration and camera.speed < decceleration then
	        camera.speed = 0
	    elseif camera.speed > mspeed then
	        camera.speed = mspeed
	    elseif camera.speed < -mspeed then
	        camera.speed = -mspeed
	    end

	    if camera.strafespeed > -(acceleration / 2) and camera.strafespeed < (acceleration / 2) then
	        camera.strafespeed = 0
	    elseif camera.strafespeed > mspeed then
	        camera.strafespeed = mspeed
	    elseif camera.strafespeed < -mspeed then
	        camera.strafespeed = -mspeed
	    end
	else
		camera.speed = 0
		camera.strafespeed = 0
		if getPedControlState(options.key_forward) then
			camera.speed = mspeed
		end
		if getPedControlState(options.key_backward) then
			camera.speed = -mspeed
		end
		if getPedControlState(options.key_left) then
			camera.strafespeed = mspeed
		end
		if getPedControlState(options.key_right) then
			camera.strafespeed = -mspeed
		end
	end

    -- Work out the distance between the target and the camera (should be 100 units)
    local camAngleX = camPosX - camTargetX
    local camAngleY = camPosY - camTargetY
    local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

    -- Calulcate the length of the vector
    local angleLength = imports.math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

    -- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
    local camNormalizedAngleX = camAngleX / angleLength
    local camNormalizedAngleY = camAngleY / angleLength
    local camNormalizedAngleZ = 0

    -- We use this as our rotation vector
    local normalAngleX = 0
    local normalAngleY = 0
    local normalAngleZ = 1

    -- Perform a cross product with the rotation vector and the normalzied angle
    local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
    local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
    local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

    -- Update the camera position based on the forwards/backwards camera.speed
    camPosX = camPosX + freeModeAngleX * camera.speed
    camPosY = camPosY + freeModeAngleY * camera.speed
    camPosZ = camPosZ + freeModeAngleZ * camera.speed

    -- Update the camera position based on the strafe camera.speed
    camPosX = camPosX + normalX * camera.strafespeed
    camPosY = camPosY + normalY * camera.strafespeed
    camPosZ = camPosZ + normalZ * camera.strafespeed

	--Store the velocity
	camera.velocityX = (freeModeAngleX * camera.speed) + (normalX * camera.strafespeed)
	camera.velocityY = (freeModeAngleY * camera.speed) + (normalY * camera.strafespeed)
	camera.velocityZ = (freeModeAngleZ * camera.speed) + (normalZ * camera.strafespeed)

    -- Update the target based on the new camera position (again, otherwise the camera kind of sways as the target is out by a frame)
    camTargetX = camPosX + freeModeAngleX * 100
    camTargetY = camPosY + freeModeAngleY * 100
    camTargetZ = camPosZ + freeModeAngleZ * 100
    -- Set the new camera position and target
    setCameraMatrix (camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, 0, 45)
end

camera.controlMouse = function(_, _, aX, aY)
    if CLIENT_MTA_WINDOW_ACTIVE or CLIENT_IS_CURSOR_SHOWING then return false end
    aX, aY = aX - CLIENT_MTA_RESOLUTION[1]*0.5, aY - CLIENT_MTA_RESOLUTION[2]*0.5
    camera.rotX, camera.rotY = camera.rotX + (aX*0.01745), camera.rotY - (aY*0.01745)
    local mulX, mulY = 2*imports.math.pi, imports.math.pi/2.05
	if camera.rotX > imports.math.pi then
        camera.rotX = camera.rotX - mulX
	elseif camera.rotX < -imports.math.pi then
        camera.rotX = camera.rotX + mulX
	end
	if camera.rotY > imports.math.pi then
        camera.rotY = camera.rotY - mulX
	elseif camera.rotY < -imports.math.pi then
        camera.rotY = camera.rotY + mulX
	end
    if camera.rotY < -mulY then
        camera.rotY = -mulY
    elseif camera.rotY > mulY then
        camera.rotY = mulY
    end
end

function camera:enable()
	imports.addEventHandler("onClientRender", root, freecamFrame)
	imports.addEventHandler("onClientCursorMove", root, camera.controlMouse)
	return true
end

function camera:disable()
	camera.speed, camera.strafespeed = 0, 0
	camera.velocityX, camera.velocityY, camera.velocityZ = 0, 0, 0
	imports.removeEventHandler("onClientRender", root, freecamFrame)
    imports.removeEventHandler("onClientCursorMove", root, camera.controlMouse)
	return true
end