extends Node2D

#@onready var Beam = preload("res://Scenes/Beam.gd")
@onready var Light = preload("res://Scenes/Light.tscn")

const max_health : int = 100
var health : int = max_health
var direction

var lightOb

var tick = 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	lightOb = Light.instantiate()
	lightOb.damage = 10
	add_child(lightOb)
	pass


func _unhandled_input(event):
	#if event.is_action("Shoot"):
#
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
	direction = global_position.direction_to(target()).angle()

	lightOb.rotation = direction

func target():
	for body in $ViewBox.get_overlapping_bodies():
		if body.name == "Enemy":
			return body
	return $DefaultAim

func damage(_damage):
	health -= _damage
	if health < 0:
		health = 0

#func _on_hitbox_body_entered(body):
	#if body.is_in_group("Enemy"):
		#health -= body.damage
		#if health < 0:
			#health = 0
