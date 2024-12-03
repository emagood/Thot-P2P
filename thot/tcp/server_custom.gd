extends Node
class_name NetworkServer

### user quite la classe global 
#class ClientData:
#
	#var peer: PacketPeerStream
	#var connection: StreamPeerTCP

# Network
var server: TCPServer # Holds the TCP Server Object
var client_datas: Dictionary = {}
var next_client_id = 1
var port = null
var upnp = UPNP.new()
var thread = null
@export var upnp_ip = 0


signal client_connected(client_id)
signal client_disconnected(client_id)
signal data_received(client_id, data)

func _init(address: String = "127.0.0.1", port: int = 3115):
	self.port = port
	server = TCPServer.new()
	var err = server.listen(port, address)
	if err == OK:
		print("Server started on port %d" % port)
	else:
		print("Failed to start server: %s" % err)
	thread = Thread.new()
	thread.start(_upnp_setup.bind(port))

func _ready() -> void:
	
	#get_tree().set_multiplayer(multiplayer, self.get_path())
	pass
	#multiplayer.peer_connected.connect(_peer_connected)
	
func _upnp_setup(server_port):
	prints("upnp setup iniciando")
	var err = upnp.discover()
	if err != OK:
		push_error(str(err))
		return
	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		#upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
		upnp_ip = upnp.query_external_address()
		print("Success! Join Address: %s" % upnp_ip)


func _process(_delta):
	if server != null:
		if server.is_connection_available():
			var client_connection: StreamPeerTCP = server.take_connection()
			##########################################
			#### prueba 
			# Encuentra la primera clave numérica faltante en el diccionario 
			var key = 1 
			while client_datas.has(key): 
				key += 1 # Agrega el nuevo valor en el primer lugar vacío encontrado 
			#dictionary[key] = new_value
			
			var client_id = key
			next_client_id += 1
			client_datas[client_id] = ClientData.new()
			client_datas[client_id].peer = PacketPeerStream.new()
			client_datas[client_id].peer.set_stream_peer(client_connection)
			client_datas[client_id].connection = client_connection
			print("[SERVER] A Client has Connected! %d" % client_id)    ###quitar 
			emit_signal("client_connected", client_id)
	
	# Usar un array temporal para evitar modificaciones concurrentes
	var disconnected_clients = []
	for client_id in client_datas:
		var client_data: ClientData = client_datas[client_id]
		var connection = client_data.connection
		var peer = client_data.peer
		
		# Update connection status
		connection.poll()
		
		# Check for disconnection
		if connection.get_status() == connection.STATUS_ERROR or connection.get_status() == connection.STATUS_NONE:
			print("[SERVER] A Client has disconnected: %d" % client_id)
			disconnected_clients.append(client_id)
			client_datas.erase(client_id) ### problema 
			
			emit_signal("client_disconnected", client_id)
		else:
			# Check for receiving data
			while peer.get_available_packet_count() > 0:
				var data = peer.get_var()
				print("[SERVER] Data received from client %d: %s" % [client_id, str(data)])
				emit_signal("data_received", client_id, data)
	
	# Limpiar clientes desconectados
	for client_id in disconnected_clients:
		client_datas.erase(client_id)
		print("[SERVER] Client %d data cleaned up" % client_id)      #quitar /////////

#func _peer_connected(id):
	#var peer_id = multiplayer.get_remote_sender_id()
	#prints("perr id @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ", peer_id)
	##_game.on_peer_add(id)


func send_data(client_id: int, data):
	if client_datas.has(client_id):
		client_datas[client_id].peer.put_var(data)
		print("[SERVER] Data sent to client %d: %s" % [client_id, str(data)]) #///quitar ///
	else:
		client_datas.erase(client_id)
		push_error("[SERVER] Client %d not found" % client_id)


func _exit_tree() -> void:
	prints("adios ")
	thread.wait_to_finish()
	upnp.delete_port_mapping(port)
