extends "res://Code/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Game/Emitter")

const damage = 50
var health = 50
var coin = preload("res://Scenes/coin.tscn")

func _ready():
	animated_sprite.queue("spawn")
	# if animated_sprite.animation_finished:
		# print("hey")

func _physics_process(delta):
	animated_sprite.queue("flying")
	health -= 1 # delete this
	if health <= 0:
		die()
	move(delta)

func move(delta):
	var direction = global_position.direction_to(emitter.global_position)
	velocity = direction * 50
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)
		var collider = collision.get_collider()
		if collider.name == "Emitter":
			collider.damage(damage)
			die()

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
	# animated_sprite.play("death")
	
func drop_coin():
	get_parent().AddMoney(10000000000000)
	pass

