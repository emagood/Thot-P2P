extends Control
class_name WebServer




@export var port = 8080
@export var ip  = '"*"'
var upnp = UPNP.new()
var thread = null
@export var upnp_ip = 0


#@onready var _host_btn = $Panel/VBoxContainer/HBoxContainer2/HBoxContainer/Host
#@onready var _connect_btn = $Panel/VBoxContainer/HBoxContainer2/HBoxContainer/Connect
#@onready var _disconnect_btn = $Panel/VBoxContainer/HBoxContainer2/HBoxContainer/Disconnect
#@onready var _name_edit = $Panel/VBoxContainer/HBoxContainer/NameEdit
#@onready var _host_edit = $Panel/VBoxContainer/HBoxContainer2/Hostname
#@onready var _game = $Panel/VBoxContainer/Game

var peer = WebSocketMultiplayerPeer.new()


func _init(ip,port):
	self.port = port
	self.ip = ip
	thread = Thread.new()
	thread.start(_upnp_setup.bind(port))
	#get_tree().set_multiplayer(MultiplayerAPI.create_default_interface(), self)
	#multiplayer.multiplayer_peer = null
	
	#multiplayer.multiplayer_peer = peer
	pass
	#peer.supported_protocols = ["ludus"]

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


func _ready():
	
	
	get_tree().set_multiplayer(multiplayer, self.get_path())
	multiplayer.multiplayer_peer = null
	peer.create_server(port,"*")
	multiplayer.multiplayer_peer = peer
	
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.server_disconnected.connect(_close_network)
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)

	#$AcceptDialog.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#$AcceptDialog.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# Set the player name according to the system username. Fallback to the path.
	#if OS.has_environment("USERNAME"):
		#_name_edit.text = OS.get_environment("USERNAME")
	#else:
		#var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP).replace("\\", "/").split("/")
		#_name_edit.text = desktop_path[desktop_path.size() - 2]


#func start_game():
	#_host_btn.disabled = true
	#_name_edit.editable = false
	#_host_edit.editable = false
	#_connect_btn.hide()
	#_disconnect_btn.show()
	#_game.start()
#
#
#func stop_game():
	#_host_btn.disabled = false
	#_name_edit.editable = true
	#_host_edit.editable = true
	#_disconnect_btn.hide()
	#_connect_btn.show()
	#_game.stop()


func _close_network():
	#stop_game()
	#$AcceptDialog.popup_centered()
	#$AcceptDialog.get_ok_button().grab_focus()
	prints("se cerro la secion ")
	multiplayer.multiplayer_peer = null
	peer.close()


func _connected():
	prints("conected")
	#_game.set_player_name.rpc(_name_edit.text)


func _peer_connected(id):
	prints("perr id ", id)
	#_game.on_peer_add(id)


func _peer_disconnected(id):
	print("Disconnected %d" % id)
	#_game.on_peer_del(id)


func _on_Host_pressed():
	pass
	multiplayer.multiplayer_peer = null
	peer.create_server(port,"*")
	multiplayer.multiplayer_peer = peer
	#_game.add_player(1, _name_edit.text)
	#start_game()


func _on_Disconnect_pressed():
	
	_close_network()


func _on_Connect_pressed():
	multiplayer.multiplayer_peer = null
	#peer.create_client("ws://" + _host_edit.text + ":" + str(port))
	multiplayer.multiplayer_peer = peer
	#start_game()




@rpc("call_remote","any_peer") 
func send_sms(smj):
	#if not is_multiplayer_authority():
		#return
	var peer_id = multiplayer.get_remote_sender_id()
	prints(":server  " , smj,peer_id)
	send_sms.rpc_id(peer_id , " te comunicaste con el servidor websocket")

func command(cmd) -> void:
	send_sms.rpc_id(1,cmd)
	#send_sms.rpc_id(1,"hola a todos que tal ")
	pass # Replace with function body.
	
func _exit_tree() -> void:
	prints("quit")
	thread.wait_to_finish()
	upnp.delete_port_mapping(port)
	get_tree().set_multiplayer(null, self.get_path())
