Shader "MagmaMc/SimpleColor"
{
    Properties
    {
        [HDR][MainColor]MainColor ("Color", Color) = (1, 1, 1, 1) // Default color is white
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float4 MainColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                return MainColor;
            }
            ENDCG
        }
    }
    CustomEditor "MagmaMc.Shaders.EasyShaderUI"
}
