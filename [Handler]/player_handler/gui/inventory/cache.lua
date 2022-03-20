----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: cache.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Cache Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerServerEvent = triggerServerEvent,
    triggerEvent = triggerEvent,
    bindKey = bindKey,
    getPlayerName = getPlayerName,
    showChat = showChat,
    showCursor = showCursor,
    beautify = beautify,
    string = string,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local inventory_margin = 4
local inventory_offsetX, inventory_offsetY = CInventory.fetchSlotDimensions(2, 6)
inventory_offsetY = inventory_offsetY + FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height + inventory_margin
local inventoryUI = {
    buffer = {},
    margin = inventory_margin,
    titlebar = {
        height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.height,
        font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 19), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)),
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.bgColor)),
        slot = {
            height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height,
            fontPaddingY = 2, font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.bgColor))
        }
    },
    clientInventory = {
        startX = 0, startY = -inventory_offsetY,
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerColor)),
        equipment = {
            {identifier = "helmet", slots = {rows = 2, columns = 2}},
            {identifier = "vest", slots = {rows = 2, columns = 2}},
            {identifier = "upper", slots = {rows = 2, columns = 2}},
            {identifier = "lower", slots = {rows = 2, columns = 2}},
            {identifier = "shoes", slots = {rows = 2, columns = 2}},
            {identifier = "primary", slots = {rows = 2, columns = 6}},
            {identifier = "secondary", slots = {rows = 2, columns = 4}},
            {identifier = "backpack", slots = {rows = 3, columns = 3}}
        }
    },
    vicinityInventory = {
        width = inventory_offsetX,
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.bgColor))
    },
    opacityAdjuster = {
        startX = 10, startY = 0,
        width = 27,
        range = {30, 100}
    }
}
inventory_margin, inventory_offsetX, inventory_offsetY = nil, nil, nil

