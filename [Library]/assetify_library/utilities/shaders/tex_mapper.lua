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
    return depDatas..[[
    int gCapsMaxAnisotropy <string deviceCaps="MaxAnisotropy";>;
    /*-----------------
    -->> Variables <<--
    -------------------*/

    texture baseTexture;

    bool enableBumpMap = false;
    texture bumpTexture;
    float anisotropy = 1;
    float redControlScale = 1;
    float greenControlScale = 1;
    float blueControlScale = 1;
    texture redControlTexture;
    texture greenControlTexture;
    texture blueControlTexture;
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
        MaxAnisotropy = gCapsMaxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };
    sampler redControlSampler = sampler_state { 
        Texture = (redControlTexture);
        MipFilter = Linear;
        MaxAnisotropy = gCapsMaxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };
    sampler greenControlSampler = sampler_state { 
        Texture = (greenControlTexture);
        MipFilter = Linear;
        MaxAnisotropy = gCapsMaxAnisotropy*anisotropy;
        MinFilter = Anisotropic;
    };
    sampler blueControlSampler = sampler_state { 
        Texture = (blueControlTexture);
        MipFilter = Linear;
        MaxAnisotropy = gCapsMaxAnisotropy*anisotropy;
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
        float4 redTexel = tex2D(redControlSampler, PS.TexCoord*redControlScale);
        float4 greenTexel = tex2D(greenControlSampler, PS.TexCoord*greenControlScale);
        float4 blueTexel = tex2D(blueControlSampler, PS.TexCoord*blueControlScale);
        float4 sampledControlTexel = controlTexel;
        sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r); sampledControlTexel = lerp(controlTexel, redTexel, controlTexel.r);
        sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g); sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g); sampledControlTexel = lerp(sampledControlTexel, greenTexel, controlTexel.g);
        sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b); sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b); sampledControlTexel = lerp(sampledControlTexel, blueTexel, controlTexel.b);
        sampledControlTexel.rgb = sampledControlTexel.rgb*0.33333;
        if (enableBumpMap) {
            float4 bumpTexel = tex2D(bumpSampler, PS.TexCoord);
            sampledControlTexel.rgb *= bumpTexel.rgb;
        }
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