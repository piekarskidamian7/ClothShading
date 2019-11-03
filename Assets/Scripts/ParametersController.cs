using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ParametersController : MonoBehaviour
{
    List<string> shaders = new List<string>() { "Model 1", "Model 2", "Model 3","Model 4" };
    [HideInInspector] public int selectedIndex;
    public Dropdown shaderDropdown;

    public Slider sliderFresnel;
    public InputField inputF0;
    [HideInInspector] public float f0Value;
    [HideInInspector] public float f0ValueFinal;

    public Slider sliderRoughness;
    public InputField inputRoughness;
    [HideInInspector] public float roughnessValue;
    [HideInInspector] public float roughnessValueFinal;

    public GameObject UIPanel;
  
   

    void Start()
    {
        AddShaders();
        f0ValueFinal = 1.0f;
        roughnessValueFinal = 1.0f;
        inputF0.text = f0ValueFinal.ToString() ;
        inputRoughness.text = roughnessValueFinal.ToString();
    }

 
    void AddShaders()
    {
        shaderDropdown.AddOptions(shaders);
    }
    
   public void ChangeLithingModel(int index)
   {
        selectedIndex = index;
   }

   public void ChangeF0Slider(float value)
   {
        f0Value = value/100;
        f0ValueFinal = f0Value;
        inputF0.text = f0ValueFinal.ToString();
   }

    public void ChangeF0Input(string value)
    {
        float floatValue = 1;

        try
        {
            floatValue = float.Parse(value);
        }
        catch (Exception e)
        {
            floatValue = 1;
            inputF0.text = (floatValue).ToString();
        }
        
        if (floatValue > 1)
        {
            f0Value = 1*100;
            inputF0.text = (f0Value/100).ToString();
        }
        else
        {
            f0Value = floatValue * 100;
        }

        sliderFresnel.value = f0Value;
        
    }


    public void ChangeRoughnessSlider(float value)
    {
        roughnessValue = value / 100;
        roughnessValueFinal = roughnessValue;
        inputRoughness.text = roughnessValueFinal.ToString();
    }

    public void ChangeRoughnessInput(string value)
    {
        float floatValue = 1;

        try
        {
            floatValue = float.Parse(value);
        }
        catch (Exception e)
        {
            floatValue = 1;
            inputRoughness.text = (floatValue).ToString();
        }
       
        if (floatValue > 1)
        {
            roughnessValue = 1 * 100;
            inputRoughness.text = (roughnessValue / 100).ToString();
        }
        else
        {
            roughnessValue = floatValue * 100;
            
        }

        sliderRoughness.value = roughnessValue;
    }


   


    public void CloseToDeskop()
    {
        Application.Quit();
    }
}
