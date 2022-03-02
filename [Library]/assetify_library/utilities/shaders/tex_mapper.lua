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

    local controlVars = ""
    for i = 1, #shaderMaps, 1 do
        local j = shaderMaps[i]
        if j,red or j.blue or j.green then
            if j.red then
                controlVars = controlVars..[[
                    texture controlTex_]]..i..[[_R;
                    texture controlScale_]]..i..[[_R;
                ]]
            end
            if j.green then
                controlVars = controlVars..[[
                    texture controlTex_]]..i..[[_G;
                    texture controlScale_]]..i..[[_G;
                ]]
            end
            if j.blue then
                controlVars = controlVars..[[
                    texture controlTex_]]..i..[[_B;
                    texture controlScale_]]..i..[[_B;
                ]]
            end
        end
    end

    return depDatas..[[
    /*-----------------
    -->> Variables <<--
    -------------------*/

    int maxAnisotropy <string deviceCaps="MaxAnisotropy";>;
    bool enableBumpMap = false;
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
    float4 PixelShaderFunction(PSInput PS) {
        float4 controlTexel = tex2D(controlSampler, PS.TexCoord);
        float4 redTexel = tex2D(redControlSampler, PS.TexCoord*controlTex1_RScale);
        float4 greenTexel = tex2D(greenControlSampler, PS.TexCoord*controlTex1_GScale);
        float4 blueTexel = tex2D(blueControlSampler, PS.TexCoord*controlTex1_BScale);
        float4 sampledControlTexel = controlTexel;
        sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r);
        sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g); sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g); sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g);
        sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b); sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b); sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b);
        sampledControlTexel.rgb = sampledControlTexel.rgb*0.33333;
        sampledControlTexel.a = controlTexel.a;
        sampledControlTexel = saturate(sampledControlTexel);
        return sampledControlTexel;
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
            PixelShader = compile ps_2_0 PixelShaderFunction();
        }
    }

    technique fallback {
        pass P0 {}
    }
    ]]
end

[[
    if (enableBumpMap) {
        float4 bumpTexel = tex2D(bumpSampler, PS.TexCoord);
        sampledControlTexel.rgb *= bumpTexel.rgb;
    }
]]