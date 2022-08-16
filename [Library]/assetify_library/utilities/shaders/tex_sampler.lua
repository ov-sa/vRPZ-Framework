----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: tex_sampler.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Texture Sampler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local identity = {
    name = "Assetify_TextureSampler",
    deps = shaderRW.createDeps({
        "utilities/shaders/helper.fx"
    })
}


----------------
--[[ Shader ]]--
----------------

shaderRW.buffer[(identity.name)] = {
    properties = {
        disabled = {
            ["vSource1"] = true,
            ["vSource2"] = true
        }
    },

    exec = function()
        return identity.deps..[[
        /*-----------------
        -->> Variables <<--
        -------------------*/

        float sampleOffset = 0.001;
        float sampleIntensity = 2;
        struct VSInput {
            float3 Position : POSITION0;
            float2 TexCoord : TEXCOORD0;
        };
        struct PSInput {
            float4 Position : POSITION0;
            float2 TexCoord : TEXCOORD0;
        };
        sampler depthSampler = sampler_state {
            Texture = gDepthBuffer;
        };
        sampler vSource0Sampler = sampler_state {
            Texture = vSource0;
        };


        /*----------------
        -->> Handlers <<--
        ------------------*/

        float2x4 SampleHandler(float2 TexCoord) {
            float4 baseTexel = tex2D(vSource0Sampler, TexCoord);
            float4 depthTexel = tex2D(depthSampler, TexCoord);
            float4 weatherTexel = ((depthTexel.r + depthTexel.g + depthTexel.b)/3) >= 1 ? baseTexel*float4(MTAGetWeatherColor(), 0.75) : float4(0, 0, 0, 0);
            float2x4 result = {baseTexel, weatherTexel};
            return result;
        }
    
        float4x4 GetViewMatrix(float4x4 matrixInput) {
            #define minor(a, b, c) determinant(float3x3(matrixInput.a, matrixInput.b, matrixInput.c))
            float4x4 cofactors = float4x4(
               minor(_22_23_24, _32_33_34, _42_43_44), 
               -minor(_21_23_24, _31_33_34, _41_43_44),
               minor(_21_22_24, _31_32_34, _41_42_44),
               -minor(_21_22_23, _31_32_33, _41_42_43),
               -minor(_12_13_14, _32_33_34, _42_43_44),
               minor(_11_13_14, _31_33_34, _41_43_44),
               -minor(_11_12_14, _31_32_34, _41_42_44),
               minor(_11_12_13, _31_32_33, _41_42_43),
               minor(_12_13_14, _22_23_24, _42_43_44),
               -minor(_11_13_14, _21_23_24, _41_43_44),
               minor(_11_12_14, _21_22_24, _41_42_44),
               -minor(_11_12_13, _21_22_23, _41_42_43),
               -minor(_12_13_14, _22_23_24, _32_33_34),
               minor(_11_13_14, _21_23_24, _31_33_34),
               -minor(_11_12_14, _21_22_24, _31_32_34),
               minor(_11_12_13, _21_22_23, _31_32_33)
            );
            #undef minor
            return transpose(cofactors)/determinant(matrixInput);
        }
       
        float3 GetViewClipPosition(float2 coords, float4 view) {
            return float3((coords.x*view.x) + view.z, (1 - coords.y)*view.y + view.w, 1)*(gProjectionMainScene[3][2]/(1 - gProjectionMainScene[2][2]));
        }
       
        float2 GetViewCoord(float3 dir, float2 div) {
            return float2(((atan2(dir.x, dir.z)/(PI*div.x)) + 1)/2, (acos(- dir.y)/(PI*div.y)));
        }

        float FetchNoise(float2 uv) {
            return frac(sin((uv.x*83.876) + (uv.y*76.123))*3853.875);
        }
      
        float CreatePerlinNoise(float2 uv, float iterations) {
            float c = 1;
            for (float i = 0; i < iterations; i++) {
                float power = pow(2, i + 1);
                float2 luv = uv * float2(power, power) + (gTime*0.2);
                float2 gv = smoothstep(0, 1, frac(luv));
                float2 id = floor(luv);
                float b = lerp(FetchNoise(id + float2(0, 0)), FetchNoise(id + float2(1, 0)), gv.x);
                float t = lerp(FetchNoise(id + float2(0, 1)), FetchNoise(id + float2(1, 1)), gv.x);
                c += 1/power*lerp(b, t, gv.y);
            }
            return c*0.5;
        }
    
        PSInput VSHandler(VSInput VS) {
            PSInput PS = (PSInput)0;
            PS.Position = MTACalcScreenPosition(VS.Position);
            PS.TexCoord = VS.TexCoord;
            return PS;
        }
    
        float4 PSHandler(PSInput PS) : COLOR0 {
            float2x4 rawTexel = SampleHandler(PS.TexCoord + float2(sampleOffset, sampleOffset));
            rawTexel += SampleHandler(PS.TexCoord + float2(-sampleOffset, -sampleOffset));
            rawTexel += SampleHandler(PS.TexCoord + float2(-sampleOffset, sampleOffset));
            rawTexel += SampleHandler(PS.TexCoord + float2(sampleOffset, -sampleOffset));
            rawTexel *= 0.25;
            float4 sampledTexel = rawTexel[0];
            if (rawTexel[1].a > 0) sampledTexel = rawTexel[1];
            else {
                float edgeIntensity = length(sampledTexel.rgb);
                sampledTexel.a = pow(length(float2(ddx(edgeIntensity), ddy(edgeIntensity))), 0.5)*sampleIntensity;
            }
            return saturate(sampledTexel);
        }


        /*------------------
        -->> Techniques <<--
        --------------------*/

        technique ]]..identity.name..[[ {
            pass P0 {
                AlphaBlendEnable = true;
                VertexShader = compile vs_3_0 VSHandler();
                PixelShader  = compile ps_3_0 PSHandler();
            }
        }

        technique fallback {
            pass P0 {}
        }
        ]]
    end
}