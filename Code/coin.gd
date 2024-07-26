extends AnimatedSprite2D

signal coin_collected(value)

@export var value = 1
@onready var area = $Area2D

func _ready():
	add_to_group("coins")
	if not area:
		push_error("Coin scene is missing an Area2D child!")
		return
	area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	play("default")

func _on_mouse_entered():
	collect()

func collect():
	print("Coin collected! Value: ", value)  # Debug print
	emit_signal("coin_collected", value)
	stop()
	area.input_pickable = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await tween.finished
	queue_free()
