extends "res://entity/EntityBase.gd"

@onready var animated_sprite = $AnimationPlayer
@onready var emitter = get_node("/root/Node2D/Player")

func _ready():
	animated_sprite.queue("spawn")
	if animated_sprite.animation_finished:
		print("hey")

func _physics_process(delta):
	animated_sprite.queue("flying")
	move()
	
func move():
	var direction = global_position.direction_to(emitter.global_position)
	velocity = direction * 50
	move_and_slide()

func die():
	queue_free()
	# animated_sprite.play("death")
	

