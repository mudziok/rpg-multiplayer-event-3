using NUnit.Framework;
using System.Collections.Generic;
using System.Numerics;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Projectile : MonoBehaviour
{
    public float MaxShootDistance = 100.0f;
    public float shootForce = 10.0f;
    public float timeReset = 0.3f;

    public List<FixedJoint> joints;
    public List<Projectile> connectedProjectiles = new List<Projectile>();

    private void OnCollisionEnter(Collision collision)
    {
        GameObject collisionGameObject = collision.gameObject;
        if (collisionGameObject.CompareTag("StickyProjectile"))
        {
            FixedJoint joint = gameObject.AddComponent<FixedJoint>();
            joint.connectedBody = collisionGameObject.GetComponent<Rigidbody>();
            joint.enableCollision = true;
            joints.Add(joint);
            connectedProjectiles.Add(collisionGameObject.GetComponent<Projectile>());

        }
    }


    public void ResetProjectile() //it's not working perfectly but oh well, no time :v 
    {
        connectedProjectiles.Clear();
        foreach (FixedJoint joint in joints)
        {
            Destroy(joint);
        }
        joints.Clear();
    }
}

