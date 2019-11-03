using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    float horizontalSpeed = 1.0f;
    float verticalSpeed = 1.0f;
    bool isActive = true;
    public GameObject UIPanel;

    void Update()
    {
        CameraMovement();
        CameraRotation();
        DisableUI();
    }

    
    void CameraMovement()
    {
        if(Input.GetKey("w") || Input.GetKey(KeyCode.UpArrow))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(0f, 0f, 0.1f);
        }

        if (Input.GetKey("s") || Input.GetKey(KeyCode.DownArrow))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(0f, 0f, -0.1f);
        }

        if (Input.GetKey("d") || Input.GetKey(KeyCode.RightArrow))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(0.1f, 0f, 0f);
        }

        if (Input.GetKey("a") || Input.GetKey(KeyCode.LeftArrow))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(-0.1f, 0f, 0f);
        }

        if (Input.GetKey(KeyCode.Space))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(0f, 0.1f, 0f);
        }

        if (Input.GetKey(KeyCode.LeftShift))
        {
            Camera.main.transform.position += Camera.main.transform.rotation * new Vector3(0f, -0.1f, 0f);
        }
    }
    void CameraRotation()
    {
        
        float h = 0.0f;
        float v = 0.0f;
        if (Input.GetMouseButton(1))
        {
            h += horizontalSpeed * Input.GetAxis("Mouse X");
            v -= verticalSpeed * Input.GetAxis("Mouse Y");
        }
        Camera.main.transform.eulerAngles += new Vector3(v, h, 0);
    }

    // Funkcja przypisana do przycisku "Pozycja 1"
    public void SetCameraTransform1()
    {
        transform.position = new Vector3(-10.0f, 4.5f, 0.0f);
        transform.localEulerAngles = new Vector3(156.5f, 270.0f, 180.0f);
    }

    // Funkcja przypisana do przycisku "Pozycja 2"
    public void SetCameraTransform2()
    {
        transform.position = new Vector3(-7.05f, 4.5f, 7.05f);
        transform.localEulerAngles = new Vector3(156.5f, 315.0f, 180.0f);
    }

    // Funkcja przypisana do przycisku "Pozycja 3"
    public void SetCameraTransform3()
    {
        transform.position = new Vector3(0.0f, 4.5f, 10.0f);
        transform.localEulerAngles = new Vector3(156.5f, 0.0f, 180.0f);
    }


    void DisableUI()
    {
        if (Input.GetKeyUp(KeyCode.X))
        {
            if (isActive == false)
            {
                UIPanel.SetActive(true);
                isActive = true;
            }
            else
            {
                UIPanel.SetActive(false);
                isActive = false;
            }
        }
    }
}
