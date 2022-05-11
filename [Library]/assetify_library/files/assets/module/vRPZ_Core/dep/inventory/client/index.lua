-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    beautify = beautify,
    math = math
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory.fetchSlotDimensions = function(rows, columns)
    rows, columns = imports.tonumber(rows), imports.tonumber(columns)
    if not rows or not columns then return false end
    return (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math.max(0, columns), (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math.max(0, rows)
end

for i, j in imports.pairs(CInventory.CItems) do
    j.icon = imports.beautify.native.createTexture("files/images/inventory/items/"..(j.slot).."/"..i..".png", "dxt5", true, "clamp")
    j.dimensions = {CInventory.fetchSlotDimensions(j.data.weight.rows, j.data.weight.columns)}
end