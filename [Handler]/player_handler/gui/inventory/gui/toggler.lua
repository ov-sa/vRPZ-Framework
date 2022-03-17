----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: toggler.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Toggler ]]--
----------------------------------------------------------------


----------------------------------------------------
--[[ Function: Retrieves Inventory's Visibility ]]--
----------------------------------------------------

isVisible = false
isSlotsUpdated = false
isEnabled = false

inventoryUI.isUIEnabled = function()
    return (inventoryUI.isSlotsUpdated and inventoryUI.isEnabled) or false
end

imports.addEvent("Client:onEnableInventoryUI", true)
imports.addEventHandler("Client:onEnableInventoryUI", root, function(state, isForced)
    if isForced then loginUI.isForcedDisabled = not state end
    inventoryUI.isEnabled = state
end)

imports.addEvent("Client:onSyncInventorySlots", true)
imports.addEventHandler("Client:onSyncInventorySlots", root, function(slotData)
    inventoryUI.inventorySlots = slotData
    inventoryUI.isSlotsUpdatePending = false
    inventoryUI.isSlotsUpdated = true
end)


-------------------------------------------
--[[ Event: On Client Inventory Update ]]--
-------------------------------------------

local function inventoryUpdate()

    inventoryUI.attachedItemOnCursor = nil
    updateItemBox(localPlayer)
    updateItemBox(inventoryUI.vicinity)

end
addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", root, inventoryUpdate)


------------------------------------------
--[[ Functions: Shows/Hides Inventory ]]--
------------------------------------------


inventoryUI.toggleUI = function(state)
    if state then
        if inventoryUI.element and imports.isElement(inventoryUI.element) then return false end
        --[[
        local panel_offsetY = inventoryUI.titlebar.height + inventoryUI.titlebar.paddingY
        inventoryUI.element = imports.beautify.card.create(inventoryUI.startX, inventoryUI.startY, inventoryUI.width, inventoryUI.height, nil, false)
        imports.beautify.setUIVisible(inventoryUI.element, true)
        for i = 1, #inventoryUI.categories, 1 do
            local j = inventoryUI.categories[i]
            j.offsetY = (inventoryUI.categories[(i - 1)] and (inventoryUI.categories[(i - 1)].offsetY + inventoryUI.categories.height + inventoryUI.categories[(i - 1)].height + inventoryUI.categories.paddingY)) or panel_offsetY
            if j.contents then
                for k, v in imports.pairs(j.contents) do
                    if v.isSlider then
                        v.element = imports.beautify.slider.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height + v.startY + v.paddingY, inventoryUI.width - (inventoryUI.categories.paddingX*2), v.height, "horizontal", inventoryUI.element, false)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISliderAltered", v.element, function() inventoryUI.updateCharacter() end)
                    elseif v.isSelector then
                        v.element = imports.beautify.selector.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height + v.startY, inventoryUI.width - (inventoryUI.categories.paddingX*2), v.height, "horizontal", inventoryUI.element, false)
                        imports.beautify.selector.setDataList(v.element, v.content)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISelectionAltered", v.element, function() inventoryUI.updateCharacter() end)
                    end
                end
            elseif j.isSelector then
                j.element = imports.beautify.selector.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height, inventoryUI.width - (inventoryUI.categories.paddingX*2), j.height, "horizontal", inventoryUI.element, false)
                imports.beautify.selector.setDataList(j.element, j.content)
                imports.beautify.setUIVisible(j.element, true)
                imports.addEventHandler("onClientUISelectionAltered", j.element, function() inventoryUI.updateCharacter() end)
            end
        end
        ]]
        imports.beautify.render.create(function()
            --[[
            imports.beautify.native.drawRectangle(0, 0, inventoryUI.width, inventoryUI.titlebar.height, inventoryUI.titlebar.bgColor, false)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Titles"][FRAMEWORK_LANGUAGE])), 0, 0, inventoryUI.width, inventoryUI.titlebar.height, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, inventoryUI.titlebar.height, inventoryUI.width, inventoryUI.titlebar.paddingY, inventoryUI.titlebar.shadowColor, false)
            for i = 1, #inventoryUI.categories, 1 do
                local j = inventoryUI.categories[i]
                local category_offsetY = j.offsetY + inventoryUI.categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, inventoryUI.width, inventoryUI.categories.height, inventoryUI.titlebar.bgColor, false)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, inventoryUI.width, category_offsetY, inventoryUI.categories.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, inventoryUI.width, j.height, inventoryUI.categories.bgColor, false)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_height = inventoryUI.categories.height
                        local title_offsetY = category_offsetY + v.startY - title_height
                        imports.beautify.native.drawRectangle(0, title_offsetY, inventoryUI.width, title_height, inventoryUI.titlebar.bgColor, false)
                        imports.beautify.native.drawText(v.title, 0, title_offsetY, inventoryUI.width, title_offsetY + title_height, inventoryUI.titlebar.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
                    end
                end
            end
            ]]
        end, {
            elementReference = inventoryUI.element,
            renderType = "preViewRTRender"
        })
    else
        if not inventoryUI.element or not imports.isElement(inventoryUI.element) then return false end
        imports.destroyElement(inventoryUI.element)
        inventoryUI.element = nil
    end
    inventoryUI.isVisible = (state and true) or false
    return true
end




function inventoryUI.toggleUI(true)

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then inventoryUI.toggleUI(false) return false end
    if inventoryUI.isVisible then return false end
    
    createItemBox(inventoryUI.gui.equipment.startX + 250 + 50, inventoryUI.gui.equipment.startY + 25, 1, localPlayer, "Inventory")
    inventoryUI.vicinity = isPlayerInLoot(localPlayer)
    if inventoryUI.vicinity and isElement(inventoryUI.vicinity) then
        local vicinityLockedStatus = inventoryUI.vicinity:getData("Loot:Locked")
        if vicinityLockedStatus then
            inventoryUI.vicinity = false
            triggerEvent("onDisplayNotification", localPlayer, "Unfortunately, loot's inventory is locked!", {255, 80, 80, 255})
        else
            createItemBox(inventoryUI.gui.equipment.startX - inventoryUI.gui.itemBox.templates[2].width - 15, inventoryUI.gui.equipment.startY, 2, inventoryUI.vicinity)
        end
    end
    triggerEvent("onClientInventorySound", localPlayer, "inventory_open")
    showChat(false)
    showCursor(true)
    inventoryUpdate()

end

function inventoryUI.toggleUI(false)

    if not inventoryUI.isVisible then return false end

    if inventoryUI.isSlotsUpdatePending then
        triggerServerEvent("onClientRequestSyncInventorySlots", localPlayer)
    end
    detachInventoryItem(true)
    destroyItemBox(localPlayer)
    destroyItemBox(inventoryUI.vicinity)
    inventoryUI.vicinity = nil
    inventoryUI.attachedItemOnCursor = nil
    showChat(true)
    showCursor(false)

end

imports.addEventHandler("onClientPlayerWasted", localPlayer, function() inventoryUI.toggleUI(false) end)

imports.bindKey("tab", "down", function()
    if inventoryUI.isVisible then
        inventoryUI.toggleUI(false)
    else
        inventoryUI.toggleUI(true)
    end
end)