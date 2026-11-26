extends Node

@onready var Levels:Array = [ "res://Scenes/main_start_menu.tscn" , "res://Scenes/levels/L1.tscn" , "res://Scenes/levels/L2.tscn" ]

var level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_level():
	level += 1
	get_tree().change_scene_to_file(Levels[level])
