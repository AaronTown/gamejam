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
	$GUI/Money.text = "Money: " + str(money)

func AddMoney(amount):
	money += amount
