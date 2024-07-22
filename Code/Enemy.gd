extends "res://entity/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Game/Emitter")

const damage = 50

func _ready():
	animated_sprite.queue("spawn")
	if animated_sprite.animation_finished:
		print("hey")

func _physics_process(delta):
	animated_sprite.queue("flying")
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

func die():
	drop()
	queue_free()
	# animated_sprite.play("death")
	
func drop():
	#Spawn loot
	pass
