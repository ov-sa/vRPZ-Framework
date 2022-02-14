----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_changer.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Texture Changer ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local identifier, dependencies = "Texture_Changer", {}
local imports = {
    pairs = pairs,
    file = file
}


----------------
--[[ Shader ]]--
----------------

local depData = ""
for i, j in imports.pairs(dependencies) do
    local fileData = imports.file.read(j.filePath)
    if fileData then
        depData = depData.."\n"..fileData
    end
end

Assetify_Shaders[identifier] = [[
/*---------------
-->> Imports <<--
-----------------*/

]]..depData..[[


/*-----------------
-->> Variables <<--
-------------------*/

texture baseTexture;


/*------------------
-->> Techniques <<--
--------------------*/

technique Assetify_TextureChanger
{
    pass P0
    {
        Texture[0] = baseTexture;
    }
}

technique fallback {
    pass P0 {}
}
]]