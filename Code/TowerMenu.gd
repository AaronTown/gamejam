extends Control

@onready var cursor_texture = load("res://assets/cursor.png")
@onready var game = get_node("/root/Game")

const SmallEmitterCost = 10
const ReflectorCost = 5

var tower_picked = false
var tower_to_place
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if not tower_picked:
		return
	if event.is_action("Click"):
		Input.set_custom_mouse_cursor(cursor_texture)
		print(get_global_mouse_position())
		game.PlaceTower(tower_to_place, get_global_mouse_position())
		tower_picked = false
		$Button/Sprite2D.show()
		$Button2/Sprite2D.show()

func _on_button_pressed():
	if tower_picked:
		return
	if TotalMoney.money < SmallEmitterCost:
		return
	TotalMoney.money -= SmallEmitterCost
	$Button/Sprite2D.hide()
	Input.set_custom_mouse_cursor($Button/Sprite2D.texture)
	tower_picked = true
	tower_to_place = "SmallEmitter"
	#Input.set_custom_mouse_cursor(cursor_texture)


func _on_button_2_pressed():
	if tower_picked:
		return
	if TotalMoney.money < ReflectorCost:
		return
	TotalMoney.money -= ReflectorCost
	$Button2/Sprite2D.hide()
	Input.set_custom_mouse_cursor($Button2/Sprite2D.texture)
	tower_picked = true
	tower_to_place = "Reflector"
