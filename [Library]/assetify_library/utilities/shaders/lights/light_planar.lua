----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: lights: light_planar.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Planar Lightning ]]--
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

local identifier = "Assetify_LightPlanar"
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

    bool isVirtualRendering = false;
    float3 lightOffset = float3(0, 0, 0);
    float3 lightColor = float3(1, 1, 1);
    texture baseTexture;
    texture vSource;
    sampler baseSampler = sampler_state {
        Texture = baseTexture;
    };
    sampler virtualSourceSampler = sampler_state {
        Texture = vSource;
    };
    struct VSInput {
        float4 Position : POSITION0;
        float4 Diffuse : COLOR0;
        float2 TexCoord : TEXCOORD0;
    };
    struct PSInput {
        float4 Position : POSITION0;
        float2 TexCoord : TEXCOORD0;
    };

    
    /*----------------
    -->> Handlers <<--
    ------------------*/

    PSInput VSHandler(VSInput VS) {
        PSInput PS = (PSInput)0;
        float4 position = VS.Position;
        float4x4 positionMatrix = MTACreateTranslationMatrix(lightOffset);
        float4x4 gWorldFix = mul(gWorld, positionMatrix);
        float4x4 worldViewMatrix = mul(gWorldFix, gView);
        float4 worldViewPosition = float4(worldViewMatrix[3].xyz + position.xzy - lightOffset.xzy, 1);
        worldViewPosition.xyz += 1.5*mul(normalize(gCameraPosition - lightOffset), gView).xyz;
        PS.Position = mul(worldViewPosition, gProjection);
        PS.TexCoord = float2(VS.TexCoord.x, 1 - VS.TexCoord.y);
        return PS;
    }
    
    float4 PSHandler(PSInput PS) : COLOR0 {
        float4 sampledTexel = tex2D(baseSampler, PS.TexCoord.xy);
        sampledTexel.rgb = pow(sampledTexel.rgb*1.5, 1.5);
        if (isVirtualRendering) {
            float4 sourceTex = tex2D(virtualSourceSampler, PS.TexCoord.xy);
            sampledTexel.rgb *= lerp(sampledTexel.rgb, sourceTex.rgb*2.5, 1);
        }
        sampledTexel.rgb *= lightColor;
        sampledTexel.rgb *= 1 + (1 - MTAGetWeatherValue());
        return saturate(sampledTexel);
    }
    

    /*------------------
    -->> Techniques <<--
    --------------------*/

    technique ]]..identifier..[[
    {
        pass P0
        {
            AlphaRef = 1;
            AlphaBlendEnable = true;
            FogEnable = false;
            VertexShader = compile vs_2_0 VSHandler();
            PixelShader = compile ps_2_0 PSHandler();
        }
    }

    technique fallback {
        pass P0 {}
    }
    ]]
end