extends Control


@onready var rpc_local = get_tree().get_first_node_in_group("rpc_local")
@onready var user_login = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer2/LineEdit
@onready var user_pass = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer3/LineEdit
@onready var ip_server = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer4/LineEdit



#func _ready() -> void:
	#if Data.id_user != "": 
		#user_login.text = Data.id_user
	#if Data.id_pass != "":
		#user_pass.text = Data.id_pass
	#@warning_ignore("int_as_enum_without_cast")
	##DebugMenu.style = wrapi(DebugMenu.style + 1, 0, DebugMenu.Style.MAX)
	#DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	#pass 
#


func _process(delta: float) -> void:
	pass


func _on_regresar_pressed() -> void:
	queue_free()
	pass # Replace with function body.



func _on_login_pressed() -> void:
	var nueva_ip = "127.0.0.1"
	if ip_server.text != "":
		nueva_ip = ip_server.text
	prints(user_login.text , "  " , user_pass.text)
	#Data.id_user = user_login.text
	#Data.id_pass = user_pass.text
	rpc_local.nueva_red(8888 ,nueva_ip )
	rpc_local.nueva_msj()
	queue_free()
	pass # Replace with function body.



func _on_salir_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_server_pressed() -> void:
	if rpc_local.host_local.has(8888):
		prints("existe el puerto del host")
		rpc_local.nueva_msj()
		queue_free()
		return
#######################################

	rpc_local.nueva_host(8888)
	rpc_local.nueva_msj()
	queue_free()
	pass # Replace with function body.
