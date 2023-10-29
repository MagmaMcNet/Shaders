using UnityEditor;
using UnityEngine;
namespace MagmaMc.Shaders 
{
    public class ObjectOverlayUI: EasyShaderUI
    {
        private string BannerPath = "Packages/net.magma-mc.Shaders/Editor/Banner/ObjectOverlayShader.png";

        public override void Initilize()
        {
            Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>(BannerPath);
            if (texture != null)
                HeaderImage = texture;
            else
                Debug.LogError("Failed to load the texture from path: " + BannerPath);
        }
    }
}
