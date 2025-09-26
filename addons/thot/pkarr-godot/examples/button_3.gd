extends Button

var push = 0
func _on_pressed() -> void:
	push += 1
	$Label.text = str(push)
	pass # Replace with function body.
