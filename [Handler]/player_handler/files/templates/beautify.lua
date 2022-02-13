-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    beautify = beautify
}


-------------------
--[[ Templates ]]--
-------------------

local BEAUTIFY_TEMPLATE = {
    ["beautify_card"] = {
        color = {0, 0, 0, 0}
    },

    ["beautify_selector"] = {
        fontPaddingY = 0,
        font = {"files/assets/fonts/teko_medium.rw", 16, "beautify_library"},
        color = {100, 100, 100, 255},
        fontColor = {200, 200, 200, 255},
        hoverColor = {200, 200, 200, 255}
    },

    ["beautify_selector"] = {
        fontPaddingY = 0,
        font = {"files/assets/fonts/teko_medium.rw", 16, "beautify_library"},
        color = {100, 100, 100, 255},
        fontColor = {200, 200, 200, 255},
        hoverColor = {200, 200, 200, 255}
    }
}

for i, j in imports.pairs(BEAUTIFY_TEMPLATE) do
    imports.beautify.setUITemplate(i, j)
end