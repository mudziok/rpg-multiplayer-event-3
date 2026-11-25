using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(CharacterController))]
public class PlayerController : MonoBehaviour
{
    [SerializeField] private float walkSpeed = 5f;
    [SerializeField] private float sprintSpeed = 9f;
    [SerializeField] private float jumpForce = 4f;
    [SerializeField] private float gravity = 10f;

    [SerializeField] private float LookSensivity = 0.2f;
    [SerializeField] private float lookAngleLimit = 90f;

    [SerializeField] Shooter shooter;


    private Camera mainCamera;
    private CharacterController controller;

    private InputAction moveInput;
    private InputAction sprintInput;
    private InputAction jumpInput;
    private InputAction shootInput;

    private float currentMoveSpeed = 0;
    private Vector3 moveDirection = Vector3.zero;
    private float lookAngle = 0;

    private bool jumped;

    private void Start()
    {
        mainCamera = GetComponentInChildren<Camera>();
        controller = GetComponent<CharacterController>();

        shootInput = InputSystem.actions.FindAction("Attack");
        moveInput = InputSystem.actions.FindAction("Move");
        sprintInput = InputSystem.actions.FindAction("Sprint");
        jumpInput = InputSystem.actions.FindAction("Jump");
        jumpInput.started += Jumped;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        currentMoveSpeed = walkSpeed;
    }


    private void Update()
    {
        Vector2 moveVector = moveInput.ReadValue<Vector2>();
        currentMoveSpeed = sprintInput.IsPressed() ? sprintSpeed : walkSpeed;
        HandleMovement(moveVector);

        Vector2 mouseDelta = new Vector2(Mouse.current.delta.x.ReadValue(), Mouse.current.delta.y.ReadValue());
        HandleLooking(mouseDelta);

        if (shootInput.IsPressed()) shooter.RequestShoot();
    }


    private void HandleMovement(Vector2 moveVector)
    {
        Vector3 forward = transform.TransformDirection(Vector3.forward);
        Vector3 right = transform.TransformDirection(Vector3.right);

        Vector2 newSpeed = new Vector2(moveVector.y * currentMoveSpeed, moveVector.x * currentMoveSpeed);
        
        float oldY = moveDirection.y;
        moveDirection = (forward * newSpeed.x) + (right*newSpeed.y);

        if (jumped)
        {
            moveDirection.y = jumpForce;
            jumped = false;
        }
        else
        {
            moveDirection.y = oldY;
        }

        if (!controller.isGrounded)
        {
            moveDirection.y -= gravity * Time.deltaTime;
        }

        controller.Move(moveDirection * Time.deltaTime);
    }

    private void Jumped(InputAction.CallbackContext action)
    {
        if (controller.isGrounded)
        {
            jumped = true;
        }
    }

    private void HandleLooking(Vector2 mouseDelta)
    {
        lookAngle += -mouseDelta.y * LookSensivity;
        lookAngle = Mathf.Clamp(lookAngle, -lookAngleLimit, lookAngleLimit);
        mainCamera.transform.localRotation = Quaternion.Euler(lookAngle, 0, 0);
        transform.rotation *= Quaternion.Euler(0, mouseDelta.x * LookSensivity, 0);
    }

}
