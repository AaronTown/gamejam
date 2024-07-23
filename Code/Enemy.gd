extends "res://Code/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Game").emitter

const damage = 50
var health = 50
var speed = 125

signal died(enemy)

func _ready():
	animated_sprite.queue("spawn")
	if animated_sprite.animation_finished:
		#print("hey")
		pass

func _physics_process(delta):
	animated_sprite.queue("flying")
	move(delta)

func move(delta):
	var direction = global_position.direction_to(emitter.global_position)
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.name == "Emitter":
			collider.damage(damage)
			die()

func takeDamage(_damage):
	health -= _damage
	if health <= 0:
		die()

func die():
	
	drop()
	queue_free()
	died.emit(self)
	# animated_sprite.play("death")
	
func drop():
	get_node("/root/Game").AddMoney(10000000000000)
	pass

