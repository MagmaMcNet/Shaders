using UnityEngine;

public class ObjectOverlayShaderUI: EasyShaderUI
{
    public override void Initilize()
    {
        HeaderImage = Resources.Load<Texture2D>("ObjectOverlayShader");

    }
}