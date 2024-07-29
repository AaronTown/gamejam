extends "res://Code/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Game").emitter
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

const damage = 50
var health = 50
var speed = 125

signal died(enemy)
var coin = preload("res://Scenes/coin.tscn")

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

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
		if collider.name == "Emitter":
			collider.damage(damage)
			die()

func GetTarget():
	var closest = emitter
	var distance = global_position.distance_squared_to(closest.global_position)
	for tower in get_node("/root/Game/Level1/Emitters").get_children():
		#print(tower, tower.global_position)
		#print(global_position)
		var towerDistance = global_position.distance_squared_to(tower.global_position)
		if  towerDistance < distance:
			closest = tower
			distance = towerDistance
	return closest

func takeDamage(_damage):
	health -= _damage
	if health <= 0:
		die()

func die():
	var coin = coin.instantiate()
	coin.global_position = global_position
	get_parent().add_child(coin)
	# drop_coin()
	queue_free()
	died.emit(self)
	# animated_sprite.play("death")
	
func drop_coin():
	get_parent().AddMoney(10000000000000)
	pass

