----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: inventory.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Inventory UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    addEventHandler = addEventHandler,
    collectgarbage = collectgarbage,
    bindKey = bindKey,
    isKeyOnHold = isKeyOnHold,
    isMouseClicked = isMouseClicked,
    isMouseScrolled = isMouseScrolled,
    isMouseOnPosition = isMouseOnPosition,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    getAbsoluteCursorPosition = getAbsoluteCursorPosition,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
    table = table,
    math = math,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Namespace ]]--
-------------------

local inventoryUI = assetify.namespace:create("inventoryUI")
CGame.execOnModuleLoad(function()
local inventory_margin = 4
local inventory_offsetX, inventory_offsetY = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]["Primary"].slots.rows, FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]["Primary"].slots.columns)
local vicinity_slotSize = inventory_offsetY
inventory_offsetY = inventory_offsetY + FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height + inventory_margin    
local inventory_slotColor, inventory_slotAvailableColor, inventory_slotUnavailableColor = imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[3], 75*0.15), imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[3], 100*0.15), imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[3], 100*0.15)
local inventory_rt_slotColor, inventory_rt_slotAvailableColor, inventory_rt_slotUnavailableColor = imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor[3], 75), imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor[3], 100), imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor[3], 100)
local inventoryUI = {
    cache = {keys = {scroll = {}}},
    buffer = {},
    margin = inventory_margin,
    titlebar = {
        height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.height,
        font = CGame.createFont(1, 19), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)),
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.bgColor)),
        slot = {
            height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height,
            fontPaddingY = 2, font = CGame.createFont(1, 16), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.bgColor))
        }
    },
    scroller = {
        width = FRAMEWORK_CONFIGS["UI"]["Inventory"].scroller.width, thumbHeight = FRAMEWORK_CONFIGS["UI"]["Inventory"].scroller.thumbHeight,
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].scroller.bgColor)), thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].scroller.thumbColor))
    },
    clientInventory = {
        startX = 0, startY = -inventory_offsetY,
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.bgColor)), dividerColor = imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerColor[1], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerColor[2], FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerColor[3], 255),
        slotColor = inventory_rt_slotColor, slotAvailableColor = inventory_rt_slotAvailableColor, slotUnavailableColor = inventory_rt_slotUnavailableColor,
        lockStat = {
            lockTexture = imports.beautify.assets["images"]["canvas/lock.rw"], unlockTexture = imports.beautify.assets["images"]["canvas/unlock.rw"]
        },
        equipment = {
            slotColor = inventory_slotColor, slotAvailableColor = inventory_slotAvailableColor, slotUnavailableColor = inventory_slotUnavailableColor,
            "Helmet", "Vest", "Upper", "Lower", "Shoes", "Primary", "Secondary", "Backpack"
        }
    },
    vicinityInventory = {
        width = inventory_offsetX,
        slotNameTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "inventory:vicinity:slot_name"),
        slotNameFont = CGame.createFont(1, 18), slotNameFontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotNameFontColor)),
        slotCounterFont = CGame.createFont(1, 16, true), slotCounterFontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotCounterFontColor)),
        slotSize = vicinity_slotSize, slotColor = inventory_rt_slotColor, slotAvailableColor = inventory_rt_slotAvailableColor, slotUnavailableColor = inventory_rt_slotUnavailableColor,
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.bgColor))
    },
    opacityAdjuster = {
        startX = 10, startY = 0,
        width = 27,
        range = {50, 100}
    }
}
inventory_margin, inventory_offsetX, inventory_offsetY, vicinity_slotSize = nil, nil, nil, nil
inventory_slotColor, inventory_slotAvailableColor, inventory_slotUnavailableColor, inventory_rt_slotColor, inventory_rt_slotAvailableColor, inventory_rt_slotUnavailableColor = nil, nil, nil, nil, nil, nil
inventoryUI.private.clientInventory.width, inventoryUI.private.clientInventory.height = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
inventoryUI.private.clientInventory.startX, inventoryUI.private.clientInventory.startY = inventoryUI.private.clientInventory.startX + ((CLIENT_MTA_RESOLUTION[1] - inventoryUI.private.clientInventory.width)*0.5) + (inventoryUI.private.clientInventory.width*0.5), ((CLIENT_MTA_RESOLUTION[2] + inventoryUI.private.clientInventory.startY - inventoryUI.private.clientInventory.height - inventoryUI.private.titlebar.height)*0.5)
inventoryUI.private.clientInventory.lockStat.size = inventoryUI.private.titlebar.height*0.5
inventoryUI.private.clientInventory.lockStat.startX, inventoryUI.private.clientInventory.lockStat.startY = inventoryUI.private.clientInventory.width - inventoryUI.private.clientInventory.lockStat.size, -inventoryUI.private.titlebar.height + ((inventoryUI.private.titlebar.height - inventoryUI.private.clientInventory.lockStat.size)*0.5)
for i = 1, #inventoryUI.private.clientInventory.equipment, 1 do
    local j = inventoryUI.private.clientInventory.equipment[i]
    inventoryUI.private.clientInventory.equipment[i] = imports.table.clone(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][j], true)
    inventoryUI.private.clientInventory.equipment[i].slot = j
    inventoryUI.private.clientInventory.equipment[i].width, inventoryUI.private.clientInventory.equipment[i].height = CInventory.fetchSlotDimensions(inventoryUI.private.clientInventory.equipment[i].slots.rows, inventoryUI.private.clientInventory.equipment[i].slots.columns)
end
local equipment_prevX, equipment_prevY = -inventoryUI.private.margin, inventoryUI.private.titlebar.slot.height + inventoryUI.private.clientInventory.equipment[1].height + inventoryUI.private.margin
for i = 5, 1, -1 do
    local j = inventoryUI.private.clientInventory.equipment[i]
    j.startX, j.startY = (-inventoryUI.private.margin*2) - j.width, inventoryUI.private.clientInventory.startY + inventoryUI.private.clientInventory.height + inventoryUI.private.margin - j.height + equipment_prevY
    equipment_prevY = equipment_prevY - j.height - (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.5) - inventoryUI.private.titlebar.slot.height
end
equipment_prevY = nil
for i = 6, 7, 1 do
    local j = inventoryUI.private.clientInventory.equipment[i]
    j.startX, j.startY = equipment_prevX, inventoryUI.private.clientInventory.equipment[5].startY
    equipment_prevX = equipment_prevX + (inventoryUI.private.margin*2) - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize + j.width
end
equipment_prevX = nil
equipment_prevY = -inventoryUI.private.titlebar.slot.height - inventoryUI.private.margin
for i = 8, 8, 1 do
    local j = inventoryUI.private.clientInventory.equipment[i]
    j.startX, j.startY = inventoryUI.private.clientInventory.width + (inventoryUI.private.margin*2), inventoryUI.private.clientInventory.equipment[5].startY - j.height + equipment_prevY
    equipment_prevY = equipment_prevY - j.height - (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.5) - inventoryUI.private.titlebar.slot.height
end
equipment_prevY = nil
for i = 1, #inventoryUI.private.clientInventory.equipment, 1 do
    local j = inventoryUI.private.clientInventory.equipment[i]
    j.startX, j.startY = inventoryUI.private.clientInventory.startX + j.startX, inventoryUI.private.clientInventory.startY + j.startY
end
inventoryUI.private.vicinityInventory.startX, inventoryUI.private.vicinityInventory.startY = inventoryUI.private.clientInventory.equipment[1].startX - inventoryUI.private.vicinityInventory.width - inventoryUI.private.margin - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize, inventoryUI.private.clientInventory.startY
inventoryUI.private.vicinityInventory.height = inventoryUI.private.clientInventory.equipment[6].startY + inventoryUI.private.clientInventory.equipment[6].height - inventoryUI.private.vicinityInventory.startY - inventoryUI.private.titlebar.height - inventoryUI.private.margin
inventoryUI.private.opacityAdjuster.startX, inventoryUI.private.opacityAdjuster.startY = inventoryUI.private.opacityAdjuster.startX + inventoryUI.private.clientInventory.startX + inventoryUI.private.clientInventory.width - inventoryUI.private.margin, inventoryUI.private.clientInventory.startY + inventoryUI.private.opacityAdjuster.startY - inventoryUI.private.margin
inventoryUI.private.opacityAdjuster.height = inventoryUI.private.clientInventory.equipment[8].startY - inventoryUI.private.opacityAdjuster.startY - inventoryUI.private.margin - inventoryUI.private.titlebar.slot.height

