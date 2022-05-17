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
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    collectgarbage = collectgarbage,
    triggerServerEvent = triggerServerEvent,
    triggerEvent = triggerEvent,
    bindKey = bindKey,
    getPlayerName = getPlayerName,
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


CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local inventory_margin = 4
    local inventory_offsetX, inventory_offsetY = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]["Primary"].slots.rows, FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]["Primary"].slots.columns)
    local vicinity_slotSize = inventory_offsetY
    inventory_offsetY = inventory_offsetY + FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height + inventory_margin
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
            slotColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor)), slotAvailableColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotAvailableColor)), slotUnavailableColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotUnavailableColor)),
            lockStat = {
                lockTexture = imports.beautify.assets["images"]["canvas/lock.rw"], unlockTexture = imports.beautify.assets["images"]["canvas/unlock.rw"]
            },
            equipment = {"Helmet", "Vest", "Upper", "Lower", "Shoes", "Primary", "Secondary", "Backpack"}
        },
        vicinityInventory = {
            width = inventory_offsetX,
            slotNameTexture = imports.beautify.native.createTexture("files/images/inventory/ui/vicinity/slot_name.rw", "argb", true, "clamp"),
            slotNameFont = CGame.createFont(1, 18), slotNameFontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotNameFontColor)),
            slotSize = vicinity_slotSize, slotColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.bgColor))
        },
        opacityAdjuster = {
            startX = 10, startY = 0,
            width = 27,
            range = {50, 100}
        }
    }
    inventory_margin, inventory_offsetX, inventory_offsetY, vicinity_slotSize = nil, nil, nil, nil

    inventoryUI.clientInventory.width, inventoryUI.clientInventory.height = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
    inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY = inventoryUI.clientInventory.startX + ((CLIENT_MTA_RESOLUTION[1] - inventoryUI.clientInventory.width)*0.5) + (inventoryUI.clientInventory.width*0.5), ((CLIENT_MTA_RESOLUTION[2] + inventoryUI.clientInventory.startY - inventoryUI.clientInventory.height - inventoryUI.titlebar.height)*0.5)
    inventoryUI.clientInventory.lockStat.size = inventoryUI.titlebar.height*0.5
    inventoryUI.clientInventory.lockStat.startX, inventoryUI.clientInventory.lockStat.startY = inventoryUI.clientInventory.width - inventoryUI.clientInventory.lockStat.size, -inventoryUI.titlebar.height + ((inventoryUI.titlebar.height - inventoryUI.clientInventory.lockStat.size)*0.5)
    for i = 1, #inventoryUI.clientInventory.equipment, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        inventoryUI.clientInventory.equipment[i] = imports.table.clone(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][j], true)
        inventoryUI.clientInventory.equipment[i].width, inventoryUI.clientInventory.equipment[i].height = CInventory.fetchSlotDimensions(inventoryUI.clientInventory.equipment[i].slots.rows, inventoryUI.clientInventory.equipment[i].slots.columns)
    end
    local equipment_prevX, equipment_prevY = -inventoryUI.margin, inventoryUI.titlebar.slot.height + inventoryUI.clientInventory.equipment[1].height + inventoryUI.margin
    for i = 5, 1, -1 do
        local j = inventoryUI.clientInventory.equipment[i]
        j.startX, j.startY = (-inventoryUI.margin*2) - j.width, inventoryUI.clientInventory.startY + inventoryUI.clientInventory.height + inventoryUI.margin - j.height + equipment_prevY
        equipment_prevY = equipment_prevY - j.height - (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.5) - inventoryUI.titlebar.slot.height
    end
    equipment_prevY = nil
    for i = 6, 7, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        j.startX, j.startY = equipment_prevX, inventoryUI.clientInventory.equipment[5].startY
        equipment_prevX = equipment_prevX + (inventoryUI.margin*2) - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize + j.width
    end
    equipment_prevX = nil
    equipment_prevY = -inventoryUI.titlebar.slot.height - inventoryUI.margin
    for i = 8, 8, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        j.startX, j.startY = inventoryUI.clientInventory.width + (inventoryUI.margin*2), inventoryUI.clientInventory.equipment[5].startY - j.height + equipment_prevY
        equipment_prevY = equipment_prevY - j.height - (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.5) - inventoryUI.titlebar.slot.height
    end
    equipment_prevY = nil
    for i = 1, #inventoryUI.clientInventory.equipment, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        j.startX, j.startY = inventoryUI.clientInventory.startX + j.startX, inventoryUI.clientInventory.startY + j.startY
    end
    inventoryUI.vicinityInventory.startX, inventoryUI.vicinityInventory.startY = inventoryUI.clientInventory.equipment[1].startX - inventoryUI.vicinityInventory.width - inventoryUI.margin - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize, inventoryUI.clientInventory.startY
    inventoryUI.vicinityInventory.height = inventoryUI.clientInventory.equipment[6].startY + inventoryUI.clientInventory.equipment[6].height - inventoryUI.vicinityInventory.startY - inventoryUI.titlebar.height - inventoryUI.margin
    inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY = inventoryUI.opacityAdjuster.startX + inventoryUI.clientInventory.startX + inventoryUI.clientInventory.width - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.opacityAdjuster.startY - inventoryUI.margin
    inventoryUI.opacityAdjuster.height = inventoryUI.clientInventory.equipment[8].startY - inventoryUI.opacityAdjuster.startY - inventoryUI.margin - inventoryUI.titlebar.slot.height
    inventoryUI.createBGTexture = function(isRefresh)
        if CLIENT_MTA_MINIMIZED then return false end
        if isRefresh then
            if inventoryUI.bgTexture and imports.isElement(inventoryUI.bgTexture) then
                imports.destroyElement(inventoryUI.bgTexture)
                inventoryUI.bgTexture = nil
            end
        end
        if not inventoryUI.bgTexture then
            inventoryUI.bgRT = imports.beautify.native.createRenderTarget(CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], true)
            imports.beautify.native.setRenderTarget(inventoryUI.bgRT, true)
            local client_startX, client_startY = inventoryUI.clientInventory.startX - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
            local client_width, client_height = inventoryUI.clientInventory.width + (inventoryUI.margin*2), inventoryUI.clientInventory.height + (inventoryUI.margin*2)
            imports.beautify.native.drawRectangle(client_startX, client_startY - inventoryUI.titlebar.height, client_width, inventoryUI.titlebar.height, inventoryUI.titlebar.bgColor, false)
            imports.beautify.native.drawRectangle(client_startX, client_startY, client_width, client_height, inventoryUI.clientInventory.bgColor, false)
            for i = 1, #inventoryUI.clientInventory.equipment, 1 do
                local j = inventoryUI.clientInventory.equipment[i]
                local title_height = inventoryUI.titlebar.slot.height
                local title_startY = j.startY - inventoryUI.titlebar.slot.height
                imports.beautify.native.drawRectangle(j.startX, title_startY, j.width, title_height, inventoryUI.titlebar.slot.bgColor, false)
                imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, inventoryUI.clientInventory.bgColor, false)
                for k = 1, j.slots.rows - 1, 1 do
                    imports.beautify.native.drawRectangle(j.startX, j.startY + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.width, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.clientInventory.dividerColor, false)
                end
                for k = 1, j.slots.columns - 1, 1 do
                    imports.beautify.native.drawRectangle(j.startX + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.startY, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, j.height, inventoryUI.clientInventory.dividerColor, false)
                end
            end
            inventoryUI.vicinityInventory.bgTexture = (inventoryUI.vicinityInventory.element and true) or false
            if inventoryUI.vicinityInventory.bgTexture then
                local vicinity_startX, vicinity_startY = inventoryUI.vicinityInventory.startX - (inventoryUI.margin*2), inventoryUI.vicinityInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
                local vicinity_width, vicinity_height = inventoryUI.vicinityInventory.width + (inventoryUI.margin*2), inventoryUI.vicinityInventory.height + (inventoryUI.margin*2)
                imports.beautify.native.drawRectangle(vicinity_startX, vicinity_startY - inventoryUI.titlebar.height, vicinity_width, inventoryUI.titlebar.height, inventoryUI.titlebar.bgColor, false)
                imports.beautify.native.drawRectangle(vicinity_startX, vicinity_startY, vicinity_width, vicinity_height, inventoryUI.vicinityInventory.bgColor, false)
            end
            imports.beautify.native.drawRectangle(inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY, inventoryUI.opacityAdjuster.width, inventoryUI.opacityAdjuster.height, inventoryUI.titlebar.bgColor, false)
            imports.beautify.native.setRenderTarget()
            local rtPixels = imports.beautify.native.getTexturePixels(inventoryUI.bgRT)
            if rtPixels then
                inventoryUI.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
                imports.destroyElement(inventoryUI.bgRT)
                inventoryUI.bgRT = nil
            end
        end
        if not inventoryUI.gridTexture or CLIENT_MTA_RESTORED then
            if not inventoryUI.gridTexture then
                inventoryUI.gridWidth, inventoryUI.gridHeight = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows + 2, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
                inventoryUI.gridTexture = imports.beautify.native.createRenderTarget(inventoryUI.gridWidth, inventoryUI.gridHeight, true)
            end
            imports.beautify.native.setRenderTarget(inventoryUI.gridTexture, true)
            for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows + 1, 1 do
                imports.beautify.native.drawRectangle(0, (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i, inventoryUI.clientInventory.width, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.clientInventory.dividerColor, false)
            end
            for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - 1, 1 do
                imports.beautify.native.drawRectangle((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i, 0, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, inventoryUI.clientInventory.height + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*2), inventoryUI.clientInventory.dividerColor, false)
            end
            imports.beautify.native.setRenderTarget()
        end
        return true
    end
    inventoryUI.updateUILang = function()
        for i = 1, #inventoryUI.clientInventory.equipment, 1 do
            local j = inventoryUI.clientInventory.equipment[i]
            j.title = imports.string.upper(imports.string.spaceChars(j["Title"][(CPlayer.CLanguage)]))
        end
        return true
    end
    imports.addEventHandler("Client:onUpdateLanguage", root, inventoryUI.updateUILang)
    inventoryUI.fetchUIGridSlotFromOffset = function(offsetX, offsetY)
        if not offsetX or not offsetY then return false end
        local row, column = imports.math.ceil(offsetY/(inventoryUI.clientInventory.height/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)), imports.math.ceil(offsetX/(inventoryUI.clientInventory.width/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns))
        row, column = (((row >= 1) and (row <= FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)) and row) or false, (((column >= 1) and (column <= FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)) and column) or false
        if not row or not column then return false end
        return row, column
    end
    inventoryUI.fetchUIGridOffsetFromSlot = function(slot)
        if not slot then return false end
        local row, column = CInventory.fetchSlotLocation(slot)
        if not row or not column then return false end
        return (column - 1)*(inventoryUI.clientInventory.width/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns), (row - 1)*(inventoryUI.clientInventory.height/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows)
    end
    inventoryUI.createBuffer = function(parent, name)
        if not parent or not imports.isElement(parent) or inventoryUI.buffer[parent] then return false end
        if (parent ~= localPlayer) and CLoot.isLocked(parent) then
            imports.triggerEvent("Client:onNotification", localPlayer, "Loot is locked..", FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        end
        inventoryUI.buffer[parent] = {
            name = imports.string.upper(imports.string.upper(imports.string.spaceChars(name or CLoot.fetchName(parent)))),
            bufferRT = imports.beautify.native.createRenderTarget(((parent == localPlayer) and inventoryUI.clientInventory.width) or inventoryUI.vicinityInventory.width, ((parent == localPlayer) and inventoryUI.clientInventory.height) or inventoryUI.vicinityInventory.height, true),
            scroller = {percent = 0, animPercent = 0},
            inventory = {}
        }
        inventoryUI.updateBuffer(parent)
        return true
    end
    inventoryUI.destroyBuffer = function(parent)
        if not parent or not imports.isElement(parent) then return false end
        if inventoryUI.buffer[parent] and inventoryUI.buffer[parent] then
            if inventoryUI.buffer[parent].bufferRT and imports.isElement(inventoryUI.buffer[parent].bufferRT) then
                imports.destroyElement(inventoryUI.buffer[parent].bufferRT)
            end
        end
        inventoryUI.buffer[parent] = nil
        return true
    end
    inventoryUI.updateBuffer = function(parent)
        if not parent or not imports.isElement(parent) or not inventoryUI.buffer[parent] then return false end
        inventoryUI.buffer[parent].maxSlots, inventoryUI.buffer[parent].assignedSlots, inventoryUI.buffer[parent].usedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent), CInventory.fetchParentUsedSlots(parent)
        inventoryUI.buffer[parent].inventory = {}
        inventoryUI.buffer[parent].bufferCache = nil
        for i, j in imports.pairs(CInventory.CItems) do
            local itemCount = CInventory.fetchItemCount(parent, i)
            if itemCount > 0 then
                inventoryUI.buffer[parent].inventory[i] = itemCount
            end
        end
        return true
    end
    inventoryUI.attachItem = function(parent, item, amount, prevSlot, prevX, prevY, prevWidth, prevHeight, offsetX, offsetY)
        if inventoryUI.attachedItem then return false end
        if not parent or not imports.isElement(parent) or not item or not amount or not prevSlot or not prevX or not prevY or not prevWidth or not prevHeight or not offsetX or not offsetY then return false end
        inventoryUI.attachedItem = {
            parent = parent, item = item, amount = amount,
            prevSlot = prevSlot, prevX = prevX, prevY = prevY,
            prevWidth = prevWidth, prevHeight = prevHeight,
            offsetX = offsetX, offsetY = offsetY,
            animTickCounter = CLIENT_CURRENT_TICK
        }
        return true
    end
    inventoryUI.detachItem = function(isForced)
        if not inventoryUI.attachedItem then return false end
        if not isForced then
            inventoryUI.attachedItem.isOnTransition = true
            inventoryUI.attachedItem.transitionTickCounter = CLIENT_CURRENT_TICK
        else
            inventoryUI.attachedItem = nil
            imports.assetify.execOnModuleLoad(function()
                imports.assetify.scheduleExec.boot()
            end)
        end      
        return true
    end
    inventoryUI.addItem = function()
        inventoryUI.isSynced, inventoryUI.isSyncScheduled = false, true
        --CInventory.CBuffer.slots[(inventoryUI.attachedItem.prevSlot)] = nil
        --TODO: REDUCE 1 ON VICINITY
        local parent, item, newSlot = inventoryUI.attachedItem.parent, inventoryUI.attachedItem.item, inventoryUI.attachedItem.isPlaceable.slot
        CInventory.CBuffer.slots[newSlot] = {
            item = item,
            translation = "inventory_add"
        }
        inventoryUI.updateBuffer(localPlayer)
        imports.assetify.scheduleExec.execOnModuleLoad(function()
            imports.triggerServerEvent("Player:onAddItem", localPlayer, parent, item, newSlot)    
        end)
        return true
    end
    inventoryUI.orderItem = function()
        inventoryUI.isSynced, inventoryUI.isSyncScheduled = false, true
        local item, prevSlot, newSlot = inventoryUI.attachedItem.item, inventoryUI.attachedItem.prevSlot, inventoryUI.attachedItem.isPlaceable.slot
        CInventory.CBuffer.slots[prevSlot] = nil
        CInventory.CBuffer.slots[newSlot] = {
            item = inventoryUI.attachedItem.item,
            translation = "inventory_order"
        }
        inventoryUI.updateBuffer(localPlayer)
        imports.assetify.scheduleExec.execOnModuleLoad(function()
            imports.triggerServerEvent("Player:onOrderItem", localPlayer, item, prevSlot, newSlot)        
        end)
        return true
    end

    -------------------------------
    --[[ Functions: UI Helpers ]]--
    -------------------------------

    inventoryUI.isUIEnabled = function()
        return (inventoryUI.isSynced and inventoryUI.isEnabled and not inventoryUI.isForcedDisabled) or false
    end

    function isInventoryUIVisible() return inventoryUI.state end
    function isInventoryUIEnabled() return inventoryUI.isUIEnabled() end

    imports.addEvent("Client:onEnableInventoryUI", true)
    imports.addEventHandler("Client:onEnableInventoryUI", root, function(state, isForced)
        if isForced then inventoryUI.isForcedDisabled = not state end
        inventoryUI.isEnabled = state
    end)

    imports.addEvent("Client:onSyncInventoryBuffer", true)
    imports.addEventHandler("Client:onSyncInventoryBuffer", root, function(buffer)
        CInventory.CBuffer = buffer
        inventoryUI.isSynced, inventoryUI.isSyncScheduled = true, false
        imports.triggerEvent("Client:onUpdateInventory", localPlayer)
    end)

    imports.addEvent("Client:onUpdateInventory", true)
    imports.addEventHandler("Client:onUpdateInventory", root, function()
        inventoryUI.detachItem(true)
        inventoryUI.updateBuffer(localPlayer)
        inventoryUI.updateBuffer(inventoryUI.vicinityInventory.element)
    end)


    ------------------------------
    --[[ Function: Renders UI ]]--
    ------------------------------

    inventoryUI.renderUI = function(renderData)
        if not inventoryUI.state or not CPlayer.isInitialized(localPlayer) then return false end
    
        if renderData.renderType == "input" then
            inventoryUI.cache.keys.mouse = imports.isMouseClicked()
            inventoryUI.cache.keys.scroll.state, inventoryUI.cache.keys.scroll.streak  = imports.isMouseScrolled()
            inventoryUI.cache.isEnabled = inventoryUI.isUIEnabled()
        elseif renderData.renderType == "preRender" then
            if not inventoryUI.bgTexture or not inventoryUI.gridTexture or CLIENT_MTA_RESTORED then inventoryUI.createBGTexture()
            elseif inventoryUI.vicinityInventory.bgTexture ~= ((inventoryUI.vicinityInventory.element and inventoryUI.buffer[(inventoryUI.vicinityInventory.element)] and true) or false) then inventoryUI.createBGTexture(true) end
            local cursorX, cursorY = imports.getAbsoluteCursorPosition()
            local isUIEnabled = inventoryUI.cache.isEnabled
            local isUIActionEnabled = isUIEnabled and not inventoryUI.attachedItem
            local isLMBClicked = (inventoryUI.cache.keys.mouse == "mouse1") and isUIActionEnabled
            local client_startX, client_startY = inventoryUI.clientInventory.startX - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
            local client_width, client_height = inventoryUI.clientInventory.width + (inventoryUI.margin*2), inventoryUI.clientInventory.height + (inventoryUI.margin*2)
            if not inventoryUI.buffer[localPlayer].bufferCache then
                inventoryUI.buffer[localPlayer].bufferCache, inventoryUI.buffer[localPlayer].assignedItems = {}, {}
                for i, j in imports.pairs(inventoryUI.buffer[localPlayer].inventory) do
                    for k = 1, j, 1 do
                        imports.table.insert(inventoryUI.buffer[localPlayer].bufferCache, {item = i, amount = 1})
                    end
                end
                for i, j in imports.pairs(inventoryUI.buffer[localPlayer].assignedSlots) do
                    if not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][i] then
                        if not inventoryUI.isSynced then
                            if j.translation == "inventory_add" then
                                imports.table.insert(inventoryUI.buffer[localPlayer].bufferCache, {item = j.item, amount = 1})
                            --[[
                            elseif (j.translation == "equipment") and j.isAutoIndexed then
                                if (inventoryUI.buffer[localPlayer].inventory[(j.item)] or 0) <= 0 then
                                    imports.table.insert(inventoryUI.buffer[localPlayer].bufferCache, {item = j.item, amount = 1})
                                end
                            ]]
                            end
                        end
                        for k = 1, #inventoryUI.buffer[localPlayer].bufferCache, 1 do
                            local v = inventoryUI.buffer[localPlayer].bufferCache[k]
                            if (j.item == v.item) and not inventoryUI.buffer[localPlayer].assignedItems[k] then
                                inventoryUI.buffer[localPlayer].assignedItems[k] = i
                                break
                            end
                        end
                    end
                end
            end
            local client_bufferCache = inventoryUI.buffer[localPlayer].bufferCache
            local client_isHovered, client_isSlotHovered = imports.isMouseOnPosition(client_startX + inventoryUI.margin, client_startY + inventoryUI.margin, inventoryUI.clientInventory.width, inventoryUI.clientInventory.height), nil
            imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], inventoryUI.bgTexture, 0, 0, 0, inventoryUI.opacityAdjuster.bgColor, false)
            imports.beautify.native.setRenderTarget(inventoryUI.buffer[localPlayer].bufferRT, true)
            imports.beautify.native.drawImage(0, 0, inventoryUI.gridWidth, inventoryUI.gridHeight, inventoryUI.gridTexture, 0, 0, 0, -1, false)
            for i, j in imports.pairs(inventoryUI.buffer[localPlayer].assignedItems) do
                local slotBuffer = client_bufferCache[i]
                local slot_offsetX, slot_offsetY = inventoryUI.fetchUIGridOffsetFromSlot(j)
                local slotWidth, slotHeight = CInventory.fetchSlotDimensions(CInventory.CItems[(slotBuffer.item)].data.itemWeight.rows, CInventory.CItems[(slotBuffer.item)].data.itemWeight.columns)
                local isItemVisible = true
                if inventoryUI.attachedItem then
                    if inventoryUI.attachedItem.parent == localPlayer then
                        if inventoryUI.attachedItem.prevSlot == j then
                            isItemVisible = false
                        end
                    elseif inventoryUI.attachedItem.isOnTransition and inventoryUI.attachedItem.isPlaceable and (inventoryUI.attachedItem.isPlaceable.slot == j) and inventoryUI.buffer[localPlayer].assignedSlots[j] then
                        isItemVisible = false
                    end
                end
                client_isSlotHovered = (client_isHovered and isUIActionEnabled and (client_isSlotHovered or (isItemVisible and imports.isMouseOnPosition(client_startX + inventoryUI.margin + slot_offsetX, client_startY + inventoryUI.margin + slot_offsetY, slotWidth, slotHeight) and i))) or false
                if not slotBuffer.isPositioned then
                    slotBuffer.title = imports.string.upper(CInventory.CItems[(slotBuffer.item)].data.itemName)
                    slotBuffer.width, slotBuffer.height = CInventory.CItems[(slotBuffer.item)].dimensions[1], CInventory.CItems[(slotBuffer.item)].dimensions[2] --TODO: FETCH SIDE USING SLOT ROW AND COLUMNS
                    slotBuffer.startX, slotBuffer.startY = (slotWidth - CInventory.CItems[(slotBuffer.item)].dimensions[1])*0.5, (slotHeight - CInventory.CItems[(slotBuffer.item)].dimensions[2])*0.5
                    slotBuffer.isPositioned = true
                end
                imports.beautify.native.drawRectangle(slot_offsetX, slot_offsetY, slotWidth, slotHeight, inventoryUI.clientInventory.slotColor, false)
                if isItemVisible then
                    imports.beautify.native.drawImage(slot_offsetX + slotBuffer.startX, slot_offsetY + slotBuffer.startY, slotBuffer.width, slotBuffer.height, CInventory.CItems[(slotBuffer.item)].icon.inventory, 0, 0, 0, -1, false)
                end
            end
            if client_isHovered then
                local slotRow, slotColumn = inventoryUI.fetchUIGridSlotFromOffset(cursorX - inventoryUI.clientInventory.startX, cursorY - (inventoryUI.clientInventory.startY + inventoryUI.titlebar.height))
                if slotRow and slotColumn then
                    if inventoryUI.attachedItem and not inventoryUI.attachedItem.isOnTransition and (not inventoryUI.attachedItem.isPlaceable or (inventoryUI.attachedItem.isPlaceable.type == "order")) then
                        local slot = CInventory.fetchSlotIndex(slotRow, slotColumn)
                        local slot_offsetX, slot_offsetY = inventoryUI.fetchUIGridOffsetFromSlot(slot)
                        local slotWidth, slotHeight = CInventory.fetchSlotDimensions(imports.math.min(CInventory.CItems[(inventoryUI.attachedItem.item)].data.itemWeight.rows, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows - (slotRow - 1)), imports.math.min(CInventory.CItems[(inventoryUI.attachedItem.item)].data.itemWeight.columns, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - (slotColumn - 1)))
                        if CInventory.isSlotAvailableForOrdering(inventoryUI.attachedItem.item, slot) then
                            inventoryUI.attachedItem.isPlaceable = inventoryUI.attachedItem.isPlaceable or {type = "order"}
                            inventoryUI.attachedItem.isPlaceable.slot = slot
                            inventoryUI.attachedItem.isPlaceable.offsetX, inventoryUI.attachedItem.isPlaceable.offsetY = slot_offsetX, slot_offsetY
                            inventoryUI.attachedItem.isPlaceable.width, inventoryUI.attachedItem.isPlaceable.height = slotWidth, slotHeight
                        else
                            inventoryUI.attachedItem.isPlaceable = false
                        end
                        imports.beautify.native.drawRectangle(slot_offsetX, slot_offsetY, slotWidth, slotHeight, (inventoryUI.attachedItem.isPlaceable and inventoryUI.clientInventory.slotAvailableColor) or inventoryUI.clientInventory.slotUnavailableColor, false)
                    end
                end
                if client_isSlotHovered then
                    if isLMBClicked then
                        iprint(client_bufferCache[client_isSlotHovered])
                        local slot_offsetX, slot_offsetY = inventoryUI.fetchUIGridOffsetFromSlot(client_isSlotHovered)
                        local slot_prevX, slot_prevY = client_startX + inventoryUI.margin + slot_offsetX, client_startY + inventoryUI.margin + slot_offsetY
                        inventoryUI.attachItem(localPlayer, client_bufferCache[client_isSlotHovered].item, client_bufferCache[client_isSlotHovered].amount, client_isSlotHovered, slot_prevX, slot_prevY, client_bufferCache[client_isSlotHovered].width, client_bufferCache[client_isSlotHovered].height, cursorX - slot_prevX, cursorY - slot_prevY)
                        isUIActionEnabled = false
                    end
                end
            end
            imports.beautify.native.setRenderTarget()
            imports.beautify.native.drawText(inventoryUI.buffer[localPlayer].name, client_startX, client_startY - inventoryUI.titlebar.height, client_startX + client_width, client_startY, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font.instance, "center", "center", true, false, false)
            imports.beautify.native.drawImage(client_startX + inventoryUI.clientInventory.lockStat.startX, client_startY + inventoryUI.clientInventory.lockStat.startY, inventoryUI.clientInventory.lockStat.size, inventoryUI.clientInventory.lockStat.size, (isUIActionEnabled and inventoryUI.clientInventory.lockStat.unlockTexture) or inventoryUI.clientInventory.lockStat.lockTexture, 0, 0, 0, inventoryUI.titlebar.fontColor, false)
            imports.beautify.native.drawImage(client_startX + inventoryUI.margin, client_startY + inventoryUI.margin, inventoryUI.clientInventory.width, inventoryUI.clientInventory.height, inventoryUI.buffer[localPlayer].bufferRT, 0, 0, 0, inventoryUI.opacityAdjuster.bgColor, false)
            for i = 1, #inventoryUI.clientInventory.equipment, 1 do
                local j = inventoryUI.clientInventory.equipment[i]
                imports.beautify.native.drawText(j.title, j.startX, j.startY - inventoryUI.titlebar.slot.height + inventoryUI.titlebar.slot.fontPaddingY, j.startX + j.width, j.startY, inventoryUI.titlebar.slot.fontColor, 1, inventoryUI.titlebar.slot.font.instance, "center", "center", true, false, false)
            end
            --[[
            --TODO: ENABLE LATER INVENTORY SCROLLER
            if client_bufferCache.overflowHeight > 0 then
                if not inventoryUI.buffer[localPlayer].scroller.isPositioned then
                    inventoryUI.buffer[localPlayer].scroller.startX, inventoryUI.buffer[localPlayer].scroller.startY = client_startX + client_width - inventoryUI.scroller.width, client_startY + inventoryUI.margin
                    inventoryUI.buffer[localPlayer].scroller.height = inventoryUI.clientInventory.height
                    inventoryUI.buffer[localPlayer].scroller.isPositioned = true
                end
                if imports.math.round(inventoryUI.buffer[localPlayer].scroller.animPercent, 2) ~= imports.math.round(inventoryUI.buffer[localPlayer].scroller.percent, 2) then
                    inventoryUI.buffer[localPlayer].scroller.animPercent = imports.interpolateBetween(inventoryUI.buffer[localPlayer].scroller.animPercent, 0, 0, inventoryUI.buffer[localPlayer].scroller.percent, 0, 0, 0.5, "InQuad")
                end
                imports.beautify.native.drawRectangle(inventoryUI.buffer[localPlayer].scroller.startX, inventoryUI.buffer[localPlayer].scroller.startY, inventoryUI.scroller.width, inventoryUI.buffer[localPlayer].scroller.height, inventoryUI.scroller.bgColor, false)
                imports.beautify.native.drawRectangle(inventoryUI.buffer[localPlayer].scroller.startX, inventoryUI.buffer[localPlayer].scroller.startY + ((inventoryUI.buffer[localPlayer].scroller.height - inventoryUI.scroller.thumbHeight)*inventoryUI.buffer[localPlayer].scroller.animPercent*0.01), inventoryUI.scroller.width, inventoryUI.scroller.thumbHeight, inventoryUI.scroller.thumbColor, false)
                if inventoryUI.cache.keys.scroll.state and (not inventoryUI.attachedItem or not inventoryUI.attachedItem.isOnTransition) and client_isHovered then
                    --TODO: WIP
                    --local client_scrollPercent = imports.math.max(1, 100/(vicinity_bufferCache.overflowHeight/(inventoryUI.clientInventory.slotSize*0.5)))
                    inventoryUI.buffer[localPlayer].scroller.percent = imports.math.max(0, imports.math.min(inventoryUI.buffer[localPlayer].scroller.percent + (client_scrollPercent*imports.math.max(1, inventoryUI.cache.keys.scroll.streak)*(((inventoryUI.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                    inventoryUI.cache.keys.scroll.state = false
                end
            end
            ]]
            if inventoryUI.vicinityInventory.element and inventoryUI.buffer[(inventoryUI.vicinityInventory.element)] then
                local vicinity_startX, vicinity_startY = inventoryUI.vicinityInventory.startX - (inventoryUI.margin*2), inventoryUI.vicinityInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
                local vicinity_width, vicinity_height = inventoryUI.vicinityInventory.width + (inventoryUI.margin*2), inventoryUI.vicinityInventory.height + (inventoryUI.margin*2)
                imports.beautify.native.setRenderTarget(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferRT, true)
                if not inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache then
                    local categoryPriority = {}
                    inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache = {}
                    for i = 1, #FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Priority"], 1 do
                        local j = FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Priority"][i]
                        if CInventory.CCategories[j] then
                            categoryPriority[j] = true
                            for k, v in imports.pairs(CInventory.CCategories[j]) do
                                if inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].inventory[k] then
                                    imports.table.insert(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache, {item = k, amount = inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].inventory[k]})
                                end
                            end
                        end
                    end
                    for i, j in imports.pairs(CInventory.CCategories) do
                        if not categoryPriority[i] then
                            for k, v in imports.pairs(j) do
                                if inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].inventory[k] then
                                    imports.table.insert(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache, {item = k, amount = inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].inventory[k]})
                                end
                            end
                        end
                    end
                end
                local vicinity_bufferCache = inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache
                local vicinity_bufferCount = #vicinity_bufferCache
                local vicinity_isHovered, vicinity_isSlotHovered = imports.isMouseOnPosition(vicinity_startX + inventoryUI.margin, vicinity_startY + inventoryUI.margin, inventoryUI.vicinityInventory.width, inventoryUI.vicinityInventory.height), nil
                vicinity_bufferCache.overflowHeight = imports.math.max(0, (inventoryUI.vicinityInventory.slotSize*vicinity_bufferCount) + (inventoryUI.margin*imports.math.max(0, vicinity_bufferCount - 1)) - inventoryUI.vicinityInventory.height)
                local vicinity_offsetY = vicinity_bufferCache.overflowHeight*inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.animPercent*0.01
                local vicinity_rowHeight = inventoryUI.vicinityInventory.slotSize + inventoryUI.margin
                local vicinity_row_startIndex = imports.math.floor(vicinity_offsetY/vicinity_rowHeight) + 1
                local vicinity_row_endIndex = imports.math.min(vicinity_bufferCount, vicinity_row_startIndex + imports.math.ceil(inventoryUI.vicinityInventory.height/vicinity_rowHeight))
                for i = vicinity_row_startIndex, vicinity_row_endIndex, 1 do
                    local j = vicinity_bufferCache[i]
                    j.offsetY = (inventoryUI.vicinityInventory.slotSize + inventoryUI.margin)*(i - 1) - vicinity_offsetY
                    local itemValue = (inventoryUI.attachedItem and (inventoryUI.attachedItem.parent == inventoryUI.vicinityInventory.element) and (inventoryUI.attachedItem.prevSlot == i) and (j.amount - inventoryUI.attachedItem.amount)) or j.amount
                    local isItemVisible = itemValue > 0
                    vicinity_isSlotHovered = (vicinity_isHovered and isUIActionEnabled and (vicinity_isSlotHovered or (isItemVisible and imports.isMouseOnPosition(vicinity_startX + inventoryUI.margin, vicinity_startY + inventoryUI.margin + j.offsetY, vicinity_width, inventoryUI.vicinityInventory.slotSize) and i))) or false
                    if not j.isPositioned then
                        j.title = imports.string.upper(CInventory.CItems[(j.item)].data.itemName)
                        j.width, j.height = (CInventory.CItems[(j.item)].dimensions[1]/CInventory.CItems[(j.item)].dimensions[2])*inventoryUI.vicinityInventory.slotSize, inventoryUI.vicinityInventory.slotSize
                        j.startX, j.startY = inventoryUI.vicinityInventory.width - j.width, 0
                        j.isPositioned = true
                    end
                    if vicinity_isSlotHovered == i then
                        if j.hoverStatus ~= "forward" then
                            j.hoverStatus = "forward"
                            j.hoverAnimTick = CLIENT_CURRENT_TICK
                        end
                    else
                        if j.hoverStatus ~= "backward" then
                            j.hoverStatus = "backward"
                            j.hoverAnimTick = CLIENT_CURRENT_TICK
                        end
                    end
                    j.animAlphaPercent = j.animAlphaPercent or 0
                    if j.hoverStatus == "forward" then
                        if j.animAlphaPercent < 1 then
                            j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.75), "OutQuad")
                            j.slotNameWidth = inventoryUI.vicinityInventory.width*j.animAlphaPercent
                        end
                    else
                        if j.animAlphaPercent > 0 then
                            j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.75), "OutQuad")
                            j.slotNameWidth = inventoryUI.vicinityInventory.width*j.animAlphaPercent
                        end
                    end
                    imports.beautify.native.drawRectangle(0, j.offsetY, inventoryUI.vicinityInventory.width, inventoryUI.vicinityInventory.slotSize, inventoryUI.vicinityInventory.slotColor, false)
                    if isItemVisible then
                        imports.beautify.native.drawImage(j.startX, j.offsetY + j.startY, j.width, j.height, CInventory.CItems[(j.item)].icon.inventory, 0, 0, 0, -1, false)
                    end
                    if j.slotNameWidth and (j.slotNameWidth > 0) then
                        imports.beautify.native.drawImageSection(0, j.offsetY, j.slotNameWidth, inventoryUI.vicinityInventory.slotSize, inventoryUI.vicinityInventory.width - j.slotNameWidth, 0, j.slotNameWidth, inventoryUI.vicinityInventory.slotSize, inventoryUI.vicinityInventory.slotNameTexture, 0, 0, 0, -1, false)
                        imports.beautify.native.drawText(j.title, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.25, j.offsetY, j.slotNameWidth - FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize, j.offsetY + inventoryUI.vicinityInventory.slotSize, inventoryUI.vicinityInventory.slotNameFontColor, 1, inventoryUI.vicinityInventory.slotNameFont.instance, "left", "center", true, false, false)
                    end
                end
                if vicinity_isSlotHovered then
                    if isLMBClicked then
                        local slot_prevX, slot_prevY = vicinity_startX + inventoryUI.margin + vicinity_bufferCache[vicinity_isSlotHovered].startX, vicinity_startY + inventoryUI.margin + vicinity_bufferCache[vicinity_isSlotHovered].startY + vicinity_bufferCache[vicinity_isSlotHovered].offsetY
                        inventoryUI.attachItem(inventoryUI.vicinityInventory.element, vicinity_bufferCache[vicinity_isSlotHovered].item, 1, vicinity_isSlotHovered, slot_prevX, slot_prevY, vicinity_bufferCache[vicinity_isSlotHovered].width, vicinity_bufferCache[vicinity_isSlotHovered].height, cursorX - slot_prevX, cursorY - slot_prevY)
                        isUIActionEnabled = false
                    end
                end
                imports.beautify.native.setRenderTarget()
                imports.beautify.native.drawText(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].name, vicinity_startX, vicinity_startY - inventoryUI.titlebar.height, vicinity_startX + vicinity_width, vicinity_startY, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font.instance, "center", "center", true, false, false)
                imports.beautify.native.drawImage(vicinity_startX + inventoryUI.margin, vicinity_startY + inventoryUI.margin, inventoryUI.vicinityInventory.width, inventoryUI.vicinityInventory.height, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferRT, 0, 0, 0, inventoryUI.opacityAdjuster.bgColor, false)
                if vicinity_bufferCache.overflowHeight > 0 then
                    if not inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.isPositioned then
                        inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startX, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startY = vicinity_startX + vicinity_width - inventoryUI.scroller.width, vicinity_startY + inventoryUI.margin
                        inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.height = inventoryUI.vicinityInventory.height
                        inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.isPositioned = true
                    end
                    if imports.math.round(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.animPercent, 2) ~= imports.math.round(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.percent, 2) then
                        inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.animPercent = imports.interpolateBetween(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.animPercent, 0, 0, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.percent, 0, 0, 0.5, "InQuad")
                    end
                    imports.beautify.native.drawRectangle(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startX, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startY, inventoryUI.scroller.width, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.height, inventoryUI.scroller.bgColor, false)
                    imports.beautify.native.drawRectangle(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startX, inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.startY + ((inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.height - inventoryUI.scroller.thumbHeight)*inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.animPercent*0.01), inventoryUI.scroller.width, inventoryUI.scroller.thumbHeight, inventoryUI.scroller.thumbColor, false)
                    if inventoryUI.cache.keys.scroll.state and (not inventoryUI.attachedItem or not inventoryUI.attachedItem.isOnTransition) and vicinity_isHovered then
                        local vicinity_scrollPercent = imports.math.max(1, 100/(vicinity_bufferCache.overflowHeight/(inventoryUI.vicinityInventory.slotSize*0.5)))
                        inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.percent = imports.math.max(0, imports.math.min(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].scroller.percent + (vicinity_scrollPercent*imports.math.max(1, inventoryUI.cache.keys.scroll.streak)*(((inventoryUI.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                        inventoryUI.cache.keys.scroll.state = false
                    end
                end
            else
                imports.beautify.native.setRenderTarget()
            end
            inventoryUI.opacityAdjuster.percent = imports.beautify.slider.getPercent(inventoryUI.opacityAdjuster.element)
            if inventoryUI.opacityAdjuster.percent ~= inventoryUI.opacityAdjuster.animPercent then
                inventoryUI.opacityAdjuster.animPercent = inventoryUI.opacityAdjuster.percent
                inventoryUI.opacityAdjuster.bgColor = imports.tocolor(255, 255, 255, 255*0.01*(inventoryUI.opacityAdjuster.range[1] + ((inventoryUI.opacityAdjuster.range[2] - inventoryUI.opacityAdjuster.range[1])*inventoryUI.opacityAdjuster.percent*0.01)))
            end
            if inventoryUI.attachedItem then
                if not inventoryUI.attachedItem.isOnTransition and (CLIENT_MTA_WINDOW_ACTIVE or not imports.isKeyOnHold("mouse1") or not isUIEnabled) then
                    local isPlaceAttachment = false
                    if inventoryUI.attachedItem.isPlaceable then
                        if inventoryUI.attachedItem.isPlaceable.type == "order" then
                            isPlaceAttachment = true
                            inventoryUI.attachedItem.prevX, inventoryUI.attachedItem.prevY = client_startX + inventoryUI.margin + inventoryUI.attachedItem.isPlaceable.offsetX + ((inventoryUI.attachedItem.isPlaceable.width - CInventory.CItems[(inventoryUI.attachedItem.item)].dimensions[1])*0.5), client_startY + inventoryUI.margin + inventoryUI.attachedItem.isPlaceable.offsetY + ((inventoryUI.attachedItem.isPlaceable.height - CInventory.CItems[(inventoryUI.attachedItem.item)].dimensions[2])*0.5)
                            if inventoryUI.attachedItem.parent == localPlayer then
                                inventoryUI.orderItem()
                            else
                                inventoryUI.addItem()
                            end
                            --triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                        elseif inventoryUI.attachedItem.isPlaceable.type == "drop" then
                            isPlaceAttachment = true
                            --[[
                            local totalLootItems = 0
                            for index, _ in pairs(inventoryUI.buffer[isItemAvailableForDropping.parent].inventory) do
                                totalLootItems = totalLootItems + 1
                            end
                            local template = inventoryUI.gui.itemBox.templates[(inventoryUI.buffer[isItemAvailableForDropping.parent].gui.templateIndex)]
                            local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                            local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                            local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(isItemAvailableForDropping.slotIndex - 1))
                            local slotWidth, slotHeight = 0, template.contentWrapper.itemSlot.iconSlot.height
                            slotWidth = (originalWidth / originalHeight)*slotHeight
                            if exceededContentHeight > 0 then
                                slot_offsetY = slot_offsetY - (exceededContentHeight*inventoryUI.buffer[isItemAvailableForDropping.parent].gui.scroller.percent*0.01)
                                if slot_offsetY < 0 then
                                    local finalScrollPercent = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.scroller.percent + (slot_offsetY/exceededContentHeight)*100
                                    slot_offsetY = template.contentWrapper.itemSlot.paddingY
                                    inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                elseif (slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) > template.contentWrapper.height then
                                    local finalScrollPercent = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.scroller.percent + (((slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) - template.contentWrapper.height)/exceededContentHeight)*100
                                    slot_offsetY = template.contentWrapper.height - (template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY)
                                    inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                            local releaseIndex = inventoryUI.attachedItem.prevSlot
                            inventoryUI.attachedItem.finalWidth, inventoryUI.attachedItem.finalHeight = slotWidth, slotHeight
                            inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                            inventoryUI.attachedItem.animTickCounter = getTickCount()
                            inventoryUI.attachedItem.prevSlot = isItemAvailableForDropping.slotIndex
                            inventoryUI.attachedItem.prevPosX = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.startX + template.contentWrapper.startX + template.contentWrapper.itemSlot.startX + template.contentWrapper.itemSlot.iconSlot.startX
                            inventoryUI.attachedItem.prevPosY = inventoryUI.buffer[isItemAvailableForDropping.parent].gui.startY + template.contentWrapper.startY + slot_offsetY
                            inventoryUI.attachedItem.releaseLoot = isItemAvailableForDropping.parent
                            if inventoryUI.attachedItem.isEquippedItem then
                                local reservedSlotIndex = false
                                inventoryUI.isSyncScheduled = true
                                inventoryUI.buffer[localPlayer].assignedSlots[releaseIndex] = nil
                                for i, j in pairs(inventoryUI.buffer[localPlayer].assignedSlots) do
                                    if tonumber(i) then
                                        if j.translation and j.translation == "equipment" and releaseIndex == j.equipmentIndex then
                                            reservedSlotIndex = i
                                            break
                                        end
                                    end
                                end
                                if reservedSlotIndex then
                                    inventoryUI.attachedItem.reservedSlot = "equipment"
                                    inventoryUI.attachedItem.reservedSlot = reservedSlotIndex
                                    inventoryUI.buffer[localPlayer].assignedSlots[reservedSlotIndex] = {
                                        item = inventoryUI.attachedItem.item,
                                        parent = isItemAvailableForDropping.parent,
                                        translation = "vicinity"
                                    }
                                end
                            else
                                inventoryUI.isSyncScheduled = true
                                inventoryUI.buffer[localPlayer].assignedSlots[releaseIndex] = {
                                    item = inventoryUI.attachedItem.item,
                                    parent = isItemAvailableForDropping.parent,
                                    translation = "vicinity"
                                }
                            end
                            triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                            ]]
                        elseif inventoryUI.attachedItem.isPlaceable.type == "equip" then
                            isPlaceAttachment = true
                            --[[
                            local slotWidth, slotHeight = inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].width - inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].paddingX, inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].height - inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].paddingY
                            local releaseIndex = inventoryUI.attachedItem.prevSlot
                            local reservedSlot = isItemAvailableForEquipping.reservedSlot or releaseIndex
                            inventoryUI.attachedItem.finalWidth, inventoryUI.attachedItem.finalHeight = slotWidth, slotHeight
                            inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                            inventoryUI.attachedItem.animTickCounter = getTickCount()
                            inventoryUI.attachedItem.prevSlot = isItemAvailableForEquipping.slotIndex
                            inventoryUI.attachedItem.prevPosX = isItemAvailableForEquipping.offsetX
                            inventoryUI.attachedItem.prevPosY = isItemAvailableForEquipping.offsetY
                            inventoryUI.attachedItem.releaseLoot = isItemAvailableForEquipping.parent
                            inventoryUI.attachedItem.reservedSlot = reservedSlot
                            if parent == localPlayer then
                                inventoryUI.isSyncScheduled = true
                                inventoryUI.buffer[localPlayer].assignedSlots[reservedSlot] = {
                                    item = inventoryUI.attachedItem.item,
                                    translation = "equipment"
                                }
                            else
                                inventoryUI.isSyncScheduled = true
                                inventoryUI.buffer[localPlayer].assignedSlots[reservedSlot] = {
                                    item = inventoryUI.attachedItem.item,
                                    parent = isItemAvailableForEquipping.parent,
                                    isAutoIndexed = true,
                                    translation = "equipment"
                                }
                            end
                            triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                            ]]
                        end
                    end
                    if not isPlaceAttachment then
                        if inventoryUI.attachedItem.parent == localPlayer then
                            --[[
                            local maxSlots = CInventory.fetchParentMaxSlots(inventoryUI.attachedItem.parent)
                            local totalContentHeight = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding
                            local exceededContentHeight =  totalContentHeight - inventoryUI.gui.itemBox.templates[1].contentWrapper.height
                            if exceededContentHeight > 0 then
                                local slotRow = math.ceil(inventoryUI.attachedItem.prevSlot/maximumInventoryRowSlots)
                                local slot_offsetY = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, slotRow - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) - (exceededContentHeight*inventoryUI.buffer[localPlayer].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryUI.attachedItem.prevPosY - inventoryUI.buffer[localPlayer].gui.startY - inventoryUI.gui.itemBox.templates[1].contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = inventoryUI.buffer[localPlayer].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[localPlayer].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                            ]]
                        else
                            inventoryUI.attachedItem.finalWidth, inventoryUI.attachedItem.finalHeight = inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight
                            inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                            inventoryUI.attachedItem.animTickCounter = getTickCount()
                            if inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache.overflowHeight > 0 then
                                local slot_offsetY = inventoryUI.vicinityInventory.startY + inventoryUI.titlebar.height + ((inventoryUI.vicinityInventory.slotSize + inventoryUI.margin)*(inventoryUI.attachedItem.prevSlot - 1)) - (inventoryUI.buffer[(inventoryUI.attachedItem.parent)].bufferCache.overflowHeight*inventoryUI.buffer[(inventoryUI.attachedItem.parent)].scroller.percent*0.01)
                                if imports.math.round(slot_offsetY, 2) ~= imports.math.round(inventoryUI.attachedItem.prevY, 2) then
                                    inventoryUI.buffer[(inventoryUI.attachedItem.parent)].scroller.percent = inventoryUI.buffer[(inventoryUI.attachedItem.parent)].scroller.percent + (((slot_offsetY - inventoryUI.attachedItem.prevY)/inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].bufferCache.overflowHeight)*100)
                                end
                            end
                        end
                        --TODO: PLAY SOUND
                        --triggerEvent("onClientInventorySound", localPlayer, "inventory_rollback_item")
                    end
                    inventoryUI.detachItem()
                end
                local isDetachAttachment = false
                local attachment_posX, attachment_posY = nil, nil
                inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height = imports.interpolateBetween(inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight, 0, inventoryUI.attachedItem.finalWidth or CInventory.CItems[(inventoryUI.attachedItem.item)].dimensions[1], inventoryUI.attachedItem.finalHeight or CInventory.CItems[(inventoryUI.attachedItem.item)].dimensions[2], 0, imports.getInterpolationProgress(inventoryUI.attachedItem.animTickCounter, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration*0.35), "OutBack")
                if inventoryUI.attachedItem.isOnTransition then
                    attachment_posX, attachment_posY = imports.interpolateBetween(inventoryUI.attachedItem.__posX, inventoryUI.attachedItem.__posY, 0, inventoryUI.attachedItem.prevX, inventoryUI.attachedItem.prevY, 0, imports.getInterpolationProgress(inventoryUI.attachedItem.transitionTickCounter, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.animDuration), "OutQuad")
                    if (imports.math.round(attachment_posX, 2) == imports.math.round(inventoryUI.attachedItem.prevX, 2)) and (imports.math.round(attachment_posY, 2) == imports.math.round(inventoryUI.attachedItem.prevY, 2)) then
                        isDetachAttachment = true
                    end
                else
                    inventoryUI.attachedItem.__posX, inventoryUI.attachedItem.__posY = cursorX - inventoryUI.attachedItem.offsetX, cursorY - inventoryUI.attachedItem.offsetY
                    attachment_posX, attachment_posY = inventoryUI.attachedItem.__posX, inventoryUI.attachedItem.__posY
                end
                imports.beautify.native.drawImage(attachment_posX, attachment_posY, inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height, CInventory.CItems[(inventoryUI.attachedItem.item)].icon.inventory, 0, 0, 0, inventoryUI.opacityAdjuster.bgColor, false)
                if isDetachAttachment then inventoryUI.detachItem(true) end
            end
        end
    end


    ----------------------------------------
    --[[ Client: On Toggle Inventory UI ]]--
    ----------------------------------------

    local testPed = getElementsByType("ped")[1]; setElementAlpha(testPed, 0) --TODO: REMOVE IT LATER
    setElementData(testPed, "Loot:Type", "something")
    setElementData(testPed, "Loot:Name", "Test Loot")
    for i, j in pairs(CInventory.CItems) do
        CInventory.addItemCount(testPed, i, 1)
    end
    inventoryUI.toggleUI = function(state)
        --TODO: ENABLE LATER
        --if (((state ~= true) and (state ~= false)) or (state == inventoryUI.state)) or (state and (not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) or CGame.isUIVisible())) then return false end
        if (((state ~= true) and (state ~= false)) or (state == inventoryUI.state)) or (state and (not CPlayer.isInitialized(localPlayer) or CGame.isUIVisible())) then return false end

        if state then
            inventoryUI.updateUILang()
            --TODO: ENABLE LATER
            --inventoryUI.vicinityInventory.element = CCharacter.isInLoot(localPlayer)
            inventoryUI.vicinityInventory.element = testPed --TODO: REMOVE IT LATER AND ENABLE ^
            imports.triggerEvent("Client:onEnableInventoryUI", localPlayer, true)
            inventoryUI.createBuffer(localPlayer, imports.string.format(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory["Title"][(CPlayer.CLanguage)], imports.getPlayerName(localPlayer)))
            inventoryUI.createBuffer(inventoryUI.vicinityInventory.element)
            inventoryUI.opacityAdjuster.element = imports.beautify.slider.create(inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY, inventoryUI.opacityAdjuster.width, inventoryUI.opacityAdjuster.height, "vertical", nil, false)
            inventoryUI.opacityAdjuster.percent = inventoryUI.opacityAdjuster.percent or 100
            imports.beautify.slider.setPercent(inventoryUI.opacityAdjuster.element, inventoryUI.opacityAdjuster.percent)
            imports.beautify.slider.setText(inventoryUI.opacityAdjuster.element, imports.string.upper(imports.string.spaceChars("Opacity")))
            imports.beautify.slider.setTextColor(inventoryUI.opacityAdjuster.element, FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)
            imports.beautify.render.create(inventoryUI.renderUI, {elementReference = inventoryUI.opacityAdjuster.element, renderType = "preRender"})
            imports.beautify.render.create(inventoryUI.renderUI, {renderType = "input"})
            imports.beautify.setUIVisible(inventoryUI.opacityAdjuster.element, true)
        else
            if inventoryUI.opacityAdjuster.element and imports.isElement(inventoryUI.opacityAdjuster.element) then
                imports.destroyElement(inventoryUI.opacityAdjuster.element)
                imports.beautify.render.remove(inventoryUI.renderUI, {renderType = "input"})
            end
            if inventoryUI.gridTexture and imports.isElement(inventoryUI.gridTexture) then
                imports.destroyElement(inventoryUI.gridTexture)
                inventoryUI.gridTexture = nil
            end
            inventoryUI.destroyBuffer(localPlayer)
            inventoryUI.destroyBuffer(inventoryUI.vicinityInventory.element)
            inventoryUI.vicinityInventory.element = nil
            inventoryUI.opacityAdjuster.element = nil
            imports.collectgarbage()
        end
        inventoryUI.detachItem(true)
        inventoryUI.state = (state and true) or false
        imports.showChat(not inventoryUI.state)
        imports.showCursor(inventoryUI.state)
        return true
    end
    imports.addEvent("Client:onToggleInventoryUI", true)
    imports.addEventHandler("Client:onToggleInventoryUI", root, inventoryUI.toggleUI)
    imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Inventory"].toggleKey, "down", function() inventoryUI.toggleUI(not inventoryUI.state) end)
    imports.addEventHandler("onClientPlayerWasted", localPlayer, function() inventoryUI.toggleUI(false) end)
