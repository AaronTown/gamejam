extends Control

@onready var Magnifier = preload("res://Scenes/magnifier.tscn")
@onready var Upgrade2 = preload("res://Scenes/upgrade_2.tscn")

var current_tower

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if TotalMoney.money >= 10:
		var magnifier = Magnifier.instantiate()
		magnifier.position = self.position
		TotalMoney.money -= 10
		current_tower.queue_free()
		self.visible = false
		get_node("../../Level1/Reflectors").add_child(magnifier)
		pass # Replace with function body.


func _on_button_2_pressed():
	if TotalMoney.money >= 10:
		var upgrade2 = Upgrade2.instantiate()
		upgrade2.position = self.position
		TotalMoney.money -= 10
		current_tower.queue_free()
		self.visible = false
		get_node("../../Level1/Reflectors").add_child(upgrade2)
		pass # Replace with function body.
