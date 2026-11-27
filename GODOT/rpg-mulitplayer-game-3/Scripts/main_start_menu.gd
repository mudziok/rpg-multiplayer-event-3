extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.button_down.connect(_play_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _play_pressed():
	GlobalVars.next_level()
