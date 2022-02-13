----------------------------------------------------------------
--[[ Resource: Beautify Library (Example) 
     Script: gui: ui_1.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 14/08/2021 (OvileAmriam)
     Desc: Example UI ]]--
----------------------------------------------------------------


----------------------
-->> Example UI 1 <<--
----------------------

FRAMEWORK_FONTS = {
    [1] = beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 19),
    [2] = beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16)
}

local customizerUI = {
    startX = 5, startY = 5,
    width = 325, height = 610,
    titleBar = {
        paddingY = 2,
        height = 35,
        text = "Character",
        font = FRAMEWORK_FONTS[1],
        fontColor = tocolor(170, 35, 35, 255),
        bgColor = tocolor(0, 0, 0, 255),
        shadowColor = tocolor(50, 50, 50, 255),
    },
    categories = {
        paddingX = 20, paddingY = 5,
        height = 30,
        font = FRAMEWORK_FONTS[2],
        fontColor = tocolor(200, 200, 200, 255),
        bgColor = tocolor(0, 0, 0, 235),
        {
            height = 185,
            identifier = "identity",
            contents = {
                tone = {
                    isSlider = true,
                    startY = 30,
                    paddingY = -10,
                    height = 30,
                    identifier = "tone",
                    content = {
                        "Military",
                        "Criminal"
                    }
                },
                gender = {
                    isSelector = true,
                    startY = 90,
                    height = 30,
                    identifier = "gender",
                    content = {
                        "Male",
                        "Female"
                    }
                },
                faction = {
                    isSelector = true,
                    startY = 150,
                    height = 30,
                    identifier = "faction",
                    content = {
                        "Military",
                        "Criminal"
                    }
                }
            }
        },
        {
            height = 65,
            identifier = "facial",
            contents = {
                hair = {
                    isSelector = true,
                    startY = 30,
                    height = 30,
                    identifier = "hair",
                    content = {
                        "None",
                        "Casual"
                    }
                }
            }
        },
        {
            isSoloSelector = true,
            height = 50,
            identifier = "upper",
            content = {
                "T-Shirt (Red)",
                "Hoody (Blue)"
            }
        },
        {
            isSoloSelector = true,
            height = 50,
            identifier = "lower",
            content = {
                "Pant (Red)",
                "Trouser (Blue)"
            }
        },
        {
            isSoloSelector = true,
            height = 50,
            identifier = "shoes",
            content = {
                "Sneakers (Red)",
                "Boots (Blue)"
            }
        }
    }
}

function createExampleUI1()

    local panel_offsetY = customizerUI.titleBar.height + customizerUI.titleBar.paddingY
    customizerUI.element = beautify.card.create(customizerUI.startX, customizerUI.startY, customizerUI.width, customizerUI.height, nil, false)
    beautify.setUIVisible(customizerUI.element, true)

    for i, j in ipairs(customizerUI.categories) do
        j.offsetY = (customizerUI.categories[(i - 1)] and (customizerUI.categories[(i - 1)].offsetY + customizerUI.categories.height + customizerUI.categories[(i - 1)].height + customizerUI.categories.paddingY)) or panel_offsetY
        if j.contents then
            for k, v in pairs(j.contents) do
                if v.isSlider then
                    v.element = beautify.slider.create(customizerUI.categories.paddingX, j.offsetY + customizerUI.categories.height + v.startY + v.paddingY, customizerUI.width - (customizerUI.categories.paddingX*2), v.height, "horizontal", customizerUI.element, false)
                    beautify.setUIVisible(v.element, true)
                elseif v.isSelector then
                    for m, n in ipairs(v.content) do
                        v.content[m] = string.upper(string.spaceChars(n))
                    end
                    v.element = beautify.selector.create(customizerUI.categories.paddingX, j.offsetY + customizerUI.categories.height + v.startY, customizerUI.width - (customizerUI.categories.paddingX*2), v.height, "horizontal", customizerUI.element, false)
                    beautify.selector.setDataList(v.element, v.content)
                    beautify.setUIVisible(v.element, true)
                end
            end
        elseif j.isSoloSelector then
            j.element = beautify.selector.create(customizerUI.categories.paddingX, j.offsetY + customizerUI.categories.height, customizerUI.width - (customizerUI.categories.paddingX*2), j.height, "horizontal", customizerUI.element, false)
            for k, v in ipairs(j.content) do
                j.content[k] = string.upper(string.spaceChars(v))
            end
            beautify.selector.setDataList(j.element, j.content)
            beautify.setUIVisible(j.element, true)
        end
    end

    beautify.render.create(function()
        beautify.native.drawRectangle(0, 0, customizerUI.width, customizerUI.titleBar.height, customizerUI.titleBar.bgColor)
        beautify.native.drawText(string.upper(string.spaceChars(customizerUI.titleBar.text)), 0, 0, customizerUI.width, customizerUI.titleBar.height, customizerUI.titleBar.fontColor, 1, customizerUI.titleBar.font, "center", "center", true, false, false)
        beautify.native.drawRectangle(0, customizerUI.titleBar.height, customizerUI.width, customizerUI.titleBar.paddingY, customizerUI.titleBar.shadowColor)
        for i, j in ipairs(customizerUI.categories) do
            local category_offsetY = j.offsetY + customizerUI.categories.height
            beautify.native.drawRectangle(0, j.offsetY, customizerUI.width, customizerUI.categories.height, customizerUI.titleBar.bgColor)
            beautify.native.drawText(string.upper(string.spaceChars(j.identifier)), 0, j.offsetY, customizerUI.width, category_offsetY, customizerUI.categories.fontColor, 1, customizerUI.categories.font, "center", "center", true, false, false)
            beautify.native.drawRectangle(0, category_offsetY, customizerUI.width, j.height, customizerUI.categories.bgColor)
        
            if j.contents then
                for k, v in pairs(j.contents) do
                    local title_height = customizerUI.categories.height
                    local title_offsetY = category_offsetY + v.startY - title_height
                    beautify.native.drawRectangle(0, title_offsetY, customizerUI.width, title_height, customizerUI.titleBar.bgColor)
                    beautify.native.drawText(string.upper(string.spaceChars(v.identifier)), 0, title_offsetY, customizerUI.width, title_offsetY + title_height, customizerUI.titleBar.fontColor, 1, customizerUI.categories.font, "center", "center", true, false, false)
                end
            end
        end
    end, {
        elementReference = customizerUI.element,
        renderType = "preViewRTRender"
    })

end

bindKey("z", "down", function()
    destroyElement(customizerUI.element)
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
    createExampleUI1()
end)