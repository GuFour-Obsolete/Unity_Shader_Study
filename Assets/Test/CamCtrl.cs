using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//==============================
//Synopsis  :
//CreatTime :  #CREATETIME#
//For       :  #AUTHORNAME#
//==============================

public class CamCtrl : MonoBehaviour
{
    public float speed = 5f;

    private void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            transform.Translate(new Vector3(0f, 0f, speed * Time.deltaTime), Space.Self);
        }
        if (Input.GetKey(KeyCode.S))
        {
            transform.Translate(new Vector3(0f, 0f, -speed * Time.deltaTime), Space.Self);
        }
        if (Input.GetKey(KeyCode.A))
        {
            transform.Translate(new Vector3(-speed * Time.deltaTime, 0f, 0f), Space.Self);
        }
        if (Input.GetKey(KeyCode.D))
        {
            transform.Translate(new Vector3(speed * Time.deltaTime, 0f, 0f), Space.Self);
        }

        transform.localEulerAngles +=
            new Vector3(speed * -Input.GetAxis("Mouse Y"), speed * Input.GetAxis("Mouse X"), 0f);

        speed += Input.mouseScrollDelta.y;
        speed = speed < 1f ? 1f : speed > 20f ? 20f : speed;
    }
}