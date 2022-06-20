loadstring(exports.beautify_library:fetchImports())()
loadstring(exports.assetify_library:import("*"))()

local testShader, testImage = exports.test:fetch()
local width, height = 200, 200
local testRT = beautify.native.createRenderTarget(width, height, true)

beautify.native.setShaderValue(testShader, "baseTexture", testImage)

addEventHandler("onClientRender", root, function()
    beautify.native.drawImage(0, 0, width, height, testShader, 0, 0, 0, -1) --Drawn without passing into RT

    beautify.native.setRenderTarget(testRT, true)
    beautify.native.drawImage(0, 0, width, height, testShader, 0, 0, 0, -1)
    beautify.native.setRenderTarget()

    beautify.native.drawImage(0, height + 20, width, height, testRT, 0, 0, 0, -1) --Drawn RT pasing the shader values
end)