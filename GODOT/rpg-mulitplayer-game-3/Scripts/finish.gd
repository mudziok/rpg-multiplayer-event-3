extends Node3D

var finished:bool = false
@onready var sfx_finish: AudioStreamPlayer = $SFX_Finish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D.body_entered.connect(_entered)
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true
	$GPUParticles3D3.emitting = true
	$GPUParticles3D4.emitting = true
	$GPUParticles3D5.emitting = true
	await get_tree().process_frame
	$GPUParticles3D.emitting = false
	$GPUParticles3D2.emitting = false
	$GPUParticles3D3.emitting = false
	$GPUParticles3D4.emitting = false
	$GPUParticles3D5.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _entered(body:Node3D):
	if body is RigidBody3D and !finished:
		sfx_finish.play()
		finished = true
		$GPUParticles3D.emitting = true
		$GPUParticles3D2.emitting = true
		$GPUParticles3D3.emitting = true
		$GPUParticles3D4.emitting = true
		$GPUParticles3D5.emitting = true
		await get_tree().create_timer(2.5).timeout
		# nie wiem co zrobić aby wyskoczył obrazek i zaniknął XD
		# get_tree().change_scene_to_file("res://Scenes/levels/baller_screen.tscn")

		GlobalVars.next_level()
