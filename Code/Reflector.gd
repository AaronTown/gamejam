extends AnimatableBody2D

var pickedUp = false
var lightOb
var receivedLights = [] # im bad at naming variables

const Light = preload("res://Code/Light.gd")
@onready var lightscene = load("res://Scenes/Light.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_pickable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pickedUp:
		self.position = get_global_mouse_position()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			pickedUp = !pickedUp
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.rotation += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.rotation -= 0.1

func createLight(area):
	lightOb = lightscene.instantiate()
	lightOb.damage = 10
	lightOb.angle = area.angle / 2
	lightOb.range = area.range * 2/3
	
	add_child(lightOb)

func _on_area_2d_area_entered(area):
	if area is Light:
		if lightOb == null:
			receivedLights.append(area)
			call_deferred("createLight", area)

func _on_area_2d_area_exited(area):
	if area is Light:
		receivedLights.erase(area)
		if receivedLights.is_empty():
			#return
			if lightOb != null:
				lightOb.queue_free()
