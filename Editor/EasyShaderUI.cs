using UnityEngine;
using UnityEditor;
namespace MagmaMc.Shaders 
{
    public delegate void GUIEventHandler(MaterialEditor materialEditor, MaterialProperty[] properties);
    public class EasyShaderUI: ShaderGUI
    {
        public Texture2D HeaderImage;
        public event GUIEventHandler PreGUIEvents;
        public event GUIEventHandler PostGUIEvents;

        public virtual void Initilize()
        {
        }


        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            Material material = materialEditor.target as Material;

            EditorGUI.BeginChangeCheck();
            Initilize();
            PreGUIEvents?.Invoke(materialEditor, properties);
            DrawBanner();
            GUILayout.Space(10);
            EditorGUI.indentLevel++;
            // Iterate through properties to find and create dropdowns
            foreach (var property in properties)
            {
                if (property.displayName.EndsWith("/Enable"))
                {
                    // Extract the "Name" from the property name
                    string propertyName = property.displayName.Replace("/Enable", "");

                    EditorGUI.indentLevel--;
                    property.floatValue = EditorGUILayout.ToggleLeft($"{propertyName}", property.floatValue > 0) ? 1 : 0;
                    EditorGUI.indentLevel++;
                } else if (property.displayName.Contains("/"))
                {
                    materialEditor.ShaderProperty(property, property.displayName.Split('/')[1]);
                }
                else
                {
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(property, property.name);

                    EditorGUI.indentLevel++;
                }
            }

            GUILayout.Space(10);

            PostGUIEvents?.Invoke(materialEditor, properties);
            EditorGUI.EndChangeCheck();
        }
        void DrawBanner()
        {
            if (HeaderImage != null)
            {
                GUILayout.Space(10);
                float headerImageWidth = EditorGUIUtility.currentViewWidth - 40; // Adjust the margin as needed
                float headerImageHeight = HeaderImage.width > 0 ? (headerImageWidth / HeaderImage.width) * HeaderImage.height : 0;
                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                GUILayout.Label(HeaderImage, GUILayout.Width(headerImageWidth), GUILayout.Height(headerImageHeight));
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();
                GUILayout.Space(10);
            }
        }
    }
}