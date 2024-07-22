extends CharacterBody2D

@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0
@export var SPEED: int = 75

# var velocity: Vector2 = Vector2.ZERO

func _ready():
	var sprite = $Sprite2D
	var collShape = $CollisionShape2D
	var animation_player = $AnimationPlayer
	
func _physics_process(delta):
	pass

