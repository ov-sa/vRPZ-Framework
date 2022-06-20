--[[
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


local coronaTexture = dxCreateTexture("models/fire1.png")

local totalLightCreated = 0
bindKey("z", "down", function()
    totalLightCreated = totalLightCreated + 1
    local cPosition = {getElementPosition(localPlayer)}
    cPosition[3] = cPosition[3] + 200
    local cLight = createObject(lightModels.plane.modelID, cPosition[1], cPosition[2], cPosition[3], 0, 0, 0, true)

    local planeLightShader = dxCreateShader("fx/planelight.fx", 10000, 0, false, "all")
    engineApplyShaderToWorldTexture(planeLightShader, "assetify_light_plane", cLight)
    dxSetShaderValue(planeLightShader, "vSource", vSource)
    dxSetShaderValue(planeLightShader, "baseTexture", coronaTexture)
    dxSetShaderValue(planeLightShader, "lightColor", 0.1, 0.1, 0.1)
    setElementDoubleSided(cLight, true)
    setElementStreamable(clight, false)
    print("TOTAL LIGHTS CURRENTLY: "..totalLightCreated)
end)
]]

print("Booted")
loadstring(exports.player_handler:fetchImports())()
--[[
async(function(self)
    local value = self:await(CGame.getServerTick(self))
    print(value)
end):resume()
]]