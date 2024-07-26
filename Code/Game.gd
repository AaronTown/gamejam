extends Node2D

var total_money : int = 0
const max_energy : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to all existing coins
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.connect("coin_collected", Callable(self, "_on_coin_collected"))
	
	# Connect to future coins
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
func _on_node_added(node):
	if node.is_in_group("coins"):
		node.connect("coin_collected", Callable(self, "_on_coin_collected"))

func _process(delta):
	# money += 1
	$HealthIndicator.energy = max_energy * ($Emitter.max_health - $Emitter.health) / $Emitter.max_health
	if $Emitter.health <= 0:
		Game_Over()
	$GUI/Money.text = "Money: " + str(total_money)

func _on_coin_collected(value):
	total_money += value
	print("Total money: ", total_money)

# This function will play out the steps for when a GameOver occurs.
# The factors to call this function will be called in _process(delta)
func Game_Over():
	var game_over = $GameOver
	game_over.show()
