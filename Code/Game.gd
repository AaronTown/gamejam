extends Node2D

@onready var emitter = $Level1/Emitters/Emitter
@onready var Spawners = $Level1/Spawners
@onready var Enemies = $Level1/Enemies
@onready var Enemy = preload("res://Scenes/Enemy.tscn")

@onready var Reflector = preload("res://Scenes/Reflector.tscn")
@onready var AuxEmitter = preload("res://Scenes/aux_emitter.tscn")


const max_energy : float = 2.0
var round : int 
var enemies_to_spawn : int = 0
var enemies : int 

# Called when the node enters the scene tree for the first time.
func _ready():
	var cursor_texture = load("res://assets/cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	randomize()
	round = 1
	StartRound(round)
	# Connect to coins
	get_tree().connect("node_added", Callable(self, "_on_node_added"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# money += 1
	$HealthIndicator.energy = max_energy * (emitter.max_health - emitter.health) / emitter.max_health
	$GUI/Money.text = ": " + str(TotalMoney.money)
	if enemies_to_spawn > 0:
		var spawn = Spawners.get_children()[randi_range(0,3)].global_position
		var new_enemy = Enemy.instantiate()
		new_enemy.position = spawn + Vector2(randf_range(-10,10), randf_range(-10,10))
		new_enemy.died.connect(EnemyDied)
		Enemies.add_child(new_enemy)
		enemies_to_spawn -= 1
	
	# Play Game Over screen
	if emitter.health <= 0:
		Game_Over()

func AddMoney(amount):
	TotalMoney.money += amount
	
func getUpgradeMenu():
	return $GUI/UpgradeMenu

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


# This function will play out the steps for when a GameOver occurs.
# The factors to call this function will be called in _process(delta)
func Game_Over():
	TotalMoney.money = 0
	var game_over = $GameOver
	game_over.show()


func _on_button_pressed():
	if TotalMoney.money >= 10:
		var reflector = Reflector.instantiate()
		get_node("Level1/Reflectors").add_child(reflector)
		reflector.position = get_global_mouse_position()
		reflector.picked_up = true
		TotalMoney.money -= 10
	else:
		print("no money")
		
	pass # Replace with function body.
