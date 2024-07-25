extends Area2D


#var strength =200
var range = 400
var angle = 20

var damage

const Enemy = preload("res://Code/Enemy.gd")
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#updateCollision()
	call_deferred("updateCollision")
	pass # Replace with function body.

#should only happen if parent is moved or rotated
func updateCollision(): 
	var col = get_node("CollisionPolygon2D")
	var p1 = Vector2(0,0)
	var opp = tan(deg_to_rad(angle)) * range
	var p2 = Vector2(range, -opp)
	var p3 = Vector2(range, opp)
	col.polygon = [p1,p2,p3]
	#col.set_polygon(PackedVector2Array([p1,p2,p3]))
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

