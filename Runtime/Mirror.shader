Shader "MagmaMc/Mirror"
{

    Properties {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0
    }

    // Define the shader program
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
                float3 vertexWorld : TEXCOORD3;
                UNITY_FOG_COORDS(4)
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Glossiness;
            float _Metallic;

            v2f vert(appdata_t v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertexWorld = UnityObjectToWorldNormal(v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.screenPos = ComputeScreenPos(o.vertex);

                UNITY_TRANSFER_FOG(o, o.vertex);

                o.pos = o.vertex; // Assign the vertex position to o.pos

                return o;
            }



            half4 frag(v2f i) : SV_Target {
                half4 col = tex2D(_MainTex, i.uv);
                col.rgb = reflect(col.rgb, normalize(i.vertexWorld.xyz));
                col.a = 1.0;
                return col;
            }
            ENDCG
        }
    }
}
