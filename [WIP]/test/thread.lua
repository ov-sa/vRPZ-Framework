--[[
loadstring(exports.assetify_library:import())()
async(function(self)
    local value = self:await(CGame.getServerTick(self))
    print(value)
end):resume()
]]

--local cDummy = assetify.createDummy("inventory", "vRPZ_Antibiotic", false, false, {})
--print(cDummy)

--[[
--Async Emit
local cNetwork = network:create("testNetwork")

cNetwork:on(function(self, arg)
    print("Invoked Emit: Going to sleep")
    self:sleep(5000)
    print("Resumed execution")
    print(arg)
end, true)

cNetwork:emit("hi")
]]

--[[
--Async Emit-Callback
local cNetwork = network:create("testNetwork", true)

cNetwork:on(function(self, arg)
    print("Invoked Emit Callback: Going to sleep")
    self:sleep(5000)
    print("Resumed execution")
    print(arg)
    return "Completed Operation"
end, true)

thread:create(function(self)
    local value = self:await(cNetwork:emitCallback(self, "hi"))
    print(value)
end):resume()
]]

--[[
--Global & Entity Data
assetify.syncer.setGlobalData("testData", "testValue")
local value = assetify.syncer.getGlobalData("testData")
print(value)

local element = createPed(0, 0, 0, 0)

assetify.syncer.setEntityData(element, "testElementData", "testElementValue")
local value = assetify.syncer.getEntityData(element, "testElementData")
print(value)
]]