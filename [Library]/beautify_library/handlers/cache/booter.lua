----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: cache: booter.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 01/02/2021
     Desc: Booter Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    dxCreateTexture = dxCreateTexture,
    assetify = assetify
}



-------------------
--[[ Variables ]]--
-------------------

createdAssets = {}


-----------------------------------
--[[ Functions: Fetches Assets ]]--
-----------------------------------

function fetchAssets()

    return createdAssets

end


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()

    for i, j in imports.pairs(availableEvents) do
        for k, v in imports.ipairs(j) do
            imports.addEvent(v, false)
        end
    end
    for i, j in imports.pairs(availableAssets) do
        createdAssets[i] = {}
        for k, v in imports.ipairs(j) do
            local assetPath = "files/assets/"..i.."/"..v
            if imports.assetify.file:exists(assetPath) then
                if i == "images" then
                    createdAssets[i][v] = imports.dxCreateTexture(assetPath, "argb", true, "clamp")
                end
            end
        end
    end

end)