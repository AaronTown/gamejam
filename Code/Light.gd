extends Area2D

var enabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not enabled:
		return
	if get_parent() == body:
		return
	if body.name == "Reflector":
		body.get_node("Light").show()
		body.get_node("Light").enabled = true
#
#
func _on_body_exited(body):
	if not enabled:
		return
	if get_parent() == body:
		return
	if body.name == "Reflector":
		body.get_node("Light").hide()
		body.get_node("Light").enabled = false



func _on_visibility_changed():
	for body in get_overlapping_bodies():
		if get_parent() == body:
			continue
		if body.name == "Reflector":
			if not enabled:
				print("show")
				body.get_node("Light").show()
			else:
				print("hide")
				body.get_node("Light").hide()
			body.get_node("Light").enabled = not body.get_node("Light").enabled
