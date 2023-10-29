Shader "MagmaMc/ObjectOverlay"
{
    Properties
    {
    
        [Toggle(_)] _UseColorMultiplier ("Color Multiplier/Enable", Int) = 0
        _RedStrength ("Color Multiplier/Red Strength", Range(0, 10)) = 1
        _GreenStrength ("Color Multiplier/Green Strength", Range(0, 10)) = 1
        _BlueStrength ("Color Multiplier/Blue Strength", Range(0, 10)) = 1
        _MRedMin ("Color Multiplier/Red Min", Range(0, 10)) = 1
        _MGreenMin ("Color Multiplier/Green Min", Range(0, 10)) = 1
        _MBlueMin ("Color Multiplier/Blue Min", Range(0, 10)) = 1

        
        [Toggle(_)] _HideColorMin ("Min Color/Enable", Int) = 0
        _RedMin ("Min Color/Red Min", Range(0, 10)) = 1
        _GreenMin ("Min Color/Green Min", Range(0, 10)) = 1
        _BlueMin ("Min Color/Blue Min", Range(0, 10)) = 1
        
        [Toggle(_)] GirlScam ("GirlScam/Enable", Int) = 0
        _GirlScamStrength ("GirlScam/Strength", Range(0, 1)) = 0
        
        //Neon
        [Toggle(_)]Neon("Neon/Enable", Int) = 0
        [HDR]_NeonColor("Neon/Tint (RGB)", Color) = (1, 1, 1, 1)
        _NeonColorAlpha("Neon/Intensity", Range(0.0, 1.0)) = 1.0
        _NeonOrigColor("Neon/Background Color (RGB)", Color) = (0.25, 0.25, 0.25, 1)
        _NeonOrigColorAlpha("Neon/Background mix", Range(0.0, 1.0)) = 1.0
        _NeonBrightness("Neon/Brightness", Float) = 3.0
        _NeonPosterization("Neon/Posterization", Range (0.0, 1.0)) = 1.0
        _NeonWidth("Neon/Width", Float) = 1.5
        _NeonGlow("Neon/Glow", Range (0.0, 1.0)) = 1.0

        
		[Toggle(_)]Glitch("Glitch/Enable", Int) = 0
		[PowerSlider(2.0)]_Glitch_Intensity("Glitch/Intensity", Range(0, 1)) = 0.1
		_Glitch_BlockSize("Glitch/Block size", Float) = 10.0
		[PowerSlider(2.0)]_Glitch_Macroblock("Glitch/Macroblock subdivide", Range(0, 1)) = 0.3
		[PowerSlider(2.0)]_Glitch_Blocks("Glitch/Block Glitch", Range(0, 1)) = 0.25
		[PowerSlider(2.0)]_Glitch_Lines("Glitch/Line Glitch", Range(0, 1)) = 0.5
		_Glitch_UPS("Glitch/Glitches per second", Float) = 15.0
		[PowerSlider(2.0)]_Glitch_ActiveTime("Glitch/Active Time", Range(0, 1)) = 0.4
		_Glitch_PeriodTime("Glitch/Period Time", Float) = 6.0
		[PowerSlider(2.0)]_Glitch_Duration("Glitch/Long duration chance", Range(0, 1)) = 0.4
		[PowerSlider(2.0)]_Glitch_Displace("Glitch/Displace", Range(0, 1)) = 0.02
		[PowerSlider(2.0)]_Glitch_Pixelization("Glitch/Pixelization", Range(0, 1)) = 0.8
		[PowerSlider(2.0)]_Glitch_Shift("Glitch/Shift", Range(0, 1)) = 0.05
		[PowerSlider(2.0)]_Glitch_ColorShift("Glitch/Color shift", Range(0, 1)) = 0.1
		[PowerSlider(2.0)]_Glitch_Interleave("Glitch/Interleave lines", Range(0, 1)) = 0.5
		[PowerSlider(2.0)]_Glitch_Displace_Chance("Glitch/Dispalce chance", Range(0, 1)) = 0.01
		[PowerSlider(2.0)]_Glitch_Pixelization_Chance("Glitch/Pixelization chance", Range(0, 1)) = 1
		[PowerSlider(2.0)]_Glitch_Shift_Chance("Glitch/Shift chance", Range(0, 1)) = 0.05
		[PowerSlider(2.0)]_Glitch_ColorShift_Chance("Glitch/Color shift chance", Range(0, 1)) = 1

		

        [Toggle(_)]GrayScale("GrayScale", Int) = 0

    }
    
    SubShader
    {
		Tags { "Queue"="Overlay+2" "RenderType"="Overlay" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "PreviewType" = "None"}
        Cull Off

        GrabPass
        {
            "_GrabTexture"
        }
        Pass
        {
            CGPROGRAM
            #pragma target 5.0
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            static const float4 hashScaleSmall = float4(443.8975, 397.2973, 491.1871, 444.129);
            static const float4 hashScale = float4(0.1031, 0.1030, 0.0973, 0.1099);
            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float4 grabPos : TEXCOORD1;
                float4 uv : TEXCOORD0;
                float3 worldRayDir: TEXCOORD2;
                float3 viewPos : TEXCOORD3;
                nointerpolation float3 viewCenter : TEXCOORD4;
                nointerpolation float falloff : TEXCOORD5;
                nointerpolation float2 grabPosForward : TEXCOORD6;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            uniform bool _UseColorMultiplier;
            uniform float _RedStrength;
            uniform float _GreenStrength;
            uniform float _BlueStrength;
            uniform float _MRedMin;
            uniform float _MGreenMin;
            uniform float _MBlueMin;
            
            uniform bool _HideColorMin;
            uniform float _RedMin;
            uniform float _GreenMin;
            uniform float _BlueMin;

			uniform int Neon;
			uniform float3 _NeonColor;
			uniform float3 _NeonOrigColor;
			uniform float _NeonColorAlpha;
			uniform float _NeonOrigColorAlpha;
			uniform float _NeonBrightness;
			uniform float _NeonPosterization;
			uniform float _NeonWidth;
			uniform float _NeonGlow;
            uniform bool GirlScam;
            uniform float _GirlScamStrength;

            uniform int GrayScale;
            
            
			uniform int Glitch;
            
			uniform float _Glitch_Intensity;
			uniform float _Glitch_BlockSize;
			uniform float _Glitch_UPS;
			uniform float _Glitch_Macroblock;
			uniform float _Glitch_Blocks;
			uniform float _Glitch_Lines;
			uniform float _Glitch_ActiveTime;
			uniform float _Glitch_PeriodTime;
			uniform float _Glitch_Duration;
			uniform float _Glitch_Displace;
			uniform float _Glitch_Pixelization;
			uniform float _Glitch_Shift;
			uniform float _Glitch_Grayscale;
			uniform float _Glitch_ColorShift;
			uniform float _Glitch_Interleave;

			uniform float _Glitch_Displace_Chance;
			uniform float _Glitch_Pixelization_Chance;
			uniform float _Glitch_Shift_Chance;
			uniform float _Glitch_Grayscale_Chance;
			uniform float _Glitch_ColorShift_Chance;
			uniform float _Glitch_Interleave_Chance;


            uniform SamplerState linear_mirror_sampler;
            #define grabSampler linear_mirror_sampler
			
            float hash11(float p)
            {
                p = frac(p * hashScale.x);
                p *= p + 33.33;
                p *= p + p;
                return frac(p);
            }
			float hash11s(float p)
			{
				p = frac(p * hashScaleSmall.x);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
            float hash12s(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 19.19);
                return frac((p3.x + p3.y) * p3.z);
            }
			float hash13(float3 p3)
			{
				p3  = frac(p3 * hashScale.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float hash13s(float3 p3)
			{
				p3 = frac(p3 * hashScaleSmall.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float2 hash21(float p)
			{
				float3 p3 = frac(p * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);

			}
			float2 hash21s(float p)
			{
				float3 p3 = frac(p * hashScaleSmall.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);

			}
			float2 hash22(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * hashScale.xyz);
				p3 += dot(p3, p3.yzx+19.19);
				return frac((p3.xx+p3.yz)*p3.zy);
			}
			float2 hash22s(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * hashScaleSmall.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			float2 hash23(float3 p3)
			{
				p3 = frac(p3 * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			float3 hash31(float p)
			{
				float3 p3 = frac(p * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			float3 hash32(float2 p)
			{
				float3 p3 = frac(p.xyx * hashScale.xyz);
				p3 += dot(p3, p3.yxz + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			float3 hash33(float3 p3)
			{
				p3 = frac(p3 * hashScale.xyz);
				p3 += dot(p3, p3.yxz+19.19);
				return frac((p3.xxy + p3.yxx)*p3.zyx);
			}
			float4 hash41(float p)
			{
				float4 p4 = frac(p * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash42(float2 p)
			{
				float4 p4 = frac(p.xyxy * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash43(float3 p)
			{
				float4 p4 = frac(float4(p.xyzx)  * hashScale);
				p4 += dot(p4, p4.wzxy+19.19);
				return frac((p4.xxyz+p4.yzzw)*p4.zywx);
			}
			float4 hash44(float4 p4)
			{
				p4 = frac(p4 * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash44s(float4 p4)
			{
				p4 = frac(p4 * hashScaleSmall);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}


            
            Texture2D _CameraDepthTexture;
            Texture2D _GrabTexture;
            
			float4 SampleGrabTexture(float2 uv)
			{
				return _GrabTexture.SampleLevel(grabSampler, uv, 0);
			}
			float4 SampleDepthTexture(float2 uv)
			{
				return _CameraDepthTexture.SampleLevel(grabSampler, uv, 0);
			}
			
            v2f vert(appdata v) {
                v2f o;
                
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                float4 grabPosFocus = ComputeGrabScreenPos(UnityViewToClipPos(float4(0, 0, 1, 1)));
                grabPosFocus /= grabPosFocus.w;
                o.grabPosForward = grabPosFocus.xy;

                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float2 screenSize = _ScreenParams.xy;
                float2 grabPos = i.grabPos.xy / i.grabPos.w;
                float time = floor(fmod(_Time.y * 2, hash11(_Time.x)));
                float rand = hash11(time);
                
                if (Glitch)
				{
					float2 uv = grabPos.xy - i.grabPosForward.xy;
					uv.x *= _ScreenParams.x / _ScreenParams.y;
					uv += 1.0;
					float2 grabPosOffsetR = 0;
					float2 grabPosOffsetB = 0;
				
					//float2 uv = i.viewPos.xy / abs(i.viewPos.z);
					//float2 uv = cubeUV(i.worldRayDir);
					float2 block = floor(uv * _Glitch_BlockSize);
					float linePos = block.y;

					float time = floor(fmod(_Time.y * _Glitch_UPS, 600));
					float rand = hash11(time);
					float2 blockID = block + rand;
					float lineID = linePos + rand;

					const uint max_subdiv = 2;
					float blockSize = _Glitch_BlockSize;
					float lineSize = _Glitch_BlockSize;
					for (uint s = max_subdiv; s; s--)
					{
						float h = hash11s(lineID);
						if (h < _Glitch_Macroblock)
						{
							lineSize *= 2;
							lineID = floor(uv.y * lineSize) + rand + 0.01;
							//lineID += h * linePos;
						}
					}

					for (s = max_subdiv; s; s--)
					{
						float2 h = hash22s(blockID);
						if (h.x < _Glitch_Macroblock)
						{
							blockSize *= 2;
							blockID = floor(uv * blockSize) + rand + 0.01;
							//blockID += h * block;
						}
					}
					float4 line_noise0 = hash41(lineID);
					float4 line_noise1 = hash41(lineID + 1);
					float4 line_noise2 = hash41(lineID + 2);
					float4 block_noise0 = hash42(blockID);
					float4 block_noise1 = hash42(blockID + 1);
					float4 block_noise2 = hash42(blockID + 2);

					_Glitch_ActiveTime = max(0.0001, _Glitch_ActiveTime);
					float glitchMul = pow(abs(sin(_Time.y * UNITY_PI / _Glitch_PeriodTime)), 1.0 / _Glitch_ActiveTime - 1.0);
					float block_thresh = _Glitch_Blocks * glitchMul;
					float line_thresh = _Glitch_Lines * glitchMul;
					line_thresh *= line_thresh;

					
					_Glitch_Intensity *= i.falloff;
					_Glitch_Displace *= _Glitch_Intensity;	
					_Glitch_Pixelization *= _Glitch_Intensity;
					_Glitch_Shift *= _Glitch_Intensity;
					_Glitch_Grayscale *= _Glitch_Intensity;
					_Glitch_ColorShift *= _Glitch_Intensity;
					_Glitch_Interleave *= _Glitch_Intensity;

					// Displace
					if (line_noise0.x < line_thresh * _Glitch_Displace_Chance)
					{
						uv.x += (line_noise0.y - 0.5) * _Glitch_Displace;
					}
					else if (block_noise0.x < block_thresh * _Glitch_Displace_Chance)
					{
						uv.xy += (block_noise0.yz - 0.5) * _Glitch_Displace;
					}

					// Pixelization
					if (line_noise1.z < line_thresh * _Glitch_Pixelization_Chance)
					{
						float2 size = exp2(floor(8 - line_noise1.w *  _Glitch_Pixelization * 8));
						uv = (round(uv * lineSize * size + 0.5) - 0.5) / size / lineSize;
					}
					else if (block_noise1.z < block_thresh * _Glitch_Pixelization_Chance)
					{
						float2 size = exp2(floor(8 - block_noise1.w *  _Glitch_Pixelization * 8));
						uv = (round(uv * blockSize * size + 0.5) - 0.5) / size / blockSize;
					}

					// Shift
					if (line_noise0.y < line_thresh * _Glitch_Shift_Chance)
					{
						uv.x += (uv.y - (linePos + 1.0) / lineSize) * (line_noise0.w * 2 - 1) * _Glitch_Shift * lineSize;
					}

					// Color Shift
					if (line_noise0.w < line_thresh * _Glitch_ColorShift_Chance)
					{
						grabPosOffsetR.x = (line_noise1.x * 3 - 1.5) * _Glitch_ColorShift * 0.5;
						grabPosOffsetB.x = (line_noise1.y * 3 - 1.5) * _Glitch_ColorShift * 0.5;
					}
					else if (block_noise0.w < block_thresh * _Glitch_ColorShift_Chance)
					{
						grabPosOffsetR.xy = (block_noise1.xy - 0.5) * _Glitch_ColorShift * 0.5;
						grabPosOffsetB.xy = (block_noise1.zw - 0.5) * _Glitch_ColorShift * 0.5;
					}

					
					uv -= 1.0;
					uv.x /= _ScreenParams.x / _ScreenParams.y;
					grabPos.xy = uv + i.grabPosForward.xy;
				}

                if (GirlScam)
                {
                    float scanLineJitter = _GirlScamStrength * lerp(1, 1.0, 1);
                    float sl_thresh = saturate(1.0 - scanLineJitter * 10.2);
                    float sl_disp = 0.002 + pow(scanLineJitter, 10.0) * 0.015;
                    float jitter = hash12s(float2(round(grabPos.y * screenSize.y)  * screenSize.y, _SinTime.w)) * 2.0 - 1.0;
                    jitter *= step(sl_thresh, abs(jitter)) * sl_disp;
                    grabPos.x += jitter;    
                    grabPos.y -= jitter;
                }

                float4 color = SampleGrabTexture(grabPos);
                
                
                
                if(Neon)
				{
					float3 pix = float3(grabPos.xy, 0) * _NeonWidth / 150;
					float3 color_sub = SampleGrabTexture(grabPos.xy - pix.xz);
					color_sub += SampleGrabTexture(grabPos.xy + pix.xz);
					color_sub += SampleGrabTexture(grabPos.xy - pix.zy);
					color_sub += SampleGrabTexture(grabPos.xy + pix.zy);
					float3 delta_color = 4.0*color.rgb*_NeonOrigColorAlpha - color_sub;
					delta_color *= _NeonBrightness;
					delta_color = lerp(delta_color, length(delta_color) > 1.0 ? normalize(delta_color) : 0.0, _NeonPosterization);
					delta_color = lerp(delta_color, abs(delta_color), _NeonGlow);
					float3 neonColor = color.rgb * _NeonOrigColor.rgb + delta_color *_NeonColor.rgb;
					color.rgb = lerp(color.rgb, neonColor, _NeonColorAlpha * i.falloff);
				}
                
                if (_UseColorMultiplier)
                {
                    if (color.r > _MRedMin)
                        color.r *= _RedStrength;
                    if (color.b > _MBlueMin)
                        color.b *= _BlueStrength;    
                    if (color.g > _MGreenMin)
                        color.g *= _GreenStrength;  
                }

                if (_HideColorMin)
                {
                
                    if (color.r < _RedMin)
                        color.r = 0;
                    if (color.b < _BlueMin)
                        color.b = 0;   
                    if (color.g < _GreenMin)
                        color.g = 0; 
                }
                if (GrayScale)
                {
                
                color.rgb = (color.r + color.b + color.g)/3;
                
                }

                return color;
            }

            ENDCG
        }
    } 
    CustomEditor "MagmaMc.Shaders.ObjectOverlayUI"
}
