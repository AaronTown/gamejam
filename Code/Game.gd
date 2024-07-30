extends Node2D

@onready var emitter = $Level1/Emitters/Emitter
@onready var Spawners = $Level1/Spawners
@onready var Enemies = $Level1/Enemies
@onready var Enemy = preload("res://Scenes/Enemy.tscn")
@onready var SmallEmitter = preload("res://Scenes/SmallEmitter.tscn")
@onready var Reflector = preload("res://Scenes/Reflector.tscn")


const max_energy : float = 2.0
var round : int 
var enemies_to_spawn : int = 0
var enemies : int 
var thematic_darkness = .1
var round_active = false
var colors_active = false
var spawn_timer = 0
#signal round_start(round)

# Called when the node enters the scene tree for the first time.
func _ready():
	var cursor_texture = load("res://assets/cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	randomize()
	round = 0
	$Tutorial.TutorialStep(round+1)
	#StartRound(round)
	# Connect to coins
	get_tree().connect("node_added", Callable(self, "_on_node_added"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# money += 1
	$HealthIndicator.energy = thematic_darkness + max_energy * (emitter.max_health - emitter.health) / emitter.max_health
	$GUI/Money.text = ": " + str(TotalMoney.money)
	spawn_timer += 1
	if enemies_to_spawn > 0 and spawn_timer > 100:
		spawn_timer = 0
		var spawn = Spawners.get_children()[randi_range(0,3)].global_position
		var new_enemy = Enemy.instantiate()
		Enemies.add_child(new_enemy)
		new_enemy.global_position = spawn + Vector2(randf_range(-10,10), randf_range(-10,10))
		var new_type = Color.WHITE
		if round == 4 :
			new_type = Color.RED
		elif round > 4:
			var enemy_type = randi_range(1,10)
			if enemy_type == 1:
				new_type = Color.RED
			elif enemy_type == 2:
				new_type = Color.BLUE
			elif enemy_type == 3:
				new_type = Color.GREEN
		new_enemy.ChangeType(new_type)
		new_enemy.died.connect(EnemyDied)
		
		enemies_to_spawn -= 1
	
	# Play Game Over screen
	if emitter.health <= 0:
		Game_Over()

func AddMoney(amount):
	TotalMoney.money += amount

func StartRound(round : int):
	round_active = true
	$GUI/Play.hide()
	$GUI/Wave.text = "Wave: " + str(round)
	$GUI/Wave.show()
	await get_tree().create_timer(3).timeout
	$GUI/Wave.hide()
	match round:
		1:
			enemies_to_spawn = 5
		_:
			enemies_to_spawn = 8 + 2 ** round
	#enemies_to_spawn = 1
	enemies = enemies_to_spawn 
	#$Tutorial.TutorialStep(round)

func EnemyDied(enemy):
	enemy.died.disconnect(EnemyDied)
	enemies -= 1
	if enemies == 0:
		EndRound(round)
		#round += 1
		#StartRound(round)

func EndRound(round):
	if round == 3:
		colors_active = true
	if round < 4:
		$Tutorial.TutorialStep(round+1)
	round_active = false
	$GUI/Play.show()
# This function will play out the steps for when a GameOver occurs.
# The factors to call this function will be called in _process(delta)
func Game_Over():
	TotalMoney.money = 0
	var game_over = $GameOver
	game_over.show()
	

func PlaceTower(tower_to_place, tower_position):
	if tower_to_place == "SmallEmitter":
		var new_tower = SmallEmitter.instantiate()
		$Level1/Emitters.add_child(new_tower, true)
		new_tower.global_position = tower_position
		print(new_tower.position)
		
	elif tower_to_place == "Reflector":
		var new_tower = Reflector.instantiate()
		$Level1/Reflectors.add_child(new_tower, true)
		new_tower.global_position = tower_position
		
		


func _on_play_pressed():
	round+=1
	StartRound(round)
