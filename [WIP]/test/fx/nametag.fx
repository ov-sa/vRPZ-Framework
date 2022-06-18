// Aviril

#include "helper.fx"

texture baseTexture;
float shadowSize = 0.006;
float4 shadowColor = float4(0, 0, 0, 0.6);
float4 baseColor = float4(1.25, 1.25, 1.25, 1);

sampler baseSampler = sampler_state
{
    Texture = baseTexture;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{   
    float4 shadowTexel = tex2D(baseSampler, PS.TexCoord.xy - float2(shadowSize*-0.5, shadowSize)) + tex2D(baseSampler, PS.TexCoord.xy - float2(shadowSize*0.5, shadowSize));
    shadowTexel.rgb = 1;
    shadowTexel *= shadowColor;
    float4 sampledTexel = tex2D(baseSampler, PS.TexCoord.xy);
    sampledTexel.rgb = pow(sampledTexel.rgb*1.5, 1.5);
    sampledTexel += shadowTexel;
    sampledTexel *= baseColor;
    //sampledTexel.rgb *= 1 + (1 - MTAGetWeatherValue());
    return saturate(sampledTexel);
}

technique Assetify_Shadow
{
    pass P0
    {
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        FogEnable = FALSE;
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {}
}
