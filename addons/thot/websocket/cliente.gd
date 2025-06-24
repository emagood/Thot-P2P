extends Control
class_name WebClient

@export var port: int = 8080
@export var ip: String = "localhost"

var peer = WebSocketMultiplayerPeer.new()

func _init(ip: String = "localhost", port: int = 8080):
	self.port = port
	self.ip = ip

func _ready():
	get_tree().set_multiplayer(MultiplayerAPI.create_default_interface(), self.get_path())
	get_tree().set_multiplayer(multiplayer, self.get_path())
	#get_tree().set_multiplayer(multiplayer)
	multiplayer.multiplayer_peer = null
	var err = peer.create_client("ws://" + ip + ":" + str(port))
	if err != OK:
		print("Failed to create client: %s" % err)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(self._peer_connected)
	multiplayer.peer_disconnected.connect(self._peer_disconnected)
	multiplayer.server_disconnected.connect(self._close_network)
	multiplayer.connection_failed.connect(self._close_network)
	multiplayer.connected_to_server.connect(self._connected)

func _close_network():
	print("_lose network :cliente")
	multiplayer.multiplayer_peer = null
	peer.close()

func _connected():
	print("se conecto")

func _peer_connected(id):
	print("se conecto :cliente %d" % id)

func _peer_disconnected(id):
	print("Disconnected :cliente %d" % id)

@rpc("any_peer")
func send_sms(smj):
	#if not is_multiplayer_authority():
		#return
	var peer_id = multiplayer.get_remote_sender_id()
	var mi_id = multiplayer.get_unique_id()
	prints(":cliente  ",mi_id ," recibio ",  smj,peer_id ,)

func command(cmd) -> void:
	send_sms.rpc_id(1,cmd)
	#send_sms.rpc_id(1,"hola a todos que tal ")
	pass # Replace with function body.


func _exit_tree() -> void:
	get_tree().set_multiplayer(null, self.get_path())
