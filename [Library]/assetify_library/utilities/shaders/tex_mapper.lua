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
    file = file
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
    local controlVars, handlerVars = "", ""
    for i = 1, #shaderMaps, 1 do
        local j = shaderMaps[i]
        for k = 1, #mapChannels, 1 do
            local v = mapChannels[k]
            controlVars = controlVars..[[
                texture controlTex_]]..i..[[_]]..v..[[;
                texture controlScale_]]..i..[[_]]..v..[[;
            ]]
            handlerVars = handlerVars..[[

            ]]
        end
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
    sampler redControlSampler = sampler_state { 
        Texture = (controlTex1_R);
        MipFilter = Linear;
        MaxAnisotropy = maxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };
    sampler greenControlSampler = sampler_state { 
        Texture = (controlTex1_G);
        MipFilter = Linear;
        MaxAnisotropy = maxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };
    sampler blueControlSampler = sampler_state { 
        Texture = (controlTex1_B);
        MipFilter = Linear;
        MaxAnisotropy = maxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    }; 
    sampler bumpSampler = sampler_state {
        Texture = (bumpTexture);
        MinFilter = Linear;
        MagFilter = Linear;
        MipFilter = Linear;
    };


    /*----------------
    -->> Handlers <<--
    ------------------*/
    float4 PSHandler(PSInput PS) {

        float4 controlTexel = tex2D(controlSampler, PS.TexCoord);
        float4 redTexel = tex2D(redControlSampler, PS.TexCoord*controlTex1_RScale);
        float4 greenTexel = tex2D(greenControlSampler, PS.TexCoord*controlTex1_GScale);
        float4 blueTexel = tex2D(blueControlSampler, PS.TexCoord*controlTex1_BScale);

        float4 sampledTexel = controlTexel;
        sampledTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledTexel = lerp(controlTexel, redTexel, controlTexel.r);
        sampledTexel = lerp(sampledTexel, greenTexel, controlTexel.g); sampledTexel = lerp(sampledTexel, greenTexel, controlTexel.g); sampledTexel = lerp(sampledTexel, greenTexel, controlTexel.g);
        sampledTexel = lerp(sampledTexel, blueTexel, controlTexel.b); sampledTexel = lerp(sampledTexel, blueTexel, controlTexel.b); sampledTexel = lerp(sampledTexel, blueTexel, controlTexel.b);
        sampledTexel.rgb = sampledTexel.rgb*0.33333;
        sampledTexel.a = controlTexel.a;


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