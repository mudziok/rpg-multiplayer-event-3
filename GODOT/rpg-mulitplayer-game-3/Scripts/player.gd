extends CharacterBody3D

@export_category("Variables")
@export var shoot_speed:float = 10.0
@export var Y_value_teleport:float = -30.0

@export_group("Other")
@export var shoot_timer:Timer
@export var shoot_point:Node3D
@export var projectile:PackedScene
	
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity:Vector3 = Vector3(0,-12,0)
var SENSITIVITY:float = 1

var can_shoot:bool = true


@export var head:Node3D
@export var camera:Camera3D

@export var level_ui:Label

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# obracanie kamery
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY * 0.01)
		camera.rotate_x(-event.relative.y * SENSITIVITY * 0.01)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(75))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	level_ui.text = "Level: " +str(GlobalVars.get_level())
	
	if not is_on_floor():
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shoot") and shoot_timer.time_left==0:
		shoot_timer.start()
		# print("shoot", randi_range(10,30))
		_shoot()
	
	if Input.is_action_just_pressed("reset"):
		GlobalVars.reload_level()
	
	if Input.is_action_just_pressed("clip"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# odbijanie się od powietrza
	if global_position.y < -10.0:
		velocity = Vector3.ZERO
		global_position = $"../StartPoint".global_position
	
	move_and_slide()

func _shoot():
	print("shoot")
	if projectile!=null:
		var projectile_new = projectile.instantiate()
		
		projectile_new.global_transform = shoot_point.global_transform
		projectile_new.linear_velocity = shoot_speed * ( -shoot_point.global_transform.basis.z )
		get_tree().current_scene.add_child(projectile_new)
		projectile_new.setup(self)
