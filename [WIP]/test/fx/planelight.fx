#include "helper.fx"

bool isVSourceEnabled = true;
float3 lightOffset = float3(0, 0, 0);
float3 lightColor = float3(1, 1, 1);
texture vSource;
texture baseTexture;

sampler vSourceSampler = sampler_state
{
    Texture = vSource;
};

sampler baseSampler = sampler_state
{
    Texture = gTexture0;
};

struct VSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};
struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};


PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    float4 position = VS.Position;
    float4x4 positionMatrix = MTACreateTranslationMatrix(lightOffset);
    float4x4 gWorldFix = mul(gWorld, positionMatrix);
    float4x4 worldViewMatrix = mul(gWorldFix, gView);
    float4 worldViewPosition = float4(worldViewMatrix[3].xyz + position.xzy - lightOffset.xzy, 1);
    worldViewPosition.xyz += 1.5*mul(normalize(gCameraPosition), gView).xyz;
    PS.Position = mul(worldViewPosition, gProjection);
    PS.TexCoord = float2(VS.TexCoord.x, 1 - VS.TexCoord.y);
    return PS;
} 

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 sampledTexel = tex2D(baseSampler, PS.TexCoord.xy);
    sampledTexel.rgb = pow(sampledTexel.rgb*1.5, 1.5);
    if (isVSourceEnabled) {
        float4 sourceTex = tex2D(vSourceSampler, PS.TexCoord.xy);
        sampledTexel.rgb *= lerp(sampledTexel.rgb, sourceTex.rgb*2.5, 1);
    }
    sampledTexel.rgb *= lightColor;
    sampledTexel.rgb *= 1 + (1 - MTAGetWeatherValue());
    return saturate(sampledTexel);
}

technique Assetify_Light_Plane
{
    pass P0
    {
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        FogEnable = FALSE;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {}
}
