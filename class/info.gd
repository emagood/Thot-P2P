extends Node
class_name class_info

@onready var inf = {}




func _init() -> void:
	
	inf = {"id" : OS.get_unique_id(),
	"size" : DisplayServer.screen_get_size(),
	"fps" : DisplayServer.screen_get_refresh_rate(),
	"timer_local" : Time.get_time_string_from_system(false),
	"engine_global" : Engine.get_version_info(),
	"is_degub" : OS.is_debug_build(),
	"local" : OS.get_locale(),
	"model" : OS.get_model_name(),
	"is_touch" : DisplayServer.is_touchscreen_available()
	
	
	}
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prints("hola")
	pass



func info() -> Dictionary:
	var d = inf
	return d





func _exit_tree() -> void:
	prints("me fui")
