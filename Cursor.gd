extends Node2D

func _ready():
	
	# load the cursor texture
	var cursor_texture = load("res://assets/cursor.png")
	# set the custom cursor
	Input.set_custom_mouse_cursor(cursor_texture)
