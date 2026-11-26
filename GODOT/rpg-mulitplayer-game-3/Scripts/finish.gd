extends Node3D

var finished:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D.body_entered.connect(_entered)
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true
	$GPUParticles3D3.emitting = true
	$GPUParticles3D4.emitting = true
	await get_tree().process_frame
	$GPUParticles3D.emitting = false
	$GPUParticles3D2.emitting = false
	$GPUParticles3D3.emitting = false
	$GPUParticles3D4.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _entered(body:Node3D):
	if body is RigidBody3D and !finished:
		finished = true
		$GPUParticles3D.emitting = true
		$GPUParticles3D2.emitting = true
		$GPUParticles3D3.emitting = true
		$GPUParticles3D4.emitting = true
		await get_tree().create_timer(2.5).timeout
		GlobalVars.next_level()
