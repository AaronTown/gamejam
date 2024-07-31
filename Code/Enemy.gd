extends "res://Code/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Game").emitter
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

const damage = 5
var health = 50
var speed = 75
var type : Color = Color.WHITE
var hit_by = [0,0,0]


signal died(enemy)
var coin = preload("res://Scenes/coin.tscn")

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	#ChangeType(type)
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	animated_sprite.queue("spawn")
	if animated_sprite.animation_finished:
		pass


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(emitter.global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _physics_process(delta):
	animated_sprite.queue("flying")
	# health -= 1 # delete this
	if health <= 0:
		die()
	move(delta)

func move(delta):
	if navigation_agent.is_navigation_finished():
		return
	navigation_agent.target_position = GetTarget().global_position
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.name.begins_with("Emitter") or collider.name.begins_with("SmallEmitter") or collider.name.begins_with("Reflector"):
			collider.damage(damage)
			die()

func GetTarget():
	var closest = emitter
	var distance = global_position.distance_squared_to(closest.global_position)
	var towers = get_node("/root/Game/Level1/Emitters").get_children() + get_node("/root/Game/Level1/Reflectors").get_children()
	for tower in towers:
		var towerDistance = global_position.distance_squared_to(tower.global_position)
		if  towerDistance < distance:
			closest = tower
			distance = towerDistance
	return closest

func resist(_type):
	if _type == type:
		return
	if _type == Color.RED:
		hit_by[0] = hit_by[0] + 1
	elif _type == Color.GREEN:
		hit_by[1] = hit_by[1] + 1
	elif _type == Color.BLUE:
		hit_by[2] = hit_by[2] + 1

func removeResist(_type):
	if _type == type:
		return
	if _type == Color.RED:
		hit_by[0] = hit_by[0] - 1
	elif _type == Color.GREEN:
		hit_by[1] = hit_by[1] - 1
	elif _type == Color.BLUE:
		hit_by[2] = hit_by[2] - 1

func takeDamage(_damage, _type):
	#resist(_type)
	if type != Color.WHITE:
		if _type != type:
			return
		for color in hit_by:
			if hit_by:
				_damage -= _damage/2
	health -= _damage
	if health <= 0:
		die()

func killed():
	for i in range(0,randi_range(0,1)):
		var coin = coin.instantiate()
		coin.global_position = global_position + Vector2(randf_range(-10,10), randf_range(-10,10))
		get_parent().add_child(coin)
	die()

func die():
	queue_free()
	died.emit(self)
	

func ChangeType(_type : Color):
	set_modulate(_type.inverted())
	type = _type
