extends Node2D

#@onready var Beam = preload("res://Scenes/Beam.gd")

const max_health : int = 100
var health : int = max_health
var direction

var tick = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _unhandled_input(event):
	if event.is_action("Shoot"):
		$Light.show()
		$Light.enabled = true
		await get_tree().create_timer(1.4).timeout
		$Light.hide()
		$Light.enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = global_position.direction_to(get_global_mouse_position()).angle()
	$Light.rotation = direction

func damage(_damage):
	health -= _damage
	if health < 0:
		health = 0

#func _on_hitbox_body_entered(body):
	#if body.is_in_group("Enemy"):
		#health -= body.damage
		#if health < 0:
			#health = 0
