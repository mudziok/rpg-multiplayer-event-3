extends Node3D

var B1:bool = false
var B2:bool = false
var B3:bool = false
var O:bool = false

@onready var Door:CSGBox3D = $Door/CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/Button1/Area3D.body_entered.connect(B1E)
	$Buttons/Button2/Area3D.body_entered.connect(B2E)
	$Buttons/Button3/Area3D.body_entered.connect(B3E)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if B1 and B2 and B3 and not O:
		O = true
		var tween = get_tree().create_tween()
		tween.tween_property(Door, "position", Vector3(0,3,0), 2.5)
		
func B1E(body: Node3D):
	if body is RigidBody3D and not B1:
		B1 = true
		$Buttons/Button1/CSGCylinder3D.material_override = load("res://Assets/gold_material.tres")

func B2E(body: Node3D):
	if body is RigidBody3D and not B2:
		B2 = true
		$Buttons/Button2/CSGCylinder3D.material_override = load("res://Assets/gold_material.tres")

func B3E(body: Node3D):
	if body is RigidBody3D and not B3:
		B3 = true
		$Buttons/Button3/CSGCylinder3D.material_override = load("res://Assets/gold_material.tres")
