extends Control

# skrypt do animacji obrazka(można go usunąć jak rezygnujesz z niego)
func _ready():
	scale = Vector2(0.0, 0.0)
	modulate.a = 1.0

	# Pop in
	var tween = create_tween()

	tween.tween_property(
		self, "scale", Vector2(1.15, 1.15), 0.3
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Settle
	tween.tween_property(
		self, "scale", Vector2(1.0, 1.0), 0.15
	)

	# Wait
	tween.tween_interval(1.5)

	# Disappear
	tween.set_parallel(true)

	tween.tween_property(
		self, "modulate:a", 0.0, 0.4
	)

	tween.tween_property(
		self, "scale", Vector2(0.0, 0.0), 0.4
	)

	await tween.finished

	GlobalVars.next_level()
