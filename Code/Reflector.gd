extends CharacterBody2D

var picked_up
var light_object
var received_lights = [] # im bad at naming variables
var disabled_lights = []

const Light = preload("res://Code/Light.gd")
@onready var light_scene = load("res://Scenes/Light.tscn")
@onready var upgrade_menu_scene = load("res://Scenes/upgrade_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_pickable = true

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

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			picked_up = false
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			showTowerMenu()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.rotation += 0.1
			$AnimatedSprite2D.rotation -= 0.1
			checkLightValidity()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.rotation -= 0.1
			$AnimatedSprite2D.rotation += 0.1
			checkLightValidity()

func showTowerMenu():
	var upgradeMenu = get_tree().get_root().get_node("Game/GUI/UpgradeMenu") #im sorry
	upgradeMenu.visible = true
	upgradeMenu.position = get_global_mouse_position()
	upgradeMenu.current_tower = self
	
	
	#add_child(upgrade_menu)

func checkLightValidity():
	var update_flag = false
	for light in received_lights:
		if isFacingAway(light, self):
			update_flag = true
	if update_flag:
		updateLight()

func createLight(area):
		light_object = light_scene.instantiate()
		light_object.damage = 10
		light_object.angle = area.angle / 2
		light_object.range = area.range * 2/3

func updateLight():
	# delete own light object, accumulate and average received_lights values, create new light
	if light_object != null:
		light_object.queue_free()
	if received_lights.is_empty():
		return

	#var strength = 0
	var angle = 0
	var range = 0
	for light in received_lights:
		if isFacingAway(light, self):
			continue
		angle += light.angle
		range += light.range

	light_object = light_scene.instantiate()
	var num_lights = received_lights.size()
	light_object.angle = angle / num_lights / 2
	light_object.range = range / num_lights * 2/3

	add_child(light_object)

func isFacingAway(a, b):
	var diff = a.rotation - b.rotation
	return abs(diff) > 1.3

func _on_area_2d_area_entered(area):
	if picked_up:
		return
	if area is Light:
		if area != light_object:
			received_lights.append(area)
			call_deferred("updateLight")

func _on_area_2d_area_exited(area):
	if area is Light:
		if area != light_object:
			received_lights.erase(area)
			call_deferred("updateLight")
