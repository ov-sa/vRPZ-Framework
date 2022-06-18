loadstring(exports.assetify_library:import("*"))()

local totalLightCreated = 0
local coronaTexture = dxCreateTexture("models/corona2.png")

bindKey("z", "down", function()
    local __position = {getElementPosition(localPlayer)}
    local cLight = assetify.light.planar.create("planar_1x1", {
        position = {x = __position[1], y = __position[2], z = __position[3] - 1},
        dimension = getElementDimension(localPlayer),
        interior = getElementInterior(localPlayer)
    }, {}, true)

    assetify.light.planar.setResolution(cLight, math.random(100, 200)/100)
    assetify.light.planar.setTexture(cLight, coronaTexture)
    assetify.light.planar.setColor(cLight, math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
    --assetify.light.planar.setColor(cLight, 255, 255, 255, 255)

    totalLightCreated = totalLightCreated + 1
    print("TOTAL LIGHTS CURRENTLY: "..totalLightCreated)
end)