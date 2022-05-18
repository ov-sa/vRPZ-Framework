--TODO: REMOVE LATER

CGame.execOnModuleLoad(function()
    local testPed = createPed(0, 0, 0, 0)
    setElementAlpha(testPed, 0)
    setElementData(testPed, "Loot:Type", "something")
    setElementData(testPed, "Loot:Name", "Test Loot")
    for i, j in pairs(CInventory.CItems) do
        CInventory.addItemCount(testPed, i, 1)
    end
end)