inventoryUI.private.createBGTexture = function(isRefresh)
    if CLIENT_MTA_MINIMIZED then return false end
    if isRefresh then
        if inventoryUI.private.bgTexture and imports.isElement(inventoryUI.private.bgTexture) then
            imports.destroyElement(inventoryUI.private.bgTexture)
            inventoryUI.private.bgTexture = nil
        end
    end
    if not inventoryUI.private.bgTexture then
        inventoryUI.private.bgRT = imports.beautify.native.createRenderTarget(CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], true)
        imports.beautify.native.setRenderTarget(inventoryUI.private.bgRT, true)
        local client_startX, client_startY = inventoryUI.private.clientInventory.startX - inventoryUI.private.margin, inventoryUI.private.clientInventory.startY + inventoryUI.private.titlebar.height - inventoryUI.private.margin
        local client_width, client_height = inventoryUI.private.clientInventory.width + (inventoryUI.private.margin*2), inventoryUI.private.clientInventory.height + (inventoryUI.private.margin*2)
        imports.beautify.native.drawRectangle(client_startX, client_startY - inventoryUI.private.titlebar.height, client_width, inventoryUI.private.titlebar.height, inventoryUI.private.titlebar.bgColor, false)
        imports.beautify.native.drawRectangle(client_startX, client_startY, client_width, client_height, inventoryUI.private.clientInventory.bgColor, false)
        for i = 1, #inventoryUI.private.clientInventory.equipment, 1 do
            local j = inventoryUI.private.clientInventory.equipment[i]
            local title_height = inventoryUI.private.titlebar.slot.height
            local title_startY = j.startY - inventoryUI.private.titlebar.slot.height
            imports.beautify.native.drawRectangle(j.startX, title_startY, j.width, title_height, inventoryUI.private.titlebar.slot.bgColor, false)
            imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, inventoryUI.private.clientInventory.bgColor, false)
            for k = 1, j.slots.rows - 1, 1 do
                imports.beautify.native.drawRectangle(j.startX, j.startY + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.width, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.private.clientInventory.dividerColor, false)
            end
            for k = 1, j.slots.columns - 1, 1 do
                imports.beautify.native.drawRectangle(j.startX + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.startY, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, j.height, inventoryUI.private.clientInventory.dividerColor, false)
            end
        end
        inventoryUI.private.vicinityInventory.bgTexture = (inventoryUI.private.vicinityInventory.element and true) or false
        if inventoryUI.private.vicinityInventory.bgTexture then
            local vicinity_startX, vicinity_startY = inventoryUI.private.vicinityInventory.startX - (inventoryUI.private.margin*2), inventoryUI.private.vicinityInventory.startY + inventoryUI.private.titlebar.height - inventoryUI.private.margin
            local vicinity_width, vicinity_height = inventoryUI.private.vicinityInventory.width + (inventoryUI.private.margin*2), inventoryUI.private.vicinityInventory.height + (inventoryUI.private.margin*2)
            imports.beautify.native.drawRectangle(vicinity_startX, vicinity_startY - inventoryUI.private.titlebar.height, vicinity_width, inventoryUI.private.titlebar.height, inventoryUI.private.titlebar.bgColor, false)
            imports.beautify.native.drawRectangle(vicinity_startX, vicinity_startY, vicinity_width, vicinity_height, inventoryUI.private.vicinityInventory.bgColor, false)
        end
        imports.beautify.native.drawRectangle(inventoryUI.private.opacityAdjuster.startX, inventoryUI.private.opacityAdjuster.startY, inventoryUI.private.opacityAdjuster.width, inventoryUI.private.opacityAdjuster.height, inventoryUI.private.titlebar.bgColor, false)
        imports.beautify.native.setRenderTarget()
        local rtPixels = imports.beautify.native.getTexturePixels(inventoryUI.private.bgRT)
        if rtPixels then
            inventoryUI.private.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(inventoryUI.private.bgRT)
            inventoryUI.private.bgRT = nil
        end
    end
    if not inventoryUI.private.gridTexture or CLIENT_MTA_RESTORED then
        if not inventoryUI.private.gridTexture then
            inventoryUI.private.gridWidth, inventoryUI.private.gridHeight = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows + 2, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
            inventoryUI.private.gridTexture = imports.beautify.native.createRenderTarget(inventoryUI.private.gridWidth, inventoryUI.private.gridHeight, true)
        end
        imports.beautify.native.setRenderTarget(inventoryUI.private.gridTexture, true)
        for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows + 1, 1 do
            imports.beautify.native.drawRectangle(0, (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i, inventoryUI.private.clientInventory.width, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.private.clientInventory.dividerColor, false)
        end
        for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - 1, 1 do
            imports.beautify.native.drawRectangle((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i, 0, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.private.clientInventory.height + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*2), inventoryUI.private.clientInventory.dividerColor, false)
        end
        imports.beautify.native.setRenderTarget()
    end
    return true
end

inventoryUI.private.updateUILang = function()
    for i = 1, #inventoryUI.private.clientInventory.equipment, 1 do
        local j = inventoryUI.private.clientInventory.equipment[i]
        j.title = imports.string.upper(imports.string.kern(j["Title"][(CPlayer.CLanguage)]))
    end
    return true
end
imports.assetify.network:fetch("Client:onUpdateLanguage"):on(inventoryUI.private.updateUILang)

inventoryUI.private.fetchUIGridSlotFromOffset = function(offsetX, offsetY)
    if not offsetX or not offsetY then return false end
    local row, column = imports.math.ceil(offsetY/(inventoryUI.private.clientInventory.height/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)), imports.math.ceil(offsetX/(inventoryUI.private.clientInventory.width/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns))
    row, column = (((row >= 1) and (row <= FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)) and row) or false, (((column >= 1) and (column <= FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)) and column) or false
    if not row or not column then return false end
    return row, column
end

inventoryUI.private.fetchUIGridOffsetFromSlot = function(slot)
    if not slot then return false end
    local row, column = CInventory.fetchSlotLocation(slot)
    if not row or not column then return false end
    return (column - 1)*(inventoryUI.private.clientInventory.width/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns), (row - 1)*(inventoryUI.private.clientInventory.height/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)
end

inventoryUI.private.createBuffer = function(parent, name)
    if not parent or not imports.isElement(parent) or inventoryUI.private.buffer[parent] then return false end
    if (parent ~= localPlayer) and CLoot.isLocked(parent) then
        imports.assetify.network:emit("Client:onNotification", false, "Loot is locked..", FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
        return false
    end
    inventoryUI.private.buffer[parent] = {
        name = imports.string.upper(imports.string.kern(name or CLoot.fetchName(parent))),
        bufferRT = imports.beautify.native.createRenderTarget(((parent == localPlayer) and inventoryUI.private.clientInventory.width) or inventoryUI.private.vicinityInventory.width, ((parent == localPlayer) and inventoryUI.private.clientInventory.height) or inventoryUI.private.vicinityInventory.height, true),
        scroller = {percent = 0, animPercent = 0},
        inventory = {}
    }
    inventoryUI.private.updateBuffer(parent)
    return true
end

inventoryUI.private.destroyBuffer = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if inventoryUI.private.buffer[parent] and inventoryUI.private.buffer[parent] then
        if inventoryUI.private.buffer[parent].bufferRT and imports.isElement(inventoryUI.private.buffer[parent].bufferRT) then
            imports.destroyElement(inventoryUI.private.buffer[parent].bufferRT)
        end
    end
    inventoryUI.private.buffer[parent] = nil
    return true
end

inventoryUI.private.updateBuffer = function(parent)
    if not parent or not imports.isElement(parent) or not inventoryUI.private.buffer[parent] then return false end
    inventoryUI.private.buffer[parent].maxSlots, inventoryUI.private.buffer[parent].assignedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent)
    inventoryUI.private.buffer[parent].inventory = {}
    inventoryUI.private.buffer[parent].bufferCache = nil
    for i, j in imports.pairs(CInventory.CItems) do
        local itemCount = CInventory.fetchItemCount(parent, i)
        if itemCount > 0 then
            inventoryUI.private.buffer[parent].inventory[i] = itemCount
        end
    end
    return true
end

inventoryUI.private.attachItem = function(parent, item, amount, prevSlot, prevX, prevY, prevWidth, prevHeight, offsetX, offsetY)
    if inventoryUI.private.attachedItem then return false end
    if not parent or not imports.isElement(parent) or not item or not amount or not prevSlot or not prevX or not prevY or not prevWidth or not prevHeight or not offsetX or not offsetY then return false end
    inventoryUI.private.attachedItem = {
        parent = parent, item = item, amount = amount,
        prevSlot = prevSlot, prevX = prevX, prevY = prevY,
        prevWidth = prevWidth, prevHeight = prevHeight,
        offsetX = offsetX, offsetY = offsetY,
        animTickCounter = CLIENT_CURRENT_TICK
    }
    return true
end

inventoryUI.private.detachItem = function(isForced)
    if not inventoryUI.private.attachedItem then return false end
    if not isForced then
        inventoryUI.private.attachedItem.isOnTransition = true
        inventoryUI.private.attachedItem.transitionTickCounter = CLIENT_CURRENT_TICK
    else
        inventoryUI.private.attachedItem = nil
        CGame.execOnModuleLoad(function()
            imports.assetify.scheduler.boot()
        end)
    end      
    return true
end

inventoryUI.private.addItem = function()
    inventoryUI.private.isSynced, inventoryUI.private.isSyncScheduled = false, true
    local vicinity, item, prevSlot, newSlot = inventoryUI.private.attachedItem.parent, inventoryUI.private.attachedItem.item, inventoryUI.private.attachedItem.prevSlot, inventoryUI.private.attachedItem.isPlaceable.slot
    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache[prevSlot].amount = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache[prevSlot].amount - 1
    CInventory.CBuffer.slots[newSlot] = {
        item = item,
        translation = "inventory_add"
    }
    inventoryUI.private.updateBuffer(localPlayer)
    imports.assetify.scheduler.execScheduleOnModuleLoad(function()
        imports.assetify.network:emit("Player:onAddItem", true, false, localPlayer, vicinity, item, newSlot)    
    end)
    return true
end

inventoryUI.private.orderItem = function()
    inventoryUI.private.isSynced, inventoryUI.private.isSyncScheduled = false, true
    local item, prevSlot, newSlot = inventoryUI.private.attachedItem.item, inventoryUI.private.attachedItem.prevSlot, inventoryUI.private.attachedItem.isPlaceable.slot
    CInventory.CBuffer.slots[prevSlot] = nil
    CInventory.CBuffer.slots[newSlot] = {
        item = inventoryUI.private.attachedItem.item,
        translation = "inventory_order"
    }
    inventoryUI.private.updateBuffer(localPlayer)
    imports.assetify.scheduler.execScheduleOnModuleLoad(function()
        imports.assetify.network:emit("Player:onOrderItem", true, false, localPlayer, item, prevSlot, newSlot)        
    end)
    return true
end

inventoryUI.private.dropItem = function()
    inventoryUI.private.isSynced, inventoryUI.private.isSyncScheduled = false, true
    local vicinity, item, amount, prevSlot, newSlot = inventoryUI.private.vicinityInventory.element, inventoryUI.private.attachedItem.item, inventoryUI.private.attachedItem.amount, inventoryUI.private.attachedItem.prevSlot, inventoryUI.private.attachedItem.isPlaceable.slot
    local slotBuffer = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache[newSlot]
    if not slotBuffer or (slotBuffer.item ~= item) then
        imports.table.insert(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache, newSlot, {item = item, amount = 0})
        local vicinity_bufferCount = #inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache
        inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight = imports.math.max(0, (inventoryUI.private.vicinityInventory.slotSize*vicinity_bufferCount) + (inventoryUI.private.margin*imports.math.max(0, vicinity_bufferCount - 1)) - inventoryUI.private.vicinityInventory.height)
        slotBuffer = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache[newSlot]
    end
    CInventory.CBuffer.slots[prevSlot] = nil
    inventoryUI.private.updateBuffer(localPlayer)
    imports.assetify.scheduler.execScheduleOnModuleLoad(function()
        slotBuffer.amount = slotBuffer.amount + amount
        imports.assetify.network:emit("Player:onDropItem", true, false, localPlayer, vicinity, item, amount, prevSlot)
    end)
    return true
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

inventoryUI.private.isUIEnabled = function()
    return (inventoryUI.private.isSynced and inventoryUI.private.isEnabled and not inventoryUI.private.isForcedDisabled) or false
end

function isInventoryUIVisible() return inventoryUI.private.state end
function isInventoryUIEnabled() return inventoryUI.private.isUIEnabled() end

imports.assetify.network:create("Client:onEnableInventoryUI"):on(function(state, isForced)
    if isForced then inventoryUI.private.isForcedDisabled = not state end
    inventoryUI.private.isEnabled = state
end)

imports.assetify.network:create("Client:onSyncInventoryBuffer"):on(function(buffer)
    CInventory.CBuffer = buffer
    inventoryUI.private.isSynced, inventoryUI.private.isSyncScheduled = true, false
    imports.assetify.network:emit("Client:onUpdateInventory", false)
end)

imports.assetify.network:create("Client:onUpdateInventory"):on(function()
    inventoryUI.private.detachItem(true)
    inventoryUI.private.updateBuffer(localPlayer)
    inventoryUI.private.updateBuffer(inventoryUI.private.vicinityInventory.element)
end)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

inventoryUI.private.renderUI = function(renderData)
    if not inventoryUI.private.state or not CPlayer.isInitialized(localPlayer) then return false end

    if renderData.renderType == "input" then
        inventoryUI.private.cache.keys.mouse = imports.isMouseClicked()
        inventoryUI.private.cache.keys.scroll.state, inventoryUI.private.cache.keys.scroll.streak = imports.isMouseScrolled()
        inventoryUI.private.cache.isEnabled = inventoryUI.private.isUIEnabled()
    elseif renderData.renderType == "preRender" then
        if not inventoryUI.private.bgTexture or not inventoryUI.private.gridTexture or CLIENT_MTA_RESTORED then inventoryUI.private.createBGTexture()
        elseif inventoryUI.private.vicinityInventory.bgTexture ~= ((inventoryUI.private.vicinityInventory.element and inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)] and true) or false) then inventoryUI.private.createBGTexture(true) end
        local cursorX, cursorY = imports.getAbsoluteCursorPosition()
        local isUIEnabled = inventoryUI.private.cache.isEnabled
        local isUIActionEnabled, isUIClearPlacement = isUIEnabled and not inventoryUI.private.attachedItem, true
        local isLMBClicked = (inventoryUI.private.cache.keys.mouse == "mouse1") and isUIActionEnabled
        local client_startX, client_startY = inventoryUI.private.clientInventory.startX - inventoryUI.private.margin, inventoryUI.private.clientInventory.startY + inventoryUI.private.titlebar.height - inventoryUI.private.margin
        local client_width, client_height = inventoryUI.private.clientInventory.width + (inventoryUI.private.margin*2), inventoryUI.private.clientInventory.height + (inventoryUI.private.margin*2)
        if not inventoryUI.private.buffer[localPlayer].bufferCache then
            inventoryUI.private.buffer[localPlayer].bufferCache, inventoryUI.private.buffer[localPlayer].assignedItems, inventoryUI.private.buffer[localPlayer].assignedBuffers = {}, {}, {}
            for i, j in imports.pairs(inventoryUI.private.buffer[localPlayer].inventory) do
                for k = 1, j, 1 do
                    imports.table.insert(inventoryUI.private.buffer[localPlayer].bufferCache, {item = i, amount = 1})
                end
            end
            for i, j in imports.pairs(inventoryUI.private.buffer[localPlayer].assignedSlots) do
                if not inventoryUI.private.isSynced then
                    if j.translation == "inventory_add" then
                        imports.table.insert(inventoryUI.private.buffer[localPlayer].bufferCache, {item = j.item, amount = 1})
                    end
                end
                for k = 1, #inventoryUI.private.buffer[localPlayer].bufferCache, 1 do
                    local v = inventoryUI.private.buffer[localPlayer].bufferCache[k]
                    if (j.item == v.item) and not inventoryUI.private.buffer[localPlayer].assignedItems[k] then
                        inventoryUI.private.buffer[localPlayer].assignedItems[k] = i
                        inventoryUI.private.buffer[localPlayer].assignedBuffers[i] = k
                        break
                    end
                end
            end
        end
        local client_bufferCache = inventoryUI.private.buffer[localPlayer].bufferCache
        local client_isHovered, client_isSlotHovered, equipment_isSlotHovered = imports.isMouseOnPosition(client_startX + inventoryUI.private.margin, client_startY + inventoryUI.private.margin, inventoryUI.private.clientInventory.width, inventoryUI.private.clientInventory.height), nil, nil
        imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], inventoryUI.private.bgTexture, 0, 0, 0, inventoryUI.private.opacityAdjuster.bgColor, false)
        imports.beautify.native.setRenderTarget(inventoryUI.private.buffer[localPlayer].bufferRT, true)
        imports.beautify.native.drawImage(0, 0, inventoryUI.private.gridWidth, inventoryUI.private.gridHeight, inventoryUI.private.gridTexture, 0, 0, 0, -1, false)
        for i, j in imports.pairs(inventoryUI.private.buffer[localPlayer].assignedItems) do
            if not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][j] then
                local slotBuffer = client_bufferCache[i]
                local slot_offsetX, slot_offsetY = inventoryUI.private.fetchUIGridOffsetFromSlot(j)
                local slotWidth, slotHeight = CInventory.fetchSlotDimensions(CInventory.CItems[(slotBuffer.item)].data.itemWeight.rows, CInventory.CItems[(slotBuffer.item)].data.itemWeight.columns)
                local isItemVisible, isSlotVisible = true, true
                if inventoryUI.private.attachedItem then
                    if inventoryUI.private.attachedItem.parent == localPlayer then
                        if inventoryUI.private.attachedItem.prevSlot == j then
                            isItemVisible = false
                            if inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and inventoryUI.private.attachedItem.isPlaceable.slot then
                                isSlotVisible = false
                            end
                        elseif inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.slot == j) and (inventoryUI.private.attachedItem.isPlaceable.type == "order") then
                            isItemVisible = false
                        end
                    elseif inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.slot == j) and (inventoryUI.private.attachedItem.isPlaceable.type == "order") then
                        isItemVisible = false
                    end
                end
                client_isSlotHovered = (client_isHovered and isUIActionEnabled and (client_isSlotHovered or (isItemVisible and imports.isMouseOnPosition(client_startX + inventoryUI.private.margin + slot_offsetX, client_startY + inventoryUI.private.margin + slot_offsetY, slotWidth, slotHeight) and i))) or false
                if not slotBuffer.isPositioned then
                    slotBuffer.title = imports.string.upper(CInventory.fetchItemName(slotBuffer.item) or "")                    
                    slotBuffer.width, slotBuffer.height = CInventory.fetchSlotDimensions(CInventory.CItems[(slotBuffer.item)].data.itemWeight.rows, CInventory.CItems[(slotBuffer.item)].data.itemWeight.columns)
                    slotBuffer.startX, slotBuffer.startY = (slotWidth - slotBuffer.width)*0.5, (slotHeight - slotBuffer.height)*0.5
                    slotBuffer.isPositioned = true
                end
                if isSlotVisible then
                    imports.beautify.native.drawRectangle(slot_offsetX, slot_offsetY, slotWidth, slotHeight, inventoryUI.private.clientInventory.slotColor, false)
                end
                if isItemVisible then
                    imports.beautify.native.drawImage(slot_offsetX + slotBuffer.startX, slot_offsetY + slotBuffer.startY, slotBuffer.width, slotBuffer.height, CInventory.CItems[(slotBuffer.item)].icon.inventory, 0, 0, 0, -1, false)
                end
            end
        end
        if client_isHovered then
            local slotRow, slotColumn = inventoryUI.private.fetchUIGridSlotFromOffset(cursorX - inventoryUI.private.clientInventory.startX, cursorY - (inventoryUI.private.clientInventory.startY + inventoryUI.private.titlebar.height))
            if slotRow and slotColumn then
                if inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and (not inventoryUI.private.attachedItem.isPlaceable or (inventoryUI.private.attachedItem.isPlaceable.type == "order")) then
                    isUIClearPlacement = false
                    local slot = CInventory.fetchSlotIndex(slotRow, slotColumn)
                    local slot_offsetX, slot_offsetY = inventoryUI.private.fetchUIGridOffsetFromSlot(slot)
                    local slotWidth, slotHeight = CInventory.fetchSlotDimensions(imports.math.min(CInventory.CItems[(inventoryUI.private.attachedItem.item)].data.itemWeight.rows, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows - (slotRow - 1)), imports.math.min(CInventory.CItems[(inventoryUI.private.attachedItem.item)].data.itemWeight.columns, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - (slotColumn - 1)))
                    if CInventory.isSlotAvailableForOrdering(inventoryUI.private.attachedItem.item, ((inventoryUI.private.attachedItem.parent == localPlayer) and inventoryUI.private.attachedItem.prevSlot) or false, slot, inventoryUI.private.attachedItem.parent == localPlayer) then
                        inventoryUI.private.attachedItem.isPlaceable = inventoryUI.private.attachedItem.isPlaceable or {type = "order"}
                        inventoryUI.private.attachedItem.isPlaceable.slot = slot
                        inventoryUI.private.attachedItem.isPlaceable.offsetX, inventoryUI.private.attachedItem.isPlaceable.offsetY = slot_offsetX, slot_offsetY
                        inventoryUI.private.attachedItem.isPlaceable.width, inventoryUI.private.attachedItem.isPlaceable.height = slotWidth, slotHeight
                    else
                        inventoryUI.private.attachedItem.isPlaceable = false
                    end
                    imports.beautify.native.drawRectangle(slot_offsetX, slot_offsetY, slotWidth, slotHeight, (inventoryUI.private.attachedItem.isPlaceable and inventoryUI.private.clientInventory.slotAvailableColor) or inventoryUI.private.clientInventory.slotUnavailableColor, false)
                end
            end
            if client_isSlotHovered then
                if isLMBClicked then
                    local slot_offsetX, slot_offsetY = inventoryUI.private.fetchUIGridOffsetFromSlot(inventoryUI.private.buffer[localPlayer].assignedItems[client_isSlotHovered])
                    local slot_prevX, slot_prevY = client_startX + inventoryUI.private.margin + slot_offsetX, client_startY + inventoryUI.private.margin + slot_offsetY
                    inventoryUI.private.attachItem(localPlayer, client_bufferCache[client_isSlotHovered].item, client_bufferCache[client_isSlotHovered].amount, inventoryUI.private.buffer[localPlayer].assignedItems[client_isSlotHovered], slot_prevX, slot_prevY, client_bufferCache[client_isSlotHovered].width, client_bufferCache[client_isSlotHovered].height, cursorX - slot_prevX, cursorY - slot_prevY)
                    isUIActionEnabled = false
                end
            end
        end
        if isUIClearPlacement and inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.type == "order") and not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(inventoryUI.private.attachedItem.isPlaceable.slot)] then
            inventoryUI.private.attachedItem.isPlaceable = false
        end
        imports.beautify.native.setRenderTarget()
        imports.beautify.native.drawText(inventoryUI.private.buffer[localPlayer].name, client_startX, client_startY - inventoryUI.private.titlebar.height, client_startX + client_width, client_startY, inventoryUI.private.titlebar.fontColor, 1, inventoryUI.private.titlebar.font.instance, "center", "center", true, false, false)
        imports.beautify.native.drawImage(client_startX + inventoryUI.private.clientInventory.lockStat.startX, client_startY + inventoryUI.private.clientInventory.lockStat.startY, inventoryUI.private.clientInventory.lockStat.size, inventoryUI.private.clientInventory.lockStat.size, (isUIActionEnabled and inventoryUI.private.clientInventory.lockStat.unlockTexture) or inventoryUI.private.clientInventory.lockStat.lockTexture, 0, 0, 0, inventoryUI.private.titlebar.fontColor, false)
        imports.beautify.native.drawImage(client_startX + inventoryUI.private.margin, client_startY + inventoryUI.private.margin, inventoryUI.private.clientInventory.width, inventoryUI.private.clientInventory.height, inventoryUI.private.buffer[localPlayer].bufferRT, 0, 0, 0, inventoryUI.private.opacityAdjuster.bgColor, false)
        isUIClearPlacement = true
        for i = 1, #inventoryUI.private.clientInventory.equipment, 1 do
            local j = inventoryUI.private.clientInventory.equipment[i]
            local slotBuffer = (inventoryUI.private.buffer[localPlayer].assignedBuffers[(j.slot)] and client_bufferCache[(inventoryUI.private.buffer[localPlayer].assignedBuffers[(j.slot)])]) or false
            local isItemVisible, isSlotVisible = (slotBuffer and true) or false, false
            isSlotVisible = isItemVisible
            if inventoryUI.private.attachedItem then
                if inventoryUI.private.attachedItem.parent == localPlayer then
                    if inventoryUI.private.attachedItem.prevSlot == j.slot then
                        isItemVisible = false
                        if inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and inventoryUI.private.attachedItem.isPlaceable.slot then
                            isSlotVisible = false
                        end
                    elseif inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.slot == j.slot) and (inventoryUI.private.attachedItem.isPlaceable.type == "order") then
                        isItemVisible = false
                    end
                elseif inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.slot == j.slot) and (inventoryUI.private.attachedItem.isPlaceable.type == "order") then
                    isItemVisible = false
                end
            end
            local equipment_isHovered = (not client_isHovered and imports.isMouseOnPosition(j.startX, j.startY, j.width, j.height)) or false
            equipment_isSlotHovered = (isUIActionEnabled and (equipment_isSlotHovered or (isItemVisible and equipment_isHovered and j.slot))) or false
            if slotBuffer and not slotBuffer.isPositioned then
                slotBuffer.index = i
                slotBuffer.title = imports.string.upper(CInventory.fetchItemName(slotBuffer.item) or "")                    
                slotBuffer.width, slotBuffer.height = CInventory.fetchSlotDimensions(CInventory.CItems[(slotBuffer.item)].data.itemWeight.rows, CInventory.CItems[(slotBuffer.item)].data.itemWeight.columns)
                slotBuffer.startX, slotBuffer.startY = j.startX + (j.width - slotBuffer.width)*0.5, j.startY + (j.height - slotBuffer.height)*0.5
                slotBuffer.isPositioned = true
            end
            imports.beautify.native.drawText(j.title, j.startX, j.startY - inventoryUI.private.titlebar.slot.height + inventoryUI.private.titlebar.slot.fontPaddingY, j.startX + j.width, j.startY, inventoryUI.private.titlebar.slot.fontColor, 1, inventoryUI.private.titlebar.slot.font.instance, "center", "center", true, false, false)
            if isSlotVisible then
                imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, inventoryUI.private.clientInventory.equipment.slotColor, false)
            end
            if isItemVisible then
                imports.beautify.native.drawImage(slotBuffer.startX, slotBuffer.startY, slotBuffer.width, slotBuffer.height, CInventory.CItems[(slotBuffer.item)].icon.inventory, 0, 0, 0, -1, false)
            end
            if equipment_isHovered then
                if inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and (not inventoryUI.private.attachedItem.isPlaceable or (inventoryUI.private.attachedItem.isPlaceable.type == "order")) then
                    isUIClearPlacement = false
                    if CInventory.isSlotAvailableForOrdering(inventoryUI.private.attachedItem.item, ((inventoryUI.private.attachedItem.parent == localPlayer) and inventoryUI.private.attachedItem.prevSlot) or false, j.slot, inventoryUI.private.attachedItem.parent == localPlayer) then
                        inventoryUI.private.attachedItem.isPlaceable = inventoryUI.private.attachedItem.isPlaceable or {type = "order"}
                        inventoryUI.private.attachedItem.isPlaceable.slot = j.slot
                        inventoryUI.private.attachedItem.isPlaceable.offsetX, inventoryUI.private.attachedItem.isPlaceable.offsetY = j.startX, j.startY
                        inventoryUI.private.attachedItem.isPlaceable.width, inventoryUI.private.attachedItem.isPlaceable.height = j.width, j.height
                    else
                        inventoryUI.private.attachedItem.isPlaceable = false
                    end
                    imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, (inventoryUI.private.attachedItem.isPlaceable and inventoryUI.private.clientInventory.equipment.slotAvailableColor) or inventoryUI.private.clientInventory.equipment.slotUnavailableColor, false)
                end
            end
        end
        if isUIClearPlacement and inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.type == "order") and FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(inventoryUI.private.attachedItem.isPlaceable.slot)] then
            inventoryUI.private.attachedItem.isPlaceable = false
        end
        if equipment_isSlotHovered then
            if isLMBClicked then
                local bufferIndex = inventoryUI.private.buffer[localPlayer].assignedBuffers[equipment_isSlotHovered]
                local renderIndex = client_bufferCache[bufferIndex].index
                local slot_prevX, slot_prevY = inventoryUI.private.clientInventory.equipment[renderIndex].startX, inventoryUI.private.clientInventory.equipment[renderIndex].startY
                inventoryUI.private.attachItem(localPlayer, client_bufferCache[bufferIndex].item, client_bufferCache[bufferIndex].amount, inventoryUI.private.buffer[localPlayer].assignedItems[bufferIndex], slot_prevX, slot_prevY, client_bufferCache[bufferIndex].width, client_bufferCache[bufferIndex].height, cursorX - slot_prevX, cursorY - slot_prevY)
                isUIActionEnabled = false
            end
        end
        --[[
        --TODO: ENABLE LATER INVENTORY SCROLLER
        if client_bufferCache.overflowHeight > 0 then
            if not inventoryUI.private.buffer[localPlayer].scroller.isPositioned then
                inventoryUI.private.buffer[localPlayer].scroller.startX, inventoryUI.private.buffer[localPlayer].scroller.startY = client_startX + client_width - inventoryUI.private.scroller.width, client_startY + inventoryUI.private.margin
                inventoryUI.private.buffer[localPlayer].scroller.height = inventoryUI.private.clientInventory.height
                inventoryUI.private.buffer[localPlayer].scroller.isPositioned = true
            end
            if imports.math.round(inventoryUI.private.buffer[localPlayer].scroller.animPercent, 2) ~= imports.math.round(inventoryUI.private.buffer[localPlayer].scroller.percent, 2) then
                inventoryUI.private.buffer[localPlayer].scroller.animPercent = imports.interpolateBetween(inventoryUI.private.buffer[localPlayer].scroller.animPercent, 0, 0, inventoryUI.private.buffer[localPlayer].scroller.percent, 0, 0, 0.5, "InQuad")
            end
            imports.beautify.native.drawRectangle(inventoryUI.private.buffer[localPlayer].scroller.startX, inventoryUI.private.buffer[localPlayer].scroller.startY, inventoryUI.private.scroller.width, inventoryUI.private.buffer[localPlayer].scroller.height, inventoryUI.private.scroller.bgColor, false)
            imports.beautify.native.drawRectangle(inventoryUI.private.buffer[localPlayer].scroller.startX, inventoryUI.private.buffer[localPlayer].scroller.startY + ((inventoryUI.private.buffer[localPlayer].scroller.height - inventoryUI.private.scroller.thumbHeight)*inventoryUI.private.buffer[localPlayer].scroller.animPercent*0.01), inventoryUI.private.scroller.width, inventoryUI.private.scroller.thumbHeight, inventoryUI.private.scroller.thumbColor, false)
            if inventoryUI.private.cache.keys.scroll.state and (not inventoryUI.private.attachedItem or not inventoryUI.private.attachedItem.isOnTransition) and client_isHovered then
                --TODO: WIP
                --local client_scrollPercent = imports.math.max(1, 100/(vicinity_bufferCache.overflowHeight/(inventoryUI.private.clientInventory.slotSize*0.5)))
                inventoryUI.private.buffer[localPlayer].scroller.percent = imports.math.max(0, imports.math.min(inventoryUI.private.buffer[localPlayer].scroller.percent + (client_scrollPercent*imports.math.max(1, inventoryUI.private.cache.keys.scroll.streak)*(((inventoryUI.private.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                inventoryUI.private.cache.keys.scroll.state = false
            end
        end
        ]]
        if inventoryUI.private.vicinityInventory.element and inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)] then
            local vicinity_startX, vicinity_startY = inventoryUI.private.vicinityInventory.startX - (inventoryUI.private.margin*2), inventoryUI.private.vicinityInventory.startY + inventoryUI.private.titlebar.height - inventoryUI.private.margin
            local vicinity_width, vicinity_height = inventoryUI.private.vicinityInventory.width + (inventoryUI.private.margin*2), inventoryUI.private.vicinityInventory.height + (inventoryUI.private.margin*2)
            imports.beautify.native.setRenderTarget(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferRT, true)
            if not inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache then
                local categoryPriority = {}
                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].assignedBuffers, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].unassignedBuffers = {}, {}, {}
                for i = 1, #FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Priority"], 1 do
                    local j = FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Priority"][i]
                    if CInventory.CCategories[j] then
                        categoryPriority[j] = true
                        for k, v in imports.pairs(CInventory.CCategories[j]) do
                            if inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].inventory[k] then
                                imports.table.insert(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache, {item = k, amount = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].inventory[k]})
                                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].assignedBuffers[k] = #inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache
                            else
                                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].unassignedBuffers[k] = #inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache + 1
                            end
                        end
                    end
                end
                for i, j in imports.pairs(CInventory.CCategories) do
                    if not categoryPriority[i] then
                        for k, v in imports.pairs(j) do
                            if inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].inventory[k] then
                                imports.table.insert(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache, {item = k, amount = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].inventory[k]})
                                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].assignedBuffers[k] = #inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache
                            else
                                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].unassignedBuffers[k] = #inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache + 1
                            end
                        end
                    end
                end
            end
            local vicinity_bufferCache = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache
            local vicinity_bufferCount = #vicinity_bufferCache
            local vicinity_isHovered, vicinity_isSlotHovered = imports.isMouseOnPosition(vicinity_startX + inventoryUI.private.margin, vicinity_startY + inventoryUI.private.margin, inventoryUI.private.vicinityInventory.width, inventoryUI.private.vicinityInventory.height), nil
            vicinity_bufferCache.overflowHeight = imports.math.max(0, (inventoryUI.private.vicinityInventory.slotSize*vicinity_bufferCount) + (inventoryUI.private.margin*imports.math.max(0, vicinity_bufferCount - 1)) - inventoryUI.private.vicinityInventory.height)
            local vicinity_offsetY = vicinity_bufferCache.overflowHeight*inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.animPercent*0.01
            local vicinity_rowHeight = inventoryUI.private.vicinityInventory.slotSize + inventoryUI.private.margin
            local vicinity_row_startIndex = imports.math.floor(vicinity_offsetY/vicinity_rowHeight) + 1
            local vicinity_row_endIndex = imports.math.min(vicinity_bufferCount, vicinity_row_startIndex + imports.math.ceil(inventoryUI.private.vicinityInventory.height/vicinity_rowHeight))
            isUIClearPlacement = true
            if vicinity_isHovered then
                if inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and (not inventoryUI.private.attachedItem.isPlaceable or (inventoryUI.private.attachedItem.isPlaceable.type == "drop")) then
                    isUIClearPlacement = false
                    local slot = inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].assignedBuffers[(inventoryUI.private.attachedItem.item)] or inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].unassignedBuffers[(inventoryUI.private.attachedItem.item)]
                    if CInventory.isVicinityAvailableForDropping(inventoryUI.private.vicinityInventory.element, inventoryUI.private.attachedItem.item, inventoryUI.private.attachedItem.amount, inventoryUI.private.attachedItem.parent == inventoryUI.private.vicinityInventory.element) then
                        inventoryUI.private.attachedItem.isPlaceable = inventoryUI.private.attachedItem.isPlaceable or {type = "drop"}
                        inventoryUI.private.attachedItem.isPlaceable.slot = slot
                        inventoryUI.private.attachedItem.isPlaceable.offsetX, inventoryUI.private.attachedItem.isPlaceable.offsetY = inventoryUI.private.vicinityInventory.width - ((CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[1]/CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[2])*inventoryUI.private.vicinityInventory.slotSize), (inventoryUI.private.vicinityInventory.slotSize + inventoryUI.private.margin)*(slot - 1)
                        inventoryUI.private.attachedItem.isPlaceable.width, inventoryUI.private.attachedItem.isPlaceable.height = inventoryUI.private.vicinityInventory.width, inventoryUI.private.vicinityInventory.slotSize
                    else
                        inventoryUI.private.attachedItem.isPlaceable = false
                    end
                    imports.beautify.native.drawRectangle(0, 0, inventoryUI.private.vicinityInventory.width, inventoryUI.private.vicinityInventory.height, (inventoryUI.private.attachedItem.isPlaceable and inventoryUI.private.vicinityInventory.slotAvailableColor) or inventoryUI.private.vicinityInventory.slotUnavailableColor, false)
                end
            end
            if isUIClearPlacement and inventoryUI.private.attachedItem and not inventoryUI.private.attachedItem.isOnTransition and inventoryUI.private.attachedItem.isPlaceable and (inventoryUI.private.attachedItem.isPlaceable.type == "drop") then
                inventoryUI.private.attachedItem.isPlaceable = false
            end
            for i = vicinity_row_startIndex, vicinity_row_endIndex, 1 do
                local slotBuffer = vicinity_bufferCache[i]
                slotBuffer.offsetY = (inventoryUI.private.vicinityInventory.slotSize + inventoryUI.private.margin)*(i - 1) - vicinity_offsetY
                local itemValue = (inventoryUI.private.attachedItem and (inventoryUI.private.attachedItem.parent == inventoryUI.private.vicinityInventory.element) and (inventoryUI.private.attachedItem.prevSlot == i) and (slotBuffer.amount - inventoryUI.private.attachedItem.amount)) or slotBuffer.amount
                local isItemVisible = itemValue > 0
                vicinity_isSlotHovered = (vicinity_isHovered and isUIActionEnabled and (vicinity_isSlotHovered or (isItemVisible and imports.isMouseOnPosition(vicinity_startX + inventoryUI.private.margin, vicinity_startY + inventoryUI.private.margin + slotBuffer.offsetY, vicinity_width, inventoryUI.private.vicinityInventory.slotSize) and i))) or false
                if not slotBuffer.isPositioned then
                    slotBuffer.title = imports.string.upper(CInventory.fetchItemName(slotBuffer.item) or "")
                    slotBuffer.width, slotBuffer.height = (CInventory.CItems[(slotBuffer.item)].dimensions[1]/CInventory.CItems[(slotBuffer.item)].dimensions[2])*inventoryUI.private.vicinityInventory.slotSize, inventoryUI.private.vicinityInventory.slotSize
                    slotBuffer.startX, slotBuffer.startY = inventoryUI.private.vicinityInventory.width - slotBuffer.width, 0
                    slotBuffer.isPositioned = true
                end
                if vicinity_isSlotHovered == i then
                    if slotBuffer.hoverStatus ~= "forward" then
                        slotBuffer.hoverStatus = "forward"
                        slotBuffer.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                else
                    if slotBuffer.hoverStatus ~= "backward" then
                        slotBuffer.hoverStatus = "backward"
                        slotBuffer.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                end
                slotBuffer.animAlphaPercent = slotBuffer.animAlphaPercent or 0
                if slotBuffer.hoverStatus == "forward" then
                    if slotBuffer.animAlphaPercent < 1 then
                        slotBuffer.animAlphaPercent = imports.interpolateBetween(slotBuffer.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(slotBuffer.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.75), "OutQuad")
                        slotBuffer.slotNameWidth = inventoryUI.private.vicinityInventory.width*slotBuffer.animAlphaPercent
                    end
                else
                    if slotBuffer.animAlphaPercent > 0 then
                        slotBuffer.animAlphaPercent = imports.interpolateBetween(slotBuffer.animAlphaPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(slotBuffer.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.75), "OutQuad")
                        slotBuffer.slotNameWidth = inventoryUI.private.vicinityInventory.width*slotBuffer.animAlphaPercent
                    end
                end
                imports.beautify.native.drawRectangle(0, slotBuffer.offsetY, inventoryUI.private.vicinityInventory.width, inventoryUI.private.vicinityInventory.slotSize, inventoryUI.private.vicinityInventory.slotColor, false)
                if isItemVisible then
                    local counter_offsetY = slotBuffer.offsetY + inventoryUI.private.vicinityInventory.slotSize - inventoryUI.private.margin
                    imports.beautify.native.drawImage(slotBuffer.startX, slotBuffer.offsetY + slotBuffer.startY, slotBuffer.width, slotBuffer.height, CInventory.CItems[(slotBuffer.item)].icon.inventory, 0, 0, 0, -1, false)
                    imports.beautify.native.drawText("x"..slotBuffer.amount, inventoryUI.private.margin, slotBuffer.offsetY, inventoryUI.private.vicinityInventory.width - inventoryUI.private.margin, counter_offsetY, inventoryUI.private.vicinityInventory.slotCounterFontColor, 1, inventoryUI.private.vicinityInventory.slotCounterFont.instance, "left", "bottom", true, false, false)
                end
                if slotBuffer.slotNameWidth and (slotBuffer.slotNameWidth > 0) then
                    imports.beautify.native.drawImageSection(0, slotBuffer.offsetY, slotBuffer.slotNameWidth, inventoryUI.private.vicinityInventory.slotSize, inventoryUI.private.vicinityInventory.width - slotBuffer.slotNameWidth, 0, slotBuffer.slotNameWidth, inventoryUI.private.vicinityInventory.slotSize, inventoryUI.private.vicinityInventory.slotNameTexture, 0, 0, 0, -1, false)
                    imports.beautify.native.drawText(slotBuffer.title, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.25, slotBuffer.offsetY, slotBuffer.slotNameWidth - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize, slotBuffer.offsetY + inventoryUI.private.vicinityInventory.slotSize, inventoryUI.private.vicinityInventory.slotNameFontColor, 1, inventoryUI.private.vicinityInventory.slotNameFont.instance, "left", "center", true, false, false)
                end
            end
            if vicinity_isSlotHovered then
                if isLMBClicked then
                    local slot_prevX, slot_prevY = vicinity_startX + inventoryUI.private.margin + vicinity_bufferCache[vicinity_isSlotHovered].startX, vicinity_startY + inventoryUI.private.margin + vicinity_bufferCache[vicinity_isSlotHovered].startY + vicinity_bufferCache[vicinity_isSlotHovered].offsetY
                    if imports.isMouseOnPosition(slot_prevX, slot_prevY, vicinity_bufferCache[vicinity_isSlotHovered].width, vicinity_bufferCache[vicinity_isSlotHovered].height) then
                        inventoryUI.private.attachItem(inventoryUI.private.vicinityInventory.element, vicinity_bufferCache[vicinity_isSlotHovered].item, 1, vicinity_isSlotHovered, slot_prevX, slot_prevY, vicinity_bufferCache[vicinity_isSlotHovered].width, vicinity_bufferCache[vicinity_isSlotHovered].height, cursorX - slot_prevX, cursorY - slot_prevY)
                        isUIActionEnabled = false
                    end
                end
            end
            imports.beautify.native.setRenderTarget()
            imports.beautify.native.drawText(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].name, vicinity_startX, vicinity_startY - inventoryUI.private.titlebar.height, vicinity_startX + vicinity_width, vicinity_startY, inventoryUI.private.titlebar.fontColor, 1, inventoryUI.private.titlebar.font.instance, "center", "center", true, false, false)
            imports.beautify.native.drawImage(vicinity_startX + inventoryUI.private.margin, vicinity_startY + inventoryUI.private.margin, inventoryUI.private.vicinityInventory.width, inventoryUI.private.vicinityInventory.height, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferRT, 0, 0, 0, inventoryUI.private.opacityAdjuster.bgColor, false)
            if vicinity_bufferCache.overflowHeight > 0 then
                if not inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.isPositioned then
                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startX, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startY = vicinity_startX + vicinity_width - inventoryUI.private.scroller.width, vicinity_startY + inventoryUI.private.margin
                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.height = inventoryUI.private.vicinityInventory.height
                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.isPositioned = true
                end
                if imports.math.round(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.animPercent, 2) ~= imports.math.round(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent, 2) then
                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.animPercent = imports.interpolateBetween(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.animPercent, 0, 0, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent, 0, 0, 0.5, "InQuad")
                end
                imports.beautify.native.drawRectangle(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startX, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startY, inventoryUI.private.scroller.width, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.height, inventoryUI.private.scroller.bgColor, false)
                imports.beautify.native.drawRectangle(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startX, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.startY + ((inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.height - inventoryUI.private.scroller.thumbHeight)*inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.animPercent*0.01), inventoryUI.private.scroller.width, inventoryUI.private.scroller.thumbHeight, inventoryUI.private.scroller.thumbColor, false)
                if inventoryUI.private.cache.keys.scroll.state and (not inventoryUI.private.attachedItem or not inventoryUI.private.attachedItem.isOnTransition) and vicinity_isHovered then
                    local vicinity_scrollPercent = imports.math.max(1, 100/(vicinity_bufferCache.overflowHeight/(inventoryUI.private.vicinityInventory.slotSize*0.5)))
                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent = imports.math.max(0, imports.math.min(inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent + (vicinity_scrollPercent*imports.math.max(1, inventoryUI.private.cache.keys.scroll.streak)*(((inventoryUI.private.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                    inventoryUI.private.cache.keys.scroll.state = false
                end
            end
        else
            imports.beautify.native.setRenderTarget()
        end
        inventoryUI.private.opacityAdjuster.percent = imports.beautify.slider.getPercent(inventoryUI.private.opacityAdjuster.element)
        if inventoryUI.private.opacityAdjuster.percent ~= inventoryUI.private.opacityAdjuster.animPercent then
            inventoryUI.private.opacityAdjuster.animPercent = inventoryUI.private.opacityAdjuster.percent
            inventoryUI.private.opacityAdjuster.bgColor = imports.tocolor(255, 255, 255, 255*0.01*(inventoryUI.private.opacityAdjuster.range[1] + ((inventoryUI.private.opacityAdjuster.range[2] - inventoryUI.private.opacityAdjuster.range[1])*inventoryUI.private.opacityAdjuster.percent*0.01)))
        end
        if inventoryUI.private.attachedItem then
            if not inventoryUI.private.attachedItem.isOnTransition and (CLIENT_MTA_WINDOW_ACTIVE or not imports.isKeyOnHold("mouse1") or not isUIEnabled) then
                local isPlaceAttachment = false
                if inventoryUI.private.attachedItem.isPlaceable then
                    if inventoryUI.private.attachedItem.isPlaceable.type == "order" then
                        isPlaceAttachment = true
                        if not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(inventoryUI.private.attachedItem.isPlaceable.slot)] then
                            inventoryUI.private.attachedItem.prevX, inventoryUI.private.attachedItem.prevY = client_startX + inventoryUI.private.margin + inventoryUI.private.attachedItem.isPlaceable.offsetX + ((inventoryUI.private.attachedItem.isPlaceable.width - CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[1])*0.5), client_startY + inventoryUI.private.margin + inventoryUI.private.attachedItem.isPlaceable.offsetY + ((inventoryUI.private.attachedItem.isPlaceable.height - CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[2])*0.5)
                        else
                            inventoryUI.private.attachedItem.prevX, inventoryUI.private.attachedItem.prevY = inventoryUI.private.attachedItem.isPlaceable.offsetX, inventoryUI.private.attachedItem.isPlaceable.offsetY
                        end
                        if inventoryUI.private.attachedItem.parent == localPlayer then
                            inventoryUI.private.orderItem()
                        else
                            inventoryUI.private.addItem()
                        end
                        --TODO: ADD LATER
                        --imports.assetify.network:emit("onClientInventorySound", false, "inventory_move_item")
                    elseif inventoryUI.private.attachedItem.isPlaceable.type == "drop" then
                        if inventoryUI.private.attachedItem.parent == localPlayer then
                            isPlaceAttachment = true
                            inventoryUI.private.dropItem()
                            if inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight > 0 then
                                local __slot_offsetY = inventoryUI.private.attachedItem.isPlaceable.offsetY - (inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent*inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight*0.01)
                                if __slot_offsetY < 0 or ((__slot_offsetY + inventoryUI.private.vicinityInventory.slotSize) > inventoryUI.private.vicinityInventory.height) then
                                    local slot_offsetY = inventoryUI.private.attachedItem.isPlaceable.offsetY + inventoryUI.private.vicinityInventory.slotSize
                                    inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent = imports.math.max(0, imports.math.min(100, ((slot_offsetY - inventoryUI.private.vicinityInventory.height)/inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight)*100))
                                end
                            end
                            inventoryUI.private.attachedItem.prevX, inventoryUI.private.attachedItem.prevY = inventoryUI.private.vicinityInventory.startX - inventoryUI.private.margin + inventoryUI.private.attachedItem.isPlaceable.offsetX, inventoryUI.private.vicinityInventory.startY + inventoryUI.private.titlebar.height + inventoryUI.private.attachedItem.isPlaceable.offsetY - (inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent*inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight*0.01)
                        end
                        --TODO: ADD LATER
                        --imports.assetify.network:emit("onClientInventorySound", false, "inventory_move_item")
                    end
                end
                if isPlaceAttachment then
                    inventoryUI.private.attachedItem.finalWidth, inventoryUI.private.attachedItem.finalHeight = inventoryUI.private.attachedItem.prevWidth, inventoryUI.private.attachedItem.prevHeight
                    inventoryUI.private.attachedItem.prevWidth, inventoryUI.private.attachedItem.prevHeight = inventoryUI.private.attachedItem.__width, inventoryUI.private.attachedItem.__height
                    inventoryUI.private.attachedItem.animTickCounter = CLIENT_CURRENT_TICK
                else
                    if inventoryUI.private.attachedItem.parent == localPlayer then
                        --TODO: LATER SCROLL LOCAL INVENTORY TOO..
                        --[[
                        local maxSlots = CInventory.fetchParentMaxSlots(inventoryUI.private.attachedItem.parent)
                        local totalContentHeight = inventoryUI.private.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.padding
                        local exceededContentHeight = totalContentHeight - inventoryUI.private.gui.itemBox.templates[1].contentWrapper.height
                        if exceededContentHeight > 0 then
                            local slotRow = math.ceil(inventoryUI.private.attachedItem.prevSlot/maximumInventoryRowSlots)
                            local slot_offsetY = inventoryUI.private.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, slotRow - 1)*(inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.private.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) - (exceededContentHeight*inventoryUI.private.buffer[localPlayer].gui.scroller.percent*0.01)
                            local slot_prevOffsetY = inventoryUI.private.attachedItem.prevPosY - inventoryUI.private.buffer[localPlayer].gui.startY - inventoryUI.private.gui.itemBox.templates[1].contentWrapper.startY
                            if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                local finalScrollPercent = inventoryUI.private.buffer[localPlayer].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                inventoryUI.private.attachedItem.__scrollItemBox = {initial = inventoryUI.private.buffer[localPlayer].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                            end
                        end
                        ]]
                    else
                        inventoryUI.private.attachedItem.finalWidth, inventoryUI.private.attachedItem.finalHeight = inventoryUI.private.attachedItem.prevWidth, inventoryUI.private.attachedItem.prevHeight
                        inventoryUI.private.attachedItem.prevWidth, inventoryUI.private.attachedItem.prevHeight = inventoryUI.private.attachedItem.__width, inventoryUI.private.attachedItem.__height
                        inventoryUI.private.attachedItem.animTickCounter = CLIENT_CURRENT_TICK
                        if inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight > 0 then
                            local slot_offsetY = inventoryUI.private.vicinityInventory.startY + inventoryUI.private.titlebar.height + ((inventoryUI.private.vicinityInventory.slotSize + inventoryUI.private.margin)*(inventoryUI.private.attachedItem.prevSlot - 1)) - (inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight*inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent*0.01)
                            if imports.math.round(slot_offsetY, 2) ~= imports.math.round(inventoryUI.private.attachedItem.prevY, 2) then
                                inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent = imports.math.max(0, imports.math.min(100, inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].scroller.percent + (((slot_offsetY - inventoryUI.private.attachedItem.prevY)/inventoryUI.private.buffer[(inventoryUI.private.vicinityInventory.element)].bufferCache.overflowHeight)*100)))
                            end
                        end
                    end
                    --TODO: PLAY SOUND
                    --imports.assetify.network:emit("onClientInventorySound", false, "inventory_rollback_item")
                end
                inventoryUI.private.detachItem()
            end
            local isDetachAttachment = false
            local attachment_posX, attachment_posY = nil, nil
            inventoryUI.private.attachedItem.__width, inventoryUI.private.attachedItem.__height = imports.interpolateBetween(inventoryUI.private.attachedItem.prevWidth, inventoryUI.private.attachedItem.prevHeight, 0, inventoryUI.private.attachedItem.finalWidth or CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[1], inventoryUI.private.attachedItem.finalHeight or CInventory.CItems[(inventoryUI.private.attachedItem.item)].dimensions[2], 0, imports.getInterpolationProgress(inventoryUI.private.attachedItem.animTickCounter, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.35), "OutBack")
            if inventoryUI.private.attachedItem.isOnTransition then
                attachment_posX, attachment_posY = imports.interpolateBetween(inventoryUI.private.attachedItem.__posX, inventoryUI.private.attachedItem.__posY, 0, inventoryUI.private.attachedItem.prevX, inventoryUI.private.attachedItem.prevY, 0, imports.getInterpolationProgress(inventoryUI.private.attachedItem.transitionTickCounter, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration), "OutQuad")
                if (imports.math.round(attachment_posX, 2) == imports.math.round(inventoryUI.private.attachedItem.prevX, 2)) and (imports.math.round(attachment_posY, 2) == imports.math.round(inventoryUI.private.attachedItem.prevY, 2)) then
                    isDetachAttachment = true
                end
            else
                local __offsetX, __offsetY = (inventoryUI.private.attachedItem.prevWidth - inventoryUI.private.attachedItem.__width)*0.5, (inventoryUI.private.attachedItem.prevHeight - inventoryUI.private.attachedItem.__height)*0.5
                inventoryUI.private.attachedItem.__posX, inventoryUI.private.attachedItem.__posY = cursorX - inventoryUI.private.attachedItem.offsetX + __offsetX, cursorY - inventoryUI.private.attachedItem.offsetY + __offsetY
                attachment_posX, attachment_posY = inventoryUI.private.attachedItem.__posX, inventoryUI.private.attachedItem.__posY
            end
            imports.beautify.native.drawImage(attachment_posX, attachment_posY, inventoryUI.private.attachedItem.__width, inventoryUI.private.attachedItem.__height, CInventory.CItems[(inventoryUI.private.attachedItem.item)].icon.inventory, 0, 0, 0, inventoryUI.private.opacityAdjuster.bgColor, false)
            if isDetachAttachment then inventoryUI.private.detachItem(true) end
        end
    end
end


----------------------------------------
--[[ Client: On Toggle Inventory UI ]]--
----------------------------------------

inventoryUI.private.toggleUI = function(state)
    --TODO: ENABLE LATER
    --if (((state ~= true) and (state ~= false)) or (state == inventoryUI.private.state)) or (state and (not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) or CGame.isUIVisible())) then return false end
    if (((state ~= true) and (state ~= false)) or (state == inventoryUI.private.state)) or (state and (not CPlayer.isInitialized(localPlayer) or CGame.isUIVisible())) then return false end

    if state then
        inventoryUI.private.updateUILang()
        --TODO: ENABLE LATER
        --inventoryUI.private.vicinityInventory.element = CCharacter.isInLoot(localPlayer)
        inventoryUI.private.vicinityInventory.element = CGame.getGlobalData("Loot:Test") --TODO: REMOVE LATER
        imports.assetify.network:emit("Client:onEnableInventoryUI", false, true)
        inventoryUI.private.createBuffer(localPlayer, imports.string.format(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory["Title"][(CPlayer.CLanguage)], CPlayer.getName(localPlayer)))
        inventoryUI.private.createBuffer(inventoryUI.private.vicinityInventory.element)
        inventoryUI.private.opacityAdjuster.element = imports.beautify.slider.create(inventoryUI.private.opacityAdjuster.startX, inventoryUI.private.opacityAdjuster.startY, inventoryUI.private.opacityAdjuster.width, inventoryUI.private.opacityAdjuster.height, "vertical", nil, false)
        inventoryUI.private.opacityAdjuster.percent = inventoryUI.private.opacityAdjuster.percent or 100
        imports.beautify.slider.setPercent(inventoryUI.private.opacityAdjuster.element, inventoryUI.private.opacityAdjuster.percent)
        imports.beautify.slider.setText(inventoryUI.private.opacityAdjuster.element, imports.string.upper(imports.string.kern("Opacity")))
        imports.beautify.slider.setTextColor(inventoryUI.private.opacityAdjuster.element, FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)
        imports.beautify.render.create(inventoryUI.private.renderUI, {elementReference = inventoryUI.private.opacityAdjuster.element, renderType = "preRender"})
        imports.beautify.render.create(inventoryUI.private.renderUI, {renderType = "input"})
        imports.beautify.setUIVisible(inventoryUI.private.opacityAdjuster.element, true)
    else
        if inventoryUI.private.opacityAdjuster.element and imports.isElement(inventoryUI.private.opacityAdjuster.element) then
            imports.destroyElement(inventoryUI.private.opacityAdjuster.element)
            imports.beautify.render.remove(inventoryUI.private.renderUI, {renderType = "input"})
        end
        if inventoryUI.private.gridTexture and imports.isElement(inventoryUI.private.gridTexture) then
            imports.destroyElement(inventoryUI.private.gridTexture)
            inventoryUI.private.gridTexture = nil
        end
        inventoryUI.private.destroyBuffer(localPlayer)
        inventoryUI.private.destroyBuffer(inventoryUI.private.vicinityInventory.element)
        inventoryUI.private.vicinityInventory.element = nil
        inventoryUI.private.opacityAdjuster.element = nil
        imports.collectgarbage()
    end
    inventoryUI.private.detachItem(true)
    inventoryUI.private.state = (state and true) or false
    imports.showChat(not inventoryUI.private.state)
    imports.showCursor(inventoryUI.private.state)
    return true
end
imports.assetify.network:create("Client:onToggleInventoryUI"):on(inventoryUI.private.toggleUI)
imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Inventory"].toggleKey, "down", function() inventoryUI.private.toggleUI(not inventoryUI.private.state) end)
imports.addEventHandler("onClientPlayerWasted", localPlayer, function() inventoryUI.private.toggleUI(false) end)
end)