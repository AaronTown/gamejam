extends Area2D


@export var strength = 10
@export var range = 100
@export var angle = 12
@export var rot = 0

var damage = 100
var type : Color = Color.RED
const Enemy = preload("res://Code/Enemy.gd")
var enemies = {}
var cooldown : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#updateCollision()
	$PointLight2D.color = type
	
	call_deferred("updateCollision")
	pass # Replace with function body.

#should only happen if parent is moved or rotated
func updateCollision():
	#var col = get_node("CollisionPolygon2D")
	#var p1 = Vector2(0,0)
	#var opp = tan(deg_to_rad(angle)) * range
	#var p2 = Vector2(range, -opp)
	#var p3 = Vector2(range, opp)
	#col.polygon = [p1,p2,p3]
	#col.set_polygon(PackedVector2Array([p1,p2,p3]))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#updateCollision()
	pass

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	if cooldown:
		return
	for enemy in enemies:
		var query = PhysicsRayQueryParameters2D.create(global_position, enemy.global_position, 0b0011, [self])
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider.name == "Wall" and global_position.distance_to(result.position) < global_position.distance_to(enemy.global_position):
				enemies[enemy] = false
				enemy.removeResist(type)
			else:
				if not enemies[enemy]:
					enemies[enemy] = true
					enemy.resist(type)
				enemy.takeDamage(damage, type)
	cooldown = true

func _on_body_entered(body):
	if body is Enemy:
		body.resist(type)
		enemies[body] = true
		#enemies.append(body)
	pass # Replace with function body.


func _on_damage_timer_timeout():
	cooldown = false
	#if enemies:
		#for enemy in enemies:
			#enemy.takeDamage(damage)
	#pass # Replace with function body.


func _on_body_exited(body):
	if body is Enemy:
		if enemies[body]:
			body.removeResist(type)
		enemies.erase(body)
	pass # Replace with function body.

func ChangeType(_type):
	type = _type
	$PointLight2D.color = _type
