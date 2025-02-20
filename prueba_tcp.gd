extends Node2D
var address = "127.0.0.1"
var port = 1454
var network_server = NetworkServer
var network_client = NetworkClient
var player_id

@onready var plano = $Control/ScrollContainer/plano



func _ready():
	get_tree().set_multiplayer(multiplayer, self.get_path())
	network_server = NetworkServer.new()
	network_client = NetworkClient.new()
	#pass






 ############### signal server 
func data_server(peer,data):
	var lavel = Label.new()
	lavel.text = str(" recibido , el server tiene  ("+str(peer) + "): " + str(data))
	plano.add_child(lavel)
	print("Server recibio de cliente  ("+str(peer) + "): " + str(data))
	pass
########################################
func peer_disconnect(peer):
	var lavel = Label.new()
	lavel.text = str(peer ,"  ","id se desconecto ")
	plano.add_child(lavel)
	print("Server has disconnection for id: "+str(peer))
	pass
#############################################
func peer_conect(peer):
	var lavel = Label.new()
	lavel.text = str(peer ,"  ","id se conectpo ")
	plano.add_child(lavel)
	self.player_id = peer
	print("El servidor tiene conexión para id: "+str(player_id))
	network_server.send_data(peer, "Hello Client")
	pass
	##############################################
	

 ############### signal cliente
func data_client(data):
	var lavel = Label.new()
	lavel.text = str("hola soy cliente recibi estov del server   ("+ str(data))
	plano.add_child(lavel)
	print("cliente recibe (" + str(data))
	pass

func server_fail():
	var lavel = Label.new()
	lavel.text = ("error server no encontrado")
	plano.add_child(lavel)
	print("Server no encontrado")
	pass

func server_ok():
	var lavel = Label.new()
	lavel.text = ("conectado al server ")
	plano.add_child(lavel)
	print("Server status OK")
	pass


func _on_button_pressed() -> void:

	if network_client != null and network_client.client_data != null:
		network_client.send_data("Hello Server")
		var lavel = Label.new()
		lavel.text = "hello server enviado de cliente "
		plano.add_child(lavel)
	else:
		print("network_client o client_data no está instanciado")
	
	if network_server != null and network_server.client_datas != {}:
		var player_id = 1  
		network_server.send_data(player_id, "Hello Client")
		var lavel = Label.new()
		lavel.text = "hello cliente desde servidor "
		plano.add_child(lavel)
		prints("enviar desde el servidor")
	else:
		push_error("network_server o client_datas no está instanciado")
	
	pass # Replace with function body.


func _on_only_client_pressed() -> void:
	if network_client != null and network_client.client_data != null:
		var lavel = Label.new()
		lavel.text = "enviado solo del cliente :)"
		plano.add_child(lavel)
		network_client.send_data("enviado solo del cliente :)")
	else:
		print("network_client o client_data no está instanciado")
	pass # Replace with function body.


func _on_only_server_pressed() -> void:
	if network_server != null and network_server.client_datas != {}:
		#prints(network_server.client_datas, {})
		var count = 0
		for player_id in network_server.client_datas:
			count = player_id
			var lavel = Label.new()
			lavel.text = "[SERVER] enviar server id ultimo " + str(player_id)
			plano.add_child(lavel)
			print("[SERVER] enviar server id ultimo " , player_id)  
		#if count == 0 :
			#return
		var lavel = Label.new()
		lavel.text = "player_id desde el servidor bienvenido " + str(player_id)
		plano.add_child(lavel)
		network_server.send_data(player_id, "desde el servidor bienvenido ")
		prints("enviar desde el servidor")
	else:
		push_error("network_server o client_datas no está instanciado")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_crea_srver_pressed() -> void:
	##  server ###################################

	network_server = NetworkServer.new(address, port)
	network_server.client_connected.connect(peer_conect)
		#func(player_id):
			#self.player_id = player_id
			#print("Server has connection for id: "+str(player_id))
			#network_server.send_data(player_id, "Hello Client")
	#)
	network_server.client_disconnected.connect(peer_disconnect)
		#func(player_id):
			#print("Server has disconnection for id: "+str(player_id))
	#)
	network_server.data_received.connect(data_server)
		#func(player_id, data):
			#print("Server received data from ("+str(player_id)+"): "+str(data))
	add_child(network_server)
	pass # Replace with function body.


func _on_crea_client_pressed() -> void:
	## client  ########################################

	network_client = NetworkClient.new(address, port)
	
	network_client.connection_failed.connect(server_fail)
	
	network_client.connection_successful.connect(server_ok)
	
	network_client.data_received.connect(data_client)
		#func(data):
			#print("Client received data: "+str(data))
			#network_client.send_data("Hello Server")
	#)
	add_child(network_client)
	pass # Replace with function body.
