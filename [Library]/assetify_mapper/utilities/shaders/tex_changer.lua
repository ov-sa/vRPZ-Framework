----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: utilities: shaders: tex_changer.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Texture Changer ]]--
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
local depDatas, dependencies = "", {
    "utilities/shaders/helper.fx"
}
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