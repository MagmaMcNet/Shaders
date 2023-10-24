Shader "MagmaMc/Opacity"
{
    Properties
    {
        [HDR][MainColor] MainColor ("Color", Color) = (1, 1, 1, 1)
        [MainTexture] MainTex("Albedo (RGB)", 2D) = "white" {}
        [OpacityMap] OpacityMap("Opacity Map", 2D) = "white" {}
        [Normal] NormalMap("Normal Map", 2D) = "white" {}
        [Smoothness] Smoothness("Smoothness", Range(0, 1)) = 0.5
        [Metallic] Metallic("Metallic", Range(0, 1)) = 0.0
        _Tiling("Tiling", Range(0.5, 10)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" } // Change to Transparent
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade
        #pragma target 5.0

        sampler2D MainTex;
        sampler2D OpacityMap;
        sampler2D NormalMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        half Smoothness;
        half Metallic;
        half _Tiling;
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Sample the opacity map
            fixed4 opacityColor = tex2D(OpacityMap, IN.uv_MainTex * _Tiling);
            fixed4 MainTexture = tex2D(MainTex, IN.uv_MainTex * _Tiling) * MainColor;

            // Sample the normal map and apply the intensity
            fixed3 normal = UnpackNormal(tex2D(NormalMap, IN.uv_MainTex * _Tiling));

            // Use the red channel of the opacity map as the new alpha value (inverted)
            o.Alpha = opacityColor.r;
            o.Albedo = MainTexture.rgb;
            o.Normal = normal;
            o.Smoothness = Smoothness;
            o.Metallic = Metallic;
        }
        ENDCG
    }

    CustomEditor "EasyShaderUI"
    FallBack "Transparent/Cutout/Diffuse" // Use the cutout diffuse shader as fallback
}
