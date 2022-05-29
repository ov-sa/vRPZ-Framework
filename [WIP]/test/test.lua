loadstring(exports.assetify_library:fetchImports())()

local vSource = assetify.renderer.getVirtualSource()
local lightModels = {
    plane = {modelID = 1866, modelName = "planelight"}
}

for i, j in pairs(lightModels) do
    local txd, dff = engineLoadTXD("models/"..j.modelName..".txd"), engineLoadDFF("models/"..j.modelName..".dff")
    engineImportTXD(txd, j.modelID)
    engineReplaceModel(dff, j.modelID, true)
end


local totalLightCreated = 0
bindKey("z", "down", function()
    totalLightCreated = totalLightCreated + 1
    local cLight = createObject(lightModels.plane.modelID, getElementPosition(localPlayer))

    local planeLightShader = dxCreateShader("fx/planelight.fx", 10000, 0, false, "all")
    engineApplyShaderToWorldTexture(planeLightShader, "assetify_light_plane", cLight)
    dxSetShaderValue(planeLightShader, "vSource", vSource)
    dxSetShaderValue(planeLightShader, "lightColor", math.random(0, 255)/255, math.random(0, 255)/255, math.random(0, 255)/255)
    setElementDoubleSided(cLight, true)
    print("TOTAL LIGHTS CURRENTLY: "..totalLightCreated)
end)

addEventHandler("onClientPreRender", root, function()
    dxDrawImage(10, 10, 1366*0.3, 768*0.3, vSource)
end)