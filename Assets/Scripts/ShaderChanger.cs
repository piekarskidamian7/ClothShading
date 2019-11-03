using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderChanger : MonoBehaviour
{
    Renderer rend;
    Shader shader1;
    Shader shader2;
    Shader shader3;
    Shader shader4;
    int shader;
    float f0;
    float roughness;
    public GameObject sceneController;
    

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();
        shader3 = Shader.Find("Cloth/Sheen");
        shader2 = Shader.Find("Cloth/TheOrder");
        shader1 = Shader.Find("Cloth/VelvetDistribution");
        shader4 = Shader.Find("Cloth/OwnModel");
       
    }

    // Update is called once per frame
    void LateUpdate()
    {
        EditShader(shader);
        shader = sceneController.GetComponent<ParametersController>().selectedIndex;
        f0 = sceneController.GetComponent<ParametersController>().f0ValueFinal;
        roughness = sceneController.GetComponent<ParametersController>().roughnessValueFinal;
       //Debug.Log(f0);
    }


    void EditShader(int index)
    {
        if (index == 0)
        {
            rend.material.shader = shader1;
            rend.sharedMaterial.SetFloat("_Roughness", roughness);
            rend.sharedMaterial.SetFloat("_Fresnel", f0);
        }
        else if(index == 1)
        {
            rend.material.shader = shader2;
            rend.sharedMaterial.SetFloat("_Roughness", roughness);
            rend.sharedMaterial.SetFloat("_Fresnel", f0);
        }
        else if (index == 2)
        {
            rend.material.shader = shader3;
            rend.sharedMaterial.SetFloat("_Roughness", roughness);
            rend.sharedMaterial.SetFloat("_Fresnel", f0);
        }
        else if (index == 3)
        {
            rend.material.shader = shader4;
            rend.sharedMaterial.SetFloat("_Roughness", roughness);
            rend.sharedMaterial.SetFloat("_Fresnel", f0);
        }
    }
}
