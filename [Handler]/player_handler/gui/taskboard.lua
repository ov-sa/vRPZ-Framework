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


CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local taskboardUI = {
        cache = {keys = {scroll = {}}},
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].bgColor)),
        titlebar = {
            font = CGame.createFont(1, 16),
            fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.fontColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerColor)), bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.bgColor))
        },
        contents = {
            font = CGame.createFont(1, 16),
            fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].fontColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerColor))
        },
        scroller = {
            percent = 0, animPercent = 0,
            thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbColor)), bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.bgColor))
        }
    }

    taskboardUI.createContents = function(contents)
        if not contents or (imports.type(contents) ~= "table") then return false end
        if not contents.__isCreated then
            for i = 1, #contents, 1 do
                local j = contents[i]
                if j and j.isCategory then
                    taskboardUI.createContents(j)
                    imports.table:insert(j, {
                        title = "Back",
                        action = "ui:back"
                    })
                end
            end
        end
        return contents
    end

    taskboardUI.createUI = function(x, y, width, height, header, contents)
        x, y, width, height = imports.tonumber(x), imports.tonumber(y), imports.tonumber(width), imports.tonumber(height)
        if taskboardUI.state then return false end
        if not x or not y or not width or not height or not header or not contents or (imports.type(contents) ~= "table") or (#contents <= 0) then return false end
        taskboardUI.viewContents = taskboardUI.createContents(contents)
        taskboardUI.startX, taskboardUI.startY, taskboardUI.width, taskboardUI.height = x, y, imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, width), (height and imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize, height)) or height
        taskboardUI.header = imports.string.upper(imports.string.spaceChars(imports.tostring(header), "  "))
        taskboardUI.viewRT = imports.beautify.native.createRenderTarget(taskboardUI.width, taskboardUI.height, true)
        taskboardUI.executeContent(taskboardUI.viewContents)
        taskboardUI.state = true
        imports.showCursor(true)
        imports.beautify.render.create(taskboardUI.renderUI)
        imports.beautify.render.create(taskboardUI.renderUI, {renderType = "input"})
        return true
    end

    taskboardUI.destroyUI = function()
        if not taskboardUI.state then return false end
        imports.beautify.render.remove(taskboardUI.renderUI)
        imports.beautify.render.remove(taskboardUI.renderUI, {renderType = "input"})
        taskboardUI.header, taskboardUI.viewContents, taskboardUI.contentView = nil, nil, nil
        if taskboardUI.viewRT and imports.isElement(taskboardUI.viewRT) then
            imports.destroyElement(taskboardUI.viewRT)
        end
        taskboardUI.viewRT = nil
        taskboardUI.state = false
        imports.showCursor(false)
        imports.collectgarbage()
        return true
    end

    taskboardUI.executeContent = function(content)
        local isUpdateView = (not taskboardUI.contentView and true) or false
        if content.isCategory or isUpdateView then
            isUpdateView = true
            if not taskboardUI.contentView then
                taskboardUI.contentView = {}
                imports.table:insert(content, {
                    title = "Close",
                    action = "ui:close"
                })
            end
            imports.table:insert(taskboardUI.contentView, content)
        elseif content.exec and (imports.type(content.exec) == "function") then
            imports.assetify.network:emit("Client:onEnableInventoryUI", false)
            content.exec(j)
        elseif content.action then
            if content.action == "ui:close" then
                taskboardUI.destroyUI()
            elseif content.action == "ui:back" then
                if #taskboardUI.contentView > 1 then
                    isUpdateView = true
                    imports.table:remove(taskboardUI.contentView, #taskboardUI.contentView)
                end
            end
        end
        if isUpdateView then
            content = taskboardUI.contentView[(#taskboardUI.contentView)]
            taskboardUI.scroller.animPercent, taskboardUI.scroller.percent = 0, 0
            taskboardUI.contentHeight = #content*(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize)
            taskboardUI.viewHeight = (not taskboardUI.height and taskboardUI.contentHeight) or imports.math.min(imports.math.max(FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, taskboardUI.height), taskboardUI.contentHeight)
        end
        return true
    end


    -------------------------------
    --[[ Functions: UI Helpers ]]--
    -------------------------------

    function isTaskUIVisible() return taskboardUI.state end


    ------------------------------
    --[[ Function: Renders UI ]]--
    ------------------------------

    taskboardUI.renderUI = function(renderData)
        if not taskboardUI.state then return false end

        if renderData.renderType == "input" then
            taskboardUI.cache.keys.mouse = imports.isMouseClicked()
            taskboardUI.cache.keys.scroll.state, taskboardUI.cache.keys.scroll.streak = imports.isMouseScrolled()
            taskboardUI.cache.isEnabled = isInventoryUIEnabled()
        elseif renderData.renderType == "render" then
            local isLMBClicked = false
            local isUIEnabled = taskboardUI.cache.isEnabled
            local isLMBClicked = (taskboardUI.cache.keys.mouse == "mouse1") and isUIEnabled
            local isTaskboardHovered = false
            local view_startX, view_startY = taskboardUI.startX, taskboardUI.startY
            local view_contents = taskboardUI.contentView[(#taskboardUI.contentView)]
            local bufferCount = #view_contents
            local row_height = FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize
            local view_overflownHeight = imports.math.max(0, (row_height*bufferCount) - taskboardUI.viewHeight)
            local offsetY = view_overflownHeight*taskboardUI.scroller.animPercent*0.01
            local row_startIndex = imports.math.floor(offsetY/row_height) + 1
            local row_endIndex = imports.math.min(bufferCount, row_startIndex + imports.math.ceil(taskboardUI.viewHeight/row_height))
            imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height, taskboardUI.titlebar.bgColor, false)
            view_startY = view_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height
            imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize, taskboardUI.titlebar.dividerColor, false)
            imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.width, taskboardUI.viewHeight, taskboardUI.bgColor, false)
            imports.beautify.native.drawText(taskboardUI.header, view_startX, view_startY - FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.height, view_startX + taskboardUI.width, view_startY, taskboardUI.titlebar.fontColor, 1, taskboardUI.titlebar.font.instance, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(view_startX, view_startY, taskboardUI.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize, taskboardUI.titlebar.dividerColor, false)
            view_startY = view_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize
            imports.beautify.native.setRenderTarget(taskboardUI.viewRT, true)
            for i = row_startIndex, row_endIndex, 1 do
                local j = view_contents[i]
                local column_startY = ((i - 1)*row_height) - offsetY
                local isRowHovered = imports.isMouseOnPosition(view_startX, view_startY + column_startY, taskboardUI.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height)
                if isRowHovered then
                    if isLMBClicked then
                        imports.assetify.timer:create(function()
                            taskboardUI.executeContent(j)
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
                imports.beautify.native.drawText(j.title, 0, column_startY, taskboardUI.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, imports.tocolor(150, 150, 150, 255*j.animAlphaPercent), 1, taskboardUI.contents.font.instance, "center", "center", true, false, false)
                if i < bufferCount then
                    imports.beautify.native.drawRectangle(0, column_startY + FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].height, taskboardUI.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"]["Contents"].dividerSize, taskboardUI.contents.dividerColor, false)
                end
            end
            imports.beautify.native.setRenderTarget()
            imports.beautify.native.drawImage(view_startX, view_startY, taskboardUI.width, taskboardUI.height, taskboardUI.viewRT, 0, 0, 0, -1, false)
            if view_overflownHeight > 0 then
                if not taskboardUI.scroller.isPositioned then
                    taskboardUI.scroller.startX, taskboardUI.scroller.startY = taskboardUI.width - FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, -FRAMEWORK_CONFIGS["UI"]["Taskboard"].titlebar.dividerSize
                    taskboardUI.scroller.height = taskboardUI.viewHeight
                    taskboardUI.scroller.isPositioned = true
                end
                if imports.math.round(taskboardUI.scroller.animPercent, 2) ~= imports.math.round(taskboardUI.scroller.percent, 2) then
                    taskboardUI.scroller.animPercent = imports.interpolateBetween(taskboardUI.scroller.animPercent, 0, 0, taskboardUI.scroller.percent, 0, 0, 0.5, "InQuad")
                end
                FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight = ((FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight >= taskboardUI.scroller.height) and (taskboardUI.scroller.height*0.5)) or FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight
                imports.beautify.native.drawRectangle(view_startX + taskboardUI.scroller.startX, view_startY + taskboardUI.scroller.startY, FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, taskboardUI.scroller.height, taskboardUI.scroller.bgColor, false)
                imports.beautify.native.drawRectangle(view_startX + taskboardUI.scroller.startX, view_startY + taskboardUI.scroller.startY + ((taskboardUI.scroller.height - FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight)*taskboardUI.scroller.animPercent*0.01), FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Taskboard"].scroller.thumbHeight, taskboardUI.scroller.thumbColor, false)
                isTaskboardHovered = isTaskboardHovered or imports.isMouseOnPosition(view_startX, view_startY, taskboardUI.width, taskboardUI.viewHeight)
                if taskboardUI.cache.keys.scroll.state and isTaskboardHovered then
                    local scrollPercent = imports.math.max(1, 100/(view_overflownHeight/row_height))
                    taskboardUI.scroller.percent = imports.math.max(0, imports.math.min(taskboardUI.scroller.percent + (scrollPercent*imports.math.max(1, taskboardUI.cache.keys.scroll.streak)*(((taskboardUI.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                    taskboardUI.cache.keys.scroll.state = false
                end
            end
        end
    end
end)