----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


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

CInventory.fetchParentMaxSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) or (parent ~= localPlayer) then return false end
        return imports.math.max(0, imports.tonumber(CInventory.CBuffer.maxSlots) or 0)
    end
    return imports.tonumber(imports.getElementData(parent, "Inventory:MaxSlots")) or 0
end

for i, j in imports.pairs(CInventory.CItems) do
    j.icon = imports.beautify.native.createTexture("files/images/inventory/items/"..(j.slot).."/"..i..".png", "dxt5", true, "clamp")
    j.dimensions = {CInventory.fetchSlotDimensions(j.data.weight.rows, j.data.weight.columns)}
end