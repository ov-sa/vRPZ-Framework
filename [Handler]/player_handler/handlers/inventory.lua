--TODO: REMOVE LATER

local testPed = createPed(0, 0, 0, 0)
setElementAlpha(testPed, 0)
assetify.syncer.setEntityData(testPed, "Loot:Type", "something")
assetify.syncer.setEntityData(testPed, "Loot:Name", "Test Loot")
assetify.syncer.setEntityData(testPed, "Inventory:MaxSlots", 10000)

CGame.execOnModuleLoad(function()
    for i, j in pairs(CInventory.CItems) do
        CInventory.addItemCount(testPed, i, 1)
    end
end)