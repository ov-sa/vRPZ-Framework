----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_mapper.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Texture Changer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    file = file,
    string = string
}


-------------------
--[[ Variables ]]--
-------------------

local identifier = "Assetify_TextureMapper"
local mapChannels = {"R", "G", "B"}
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

shaderRW[identifier] = function(shaderMaps)
    if not shaderMaps then return false end
    local controlVars, handlerBody, handlerFooter = "", "", ""
    for i = 1, #shaderMaps, 1 do
        local j = shaderMaps[i]
        handlerBody = handlerBody..[[
            float4 sampledTexel_]]..i..[[ = controlTexel_]]..i..[[;
        ]]
        for k = 1, #mapChannels, 1 do
            local v = mapChannels[k]
            controlVars = controlVars..[[
                texture controlTex_]]..i..[[_]]..v..[[;
                float controlScale_]]..i..[[_]]..v..[[ = ]]..(j[v].scale);
                sampler controlSampler_]]..i..[[_]]..v..[[ = sampler_state { 
                    Texture = controlTex_]]..i..[[_]]..v..[[;
                    MipFilter = Linear;
                    MaxAnisotropy = maxAnisotropy*anisotropy;
                    MinFilter = Anisotropic;
                };
            ]]
            local sampler = [[
                float4 channelTexel_]]..i..[[_]]..v..[[ = tex2D(controlSampler_]]..i..[[_]]..v..[[, PS.TexCoord*controlScale_]]..i..[[_]]..v..[[);
                sampledTexel_]]..i..[[ = lerp(controlTexel_]]..i..[[, channelTexel_]]..i..[[_]]..v..[[, controlTexel_]]..i..[[.]]..imports.string.lower(v)..[[);
            ]]
            handlerBody = sampler..sampler..sampler
        end
        handlerBody = handlerBody..[[
            sampledTexel_]]..i..[[.rgb = sampledTexel_]]..i..[[.rgb*0.33333;
            sampledTexel_]]..i..[[.a = controlTexel_]]..i..[[.a;
        ]]
        handlerFooter = handlerFooter..[[
            sampledTexel *= sampledTexel_]]..i..[[;
        ]]
    end
    return depDatas..[[
    /*-----------------
    -->> Variables <<--
    -------------------*/

    int maxAnisotropy <string deviceCaps="MaxAnisotropy";>;
    float anisotropy = 1;
    ]]..controlVars..[[
    struct PSInput {
        float4 Position : POSITION0;
        float4 Diffuse : COLOR0;
        float2 TexCoord : TEXCOORD0;
    };


    /*----------------
    -->> Samplers <<--
    ------------------*/

    sampler controlSampler = sampler_state {
        Texture = (gTexture0);
        MipFilter = Linear;
        MaxAnisotropy = maxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };


    /*----------------
    -->> Handlers <<--
    ------------------*/
    float4 PSHandler(PSInput PS) {
    ]]..handlerBody..[[
        float4 controlTexel = tex2D(controlSampler, PS.TexCoord);
        // LERP ALL TEXELS BY CONTROL'S ALPHA AND THEN RETURN...
    ]]..handlerFooter..[[
        return saturate(sampledTexel);
    }


    /*------------------
    -->> Techniques <<--
    --------------------*/

    technique ]]..identifier..[[
    {
        pass P0
        {
            AlphaBlendEnable = true;
            SRGBWriteEnable = false;
            PixelShader = compile ps_2_0 PSHandler();
        }
    }

    technique fallback {
        pass P0 {}
    }
    ]]
end