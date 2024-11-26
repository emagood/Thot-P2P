extends Node2D
var address = "127.0.0.1"
var port = 1454
var network_server = NetworkServer
var network_client = NetworkClient
var player_id



func _ready():
	get_tree().set_multiplayer(multiplayer, self.get_path())
	
	pass

	
	
	network_client = NetworkClient.new(address, port)
	
	network_client.data_received.connect(
		func(data):
			print("Client received data: "+str(data))
			network_client.send_data("Hello Server")
	)
	add_child(network_client)
	
	
	network_server = NetworkServer.new(address, port)
	network_server.client_connected.connect(
		func(player_id):
			self.player_id = player_id
			print("Server has connection for id: "+str(player_id))
			network_server.send_data(player_id, "Hello Client")
	)
	network_server.client_disconnected.connect(
		func(player_id):
			print("Server has disconnection for id: "+str(player_id))
	)
	network_server.data_received.connect(
		func(player_id, data):
			print("Server received data from ("+str(player_id)+"): "+str(data))
	)
	add_child(network_server)


func _on_button_pressed() -> void:

	if network_client != null and network_client.client_data != null:
		network_client.send_data("Hello Server")
	else:
		print("network_client o client_data no está instanciado")
	
	if network_server != null and network_server.client_datas != null:
		var player_id = 1  
		network_server.send_data(player_id, "Hello Client")
		prints("enviar desde el servidor")
	else:
		push_error("network_server o client_datas no está instanciado")
	
	pass # Replace with function body.
