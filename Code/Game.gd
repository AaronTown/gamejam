extends Node2D

var money : int = 0
const max_energy : float = 2.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money += 1
	$HealthIndicator.energy = max_energy * ($Emitter.max_health - $Emitter.health) / $Emitter.max_health
	if $Emitter.health <= 0:
		Game_Over()
	$GUI/Money.text = "Money: " + str(money)

func AddMoney(amount):
	money += amount

# This function will play out the steps for when a GameOver occurs.
# The factors to call this function will be called in _process(delta)
func Game_Over():
	var game_over = $GameOver
	game_over.show()
