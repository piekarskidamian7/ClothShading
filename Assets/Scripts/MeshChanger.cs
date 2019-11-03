using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MeshChanger : MonoBehaviour
{
    List<string> meshs = new List<string>() { "Bluza", "Suknia z aksamitu", "Suknia z jedwabiu", "Sfera"};
    public GameObject object0;
    public GameObject object1;
    public GameObject object2;
    public GameObject object3;
    public Dropdown meshDropdown;
    int meshIndex;

    void Start()
    {
        meshDropdown.AddOptions(meshs);
    }

    public void ChangeMesh(int index)
    {
        if (index == 0)
        {
            object0.SetActive(true);
            object1.SetActive(false);
            object2.SetActive(false);
            object3.SetActive(false);
        }
        if (index == 1)
        {
            object1.SetActive(true);
            object0.SetActive(false);
            object2.SetActive(false);
            object3.SetActive(false);
        }
        if(index == 2)
        {
            object2.SetActive(true);
            object0.SetActive(false);
            object1.SetActive(false);
            object3.SetActive(false);
        }
        if(index == 3)
        {
            object3.SetActive(true);
            object0.SetActive(false);
            object1.SetActive(false);
            object2.SetActive(false);
        }
    }
}
