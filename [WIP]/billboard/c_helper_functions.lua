--
-- c_helper_functions.lua
--

---------------------------------------------------------------------------------------------------
-- Version check
---------------------------------------------------------------------------------------------------
function isMTAUpToDate()
	local mtaVer = getVersion().sortable
	outputDebugString("MTA Version: "..tostring(mtaVer))
	if getVersion ().sortable < "1.3.4-9.05899" then
		return false
	else
		return true
	end
end

---------------------------------------------------------------------------------------------------
-- dxGetStatus for diag
---------------------------------------------------------------------------------------------------
addCommandHandler( "dxGetStatus",
function()
	if isDebugViewActive() then 
		local info = dxGetStatus()
		local ver = getVersion().sortable
		local outStr = 'MTAVersion:'..ver..'dxGetStatus: '
		for k,v in pairs(info) do
			outStr = outStr..' '..k..': '..tostring(v)..'  ,'
		end
		outputDebugString(outStr)
		setClipboard(outStr)
		outputChatBox('---dxGetStatus copied to clipboard---' )
	end
end
)

---------------------------------------------------------------------------------------------------
-- debug billboards
---------------------------------------------------------------------------------------------------
local billboardDebugSwitch = false

addCommandHandler( "debugCustomBillboards",
function()
	if isDebugViewActive() then 
		billboardDebugSwitch = switchDebugBillboards(not billboardDebugSwitch)
	end
end
)

function switchDebugBillboards(switch)
	if switch then
		addEventHandler("onClientRender",root,renderDebugBillboards)
	else
		outputDebugString('Debug mode: OFF')
		removeEventHandler("onClientRender",root,renderDebugBillboards)
	end
	return switch
end

local scx,scy = guiGetScreenSize()
function renderDebugBillboards()
	dxDrawText(fpscheck()..' FPS',scx/2,25)
	if (#billboardTable.outputBillboards<1) then 
		return
	end
	dxDrawText(billboardTable.thisBillboard..'/'..billboardTable.maxBillboards,scx/2,10)
	for index,this in ipairs(billboardTable.outputBillboards) do
		if this.enabled then
			local siX, siY = math.max(10 * this.size[1], 2), math.max(10 * this.size[2], 2)
			local xVal, yVal, xStr, yStr, dist, sx, sy = getBoxScreenParams(scx, scy, this.pos[1], this.pos[2], this.pos[3], siX, siY)
			local col = tocolor(this.color[1], this.color[2], this.color[3], this.color[4])
			if xVal and yVal then
				dxDrawRectangle ( xVal, yVal, 1, yStr, col)
				dxDrawRectangle ( xVal, yVal, xStr, 1, col)
				dxDrawRectangle ( xVal, yVal + yStr-1, xStr, 1, col)
				dxDrawRectangle ( xVal + xStr - 1, yVal, 1, yStr, col)
			end
		end
	end
end

function getBoxScreenParams(szx, szy, hx, hy, hz, sizeX, sizeY)
	local sx, sy = getScreenFromWorldPosition(hx, hy, hz, 0.25, true)
	if sx and sy then
		local cx, cy, cz, clx, cly, clz, crz, cfov = getCameraMatrix()
		local dist = getDistanceBetweenPoints3D(hx, hy, hz, cx, cy, cz)
		local xMult = szx/800/70 * cfov * sizeX
		local yMult = szy/600/70 * cfov * sizeY
		local xVal = sx-(100/dist) * xMult
		local yVal = sy-(100/dist) * yMult
		local xStr = (200/dist) * xMult
		local yStr = (200/dist) * yMult
		return xVal, yVal, xStr, yStr, dist, sx, sy
	else
		return false
	end
end

local frames,lastsec,fpsOut = 0,0,0
function fpscheck()
	local frameticks = getTickCount()
	frames = frames + 1
	if frameticks - 1000 > lastsec then
		local prog = ( frameticks - lastsec )
		lastsec = frameticks
		fps = frames / (prog / 1000)
		frames = fps * ((prog - 1000) / 1000)
		fpsOut = tostring(math.floor( fps ))
	end
	return fpsOut
end

---------------------------------------------------------------------------------------------------
-- billboard sorting
---------------------------------------------------------------------------------------------------
function sortedOutput(inTable,isSo,distFade,maxEntities)
	local outTable = {}
	for index,value in ipairs(inTable) do
		if inTable[index].enabled then
			local dist = getElementFromCameraDistance(value.pos[1],value.pos[2],value.pos[3])
			if dist <= distFade then 
				local w = #outTable + 1
				if not outTable[w] then 
					outTable[w] = {} 
				end
				outTable[w].enabled = value.enabled
				outTable[w].shader = value.shader
				outTable[w].size =  value.size
				outTable[w].dBias = value.dBias
				outTable[w].pos = value.pos
				outTable[w].dist = dist
				outTable[w].color = value.color	
			end
		end
	end
		if isSo and (#outTable > maxEntities) then
			table.sort(outTable, function(a, b) return a.dist < b.dist end)
		end
	return outTable
end

function findEmptyEntry(inTable)
	for index,value in ipairs(inTable) do
		if not value.enabled then
			return index
		end
	end
	return #inTable + 1
end

function getElementFromCameraDistance(hx,hy,hz)
	local cx,cy,cz,clx,cly,clz,crz,cfov = getCameraMatrix()
	return getDistanceBetweenPoints3D( hx, hy, hz, cx, cy, cz )
end
