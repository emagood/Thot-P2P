#Thot p2p
extends Control
class_name WebServer




@export var port = 9999
@export var ip  = '"*"'

signal client_connected(client_id)
signal client_disconnected(client_id)
signal data_received(client_id, data)


var peer = WebSocketMultiplayerPeer.new()
var multiplayer_api : MultiplayerAPI

func _init(ip = "*",port = 9999):
	self.port = port
	self.ip = ip

func _ready():

	get_tree().set_multiplayer(multiplayer, self.get_path())
	#multiplayer.multiplayer_peer = null
	prints(port ," server")
	peer.create_server(port,"*")
	multiplayer_api = MultiplayerAPI.create_default_interface()
	multiplayer.multiplayer_peer = peer
	
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.server_disconnected.connect(_close_network)
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)


func _close_network():
	prints("se cerro la secion ")
	multiplayer.multiplayer_peer = null
	peer.close()


func _connected():
	prints("conected")
	#_game.set_player_name.rpc(_name_edit.text)


func _peer_connected(id):
	prints("perr id ", id)

func _peer_disconnected(id):
	print("Disconnected %d" % id)

func _on_Host_pressed():
	pass
	multiplayer.multiplayer_peer = null
	peer.create_server(port,"*")
	multiplayer.multiplayer_peer = peer

func _on_Disconnect_pressed():
	_close_network()

#no tiene sentido en server
#func _on_Connect_pressed():
	#multiplayer.multiplayer_peer = null
	##peer.create_client("ws://" + _host_edit.text + ":" + str(port))
	#multiplayer.multiplayer_peer = peer
	#prints("se quito peer server")
#





func send_pack(smj):
	command.rpc(smj)
	#if not is_multiplayer_authority():
		#return
@rpc("call_remote") 
func command(smj) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	var mi_id = multiplayer.get_unique_id()
	prints(":cliente  ",mi_id ," recibio ",  smj,peer_id ,)
	#send_pack.rpc_id(1,cmd)
	#send_sms.rpc_id(1,"hola a todos que tal ")
	pass # Replace with function body.

func _exit_tree() -> void:
	prints("quit")
	#thread.wait_to_finish()
	#upnp.delete_port_mapping(port)
	get_tree().set_multiplayer(null, self.get_path())
