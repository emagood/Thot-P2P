#Thot p2p
@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton("Thot", "res://addons/thot/service.gd")
	
	
func _enter_tree() -> void:
	add_autoload_singleton("Thot", "res://addons/thot/service.gd")



func _disable_plugin() -> void:
	remove_autoload_singleton("Thot")
