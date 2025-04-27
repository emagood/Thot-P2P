@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("UDPManager", "Node", preload("core/udp_manager.gd"), preload("icon.svg"))

func _exit_tree() -> void:
	remove_custom_type("UDPManager") 
