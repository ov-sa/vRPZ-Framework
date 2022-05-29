--
-- c_exported_functions.lua
--

function createBillboard(texImage,posX,posY,posZ,sizeX,sizeY,colorR,colorG,colorB,colorA)
	local reqParam = {posX,posY,posZ,sizeX,sizeY,colorR,colorG,colorB,colorA}
	local isThisValid = true
	local countParam = 0
	for m, param in ipairs(reqParam) do
		countParam = countParam + 1
		isThisValid = isThisValid and param ~= nil and (type(param) == "number")
	end
	if not isThisValid or ( #reqParam ~= 9 ) or ( countParam ~= 9 ) or not isElement( texImage ) then
		outputDebugString('createBillboard fail!')
		return false 
	end
	local SHBelementID = funcTable.create(texImage,posX,posY,posZ,sizeX,sizeY,colorR,colorG,colorB,colorA)
	return createElement("SHCustomBillboard",tostring(SHBelementID))
end

function destroyBillboard(w)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	if type(SHBelementID) == "number" then
		return destroyElement(w) and funcTable.destroy(SHBelementID)
	else
		outputDebugString('destroyBillboard fail!')
		return false
	end
end

function setBillboardMaterial(w,texImage)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	if billboardTable.inputBillboards[SHBelementID] and isElement(texImage)  then
		billboardTable.isInValChanged = true
		return funcTable.setMaterial(SHBelementID,texImage)
	else
		outputDebugString('setBillboardMaterial fail!')
		return false
	end
end

function setBillboardPosition(w,posX,posY,posZ)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	local reqParam = {SHBelementID,posX,posY,posZ}
	local isThisValid = true
	local countParam = 0
	for m, param in ipairs(reqParam) do
		countParam = countParam + 1
		isThisValid = isThisValid and param and (type(param) == "number")
	end
	if billboardTable.inputBillboards[SHBelementID] and isThisValid  and (countParam == 4) then
		billboardTable.inputBillboards[SHBelementID].pos = {posX,posY,posZ}
		billboardTable.isInValChanged = true
		return true
	else
		outputDebugString('setBillboardPosition fail!')
		return false
	end
end

function setBillboardColor(w,colorR,colorG,colorB,colorA)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	local reqParam = {SHBelementID,colorR,colorG,colorB,colorA}
	local isThisValid = true
	local countParam = 0
	for m, param in ipairs(reqParam) do
		countParam = countParam + 1
		isThisValid = isThisValid and param and (type(param) == "number")
	end
	if billboardTable.inputBillboards[SHBelementID] and isThisValid  and (countParam == 5)  then
		billboardTable.inputBillboards[SHBelementID].color = {colorR,colorG,colorB,colorA}
		billboardTable.isInValChanged = true
		return true
	else
		outputDebugString('setBillboardColor fail!')
		return false
	end
end

function setBillboardSize(w,size)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	if billboardTable.inputBillboards[SHBelementID] and (type(size) == "number") then 
		billboardTable.inputBillboards[SHBelementID].size = {size,size}
		billboardTable.inputBillboards[SHBelementID].dBias = math.min(size,1)
		billboardTable.isInValChanged = true
		return true
	else
		outputDebugString('setBillboardSize fail!')
		return false
	end
end

function setBillboardSizeXY(w,sizeX,sizeY)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	if billboardTable.inputBillboards[SHBelementID] and (type(sizeX) == "number") and (type(sizeY) == "number") then 
		billboardTable.inputBillboards[SHBelementID].size = {sizeX,sizeY}
		billboardTable.inputBillboards[SHBelementID].dBias = math.min((sizeX + sizeY)/2,1)
		billboardTable.isInValChanged = true
		return true
	else
		outputDebugString('setBillboardSizeXY fail!')
		return false
	end
end

function setBillboardDepthBias(w,depthBias)
	if not isElement(w) then 
		return false
	end
	local SHBelementID = tonumber(getElementID(w))
	if billboardTable.inputBillboards[SHBelementID] and (type(depthBias) == "number") then 
		billboardTable.inputBillboards[SHBelementID].dBias = depthBias
		billboardTable.isInValChanged = true
		return true
	else
		outputDebugString('setBillboardDepthBias fail!')
		return false
	end
end

function setBillboardDistFade(dist1,dist2)
	if (type(dist1) == "number") and (type(dist2) == "number") then
		return funcTable.setDistFade(dist1,dist2)
	else
		outputDebugString('setBillboardDistFade fail!')
		return false
	end
end

function enableDepthBiasScale(depthBiasEnable)
	if type(depthBiasEnable) == "boolean" then
		billboardTable.depthBias = depthBiasEnable
		return true
	else
		outputDebugString('enableDepthBiasScale fail!')
		return false
	end
end