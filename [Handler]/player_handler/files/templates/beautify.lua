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

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Beautify"]) do
    imports.beautify.setUITemplate(i, j)
end