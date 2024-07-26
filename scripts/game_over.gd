extends CanvasLayer


func _ready() -> void:
	hide()
	
func _process(delta: float) -> void:
	pass
	

func _on_reset_game_button_pressed():
	get_tree().reload_current_scene()

