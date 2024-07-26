extends Node2D

const max_energy : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to coins
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
func _process(delta):
	# money += 1
	# Changing the light on screen when health is lost
	$HealthIndicator.energy = max_energy * ($Emitter.max_health - $Emitter.health) / $Emitter.max_health
	# Play Game Over screen
	if $Emitter.health <= 0:
		Game_Over()

# This function will play out the steps for when a GameOver occurs.
# The factors to call this function will be called in _process(delta)
func Game_Over():
	var game_over = $GameOver
	game_over.show()
