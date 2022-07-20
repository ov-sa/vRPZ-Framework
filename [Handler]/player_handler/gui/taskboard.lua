----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: taskboard.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Taskboard UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    collectgarbage = collectgarbage,
    tonumber = tonumber,
    tostring = tostring,
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    isMouseClicked = isMouseClicked,
    isMouseScrolled = isMouseScrolled,
    isMouseOnPosition = isMouseOnPosition,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    showCursor = showCursor,
    table = table,
    string = string,
    math = math,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Namespace ]]--
-------------------

local taskboardUI = assetify.namespace:create("taskboardUI")
CGame.execOnModuleLoad(function()
taskboardUI.private.cache = {keys = {scroll = {}}}
taskboardUI.private.bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].bgColor))
taskboardUI.private.titlebar = {
    font = CGame.createFont(1, 16),
    fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.fontColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerColor)), bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.bgColor))
}
taskboardUI.private.contents = {
    font = CGame.createFont(1, 16),
    fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].fontColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerColor))
}
taskboardUI.private.scroller = {
    percent = 0, animPercent = 0,
    thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbColor)), bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.bgColor))
}

taskboardUI.private.createContents = function(contents)
    if not contents or (imports.type(contents) ~= "table") then return false end
    if not contents.__isCreated then
        for i = 1, #contents, 1 do
            local j = contents[i]
            if j and j.isCategory then
                taskboardUI.private.createContents(j)
                imports.table.insert(j, {
                    title = "Back",
                    action = "ui:back"
                })
            end
        end
    end
    return contents
end

taskboardUI.private.createUI = function(x, y, width, height, header, contents)
    x, y, width, height = imports.tonumber(x), imports.tonumber(y), imports.tonumber(width), imports.tonumber(height)
    if taskboardUI.private.state then return false end
    if not x or not y or not width or not height or not header or not contents or (imports.type(contents) ~= "table") or (#contents <= 0) then return false end
    taskboardUI.private.viewContents = taskboardUI.private.createContents(contents)
    taskboardUI.private.startX, taskboardUI.private.startY, taskboardUI.private.width, taskboardUI.private.height = x, y, imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, width), (height and imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize, height)) or height
    taskboardUI.private.header = imports.string.upper(imports.string.kern(imports.tostring(header), "  "))
    taskboardUI.private.viewRT = imports.beautify.native.createRenderTarget(taskboardUI.private.width, taskboardUI.private.height, true)
    taskboardUI.private.executeContent(taskboardUI.private.viewContents)
    taskboardUI.private.state = true
    imports.showCursor(true)
    imports.beautify.render.create(taskboardUI.private.renderUI)
    imports.beautify.render.create(taskboardUI.private.renderUI, {renderType = "input"})
    return true
end

taskboardUI.private.destroyUI = function()
    if not taskboardUI.private.state then return false end
    imports.beautify.render.remove(taskboardUI.private.renderUI)
    imports.beautify.render.remove(taskboardUI.private.renderUI, {renderType = "input"})
    taskboardUI.private.header, taskboardUI.private.viewContents, taskboardUI.private.contentView = nil, nil, nil
    if taskboardUI.private.viewRT and imports.isElement(taskboardUI.private.viewRT) then
        imports.destroyElement(taskboardUI.private.viewRT)
    end
    taskboardUI.private.viewRT = nil
    taskboardUI.private.state = false
    imports.showCursor(false)
    imports.collectgarbage()
    return true
end

