extends Area2D


@export var strength = 10
@export var range = 10
@export var angle = 12 
@export var rot = 0

var damage

const Enemy = preload("res://Code/Enemy.gd")
var enemies = []

@onready var col = $CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#updateCollision()
	call_deferred("updateCollision")
	pass # Replace with function body.

#should only happen if parent is moved or rotated
func updateCollision():
	#var col = get_node("CollisionPolygon2D")
	var p1 = Vector2(0,0)
	var opp = tan(deg_to_rad(angle)) * range
	var p2 = Vector2(range, -opp)
	var p3 = Vector2(range, opp)
	col.polygon = [p1,p2,p3]
	#col.set_polygon(PackedVector2Array([p1,p2,p3]))
	self.rotation = deg_to_rad(rot)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#updateCollision()
	pass



func _on_body_entered(body):
	if body is Enemy:
		enemies.append(body)
	pass # Replace with function body.


func _on_damage_timer_timeout():
	if enemies:
		for enemy in enemies:
			enemy.takeDamage(damage)
	pass # Replace with function body.


func _on_body_exited(body):
	if body is Enemy:
		enemies.erase(body)
	pass # Replace with function body.

