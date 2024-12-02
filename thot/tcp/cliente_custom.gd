extends Node
class_name NetworkClient



#class ClientData:
#
	#var peer: PacketPeerStream
	#var connection: StreamPeerTCP



# Network
var client_data: ClientData
var connected = false

# Time out
var timeout: float = 3.0
var timeout_update_intervals_limit: float = 0.4
var timeout_update_intervals: float = 0.0

var address: String
var port: int

signal data_received(data)
signal connection_successful
signal connection_failed

func _init(conecting_address: String = "127.0.0.1", connecting_port: int = 3115):
	address = conecting_address
	port = connecting_port
	client_data = ClientData.new()
	client_data.connection = StreamPeerTCP.new()
	client_data.connection.connect_to_host(address, port)
	client_data.peer = PacketPeerStream.new()
	client_data.peer.set_stream_peer(client_data.connection)
	
	timeout = 5.0
	
	client_data.connection.poll()
	_check_connection_status(client_data.connection.get_status())

func _ready() -> void:
	pass
	#get_tree().set_multiplayer(multiplayer, self.get_path())
	
	#multiplayer.peer_connected.connect(_peer_connected)

func _process(delta):
	if client_data == null:
		return
	
	client_data.connection.poll()
	var status = client_data.connection.get_status()
	
	if !connected:
		_handle_connection_pending(delta, status)
	else:
		_handle_connection_active(status)
		_check_for_data()

 ## add mach  ferifico el status 
func _check_connection_status(status):
	match status:
		StreamPeerTCP.STATUS_CONNECTED:
			_connection_successful()
		StreamPeerTCP.STATUS_CONNECTING:
			print("[CLIENT] Pending connection to " + address + ":" + str(port))        #quitar 
		StreamPeerTCP.STATUS_NONE, StreamPeerTCP.STATUS_ERROR:
			_connection_failed()

func _handle_connection_pending(delta, status):
	if status == StreamPeerTCP.STATUS_CONNECTED:
		_connection_successful()
		return

	if timeout > 0:
		timeout -= delta
		if timeout_update_intervals < timeout_update_intervals_limit:
			timeout_update_intervals += delta
		else:
			timeout_update_intervals = 0.0
			print("[CLIENT] Pending connection to " + address + ":" + str(port) + " timeout in " + str(snapped(timeout, 0.01)) + "s")    #quitar      
	else:
		push_error("[CLIENT] Timeout from server")     #quitar 
		_connection_failed()


#func _peer_connected(id):
	#var peer_id = multiplayer.get_remote_sender_id()
	#prints("perr id ################################################################################", peer_id)
	##_game.on_peer_add(id)




func _handle_connection_active(status):
	if status in [StreamPeerTCP.STATUS_NONE, StreamPeerTCP.STATUS_ERROR]:
		_connection_failed()

func _check_for_data():
	while client_data.peer.get_available_packet_count() > 0:
		var data = client_data.peer.get_var()
		prints(client_data.connection.get_connected_host())
		print("[CLIENT] Data received: " + str(data))   #quitar 
		data_received.emit(data)

func _connection_successful():
	print("[CLIENT] Successfully connected to " + address + ":" + str(port))   #quitar 
	connected = true
	emit_signal("connection_successful")

func _connection_failed():
	print("[CLIENT] Couldn't connect to " + address + ":" + str(port))  #quitar usar // aqui no //# push_error
	connected = false
	client_data.queue_free()
	emit_signal("connection_failed")

func send_data(data):
	if connected:
		client_data.peer.put_var(data)
	else:
		push_error("[CLIENT] Cannot send data, not connected.")   
