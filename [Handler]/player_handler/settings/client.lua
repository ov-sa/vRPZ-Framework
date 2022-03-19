----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: settings: client.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Client Sided Settings ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    beautify = beautify
}


------------------
--[[ Settings ]]--
------------------

FRAMEWORK_LANGUAGE = "EN"
FRAMEWORK_FONTS = {
    [1] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 23),
    [2] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 30),
    [3] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 19),
    [4] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16),
    [5] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 28),
    [6] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 17),
    [7] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 23),
    [8] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 15),
    [9] = imports.beautify.native.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16),
}