inventoryUI.clientInventory.width, inventoryUI.clientInventory.height = CInventory.fetchSlotDimensions(FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY = inventoryUI.clientInventory.startX + ((CLIENT_MTA_RESOLUTION[1] - inventoryUI.clientInventory.width)*0.5) + (inventoryUI.clientInventory.width*0.5), ((CLIENT_MTA_RESOLUTION[2] + inventoryUI.clientInventory.startY - inventoryUI.clientInventory.height - inventoryUI.titlebar.height)*0.5)
for i = 1, #inventoryUI.clientInventory.equipment, 1 do
    local j = inventoryUI.clientInventory.equipment[i]
    j.width, j.height = CInventory.fetchSlotDimensions(j.slots.rows, j.slots.columns)
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
inventoryUI.vicinityInventory.height = inventoryUI.clientInventory.height
inventoryUI.vicinityInventory.startX, inventoryUI.vicinityInventory.startY = inventoryUI.clientInventory.equipment[1].startX - inventoryUI.vicinityInventory.width - inventoryUI.margin - (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize*0.5), inventoryUI.clientInventory.startY
inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY = inventoryUI.opacityAdjuster.startX + inventoryUI.clientInventory.startX + inventoryUI.clientInventory.width - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.opacityAdjuster.startY - inventoryUI.margin
inventoryUI.opacityAdjuster.height = inventoryUI.clientInventory.equipment[8].startY - inventoryUI.opacityAdjuster.startY - inventoryUI.margin - inventoryUI.titlebar.slot.height
inventoryUI.createBGTexture = function(isRefresh)
    if CLIENT_MTA_MINIMIZED then return false end
    if isRefresh and inventoryUI.bgTexture and imports.isElement(inventoryUI.bgTexture) then
        imports.destroyElement(inventoryUI.bgTexture)
        inventoryUI.bgTexture = nil
    end
    inventoryUI.bgRT = imports.beautify.native.createRenderTarget(CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], true)
    imports.beautify.native.setRenderTarget(inventoryUI.bgRT, true)
    local inventory_startX, inventory_startY = inventoryUI.clientInventory.startX - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
    local inventory_width, inventory_height = inventoryUI.clientInventory.width + (inventoryUI.margin*2), inventoryUI.clientInventory.height + (inventoryUI.margin*2)
    imports.beautify.native.drawRectangle(inventory_startX, inventory_startY - inventoryUI.titlebar.height, inventory_width, inventoryUI.titlebar.height, inventoryUI.titlebar.bgColor, false)
    imports.beautify.native.drawRectangle(inventory_startX, inventory_startY, inventory_width, inventory_height, inventoryUI.clientInventory.bgColor, false)
    for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows - 1, 1 do
        imports.beautify.native.drawRectangle(inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY + inventoryUI.titlebar.height + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i), inventoryUI.clientInventory.width, 1, inventoryUI.clientInventory.dividerColor, false)
    end
    for i = 1, FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - 1, 1 do
        imports.beautify.native.drawRectangle(inventoryUI.clientInventory.startX + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*i), inventoryUI.clientInventory.startY + inventoryUI.titlebar.height, 1, inventoryUI.clientInventory.height, inventoryUI.clientInventory.dividerColor, false)
    end
    for i = 1, #inventoryUI.clientInventory.equipment, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        local title_height = inventoryUI.titlebar.slot.height
        local title_startY = j.startY - inventoryUI.titlebar.slot.height
        j.title = imports.string.upper(imports.string.spaceChars(j.identifier))
        imports.beautify.native.drawRectangle(j.startX, title_startY, j.width, title_height, inventoryUI.titlebar.slot.bgColor, false)
        imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, inventoryUI.clientInventory.bgColor, false)
        for k = 1, j.slots.rows - 1, 1 do
            imports.beautify.native.drawRectangle(j.startX, j.startY + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.width, 1, inventoryUI.clientInventory.dividerColor, false)
        end
        for k = 1, j.slots.columns - 1, 1 do
            imports.beautify.native.drawRectangle(j.startX + ((FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*k), j.startY, 1, j.height, inventoryUI.clientInventory.dividerColor, false)
        end
    end
    if inventoryUI.vicinityInventory.element then
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
inventoryUI.updateUILang = function() inventoryUI.isLangUpdated = true end
imports.addEventHandler("Client:onUpdateLanguage", root, inventoryUI.updateUILang)
inventoryUI.createBuffer = function(parent, name)
    if not parent or not imports.isElement(parent) or inventoryUI.buffer[parent] then return false end
    if (parent ~= localPlayer) and CLoot.isLocked(parent) then
        imports.triggerEvent("Client:onNotification", localPlayer, "Loot is locked..", FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
        return false
    end
    inventoryUI.buffer[parent] = {
        name = imports.string.upper(imports.string.upper(imports.string.spaceChars(boxName or CLoot.fetchName(parent))),
        bufferRT = imports.beautify.native.createRenderTarget(((parent == localPlayer) and inventoryUI.clientInventory.width) or inventoryUI.vicinityInventory.width, ((parent == localPlayer) and inventoryUI.clientInventory.height) or inventoryUI.vicinityInventory.height, true),
        scroller = {percent = 0},
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
inventoryUI.detachItem = function(isForced)
    if not inventoryUI.attachedItem then return false end
    if not isForced then
        inventoryUI.attachedItem.__posX, inventoryUI.attachedItem.__posY = CLIENT_CURSOR_OFFSET[1] - inventoryUI.attachedItem.offsetX, CLIENT_CURSOR_OFFSET[2] - inventoryUI.attachedItem.offsetY
        inventoryUI.attachedItem.animTickCounter = CLIENT_CURRENT_TICK
    else
        inventoryUI.attachedItem = nil
    end
    return true
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

inventoryUI.isUIEnabled = function()
    return (inventoryUI.isUpdated and inventoryUI.isEnabled) or false
end

function isInventoryUIVisible() return inventoryUI.state end
function isInventoryUIEnabled() return inventoryUI.isUIEnabled() end

imports.addEvent("Client:onEnableInventoryUI", true)
imports.addEventHandler("Client:onEnableInventoryUI", root, function(state, isForced)
    if isForced then loginUI.isForcedDisabled = not state end
    inventoryUI.isEnabled = state
end)

imports.addEvent("Client:onSyncInventorySlots", true)
imports.addEventHandler("Client:onSyncInventorySlots", root, function(slots)
    inventoryUI.slots = slots
    inventoryUI.isUpdated, inventoryUI.isUpdateScheduled = true, false
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

inventoryUI.renderUI = function()
    --TODO: ENABLE LATER.
    --if not inventoryUI.state or CPlayer.isInitialized(localPlayer) then return false end
    if inventoryUI.isLangUpdated or not inventoryUI.bgTexture then inventoryUI.createBGTexture(inventoryUI.isLangUpdated) end

    local isInventoryEnabled = inventoryUI.isUIEnabled()
    local inventory_startX, inventory_startY = inventoryUI.clientInventory.startX - inventoryUI.margin, inventoryUI.clientInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
    local inventory_width, inventory_height = inventoryUI.clientInventory.width + (inventoryUI.margin*2), inventoryUI.clientInventory.height + (inventoryUI.margin*2)
    inventoryUI.opacityAdjuster.percent = imports.beautify.slider.getPercent(inventoryUI.opacityAdjuster.element)
    if inventoryUI.opacityAdjuster.percent ~= inventoryUI.opacityAdjuster.__percent then
        inventoryUI.opacityAdjuster.__percent = inventoryUI.opacityAdjuster.percent
        inventoryUI.opacityAdjuster.bgColor = imports.tocolor(255, 255, 255, 255*0.01*(inventoryUI.opacityAdjuster.range[1] + ((inventoryUI.opacityAdjuster.range[2] - inventoryUI.opacityAdjuster.range[1])*inventoryUI.opacityAdjuster.percent*0.01)))
    end
    imports.beautify.native.drawImage(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], inventoryUI.bgTexture, 0, 0, 0, inventoryUI.opacityAdjuster.bgColor, false)
    imports.beautify.native.drawText(inventoryUI.buffer[localPlayer].name, inventory_startX, inventory_startY - inventoryUI.titlebar.height, inventory_startX + inventory_width, inventory_startY, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font, "center", "center", true, false, false)
    for i = 1, #inventoryUI.clientInventory.equipment, 1 do
        local j = inventoryUI.clientInventory.equipment[i]
        imports.beautify.native.drawText(j.title, j.startX, j.startY - inventoryUI.titlebar.slot.height + inventoryUI.titlebar.slot.fontPaddingY, j.startX + j.width, j.startY, inventoryUI.titlebar.slot.fontColor, 1, inventoryUI.titlebar.slot.font, "center", "center", true, false, false)
    end
    if inventoryUI.vicinityInventory.element and inventoryUI.buffer[(inventoryUI.vicinityInventory.element)] then
        local vicinity_startX, vicinity_startY = inventoryUI.vicinityInventory.startX - (inventoryUI.margin*2), inventoryUI.vicinityInventory.startY + inventoryUI.titlebar.height - inventoryUI.margin
        local vicinity_width, vicinity_height = inventoryUI.vicinityInventory.width + (inventoryUI.margin*2), inventoryUI.vicinityInventory.height + (inventoryUI.margin*2)
        imports.beautify.native.drawText(inventoryUI.buffer[(inventoryUI.vicinityInventory.element)].name, vicinity_startX, vicinity_startY - inventoryUI.titlebar.height, vicinity_startX + vicinity_width, vicinity_startY, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font, "center", "center", true, false, false)
    end
    inventoryUI.isLangUpdated = nil
end


----------------------------------------
--[[ Client: On Toggle Inventory UI ]]--
----------------------------------------

inventoryUI.toggleUI = function(state)
    if (((state ~= true) and (state ~= false)) or (state == inventoryUI.state)) then return false end

    if state then
        if inventoryUI.state then return false end
        --TODO: ENABLE LATER
        --if not CPlayer.isInitialized(localPlayer) or (CCharacter.getHealth(localPlayer) <= 0) then inventoryUI.toggleUI(false) return false end
        --TODO: WIP...
        inventoryUI.vicinityInventory.element = CCharacter.isInLoot(localPlayer)
        inventoryUI.createBuffer(localPlayer, imports.getPlayerName(localPlayer).."'s Inventory")
        inventoryUI.createBuffer(inventoryUI.vicinityInventory.element)
        inventoryUI.opacityAdjuster.element = imports.beautify.slider.create(inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY, inventoryUI.opacityAdjuster.width, inventoryUI.opacityAdjuster.height, "vertical", nil, false)
        inventoryUI.opacityAdjuster.percent = inventoryUI.opacityAdjuster.percent or 100
        imports.beautify.slider.setPercent(inventoryUI.opacityAdjuster.element, inventoryUI.opacityAdjuster.percent)
        imports.beautify.slider.setText(inventoryUI.opacityAdjuster.element, "Opacity")
        imports.beautify.slider.setTextColor(inventoryUI.opacityAdjuster.element, FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)
        imports.beautify.render.create(inventoryUI.renderUI, {
            elementReference = inventoryUI.opacityAdjuster.element,
            renderType = "preRender"
        })
        imports.beautify.setUIVisible(inventoryUI.opacityAdjuster.element, true)
    else
        if not inventoryUI.state then return false end
        if inventoryUI.opacityAdjuster.element and imports.isElement(inventoryUI.opacityAdjuster.element) then
            imports.destroyElement(inventoryUI.opacityAdjuster.element)
        end
        if inventoryUI.isUpdateScheduled then
            imports.triggerServerEvent("Player:onSyncInventorySlots", localPlayer)
        end
        inventoryUI.destroyBuffer(localPlayer)
        inventoryUI.destroyBuffer(inventoryUI.vicinityInventory.element)
        inventoryUI.vicinityInventory.element = nil
        inventoryUI.opacityAdjuster.element = nil
    end
    inventoryUI.detachItem(true)
    inventoryUI.state = (state and true) or false
    imports.showChat(not inventoryUI.state)
    imports.showCursor(inventoryUI.state, true) --TODO: RMEOVE FORCED CHECK LATER
    return true
end

imports.addEvent("Client:onToggleInventoryUI", true)
imports.addEventHandler("Client:onToggleInventoryUI", root, inventoryUI.toggleUI)
imports.bindKey(FRAMEWORK_CONFIGS["Inventory"]["UI_ToggleKey"], "down", function() inventoryUI.toggleUI(not inventoryUI.state) end)
imports.addEventHandler("onClientPlayerWasted", localPlayer, function() inventoryUI.toggleUI(false) end)


-------------------
--[[ Variables ]]--
-------------------

--[[
local iconTextures = {}
local iconDimensions = {}
local sortedItems = {
    "primary_weapon",
    "secondary_weapon",
    "Ammo",
    "special_weapon",
    "Medical",
    "Nutrition",
    "Backpack",
    "Helmet",
    "Armor",
    "Suit",
    "Tent",
    "Other",
    "Build",
    "Utility"
}
]]


--------------------------------------
--[[ Function: Displays Inventory ]]--
--------------------------------------

--[[
function displayInventoryUI()

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then return false end

    local isInventoryEnabled = inventoryUI.isUIEnabled()
    local isItemAvailableForOrdering = false
    local isItemAvailableForDropping = false
    local isItemAvailableForEquipping = false
    local equipmentInformation = false
    local playerName = getElementData(localPlayer, "Character:name") or ""
    local playerMaxSlots = getElementMaxSlots(localPlayer)
    local playerUsedSlots = getElementUsedSlots(localPlayer)
    local equipmentInformationColor = inventoryUI.gui.equipment.description.fontColor

    --Draws Equipment
    dxSetRenderTarget()
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.leftEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawRectangle(inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY, inventoryUI.gui.equipment.width, inventoryUI.gui.equipment.height, inventoryUI.gui.equipment.bgPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.bgColor[1], inventoryUI.gui.equipment.bgColor[2], inventoryUI.gui.equipment.bgColor[3], inventoryUI.gui.equipment.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawBorderedText(inventoryUI.gui.equipment.titlebar.outlineWeight, inventoryUI.gui.equipment.titlebar.fontColor, string.upper(playerName.."'S EQUIPMENT   |   "..playerUsedSlots.."/"..playerMaxSlots), inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY, tocolor(inventoryUI.gui.equipment.titlebar.fontColor[1], inventoryUI.gui.equipment.titlebar.fontColor[2], inventoryUI.gui.equipment.titlebar.fontColor[3], inventoryUI.gui.equipment.titlebar.fontColor[4]*inventoryOpacityPercent), 1, inventoryUI.gui.equipment.titlebar.font, "right", "center", true, false, inventoryUI.gui.postGUI)
    dxDrawRectangle(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY, inventoryUI.gui.equipment.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    for i, j in pairs(inventoryUI.gui.equipment.slot) do
        local itemDetails, itemCategory = false, false
        if inventoryUI.slots and inventoryUI.slots.slots[i] then
            itemDetails, itemCategory = getItemDetails(inventoryUI.slots.slots[i])
        end
        imports.beautify.native.drawImage(j.startX - j.borderSize, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX - j.borderSize, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY - j.borderSize, j.width - j.height, j.height + (j.borderSize*2), tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        end
        imports.beautify.native.drawImage(j.startX, j.startY, j.height/2, j.height/2, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY, j.height/2, j.height/2, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY, j.width - j.height, j.height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        end
        local isSlotHovered = isMouseOnPosition(j.startX, j.startY, j.width, j.height) and isInventoryEnabled
        if itemDetails and itemCategory then
            if iconTextures[itemDetails.iconPath] then
                if not inventoryUI.attachedItem or (inventoryUI.attachedItem.itemBox ~= localPlayer) or (inventoryUI.attachedItem.prevSlotIndex ~= i) then                
                    imports.beautify.native.drawImage(j.startX + (j.paddingX/2), j.startY + (j.paddingY/2), j.width - j.paddingX, j.height - j.paddingY, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                end
                if isSlotHovered then
                    equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
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
                        if isSlotHovered and isInventoryEnabled then
                            local isSlotAvailable, slotIndex = isPlayerSlotAvailableForEquipping(localPlayer, inventoryUI.attachedItem.item, i, inventoryUI.attachedItem.itemBox == localPlayer)
                            if isSlotAvailable then
                                isItemAvailableForEquipping = {
                                    slotIndex = i,
                                    reservedSlot = slotIndex,
                                    offsetX = j.startX + (j.paddingX/2),
                                    offsetY = j.startY + (j.paddingY/2),
                                    loot = inventoryUI.attachedItem.itemBox
                                }
                            end
                            placeHolderColor = (isSlotAvailable and j.availableBGColor) or j.unavailableBGColor
                        end
                    else
                        if inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "equipping" and inventoryUI.attachedItem.prevSlotIndex == i then
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
        if i and isElement(i) and j then
            local maxSlots = getElementMaxSlots(i)
            local usedSlots = getElementUsedSlots(i)
            local sortedItems = {}
            local template = inventoryUI.gui.itemBox.templates[j.gui.templateIndex]
            if j.gui.templateIndex == 1 then
                if not j.sortedItems then
                    j.sortedItems = {}
                    for k, v in pairs(inventoryDatas) do
                        for key, value in ipairs(v) do
                            if j.inventory[value.dataName] then
                                for x = 1, j.inventory[value.dataName], 1 do
                                    table.insert(j.sortedItems, {item = value.dataName, itemValue = 1})
                                end
                            end
                        end
                    end
                end
                sortedItems = j.sortedItems
                imports.beautify.native.drawImage(j.gui.startX - template.borderSize, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX - template.borderSize, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX - template.borderSize, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY - template.borderSize, template.width - template.height/5, template.height + (template.borderSize*2), tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY, template.height/10, template.height/10, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY, template.height/10, template.height/10, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY, template.width - template.height/5, template.height, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxSetRenderTarget(j.gui.bufferRT, true)
                local totalSlots, assignedItems, occupiedSlots = math.min(maxSlots, math.max(maxSlots, #sortedItems)), {}, getPlayerOccupiedSlots(localPlayer) or {}
                local totalContentHeight = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) + template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                dxSetRenderTarget(j.gui.bufferRT, true)
                if inventoryUI.slots then
                    for k, v in pairs(inventoryUI.slots.slots) do
                        if tonumber(k) then
                            local isSlotToBeDrawn = true
                            if v.movementType and v.movementType ~= "inventory" then
                                isSlotToBeDrawn = false
                            end
                            if not inventoryUI.isUpdated then
                                if v.movementType == "equipment" and v.isAutoReserved then
                                    if (tonumber(j.inventory[v.item]) or 0) <= 0 then
                                        if not sortedItems["__"..v.item] then
                                            table.insert(sortedItems, {item = v.item, itemValue = 1})
                                            sortedItems["__"..v.item] = true
                                        end
                                    end
                                end
                            end
                            if isSlotToBeDrawn then
                                if v.movementType then
                                    local itemDetails, itemCategory = getItemDetails(v.item)
                                    if itemDetails and itemCategory and iconTextures[itemDetails.iconPath] then
                                        local slotIndex = k
                                        if slotIndex then
                                            local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                            local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                            local iconWidth, iconHeight = 0, template.contentWrapper.itemGrid.inventory.slotSize*verticalSlotsToOccupy
                                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                                            iconWidth = (originalWidth / originalHeight)*iconHeight
                                            local slot_row = math.ceil(slotIndex/maximumInventoryRowSlots)
                                            local slot_column = slotIndex - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                            local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                                            if not inventoryUI.attachedItem or (inventoryUI.attachedItem.itemBox ~= i) or (inventoryUI.attachedItem.prevSlotIndex ~= slotIndex) then
                                                imports.beautify.native.drawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                                            end
                                        end
                                    end
                                else
                                    for m, n in ipairs(sortedItems) do
                                        if v.item == n.item then
                                            if not assignedItems[m] then
                                                assignedItems[m] = k
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k, v in ipairs(sortedItems) do
                    local itemDetails, itemCategory = getItemDetails(v.item)
                    if itemDetails and itemCategory and iconTextures[itemDetails.iconPath] then
                        local slotIndex = assignedItems[k] or false
                        if slotIndex then
                            local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                            local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                            local iconWidth, iconHeight = 0, template.contentWrapper.itemGrid.inventory.slotSize*verticalSlotsToOccupy
                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                            iconWidth = (originalWidth / originalHeight)*iconHeight
                            local slot_row = math.ceil(slotIndex/maximumInventoryRowSlots)
                            local slot_column = slotIndex - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                            local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                            local isItemToBeDrawn = true
                            if inventoryUI.attachedItem and (inventoryUI.attachedItem.itemBox == i) and (inventoryUI.attachedItem.prevSlotIndex == slotIndex) then 
                                if not inventoryUI.attachedItem.reservedSlotType then
                                    isItemToBeDrawn = false
                                end
                            end
                            if isItemToBeDrawn then
                                imports.beautify.native.drawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                            end
                            if not inventoryUI.attachedItem and isInventoryEnabled then
                                if (slot_offsetY >= 0) and ((slot_offsetY + slotHeight) <= template.contentWrapper.height) then
                                    local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, slotWidth, slotHeight)
                                    if isSlotHovered then
                                        equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
                                        if isLMBClicked then
                                            local CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = getAbsoluteCursorPosition()
                                            local prev_offsetX, prev_offsetY = j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY
                                            local prev_width, prev_height = iconWidth, iconHeight
                                            local attached_offsetX, attached_offsetY = CLIENT_CURSOR_OFFSET[1] - prev_offsetX, CLIENT_CURSOR_OFFSET[2] - prev_offsetY
                                            attachInventoryItem(i, v.item, itemCategory, slotIndex, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k = 1, totalSlots, 1 do
                    if not occupiedSlots[k] then
                        local slot_row = math.ceil(k/maximumInventoryRowSlots)
                        local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                        local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                        local isSlotToBeDrawn = true
                        if inventoryUI.attachedItem and inventoryUI.attachedItem.itemBox and isElement(inventoryUI.attachedItem.itemBox) and inventoryUI.attachedItem.itemBox ~= localPlayer and inventoryUI.attachedItem.animTickCounter and inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "ordering" then
                            local slotIndexesToOccupy = {}
                            for m = inventoryUI.attachedItem.prevSlotIndex, inventoryUI.attachedItem.prevSlotIndex + (inventoryUI.attachedItem.occupiedRowSlots - 1), 1 do
                                if m <= totalSlots then
                                    for x = 1, inventoryUI.attachedItem.occupiedColumnSlots, 1 do
                                        local succeedingColumnIndex = m + (maximumInventoryRowSlots*(x - 1))
                                        if succeedingColumnIndex <= totalSlots then
                                            if k == succeedingColumnIndex then
                                                isSlotToBeDrawn = false
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if isSlotToBeDrawn then
                            dxDrawRectangle(slot_offsetX, slot_offsetY, template.contentWrapper.itemGrid.inventory.slotSize, template.contentWrapper.itemGrid.inventory.slotSize, tocolor(unpack(template.contentWrapper.itemGrid.slot.bgColor)), false)
                        end
                    else
                        if inventoryUI.slots.slots[k] and inventoryUI.slots.slots[k].movementType and inventoryUI.slots.slots[k].movementType == "equipment" then
                            local itemDetails, itemCategory = getItemDetails(inventoryUI.slots.slots[k].item)
                            if itemDetails and itemCategory then
                                local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                local slot_row = math.ceil(k/maximumInventoryRowSlots)
                                local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                                local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.inventory.slotSize + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                                local equippedIndex = inventoryUI.slots.slots[k].equipmentIndex
                                if not equippedIndex then
                                    for m, n in pairs(inventoryUI.gui.equipment.slot) do
                                        if inventoryUI.slots.slots[m] and inventoryUI.slots.slots[m] == inventoryUI.slots.slots[k].item then
                                            equippedIndex = m
                                            break
                                        end
                                    end
                                end
                                if equippedIndex then
                                    dxDrawText(string.upper("EQUIPPED: "..equippedIndex), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth, slot_offsetY + slotHeight, tocolor(unpack(template.contentWrapper.itemGrid.slot.fontColor)), 1, template.contentWrapper.itemGrid.slot.font, "right", "bottom", true, true, false)
                                end
                            end
                        end
                    end
                end
                if inventoryUI.attachedItem and not inventoryUI.attachedItem.animTickCounter then
                    for k = 1, totalSlots, 1 do
                        if not occupiedSlots[k] then
                            local slot_row = math.ceil(k/maximumInventoryRowSlots)
                            local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                            if (slot_offsetY >= 0) and ((slot_offsetY + template.contentWrapper.itemGrid.inventory.slotSize) <= template.contentWrapper.height) then
                                local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, template.contentWrapper.itemGrid.inventory.slotSize, template.contentWrapper.itemGrid.inventory.slotSize)
                                if isSlotHovered then
                                    local isSlotAvailable = isPlayerSlotAvailableForOrdering(localPlayer, inventoryUI.attachedItem.item, k, inventoryUI.attachedItem.isEquippedItem)
                                    if isSlotAvailable then
                                        isItemAvailableForOrdering = {
                                            slotIndex = k,
                                            offsetX = slot_offsetX,
                                            offsetY = slot_offsetY
                                        }
                                    end
                                    for m = k, k + (inventoryUI.attachedItem.occupiedRowSlots - 1), 1 do
                                        for x = 1, inventoryUI.attachedItem.occupiedColumnSlots, 1 do
                                            local succeedingColumnIndex = m + (maximumInventoryRowSlots*(x - 1))
                                            if succeedingColumnIndex <= totalSlots and not occupiedSlots[succeedingColumnIndex] then
                                                local _slot_row = math.ceil(succeedingColumnIndex/maximumInventoryRowSlots)
                                                local _slot_column = succeedingColumnIndex - (math.max(0, _slot_row - 1)*maximumInventoryRowSlots)
                                                local _slot_offsetX, _slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, _slot_column - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, _slot_row - 1)*(template.contentWrapper.itemGrid.inventory.slotSize + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                                if _slot_column >= slot_column then
                                                    dxDrawRectangle(_slot_offsetX, _slot_offsetY, template.contentWrapper.itemGrid.inventory.slotSize, template.contentWrapper.itemGrid.inventory.slotSize, tocolor(unpack((isSlotAvailable and template.contentWrapper.itemGrid.slot.availableBGColor) or template.contentWrapper.itemGrid.slot.unavailableBGColor)), false)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                dxSetRenderTarget()
                imports.beautify.native.drawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.bufferRT, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    if prevScrollState and (not inventoryUI.attachedItem or not inventoryUI.attachedItem.animTickCounter) and (isMouseOnPosition(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight) or isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height)) then
                        if prevScrollState == "up" then
                            if j.gui.scroller.percent <= 0 then
                                j.gui.scroller.percent = 0
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent - (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent - (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent <= 0 then j.gui.scroller.percent = 0 end
                            end
                        elseif prevScrollState == "down" then
                            if j.gui.scroller.percent >= 100 then
                                j.gui.scroller.percent = 100
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent + (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent + (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent >= 100 then j.gui.scroller.percent = 100 end
                            end
                        end
                        prevScrollState = false
                    end
                end
            else
                if not j.sortedItems then
                    j.sortedItems = {}
                    for k, v in ipairs(sortedItems) do
                        if inventoryDatas[v] then
                            for key, value in ipairs(inventoryDatas[v]) do
                                if j.inventory[value.dataName] then
                                    table.insert(j.sortedItems, {item = value.dataName, itemValue = j.inventory[value.dataName]})
                                end
                            end
                        end
                    end
                    for k, v in pairs(inventoryDatas) do
                        local isSortedCategory = false
                        for m, n in ipairs(sortedItems) do
                            if k == n then
                                isSortedCategory = true
                                break
                            end
                        end
                        if not isSortedCategory then
                            for key, value in ipairs(v) do
                                if j.inventory[value.dataName] then
                                    table.insert(j.sortedItems, {item = value.dataName, itemValue = j.inventory[value.dataName]})
                                end
                            end
                        end
                    end
                end
                sortedItems = j.sortedItems
                imports.beautify.native.drawImage(j.gui.startX + template.width - inventoryUI.gui.equipment.titlebar.height, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.rightEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawBorderedText(inventoryUI.gui.equipment.titlebar.outlineWeight, inventoryUI.gui.equipment.titlebar.fontColor, string.upper(j.gui.identifier.."   |   "..usedSlots.."/"..maxSlots), j.gui.startX + inventoryUI.gui.equipment.titlebar.height, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startX + template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY, tocolor(inventoryUI.gui.equipment.titlebar.fontColor[1], inventoryUI.gui.equipment.titlebar.fontColor[2], inventoryUI.gui.equipment.titlebar.fontColor[3], inventoryUI.gui.equipment.titlebar.fontColor[4]*inventoryOpacityPercent), 1, inventoryUI.gui.equipment.titlebar.font, "left", "center", true, false, inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY + template.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.invertedEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + inventoryUI.gui.equipment.titlebar.height, j.gui.startY + template.height, template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                local templateBGColor = table.copy(template.bgColor, true)
                if inventoryUI.attachedItem and not inventoryUI.attachedItem.animTickCounter and inventoryUI.attachedItem.itemBox == localPlayer then
                    local isLootHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and not isItemAvailableForOrdering
                    if isLootHovered then
                        if isLootSlotAvailableForDropping(i, inventoryUI.attachedItem.item) then
                            local itemSlotIndex = false
                            for k, v in ipairs(sortedItems) do
                                if v.item == inventoryUI.attachedItem.item then
                                    itemSlotIndex = k
                                    break
                                end
                            end
                            if not itemSlotIndex then itemSlotIndex = (#sortedItems) + 1 end
                            isItemAvailableForDropping = {
                                slotIndex = itemSlotIndex,
                                loot = i
                            }
                            templateBGColor[1] = template.contentWrapper.itemSlot.availableBGColor[1]
                            templateBGColor[2] = template.contentWrapper.itemSlot.availableBGColor[2]
                            templateBGColor[3] = template.contentWrapper.itemSlot.availableBGColor[3]
                        else
                            templateBGColor[1] = template.contentWrapper.itemSlot.unavailableBGColor[1]
                            templateBGColor[2] = template.contentWrapper.itemSlot.unavailableBGColor[2]
                            templateBGColor[3] = template.contentWrapper.itemSlot.unavailableBGColor[3]
                        end
                    end
                end
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY, template.width, template.height, template.bgImage, 0, 0, 0, tocolor(templateBGColor[1], templateBGColor[2], templateBGColor[3], templateBGColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY, template.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height - inventoryUI.gui.equipment.titlebar.dividerSize, template.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxSetRenderTarget(j.gui.bufferRT, true)
                local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(#sortedItems))
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                if not j.itemBuffer then j.itemBuffer = {} end
                if not inventoryUI.isUpdated then
                    for k, v in pairs(inventoryUI.slots.slots) do
                        if tonumber(k) and v.loot and v.loot == i then
                            if v.movementType then
                                if v.movementType == "loot" and (tonumber(j.inventory[v.item]) or 0) <= 0 then
                                    if not sortedItems["__"..v.item] then
                                        table.insert(sortedItems, {item = v.item, itemValue = 1})
                                        sortedItems["__"..v.item] = true
                                    end
                                elseif not inventoryUI.attachedItem then
                                    if (v.movementType == "inventory" and not v.isOrdering) or (v.movementType == "equipment" and v.isAutoReserved) then
                                        if not sortedItems["__"..v.item] then
                                            for m, n in ipairs(sortedItems) do
                                                if n.item == v.item then
                                                    if n.itemValue == 1 then
                                                        table.remove(sortedItems, m)
                                                    else
                                                        n.itemValue = n.itemValue - 1
                                                    end
                                                    sortedItems["__"..v.item] = true
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
                for k, v in ipairs(sortedItems) do
                    local slot_offsetX, slot_offsetY = template.contentWrapper.itemSlot.startX, template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(k - 1))
                    local slotWidth, slotHeight = template.contentWrapper.width + template.contentWrapper.itemSlot.width, template.contentWrapper.itemSlot.height
                    if exceededContentHeight > 0 then slot_offsetY = slot_offsetY - (exceededContentHeight*j.gui.scroller.percent*0.01) end
                    imports.beautify.native.drawImage(slot_offsetX, slot_offsetY, slotWidth, slotHeight, template.contentWrapper.itemSlot.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                    local itemDetails, itemCategory = getItemDetails(v.item)
                    if itemDetails and itemCategory then
                        if iconTextures[itemDetails.iconPath] then
                            if not j.itemBuffer[itemDetails.dataName] then
                                j.itemBuffer[itemDetails.dataName] = {
                                    hoverAnimPercent = 0,
                                    hoverAlphaPercent = 0,
                                    hoverStatus = "backward",
                                    hoverAnimTickCounter = getTickCount() - template.contentWrapper.itemSlot.itemName.hoverAnimDuration
                                }
                            end
                            local iconStartX, iconStartY = slot_offsetX + template.contentWrapper.itemSlot.iconSlot.startX, slot_offsetY + template.contentWrapper.itemSlot.iconSlot.startY
                            local iconWidth, iconHeight = 0, template.contentWrapper.itemSlot.iconSlot.height
                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                            iconWidth = (originalWidth / originalHeight)*iconHeight
                            local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, slotWidth, slotHeight) and (slot_offsetY >= 0) and ((slot_offsetY + slotHeight) <= template.contentWrapper.height) and not inventoryUI.attachedItem and isInventoryEnabled
                            if isSlotHovered then
                                equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
                                if j.itemBuffer[itemDetails.dataName].hoverStatus ~= "forward" then
                                    j.itemBuffer[itemDetails.dataName].hoverStatus = "forward"
                                    j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter = getTickCount()
                                end
                            else
                                if j.itemBuffer[itemDetails.dataName].hoverStatus ~= "backward" then
                                    j.itemBuffer[itemDetails.dataName].hoverStatus = "backward"
                                    j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter = getTickCount()
                                end
                            end
                            if j.itemBuffer[itemDetails.dataName].hoverStatus == "forward" then
                                j.itemBuffer[itemDetails.dataName].hoverAnimPercent = interpolateBetween(j.itemBuffer[itemDetails.dataName].hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration), "OutBounce")
                                j.itemBuffer[itemDetails.dataName].hoverAlphaPercent = interpolateBetween(j.itemBuffer[itemDetails.dataName].hoverAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration*2), "OutBounce")
                            else
                                j.itemBuffer[itemDetails.dataName].hoverAnimPercent = interpolateBetween(j.itemBuffer[itemDetails.dataName].hoverAnimPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration), "OutBounce")
                                j.itemBuffer[itemDetails.dataName].hoverAlphaPercent = interpolateBetween(j.itemBuffer[itemDetails.dataName].hoverAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.itemBuffer[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration*0.5), "OutBounce")
                            end
                            local lootItemValue = v.itemValue
                            if inventoryUI.attachedItem then
                                if inventoryUI.attachedItem.itemBox == i then
                                    if inventoryUI.attachedItem.releaseIndex then
                                        if inventoryUI.attachedItem.releaseIndex == k then
                                            lootItemValue = lootItemValue - 1
                                        end
                                    elseif inventoryUI.attachedItem.prevSlotIndex == k then
                                        lootItemValue = lootItemValue - 1
                                    end
                                end
                            end
                            if lootItemValue > 0 then
                                imports.beautify.native.drawImage(iconStartX, iconStartY, iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                                dxDrawText(tostring(lootItemValue), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth - template.contentWrapper.itemSlot.itemCounter.paddingX, slot_offsetY + slotHeight - template.contentWrapper.itemSlot.itemCounter.paddingY, tocolor(unpack(template.contentWrapper.itemSlot.itemCounter.fontColor)), 1, template.contentWrapper.itemSlot.itemCounter.font, "right", "bottom", true, false, false)
                            end
                            dxDrawImageSection(slot_offsetX, slot_offsetY, slotWidth, slotHeight, 0, 0, slotWidth*j.itemBuffer[itemDetails.dataName].hoverAnimPercent, slotHeight, template.contentWrapper.itemSlot.itemName.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                            dxDrawText(string.upper(itemDetails.itemName), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth - template.contentWrapper.itemSlot.itemName.paddingX, slot_offsetY + slotHeight, tocolor(template.contentWrapper.itemSlot.itemName.fontColor[1], template.contentWrapper.itemSlot.itemName.fontColor[2], template.contentWrapper.itemSlot.itemName.fontColor[3], template.contentWrapper.itemSlot.itemName.fontColor[4]*j.itemBuffer[itemDetails.dataName].hoverAlphaPercent), 1, template.contentWrapper.itemSlot.itemName.font, "right", "center", true, false, false)
                            if isSlotHovered then
                                if isLMBClicked then
                                    local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                    local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                    local CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = getAbsoluteCursorPosition()
                                    local prev_offsetX, prev_offsetY = j.gui.startX + template.contentWrapper.startX + iconStartX, j.gui.startY + template.contentWrapper.startY + iconStartY
                                    local prev_width, prev_height = iconWidth, iconHeight
                                    local attached_offsetX, attached_offsetY = CLIENT_CURSOR_OFFSET[1] - prev_offsetX, CLIENT_CURSOR_OFFSET[2] - prev_offsetY
                                    attachInventoryItem(i, v.item, itemCategory, k, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                                elseif isRMBClicked then
                                    --TODO: ...
                                end
                            end
                        end
                    end
                end
                dxSetRenderTarget()
                imports.beautify.native.drawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.bufferRT, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    if prevScrollState and (isMouseOnPosition(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight) or isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height)) then
                        if prevScrollState == "up" then
                            if j.gui.scroller.percent <= 0 then
                                j.gui.scroller.percent = 0
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent - (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent - (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent <= 0 then j.gui.scroller.percent = 0 end
                            end
                        elseif prevScrollState == "down" then
                            if j.gui.scroller.percent >= 100 then
                                j.gui.scroller.percent = 100
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent + (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent + (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent >= 100 then j.gui.scroller.percent = 100 end
                            end
                        end
                        prevScrollState = false
                    end
                end
            end
        end
    end

    --Draws Lock Stat
    local lockStat_offsetX, lockStat_offsetY = inventoryUI.gui.lockStat.startX + (inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.width - inventoryUI.gui.lockStat.iconSize), inventoryUI.gui.equipment.startY + inventoryUI.gui.lockStat.startY
    imports.beautify.native.drawImage(lockStat_offsetX, lockStat_offsetY, inventoryUI.gui.lockStat.iconSize, inventoryUI.gui.lockStat.iconSize, ((isInventoryEnabled and not inventoryUI.attachedItem) and inventoryUI.gui.lockStat.unlockedIconPath) or inventoryUI.gui.lockStat.lockedIconPath, 0, 0, 0, tocolor(inventoryUI.gui.lockStat.iconColor[1], inventoryUI.gui.lockStat.iconColor[2], inventoryUI.gui.lockStat.iconColor[3], inventoryUI.gui.lockStat.iconColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)

    if inventoryUI.attachedItem then
        local itemDetails = getItemDetails(inventoryUI.attachedItem.item)
        if not itemDetails then
            detachInventoryItem(true)
        else
            local horizontalSlotsToOccupy = inventoryUI.attachedItem.occupiedRowSlots
            local verticalSlotsToOccupy = inventoryUI.attachedItem.occupiedColumnSlots
            local iconWidth, iconHeight = 0, inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize*verticalSlotsToOccupy
            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
            iconWidth = (originalWidth / originalHeight)*iconHeight
            if (GuiElement.isMTAWindowActive() or not getKeyState("mouse1") or not isInventoryEnabled) and (not inventoryUI.attachedItem.animTickCounter) then
                prevScrollState = false
                if isItemAvailableForOrdering then
                    local slotWidth, slotHeight = horizontalSlotsToOccupy*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + ((horizontalSlotsToOccupy - 1)*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding), verticalSlotsToOccupy*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + ((verticalSlotsToOccupy - 1)*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)
                    local releaseIndex = inventoryUI.attachedItem.prevSlotIndex
                    inventoryUI.attachedItem.prevSlotIndex = isItemAvailableForOrdering.slotIndex
                    inventoryUI.attachedItem.prevPosX = inventoryUI.buffer[localPlayer].gui.startX + inventoryUI.gui.itemBox.templates[1].contentWrapper.startX + isItemAvailableForOrdering.offsetX + ((slotWidth - iconWidth)/2)
                    inventoryUI.attachedItem.prevPosY = inventoryUI.buffer[localPlayer].gui.startY + inventoryUI.gui.itemBox.templates[1].contentWrapper.startY + isItemAvailableForOrdering.offsetY + ((slotHeight - iconHeight)/2)
                    inventoryUI.attachedItem.releaseType = "ordering"
                    inventoryUI.attachedItem.releaseIndex = releaseIndex
                    if inventoryUI.attachedItem.itemBox == localPlayer then
                        if inventoryUI.attachedItem.isEquippedItem then
                            unequipItemInInventory(inventoryUI.attachedItem.item, releaseIndex, isItemAvailableForOrdering.slotIndex, localPlayer)
                        else
                            orderItemInInventory(inventoryUI.attachedItem.item, releaseIndex, isItemAvailableForOrdering.slotIndex)
                        end
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForDropping then
                    local totalLootItems = 0
                    for index, _ in pairs(inventoryUI.buffer[isItemAvailableForDropping.loot].inventory) do
                        totalLootItems = totalLootItems + 1
                    end
                    local template = inventoryUI.gui.itemBox.templates[(inventoryUI.buffer[isItemAvailableForDropping.loot].gui.templateIndex)]
                    local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                    local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                    local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(isItemAvailableForDropping.slotIndex - 1))
                    local slotWidth, slotHeight = 0, template.contentWrapper.itemSlot.iconSlot.height
                    slotWidth = (originalWidth / originalHeight)*slotHeight
                    if exceededContentHeight > 0 then
                        slot_offsetY = slot_offsetY - (exceededContentHeight*inventoryUI.buffer[isItemAvailableForDropping.loot].gui.scroller.percent*0.01)
                        if slot_offsetY < 0 then
                            local finalScrollPercent = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.scroller.percent + (slot_offsetY/exceededContentHeight)*100
                            slot_offsetY = template.contentWrapper.itemSlot.paddingY
                            inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        elseif (slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) > template.contentWrapper.height then
                            local finalScrollPercent = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.scroller.percent + (((slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) - template.contentWrapper.height)/exceededContentHeight)*100
                            slot_offsetY = template.contentWrapper.height - (template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY)
                            inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        end
                    end
                    local releaseIndex = inventoryUI.attachedItem.prevSlotIndex
                    inventoryUI.attachedItem.__finalWidth, inventoryUI.attachedItem.__finalHeight = slotWidth, slotHeight
                    inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                    inventoryUI.attachedItem.sizeAnimTickCounter = getTickCount()
                    inventoryUI.attachedItem.prevSlotIndex = isItemAvailableForDropping.slotIndex
                    inventoryUI.attachedItem.prevPosX = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.startX + template.contentWrapper.startX + template.contentWrapper.itemSlot.startX + template.contentWrapper.itemSlot.iconSlot.startX
                    inventoryUI.attachedItem.prevPosY = inventoryUI.buffer[isItemAvailableForDropping.loot].gui.startY + template.contentWrapper.startY + slot_offsetY
                    inventoryUI.attachedItem.releaseType = "dropping"
                    inventoryUI.attachedItem.releaseLoot = isItemAvailableForDropping.loot
                    inventoryUI.attachedItem.releaseIndex = releaseIndex
                    if inventoryUI.attachedItem.isEquippedItem then
                        local reservedSlotIndex = false
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[releaseIndex] = nil
                        for i, j in pairs(inventoryUI.slots.slots) do
                            if tonumber(i) then
                                if j.movementType and j.movementType == "equipment" and releaseIndex == j.equipmentIndex then
                                    reservedSlotIndex = i
                                    break
                                end
                            end
                        end
                        if reservedSlotIndex then
                            inventoryUI.attachedItem.reservedSlotType = "equipment"
                            inventoryUI.attachedItem.reservedSlot = reservedSlotIndex
                            inventoryUI.slots.slots[reservedSlotIndex] = {
                                item = inventoryUI.attachedItem.item,
                                loot = isItemAvailableForDropping.loot,
                                movementType = "loot"
                            }
                        end
                    else
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[releaseIndex] = {
                            item = inventoryUI.attachedItem.item,
                            loot = isItemAvailableForDropping.loot,
                            movementType = "loot"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForEquipping then
                    local slotWidth, slotHeight = inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].width - inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].paddingX, inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].height - inventoryUI.gui.equipment.slot[isItemAvailableForEquipping.slotIndex].paddingY
                    local releaseIndex = inventoryUI.attachedItem.prevSlotIndex
                    local reservedSlot = isItemAvailableForEquipping.reservedSlot or releaseIndex
                    inventoryUI.attachedItem.__finalWidth, inventoryUI.attachedItem.__finalHeight = slotWidth, slotHeight
                    inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                    inventoryUI.attachedItem.sizeAnimTickCounter = getTickCount()
                    inventoryUI.attachedItem.prevSlotIndex = isItemAvailableForEquipping.slotIndex
                    inventoryUI.attachedItem.prevPosX = isItemAvailableForEquipping.offsetX
                    inventoryUI.attachedItem.prevPosY = isItemAvailableForEquipping.offsetY
                    inventoryUI.attachedItem.releaseType = "equipping"
                    inventoryUI.attachedItem.releaseLoot = isItemAvailableForEquipping.loot
                    inventoryUI.attachedItem.releaseIndex = releaseIndex
                    inventoryUI.attachedItem.reservedSlot = reservedSlot
                    if loot == localPlayer then
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[reservedSlot] = {
                            item = inventoryUI.attachedItem.item,
                            movementType = "equipment"
                        }
                    else
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[reservedSlot] = {
                            item = inventoryUI.attachedItem.item,
                            loot = isItemAvailableForEquipping.loot,
                            isAutoReserved = true,
                            movementType = "equipment"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                else
                    if inventoryUI.attachedItem.itemBox and isElement(inventoryUI.attachedItem.itemBox) and inventoryUI.buffer[inventoryUI.attachedItem.itemBox] then
                        if inventoryUI.attachedItem.itemBox == localPlayer then
                            local maxSlots = getElementMaxSlots(inventoryUI.attachedItem.itemBox)
                            local totalContentHeight = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding
                            local exceededContentHeight =  totalContentHeight - inventoryUI.gui.itemBox.templates[1].contentWrapper.height
                            if exceededContentHeight > 0 then
                                local slot_row = math.ceil(inventoryUI.attachedItem.prevSlotIndex/maximumInventoryRowSlots)
                                local slot_offsetY = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.inventory.slotSize + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) - (exceededContentHeight*inventoryUI.buffer[localPlayer].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryUI.attachedItem.prevPosY - inventoryUI.buffer[localPlayer].gui.startY - inventoryUI.gui.itemBox.templates[1].contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = inventoryUI.buffer[localPlayer].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[localPlayer].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        else
                            local totalLootItems = 0
                            for index, _ in pairs(inventoryUI.buffer[inventoryUI.attachedItem.itemBox].inventory) do
                                totalLootItems = totalLootItems + 1
                            end
                            local template = inventoryUI.gui.itemBox.templates[(inventoryUI.buffer[inventoryUI.attachedItem.itemBox].gui.templateIndex)]
                            local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                            local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                            inventoryUI.attachedItem.__finalWidth, inventoryUI.attachedItem.__finalHeight = inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight
                            inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight = inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height
                            inventoryUI.attachedItem.sizeAnimTickCounter = getTickCount()
                            if exceededContentHeight > 0 then
                                local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(inventoryUI.attachedItem.prevSlotIndex - 1)) + template.contentWrapper.itemSlot.paddingY - (exceededContentHeight*inventoryUI.buffer[inventoryUI.attachedItem.itemBox].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryUI.attachedItem.prevPosY - inventoryUI.buffer[inventoryUI.attachedItem.itemBox].gui.startY - template.contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = inventoryUI.buffer[inventoryUI.attachedItem.itemBox].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryUI.attachedItem.__scrollItemBox = {initial = inventoryUI.buffer[inventoryUI.attachedItem.itemBox].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        end
                        triggerEvent("onClientInventorySound", localPlayer, "inventory_rollback_item")
                    end
                end
                detachInventoryItem()
            end
            if not inventoryUI.attachedItem.__finalWidth or not inventoryUI.attachedItem.__finalHeight then
                inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height = interpolateBetween(inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight, 0, iconWidth, iconHeight, 0, getInterpolationProgress(inventoryUI.attachedItem.sizeAnimTickCounter, inventoryUI.attachedItemAnimDuration/3), "OutBack")
            else
                inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height = interpolateBetween(inventoryUI.attachedItem.prevWidth, inventoryUI.attachedItem.prevHeight, 0, inventoryUI.attachedItem.__finalWidth, inventoryUI.attachedItem.__finalHeight, 0, getInterpolationProgress(inventoryUI.attachedItem.sizeAnimTickCounter, inventoryUI.attachedItemAnimDuration/3), "OutBack")
            end
            if inventoryUI.attachedItem.animTickCounter then
                local icon_offsetX, icon_offsetY = interpolateBetween(inventoryUI.attachedItem.__posX, inventoryUI.attachedItem.__posY, 0, inventoryUI.attachedItem.prevPosX, inventoryUI.attachedItem.prevPosY, 0, getInterpolationProgress(inventoryUI.attachedItem.animTickCounter, inventoryUI.attachedItemAnimDuration), "OutBounce")
                if inventoryUI.attachedItem.__scrollItemBox then
                    inventoryUI.buffer[(inventoryUI.attachedItem.releaseLoot or inventoryUI.attachedItem.itemBox)].gui.scroller.percent = interpolateBetween(inventoryUI.attachedItem.__scrollItemBox.initial, 0, 0, inventoryUI.attachedItem.__scrollItemBox.final, 0, 0, getInterpolationProgress(inventoryUI.attachedItem.__scrollItemBox.tickCounter, inventoryUI.attachedItemAnimDuration), "OutBounce")
                end
                imports.beautify.native.drawImage(icon_offsetX, icon_offsetY, inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                if (math.round(icon_offsetX, 2) == math.round(inventoryUI.attachedItem.prevPosX, 2)) and (math.round(icon_offsetY, 2) == math.round(inventoryUI.attachedItem.prevPosY, 2)) then
                    if inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "equipping" then
                        equipItemInInventory(inventoryUI.attachedItem.item, inventoryUI.attachedItem.releaseIndex, inventoryUI.attachedItem.reservedSlot, inventoryUI.attachedItem.prevSlotIndex, inventoryUI.attachedItem.itemBox)
                    else
                        if inventoryUI.attachedItem.itemBox ~= localPlayer then
                            if inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "ordering" then
                                if not inventoryUI.attachedItem.isEquippedItem then
                                    moveItemInInventory(inventoryUI.attachedItem.item, inventoryUI.attachedItem.prevSlotIndex, inventoryUI.attachedItem.itemBox)
                                end
                            end
                        else
                            if inventoryUI.attachedItem.releaseType and inventoryUI.attachedItem.releaseType == "dropping" then
                                if inventoryUI.attachedItem.isEquippedItem then
                                    unequipItemInInventory(inventoryUI.attachedItem.item, inventoryUI.attachedItem.releaseIndex, inventoryUI.attachedItem.prevSlotIndex, inventoryUI.attachedItem.releaseLoot, inventoryUI.attachedItem.reservedSlot)
                                else
                                    moveItemInLoot(inventoryUI.attachedItem.item, inventoryUI.attachedItem.releaseIndex, inventoryUI.attachedItem.releaseLoot)
                                end
                            end
                        end
                    end
                    detachInventoryItem(true)
                end
            else
                local CLIENT_CURSOR_OFFSET[1], CLIENT_CURSOR_OFFSET[2] = getAbsoluteCursorPosition()
                imports.beautify.native.drawImage(CLIENT_CURSOR_OFFSET[1] - inventoryUI.attachedItem.offsetX, CLIENT_CURSOR_OFFSET[2] - inventoryUI.attachedItem.offsetY, inventoryUI.attachedItem.__width, inventoryUI.attachedItem.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
            end
        end
    end

    prevScrollState = false

end
]]--

-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

--[[
addEventHandler("onClientResourceStart", resource, function()

    for i, j in pairs(inventoryDatas) do
        for k, v in ipairs(j) do
            iconTextures[v.iconPath] = DxTexture(v.iconPath, "argb", true, "clamp")
            local originalWidth, originalHeight = dxGetMaterialSize(iconTextures[v.iconPath])
            iconDimensions[v.iconPath] = {width = originalWidth, height = originalHeight}
        end
    end

end)
]]