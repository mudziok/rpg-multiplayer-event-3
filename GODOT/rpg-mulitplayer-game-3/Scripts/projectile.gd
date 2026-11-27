extends RigidBody3D

@export var player_col:Area3D
@export var player_timer:Timer
@export var player_first_timer:Timer
@export var ball_col:Area3D
var player:Node3D = null
var fired:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(player_node:Node3D):
	player = player_node
	add_collision_exception_with(player)
	player_col.body_exited.connect(_body_exited)
	player_col.body_entered.connect(_body_entered)
	player_timer.timeout.connect(_re_add_collisions)
	player_timer.start()
	player_first_timer.start()
	ball_col.body_entered.connect(_weld_balls)
	fired = true
	

func _body_exited(body:Node3D):
	if body == player:
		_re_add_collisions()

func _body_entered(body:Node3D):
	if body == player and player_first_timer.time_left==0:
		_re_add_collisions()

func _re_add_collisions():
	if player_col != null:
		remove_collision_exception_with(player)
		player_col.queue_free()

# połączenie kul
func _weld_balls(body:Node3D):
	if body is RigidBody3D and body != self:
		if body.physics_material_override == null:
			var dir:Vector3 = self.global_position.direction_to(body.global_position)
			global_position = ( ( self.global_position + body.global_position ) * 0.5 ) - dir*0.45
			var joint_new = Generic6DOFJoint3D.new()
			get_tree().current_scene.add_child(joint_new)
			joint_new.global_position = ( self.global_position + body.global_position ) * 0.5
			joint_new.node_a = joint_new.get_path_to(self)
			joint_new.node_b = joint_new.get_path_to(body)
		else:
			if body.physics_material_override.bounce != 10:
				var dir:Vector3 = self.global_position.direction_to(body.global_position)
				global_position = ( ( self.global_position + body.global_position ) * 0.5 ) - dir*0.45
				
				var joint_new = Generic6DOFJoint3D.new()
				get_tree().current_scene.add_child(joint_new)
				joint_new.global_position = ( self.global_position + body.global_position ) * 0.5
				joint_new.node_a = joint_new.get_path_to(self)
				joint_new.node_b = joint_new.get_path_to(body)
		
		
