extends Node2D

@onready var emitter = $Level1/Emitters/Emitter
@onready var Spawners = $Level1/Spawners
@onready var Enemies = $Level1/Enemies
@onready var Enemy = preload("res://Scenes/Enemy.tscn")

var money : int = 0
const max_energy : float = 2.0
var round : int 
var enemies_to_spawn : int = 0
var enemies : int 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	round = 1
	StartRound(round)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money += 1
	$HealthIndicator.energy = max_energy * (emitter.max_health - emitter.health) / emitter.max_health
	$GUI/Money.text = "Money: " + str(money)
	if enemies_to_spawn > 0:
		var spawn = Spawners.get_children()[randi_range(0,3)].global_position
		var new_enemy = Enemy.instantiate()
		new_enemy.position = spawn + Vector2(randf_range(-10,10), randf_range(-10,10))
		new_enemy.died.connect(EnemyDied)
		Enemies.add_child(new_enemy)
		enemies_to_spawn -= 1

func AddMoney(amount):
	money += amount

func StartRound(round : int):
	$GUI/Wave.text = "Wave: " + str(round)
	$GUI/Wave.show()
	await get_tree().create_timer(3).timeout
	$GUI/Wave.hide()
	enemies_to_spawn = 8 + 2 ** round
	#enemies_to_spawn = 1
	enemies = enemies_to_spawn 

func EnemyDied(enemy):
	enemy.died.disconnect(EnemyDied)
	enemies -= 1
	if enemies == 0:
		round += 1
		StartRound(round)