end)



--[[
--TODO: REMOVE LATER...........
    function displayInventoryUI()
        local playerMaxSlots = CInventory.fetchParentMaxSlots(localPlayer)
        local playerUsedSlots = getElementUsedSlots(localPlayer)

        --Draws Equipment
        for i, j in pairs(inventoryUI.gui.equipment.slot) do
            local isSlotHovered = isMouseOnPosition(j.startX, j.startY, j.width, j.height) and isUIEnabled
            if itemDetails and itemCategory then
                if CInventory.CItems[itemDetails.iconPath] then
                    if not inventoryUI.attachedItem or (inventoryUI.attachedItem.parent ~= localPlayer) or (inventoryUI.attachedItem.prevSlot ~= i) then                
                        imports.beautify.native.drawImage(j.startX + (j.paddingX/2), j.startY + (j.paddingY/2), j.width - j.paddingX, j.height - j.paddingY, CInventory.CItems[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    end
                    if isSlotHovered then
                        if isLMBClicked then
                            local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                            local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                            local CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = getAbsoluteCursorPosition()
                            local prev_offsetX, prev_offsetY = j.startX + (j.paddingX/2), j.startY + (j.paddingY/2)
                            local prev_width, prev_height = j.width - j.paddingX, j.height - j.paddingY
                            local attached_offsetX, attached_offsetY = CLIENT_CURSOR_OFFSET[1] - prev_offsetX, CLIENT_CURSOR_OFFSET[2] - prev_offsetY
                            attachInventoryItem(localPlayer, itemDetails.dataName, itemCategory, i, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                        end
                    end
                end
            else
                if j.bgImage then
                    local isPlaceHolderToBeShown = true
                    local placeHolderColor = {255, 255, 255, 255}
                    if inventoryUI.attachedItem then
                        if not inventoryUI.attachedItem.animTickCounter then
                            if isSlotHovered and isUIEnabled then
                                local isSlotAvailable, slotIndex = isPlayerSlotAvailableForEquipping(localPlayer, inventoryUI.attachedItem.item, i, inventoryUI.attachedItem.parent == localPlayer)
                                if isSlotAvailable then
                                    isItemAvailableForEquipping = {
                                        slotIndex = i,
                                        reservedSlot = slotIndex,
                                        offsetX = j.startX + (j.paddingX/2),
                                        offsetY = j.startY + (j.paddingY/2),
                                        parent = inventoryUI.attachedItem.parent
                                    }
                                end
                                placeHolderColor = (isSlotAvailable and j.availableBGColor) or j.unavailableBGColor
                            end
                        else
                            if inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "equipping" and inventoryUI.attachedItem.prevSlot == i then
                                isPlaceHolderToBeShown = false
                            end
                        end
                    end
                    if isPlaceHolderToBeShown then
                        imports.beautify.native.drawImage(j.startX, j.startY, j.width, j.height, j.bgImage, 0, 0, 0, tocolor(placeHolderColor[1], placeHolderColor[2], placeHolderColor[3], placeHolderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)	
                    end
                end
            end
        end

        --Draws ItemBoxes
        for i, j in pairs(inventoryUI.buffer) do
                    if not inventoryUI.isSynced then
                        for k, v in pairs(inventoryUI.buffer[localPlayer].assignedSlots) do
                            if tonumber(k) and v.parent and v.parent == i then
                                if v.translation then
                                    if v.translation == "vicinity" and (tonumber(j.inventory[v.item]) or 0) <= 0 then
                                        if not bufferCache["__"..v.item] then
                                            table.insert(bufferCache, {item = v.item, itemValue = 1})
                                            bufferCache["__"..v.item] = true
                                        end
                                    elseif not inventoryUI.attachedItem then
                                        if (v.translation == "inventory" and not v.isOrdering) or (v.translation == "equipment" and v.isAutoIndexed) then
                                            if not bufferCache["__"..v.item] then
                                                for m, n in ipairs(bufferCache) do
                                                    if n.item == v.item then
                                                        if n.itemValue == 1 then
                                                            table.remove(bufferCache, m)
                                                        else
                                                            n.itemValue = n.itemValue - 1
                                                        end
                                                        bufferCache["__"..v.item] = true
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                    dxSetRenderTarget()
                end
        end
    end
    ]]--