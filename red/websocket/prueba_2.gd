extends Control

var server: WebServer
var client: WebClient

func _ready() -> void:

	pass



func _on_server_2_pressed() -> void:
	if client:
		return
	server = WebServer.new("*", 8080)
	add_child(server)
	#server.send.rpc("hola a todos")    # get_tree().root.
	pass # Replace with function body.


func _on_cliente_pressed() -> void:
	#if server :    ////para crear instanccias de esto 
		#return
	client = WebClient.new()
	add_child(client)
	await get_tree().create_timer(2).timeout
	client.command("hola del cliente") # use rcp no funciones de clase
	pass # Replace with function body.     get_tree().root.


func _on_button_pressed() -> void:
	if server != null:
		pass
		server.send_sms.rpc("hola a todos desde el server")
	
	if client != null:
		client.send_sms.rpc("hola a todos desde el cliente ")



func _on_peers_pressed() -> void:
	if server == null:
		return
	prints(server.multiplayer.get_peers())
	pass # Replace with function body.
