//
// billboard.fx
// author: Ren712/AngerMAN
//

//-----------------------------------------------------------------------------
// Effect Settings
//-----------------------------------------------------------------------------
float3 fElementPosition = float3( 0, 0, 0 );
float4 gVertexColor = float4( 1, 1, 1, 1 );
float2 gDistFade = float2( 250, 150 );
float2 sCutPrec = float2( 0.003, 0.003 );
float fDepthBias = 1;
bool gDiffuse = false;

//-----------------------------------------------------------------------------
// Include some common stuff
//-----------------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float3 gCameraPosition : CAMERAPOSITION;
int CUSTOMFLAGS <string skipUnusedParameters = "yes"; >;
float gFogStart  < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;

//-----------------------------------------------------------------------------
// Texture
//-----------------------------------------------------------------------------
texture gTexture;

//-----------------------------------------------------------------------------
// Sampler Inputs
//-----------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture);
};

//-----------------------------------------------------------------------------
// Structure of data sent to the vertex shader
//-----------------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//-----------------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//-----------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float DistFactor : TEXCOORD1;
    float DistFade : TEXCOORD2;
};

//-----------------------------------------------------------------------------
// Returns a translation matrix
//-----------------------------------------------------------------------------
float4x4 makeTranslation (float3 pos)
{
    return float4x4(
                    1, 0, 0, 0,
                    0, 1, 0, 0,
					0, 0, 1, 0,
                    pos.x, pos.y, pos.z, 1
                    );
}

//-----------------------------------------------------------------------------
// MTAUnlerp
//-----------------------------------------------------------------------------
float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}

//-----------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//-----------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    float4 position = VS.Position;	
    float4x4 posMat = makeTranslation( fElementPosition );
    float4x4 gWorldFix = mul( gWorld, posMat );

    float4x4 worldViewMatrix = mul( gWorldFix, gView );
    float4 worldViewPosition = float4( worldViewMatrix[3].xyz + position.xzy - fElementPosition.xzy , 1 );
    worldViewPosition.xyz += fDepthBias * 1.5 * mul( normalize( gCameraPosition - fElementPosition ), gView).xyz;
	
    float DistFromCam = distance( gCameraPosition, fElementPosition.xyz );
    PS.DistFade = MTAUnlerp ( gDistFade[0], gDistFade[1], DistFromCam );
    PS.DistFactor = saturate( (DistFromCam / fDepthBias) * 0.5 - 1.6 );

    PS.Position = mul( worldViewPosition, gProjection );
    PS.TexCoord = float2( VS.TexCoord.x, 1 - VS.TexCoord.y );
    PS.Diffuse = gVertexColor;
	if (gDiffuse) PS.Diffuse *= VS.Diffuse;
    float sFarClip = gProjectionMainScene[3][2] / (1 - gProjectionMainScene[2][2]);
    float fogEnd = max(gFogEnd, sFarClip);
    float fogStart = max(gFogStart, fogEnd - 20);
    PS.Diffuse.a *= saturate( MTAUnlerp ( fogEnd, fogStart , DistFromCam ));
    return PS;
} 

//-----------------------------------------------------------------------------
//-- PixelShaderExample
//--  1. Read from PS structure
//--  2. Process
//--  3. Return pixel color
//-----------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 color = tex2D( Sampler0 , PS.TexCoord.xy );
    color.rgb = pow( color.rgb * 1.2, 1.5 );
    color *= PS.Diffuse;
    color.a *= PS.DistFactor;
    color.a *= saturate( PS.DistFade );
    if (( PS.TexCoord.x > (1 - sCutPrec.x )) || ( PS.TexCoord.x < sCutPrec.x )) color.a *= 0;
    if (( PS.TexCoord.y > (1 - sCutPrec.y )) || ( PS.TexCoord.y < sCutPrec.y )) color.a *= 0;
    return saturate( color );
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique billboard
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

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
