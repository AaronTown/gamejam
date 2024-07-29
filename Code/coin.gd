extends AnimatedSprite2D

signal coin_collected(value)

@export var value : int = 1 # value of the coin
@onready var area = $Area2D
@onready var GUI = get_node("/root/Game/GUI/Money")

func _ready():
	add_to_group("coins")
	area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))

func _on_mouse_entered():
	collect()
	GUI.text = str(TotalMoney.money)

func collect():
	
	TotalMoney.money += value
	#print(TotalMoney.money)
	#print("Coin collected!")  # Debug print
	$Sound.play()
	emit_signal("coin_collected", value)
	stop() 						# stops animation of sprite
	area.input_pickable = false # can't be picked up multiple times as fade starts
	
	# process to fade out sprite
	var tween = create_tween() 
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await tween.finished
	
	queue_free()
