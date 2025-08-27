extends Control


var server: Eserver
var client: Eclient

func _ready() -> void:

	pass



func _on_server_2_pressed() -> void:
	if client:
		return
	server = Eserver.new("*", 8080)
	add_child(server)
	#server.send.rpc("hola a todos")    # get_tree().root.
	pass # Replace with function body.


func _on_cliente_pressed() -> void:
	#if server :    ////para crear instanccias de esto 
		#return
	client = Eclient.new("localhost",8080)
	add_child(client)
	await get_tree().create_timer(2).timeout
	client.send_msja("hola del cliente", " ejemplo cliente ") # use rcp no funciones de clase
	pass # Replace with function body.     get_tree().root.


func _on_button_pressed() -> void:
	if server != null:
		pass
		server.rpc_sms.rpc("hola a todos desde el server","hola var")
	
	if client != null:
		client.rpc_sms.rpc("hola a todos desde el cliente " ," todo bien ")



func _on_peers_pressed() -> void:
	if server == null:
		prints(client.multiplayer.get_peers())
		return
	prints(server.multiplayer.get_peers())
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	queue_free()
	pass # Replace with function body.
