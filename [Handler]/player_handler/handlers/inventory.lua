--TODO: REMOVE LATER

local testPed = createObject(1337, 0, 0, 0)
setElementAlpha(testPed, 0)

CGame.execOnModuleLoad(function()
    CGame.setGlobalData("Loot:Test", testPed)
    CGame.setEntityData(testPed, "Loot:Type", "something")
    CGame.setEntityData(testPed, "Loot:Name", "Test Loot")
    CGame.setEntityData(testPed, "Inventory:MaxSlots", 10000)
    for i, j in pairs(CInventory.CItems) do
        CInventory.addItemCount(testPed, i, 1)
    end
end)