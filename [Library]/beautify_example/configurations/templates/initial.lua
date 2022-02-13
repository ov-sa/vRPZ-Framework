----------------------------------------------------------------
--[[ Resource: Beautify Library (Example) 
     Script: configurations: templates: initial.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 14/08/2021 (OvileAmriam)
     Desc: Template's Confign ]]--
----------------------------------------------------------------


------------------------
--[[ Configurations ]]--
------------------------

availableTemplates = {}

availableTemplates["beautify_card"] = {
    ["dark-silver-theme"] = {
        color = {0, 0, 0, 0}
    }
}

availableTemplates["beautify_selector"] = {
    ["dark-silver-theme"] = {
        fontPaddingY = 0,
        font = {"files/assets/fonts/teko_medium.rw", 16, "beautify_library"},
        color = {100, 100, 100, 255},
        fontColor = {200, 200, 200, 255},
        hoverColor = {200, 200, 200, 255}
    }
}

resource = getResourceRootElement(getThisResource())
loadstring(exports.beautify_library:fetchImports())()
beautify.setUITemplate("beautify_card", availableTemplates["beautify_card"]["dark-silver-theme"])
beautify.setUITemplate("beautify_selector", availableTemplates["beautify_selector"]["dark-silver-theme"])
