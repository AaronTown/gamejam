extends CharacterBody2D

var picked_up = false
var received_lights = [] # im bad at naming variables
var disabled_lights = []
var type : Color = Color.BLACK

#const Light = preload("res://Code/Light.gd")
#@onready var light_scene = load("res://Scenes/Light.tscn")
@onready var tower_menu_scene = load("res://Scenes/tower_menu.tscn")
@onready var light_object = $Light

const max_health : int = 100
var health : int = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	input_pickable = true
	print("placed at " + str(global_position))
	#createLight()
	#light_object.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if picked_up:
		var current_position = self.global_position
		var mouse_position = get_global_mouse_position()

		var distance = current_position.distance_to(mouse_position)
		if distance > 80:
			position = mouse_position
			return
		var direction = current_position.direction_to(mouse_position)

		var speed = distance / delta
		velocity = direction * speed

		move_and_slide()

func _input(event):
	if get_node("/root/Game").round_active:
		return

func _on_input_event(viewport, event, shape_idx):
	if get_node("/root/Game").round_active:
		return
	if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#picked_up = !picked_up
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			showTowerMenu()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Light.rotation += 0.1
			checkLightValidity()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Light.rotation -= 0.1
			checkLightValidity()

func showTowerMenu():
	var tower_menu = tower_menu_scene.instantiate()
	add_child(tower_menu)

func checkLightValidity():
	var update_flag = false
	for light in received_lights:
		if isFacingAway(light, self):
			update_flag = true
	if update_flag:
		updateLight()

#func createLight():
		#light_object = light_scene.instantiate()
		#light_object.damage = 10
		##light_object.angle = area.angle / 2
		##light_object.range = area.range * 2/3

func updateLight():
	# delete own light object, accumulate and average received_lights values, create new light
	#if light_object != null:
		#light_object.queue_free()
	if received_lights.is_empty():
		light_object.hide()
		light_object.get_node("CollisionPolygon2D").set_disabled(true)
		return
	light_object.get_node("CollisionPolygon2D").set_disabled(false)
	#var strength = 0
	var angle = 0
	var range = 0
	var new_type : Color = Color.BLACK
	var num_lights = received_lights.size()
	for light in received_lights:
		#if isFacingAway(light, self):
		#	continue
		#print(light.type)
		angle += light.angle
		range += light.range
		new_type += light.type / num_lights

	#light_object = light_scene.instantiate()
	light_object.get_node("PointLight2D").energy = 0.5
	light_object.angle = angle / num_lights / 2
	light_object.range = range / num_lights * 2/3
	if new_type.a > 1:
		new_type.a = 1
	light_object.ChangeType(new_type)
	light_object.show()
	#add_child(light_object)

func isFacingAway(a, b):
	var diff = a.rotation - b.rotation
	return abs(diff) > .1

func _on_area_2d_area_entered(area):
	if area.name == "Light":
		if area.get_parent().name.begins_with("Reflector"):
			return
		if area != light_object:
			received_lights.append(area)
			call_deferred("updateLight")

func _on_area_2d_area_exited(area):
	if area.name == "Light":
		if area != light_object:
			received_lights.erase(area)
			call_deferred("updateLight")

func damage(_damage):
	health -= _damage
	if health <= 0:
		queue_free()
		#health = 0
