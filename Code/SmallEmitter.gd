extends CharacterBody2D

#@onready var Beam = preload("res://Scenes/Beam.gd")
@onready var Light = preload("res://Scenes/Light.tscn")

const max_health : int = 100
var health : int = max_health
var direction

var lightOb

var picked_up

var tick = 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	input_pickable = true
	pass


func _unhandled_input(event):
	#if event.is_action("Shoot"):
		#$Beam.show()
		#await get_tree().create_timer(0.4).timeout
		#$Beam.hide()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			lightOb.range += 1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			lightOb.range -= 1
	  
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
	
	if lightOb:
		direction = global_position.direction_to(target()).angle()
		lightOb.rotation = direction

func target():
	for body in $ViewBox.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			return body.global_position
	return $DefaultAim.global_position

func damage(_damage):
	health -= _damage
	if health < 0:
		health = 0

#func _on_hitbox_body_entered(body):
	#if body.is_in_group("Enemy"):
		#health -= body.damage
		#if health < 0:
			#health = 0


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			picked_up = false
			input_pickable = false
			lightOb = Light.instantiate()
			lightOb.damage = 10
			add_child(lightOb)
	pass # Replace with function body.