taskboardUI.private.executeContent = function(content)
    local isUpdateView = (not taskboardUI.private.contentView and true) or false
    if content.isCategory or isUpdateView then
        isUpdateView = true
        if not taskboardUI.private.contentView then
            taskboardUI.private.contentView = {}
            imports.table.insert(content, {
                title = "Close",
                action = "ui:close"
            })
        end
        imports.table.insert(taskboardUI.private.contentView, content)
    elseif content.exec and (imports.type(content.exec) == "function") then
        imports.assetify.network:emit("Client:onEnableInventoryUI", false)
        content.exec(j)
    elseif content.action then
        if content.action == "ui:close" then
            taskboardUI.private.destroyUI()
        elseif content.action == "ui:back" then
            if #taskboardUI.private.contentView > 1 then
                isUpdateView = true
                imports.table.remove(taskboardUI.private.contentView, #taskboardUI.private.contentView)
            end
        end
    end
    if isUpdateView then
        content = taskboardUI.private.contentView[(#taskboardUI.private.contentView)]
        taskboardUI.private.scroller.animPercent, taskboardUI.private.scroller.percent = 0, 0
        taskboardUI.private.contentHeight = #content*(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize)
        taskboardUI.private.viewHeight = (not taskboardUI.private.height and taskboardUI.private.contentHeight) or imports.math.min(imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, taskboardUI.private.height), taskboardUI.private.contentHeight)
    end
    return true
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

function taskboardUI.public:isVisible() return taskboardUI.private.state end


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

taskboardUI.private.renderUI = function(renderData)
    if not taskboardUI.private.state then return false end

    if renderData.renderType == "input" then
        taskboardUI.private.cache.keys.mouse = imports.isMouseClicked()
        taskboardUI.private.cache.keys.scroll.state, taskboardUI.private.cache.keys.scroll.streak = imports.isMouseScrolled()
        taskboardUI.private.cache.isEnabled = inventoryUI:isEnabled()
    elseif renderData.renderType == "render" then
        local isLMBClicked = false
        local isUIEnabled = taskboardUI.private.cache.isEnabled
        local isLMBClicked = (taskboardUI.private.cache.keys.mouse == "mouse1") and isUIEnabled
        local isTaskboardHovered = false
        local view_startX, view_startY = taskboardUI.private.startX, taskboardUI.private.startY
        local view_contents = taskboardUI.private.contentView[(#taskboardUI.private.contentView)]
        local bufferCount = #view_contents
        local row_height = FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize
        local view_overflownHeight = imports.math.max(0, (row_height*bufferCount) - taskboardUI.private.viewHeight)
        local offsetY = view_overflownHeight*taskboardUI.private.scroller.animPercent*0.01
        local row_startIndex = imports.math.floor(offsetY/row_height) + 1
        local row_endIndex = imports.math.min(bufferCount, row_startIndex + imports.math.ceil(taskboardUI.private.viewHeight/row_height))
        imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.private.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height, taskboardUI.private.titlebar.bgColor, false)
        view_startY = view_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height
        imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.private.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize, taskboardUI.private.titlebar.dividerColor, false)
        imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.private.width, taskboardUI.private.viewHeight, taskboardUI.private.bgColor, false)
        imports.beautify.native.drawText(taskboardUI.private.header, view_startX, view_startY - FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height, view_startX + taskboardUI.private.width, view_startY, taskboardUI.private.titlebar.fontColor, 1, taskboardUI.private.titlebar.font.instance, "center", "center", true, false, false)
        imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.private.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize, taskboardUI.private.titlebar.dividerColor, false)
        view_startY = view_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize
        imports.beautify.native.setRenderTarget(taskboardUI.private.viewRT, true)
        for i = row_startIndex, row_endIndex, 1 do
            local j = view_contents[i]
            local column_startY = ((i - 1)*row_height) - offsetY
            local isRowHovered = imports.isMouseOnPosition(view_startX, view_startY + column_startY, taskboardUI.private.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height)
            if isRowHovered then
                if isLMBClicked then
                    imports.assetify.timer:create(function()
                        taskboardUI.private.executeContent(j)
                    end, 1, 1)
                end
                if j.hoverStatus ~= "forward" then
                    j.hoverStatus = "forward"
                    j.hoverAnimTick = CLIENT_CURRENT_TICK
                end
                isTaskboardHovered = true
            else
                if j.hoverStatus ~= "backward" then
                    j.hoverStatus = "backward"
                    j.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            end
            j.animAlphaPercent = j.animAlphaPercent or 0.45
            if j.hoverStatus == "forward" then
                if j.animAlphaPercent < 1 then
                    j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].hoverDuration), "Linear")
                end
            elseif j.hoverStatus == "backward" then
                if j.animAlphaPercent > 0.45 then
                    j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0.45, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].hoverDuration), "Linear")
                end
            end
            imports.beautify.native.drawText(j.title, 0, column_startY, taskboardUI.private.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, imports.tocolor(150, 150, 150, 255*j.animAlphaPercent), 1, taskboardUI.private.contents.font.instance, "center", "center", true, false, false)
            if i < bufferCount then
                imports.beautify.native.drawRectangle(0, column_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, taskboardUI.private.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize, taskboardUI.private.contents.dividerColor, false)
            end
        end
        imports.beautify.native.setRenderTarget()
        imports.beautify.native.drawImage(view_startX, view_startY, taskboardUI.private.width, taskboardUI.private.height, taskboardUI.private.viewRT, 0, 0, 0, -1, false)
        if view_overflownHeight > 0 then
            if not taskboardUI.private.scroller.isPositioned then
                taskboardUI.private.scroller.startX, taskboardUI.private.scroller.startY = taskboardUI.private.width - FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, -FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize
                taskboardUI.private.scroller.height = taskboardUI.private.viewHeight
                taskboardUI.private.scroller.isPositioned = true
            end
            if imports.math.round(taskboardUI.private.scroller.animPercent, 2) ~= imports.math.round(taskboardUI.private.scroller.percent, 2) then
                taskboardUI.private.scroller.animPercent = imports.interpolateBetween(taskboardUI.private.scroller.animPercent, 0, 0, taskboardUI.private.scroller.percent, 0, 0, 0.5, "InQuad")
            end
            FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight = ((FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight >= taskboardUI.private.scroller.height) and (taskboardUI.private.scroller.height*0.5)) or FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight
            imports.beautify.native.drawRectangle(view_startX + taskboardUI.private.scroller.startX, view_startY + taskboardUI.private.scroller.startY, FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, taskboardUI.private.scroller.height, taskboardUI.private.scroller.bgColor, false)
            imports.beautify.native.drawRectangle(view_startX + taskboardUI.private.scroller.startX, view_startY + taskboardUI.private.scroller.startY + ((taskboardUI.private.scroller.height - FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight)*taskboardUI.private.scroller.animPercent*0.01), FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight, taskboardUI.private.scroller.thumbColor, false)
            isTaskboardHovered = isTaskboardHovered or imports.isMouseOnPosition(view_startX, view_startY, taskboardUI.private.width, taskboardUI.private.viewHeight)
            if taskboardUI.private.cache.keys.scroll.state and isTaskboardHovered then
                local scrollPercent = imports.math.max(1, 100/(view_overflownHeight/row_height))
                taskboardUI.private.scroller.percent = imports.math.max(0, imports.math.min(taskboardUI.private.scroller.percent + (scrollPercent*imports.math.max(1, taskboardUI.private.cache.keys.scroll.streak)*(((taskboardUI.private.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                taskboardUI.private.cache.keys.scroll.state = false
            end
        end
    end
end
end)