----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_clear.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Texture Clearer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    file = file
}


-------------------
--[[ Variables ]]--
-------------------

local identifier = "Assetify_TextureChanger"
local depDatas, dependencies = "", {}
for i, j in imports.pairs(dependencies) do
    local depData = imports.file.read(j.filePath)
    if depData then
        depDatas = depDatas.."\n"..depData
    end
end


----------------
--[[ Shader ]]--
----------------

Assetify_Shaders["Assetify_TextureChanger"] = depDatas..[[
/*-----------------
-->> Variables <<--
-------------------*/

texture baseTexture;


/*------------------
-->> Techniques <<--
--------------------*/

technique ]]..identifier..[[
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