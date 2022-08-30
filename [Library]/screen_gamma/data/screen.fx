// Native
float gTime : TIME;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gProjectionMainScene : PROJECTION_MAIN_SCENE;
float4x4 gViewMainScene : VIEW_MAIN_SCENE;
float2 vResolution = float2(1, 1);
texture vSource0;
struct VSInput {
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};
struct PSInput {
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};
sampler vSource0Sampler = sampler_state {
    Texture = vSource0;
};

float4 MTACalcScreenPosition( float3 InPosition ) {
    return mul(float4(InPosition,1), gWorldViewProjection);
}

PSInput VSHandler(VSInput VS) {
    PSInput PS = (PSInput)0;
    PS.Position = MTACalcScreenPosition(VS.Position);
    PS.TexCoord = VS.TexCoord;
    return PS;
}




//utility

float4 PSHandler(PSInput PS) : COLOR0 {
    float2 UV = PS.TexCoord.xy;
    float4 sampledTexel = tex2D(vSource0Sampler, UV);
    sampledTexel.rgb *= lerp(1, float3(.8, .9, 1.3), sin(gTime + 3)*0.5 + 0.5);
    sampledTexel.rgb *= (1 - dot(UV -= .5, UV))*pow(smoothstep(0, 10, gTime), 2);
    return sampledTexel;
}



technique Test {
    pass P0 {
        AlphaBlendEnable = true;
    	VertexShader = compile vs_3_0 VSHandler();
        PixelShader  = compile ps_3_0 PSHandler();
    }
}

technique fallback {
    pass P0
    {}
}
