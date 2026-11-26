using NUnit.Framework;
using System.Collections.Generic;
using UnityEngine;

public class Shooter : MonoBehaviour
{
    [SerializeField] int numberOfProjectilesInPool = 20;
    [SerializeField] GameObject projectilePrefab;
    [SerializeField] Camera camera;
    private bool readyToShoot = true;
    private Queue<Projectile> projectilePool = new Queue<Projectile>();
    
    

    private void Awake()
    {
        GenerateProjectilesPool();
    }

    private void GenerateProjectilesPool()
    {
        for (int i = 0; i < numberOfProjectilesInPool; i++)
        {
            Projectile projectile = Instantiate(projectilePrefab).GetComponent<Projectile>();
            if (projectile == null)
            {
                Debug.Log("No projectile component on projectile prefab :x");
                return;
            }
            projectilePool.Enqueue(projectile);
            projectile.gameObject.SetActive(false);

        }
    }

    public void RequestShoot()
    {
        if (readyToShoot)
        {
            Projectile projectile = projectilePool.Dequeue();

            if (projectile.connectedProjectiles.Count > 0)
            {
                foreach (Projectile p in projectile.connectedProjectiles)
                {
                    p.ResetProjectile();
                    p.gameObject.SetActive(false);
                }
                projectile.ResetProjectile();
            }
            ShootProjectile(projectile);
            projectilePool.Enqueue(projectile);

        }


    }

    private void ShootProjectile(Projectile projectile)
    {
        readyToShoot = false;
        projectile.gameObject.transform.position = transform.position;
        Rigidbody rb = projectile.GetComponent<Rigidbody>();
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        projectile.gameObject.SetActive(true);


        Ray ray = camera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0));
        RaycastHit hit;

        Vector3 targetPoint;
        if(Physics.Raycast(ray, out hit))
        {
            targetPoint = hit.point;
        }
        else
        {
            targetPoint = ray.GetPoint(projectile.MaxShootDistance);
        }

        Vector3 direction = targetPoint - transform.position;

        projectile.gameObject.transform.forward = direction.normalized;

        rb.AddForce(direction.normalized*projectile.shootForce, ForceMode.Impulse);


        Invoke("ResetShoot", projectile.timeReset);
    }

    private void ResetShoot()
    {
        readyToShoot = true;
    }
}
