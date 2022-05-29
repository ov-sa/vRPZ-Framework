----------------------------------------
--Resource: Shader Custom Billboards  --
--Author: Ren712                      --
--Contact: knoblauch700@o2.pl         --
----------------------------------------

billboardTable = { texture = {}, inputBillboards = {} , outputBillboards = {} , thisBillboard = 0 , isInNrChanged = false,
				isInValChanged = false, isStarted = false, maxBillboards = 300, depthBias = false }
funcTable = {}

----------------------------------------------------------------------------------------------------------------------------
-- editable variables
----------------------------------------------------------------------------------------------------------------------------						
local edgeTolerance = 0.35 -- cull the effects that are off the screen
local shaderSettings = {
				gDistFade = {420, 380}, -- [0]MaxEffectFade,[1]MinEffectFade
				sCutPrec = {0.003, 0.003} -- cut the borders of an image
				}

----------------------------------------------------------------------------------------------------------------------------
-- main functions
----------------------------------------------------------------------------------------------------------------------------
function funcTable.create(texImage,posX,posY,posZ,sizeX,sizeY,colorR,colorG,colorB,colorA)
	local w = findEmptyEntry(billboardTable.inputBillboards)
	if not billboardTable.inputBillboards[w] then 
		billboardTable.inputBillboards[w] = {}
	end
	billboardTable.inputBillboards[w].enabled = true
	billboardTable.inputBillboards[w].shader = funcTable.createShader()
	billboardTable.inputBillboards[w].size = {sizeX,sizeY}
	billboardTable.inputBillboards[w].dBias = math.min((sizeX+sizeY)/2,1)
	billboardTable.inputBillboards[w].pos = {posX,posY,posZ}
	billboardTable.inputBillboards[w].color = {colorR,colorG,colorB,colorA}
	billboardTable.texture[w] = texImage
	billboardTable.isInNrChanged = true
	if not funcTable.applySettings( billboardTable.inputBillboards[w].shader ) or 
		not funcTable.applyTexture( billboardTable.inputBillboards[w].shader, billboardTable.texture[w] ) then
		outputDebugString('Have Not Created billboard ID:'..w)
		return false
	else
		outputDebugString('Created billboard ID:'..w)
		return w
	end
end

function funcTable.destroy(w)
	if billboardTable.inputBillboards[w] then
		billboardTable.inputBillboards[w].enabled = false
		billboardTable.inputBillboards[w].shader = not funcTable.destroyShader( billboardTable.inputBillboards[w].shader )
		billboardTable.isInNrChanged = true
		outputDebugString('Destroyed billboard ID:'..w)
		return not billboardTable.inputBillboards[w].shader
	else
		outputDebugString('Have Not Destroyed billboard ID:'..w)
		return false 
	end
end

function funcTable.setMaterial(w,texImage)
	if billboardTable.inputBillboards[w].enabled then
		billboardTable.texture[w] = texImage
		outputDebugString('Set billboard texture ID: '..w)
		return funcTable.applyTexture( billboardTable.inputBillboards[w].shader, billboardTable.texture[w] )
	else
		return true
	end
end

function funcTable.setDistFade(w,v)
	if  (w >= v) then
		shaderSettings.gDistFade = {w,v}
		billboardTable.isInNrChanged = true
		for index,this in ipairs( billboardTable.inputBillboards ) do
			if this.enabled then
				funcTable.applySettings( this.shader )
			end
		end
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- creating and sorting a table of active billboards
----------------------------------------------------------------------------------------------------------------------------
local tickCount = getTickCount()
addEventHandler("onClientPreRender",root, function()
	if (#billboardTable.inputBillboards == 0) then
		return 
	end
	if billboardTable.isInNrChanged then
		billboardTable.outputBillboards = sortedOutput( billboardTable.inputBillboards, true, shaderSettings.gDistFade[1], billboardTable.maxBillboards )		
		billboardTable.isInNrChanged = false
		return
	end
		if billboardTable.isInValChanged or ( tickCount + 200 < getTickCount() ) then
			billboardTable.outputBillboards = sortedOutput( billboardTable.inputBillboards, true, shaderSettings.gDistFade[1], billboardTable.maxBillboards )
			billboardTable.isInValChanged = false
			tickCount = getTickCount()
		end
end
,true ,"low-1")

----------------------------------------------------------------------------------------------------------------------------
-- display active billboards
----------------------------------------------------------------------------------------------------------------------------
addEventHandler("onClientPreRender", root, function()
	if (#billboardTable.outputBillboards == 0) then
		return 
	end 
	if not billboardTable.isStarted then 
		return 
	end
	billboardTable.thisBillboard = 0
	for index, this in ipairs( billboardTable.outputBillboards ) do
		if this.dist <= shaderSettings.gDistFade[1] and this.enabled and billboardTable.thisBillboard < billboardTable.maxBillboards then
			local isOnScrX, isOnScrY, isOnScrZ = getScreenFromWorldPosition ( this.pos[1], this.pos[2], this.pos[3], edgeTolerance, true )
			if ((( isOnScrX and isOnScrY and isOnScrZ) or ( this.dist <= shaderSettings.gDistFade[1] * 0.1 ))) then
			if this.shader then
				if billboardTable.depthBias then
					dxSetShaderValue( this.shader, "fDepthBias",this.dBias)
				else
					dxSetShaderValue( this.shader, "fDepthBias",0)
				end
				dxSetShaderValue( this.shader, "fElementPosition", this.pos[1], this.pos[2], this.pos[3])
				dxSetShaderValue( this.shader, "gVertexColor", this.color[1]/255, this.color[2]/255, this.color[3]/255, this.color[4]/255)				
				dxDrawMaterialLine3D( 0 + this.pos[1], 0 + this.pos[2], this.pos[3] - this.size[2] * 2, 0 + this.pos[1], 0 + this.pos[2], 
					this.pos[3] + this.size[2] * 2, this.shader, this.size[1] * 4, tocolor(255,255,255,254),
					0 + this.pos[1],1 +  this.pos[2],0 + this.pos[3] )	
				billboardTable.thisBillboard = billboardTable.thisBillboard + 1
			end
			end
		end
	end
end
,true ,"low-2")

----------------------------------------------------------------------------------------------------------------------------
-- add or remove shader settings 
----------------------------------------------------------------------------------------------------------------------------
function funcTable.createShader()
	local pathString = "fx/billboard.fx"
	local theShader, technique = dxCreateShader( pathString, 0, 0, false, "all" )
	if theShader then
		outputDebugString( 'Started shader tec:'..technique )
		return theShader
	else
		return false
	end
end

function funcTable.destroyShader( theShader )
	local theShader = destroyElement ( theShader )
	theShader = nil
	return not theShader
end

function funcTable.applyTexture( theShader, texImage )
	if theShader then
		dxSetShaderValue ( theShader, "gTexture", texImage )
		return true
	else
		return false
	end
end
 
function funcTable.applySettings(theShader)
	if theShader then
		dxSetShaderValue ( theShader, "gDistFade", shaderSettings.gDistFade )
		dxSetShaderValue ( theShader, "sCutPrec", shaderSettings.sCutPrec )
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- onClientResourceStart 
----------------------------------------------------------------------------------------------------------------------------	
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	if not isMTAUpToDate() then 
		outputChatBox( 'Custom billboards: The resource is not compatible with this client version!', 255, 0, 0 )
		return
	end
	billboardTable.isStarted = true
end
)
