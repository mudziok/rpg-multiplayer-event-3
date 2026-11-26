extends Node

@onready var Levels:Array = [ "res://Scenes/levels/TemplateLevel.tscn" , "res://Scenes/levels/L1.tscn" , "res://Scenes/levels/L2.tscn" , "res://Scenes/levels/L3.tscn" , "res://Scenes/levels/L4.tscn" , "res://Scenes/levels/L5.tscn" , "res://Scenes/end_screen_menu.tscn" ]
var level_finished:bool = false

var level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_level():
	if !level_finished:
		level_finished = true
		level += 1
		get_tree().change_scene_to_file(Levels[level])
		await get_tree().create_timer(0.1).timeout
		level_finished = false

func reload_level():
	get_tree().change_scene_to_file(Levels[level])

func get_level() -> int:
	return level
