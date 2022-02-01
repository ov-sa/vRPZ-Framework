----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: settings: client.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Client Sided Settings ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    dxCreateFont = dxCreateFont
}


------------------
--[[ Settings ]]--
------------------

FRAMEWORK_FONTS = {
    [1] = imports.dxCreateFont("files/fonts/architectsdaughter.ttf", 17, true),
    [2] = imports.dxCreateFont("files/fonts/signika_semibold.ttf", 15, true),
    [3] = imports.dxCreateFont("files/fonts/courgette.ttf", 20, true),
    [4] = imports.dxCreateFont("files/fonts/signika_semibold.ttf", 12, true),
    [5] = imports.dxCreateFont("files/fonts/signika_semibold.ttf", 11, true),
    [6] = imports.dxCreateFont("files/fonts/architectsdaughter.ttf", 13, true),
    [7] = imports.dxCreateFont("files/fonts/signika_semibold.ttf", 11, true),
    [8] = imports.dxCreateFont("files/fonts/signika_semibold.ttf", 11, true)
}