extends Node2D

#@onready var Beam = preload("res://Scenes/Beam.gd")
@onready var Light = preload("res://Scenes/Light.tscn")

const max_health : int = 100
var health : int = max_health
var direction
var type : Color = Color.WHITE

var lightOb

var tick = 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	lightOb = Light.instantiate()
	lightOb.damage = 100
	add_child(lightOb)
	#ChangeType(Color.RED)
	pass


func _unhandled_input(event):
	if get_node("/root/Game").round_active or global_position.distance_to(get_global_mouse_position()) > 50:
		$UpgradeMenu.hide()
		return
	if event.is_action("Click") and get_node("/root/Game").colors_active:
		$UpgradeMenu.show()
	#if event.is_action("Shoot"):
#
		#$Light.show()
		#await get_tree().create_timer(0.4).timeout
		#$Light.hide()
	
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#lightOb.range += 1
		#if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#lightOb.range -= 1
	  
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	direction = global_position.direction_to(get_global_mouse_position()).angle()

	lightOb.rotation = direction



func damage(_damage):
	print(health)
	health -= _damage
	if health < 0:
		health = 0

func ChangeType(_type : Color):
	type = _type
	lightOb.ChangeType(type)
	$PointLight2D.color = type

#func _on_hitbox_body_entered(body):
	#if body.is_in_group("Enemy"):
		#health -= body.damage
		#if health < 0:
			#health = 0
