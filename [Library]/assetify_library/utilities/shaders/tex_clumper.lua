----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_clumper.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Texture Clumper ]]--
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

local identifier = "Assetify_TextureClumper"
local depDatas, dependencies = "", {}
for i, j in imports.pairs(dependencies) do
    local depData = imports.file.read(j)
    if depData then
        depDatas = depDatas.."\n"..depData
    end
end


----------------
--[[ Shader ]]--
----------------

shaderRW[identifier] = function()
    return depDatas..[[
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
end