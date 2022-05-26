----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_exporter.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Texture Exporter ]]--
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

local identifier = "Assetify_TextureExporter"
local depDatas, dependencies = "", {
    helper = "utilities/shaders/helper.fx"
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

    texture diffuseLayer <string renderTarget = "yes";>;
    texture emissiveLayer <string renderTarget = "yes";>;
    struct Export {
        float4 World : COLOR0;
        float4 Color : COLOR1;
        float4 Emissive : COLOR2;
    };
    struct PSInput {
        float4 Position : POSITION0;
        float4 Diffuse : COLOR0;
        float2 TexCoord : TEXCOORD0;
    };
    sampler baseSampler = sampler_state {
        Texture = (gTexture0);
    };


    /*----------------
    -->> Handlers <<--
    ------------------*/

    Export PSHandler(PSInput PS) {
        Export output;
        float4 sampledTexel = tex2D(baseSampler, PS.TexCoord);
        float4 worldColor = sampledTexel*PS.Diffuse;
        //worldColor = lerp(worldColor, filterColor, filterColor.a);
        worldColor.a = sampledTexel.a;
        output.World = sampledTexel;
        output.World.a = 0;
        output.Color.rgb = sampledTexel.rgb;
        output.Color.a = sampledTexel.a*PS.Diffuse.a;
        output.Emissive.rgb = 0;
        output.Emissive.a = 1;
        return output;
    }


    /*------------------
    -->> Techniques <<--
    --------------------*/

    technique ]]..identifier..[[
    {
        pass P0
        {
            PixelShader = compile ps_2_0 PSHandler();
        }
    }

    technique fallback {
        pass P0 {}
    }
    ]]
end