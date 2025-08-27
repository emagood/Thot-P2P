extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar


const Player = preload("res://addons/thot/example/example FPS/player.tscn")
const PORT = 9999
#var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	DisplayServer.window_set_title("fps test thot-p2p servidor : SERVIDOR")

	main_menu.hide()
	hud.show()

	Thot.add_server(self ,"enet", 9999, "lobby")
	#enet_peer.create_server(PORT)
	prints(Thot.get_servers())
	var serverlobby := Node.new()  # o una instancia real que ya tengas
	

	prints(Thot.get_servers())
	var dic = Thot.get_servers()
	var nodo = dic["enet"][9999]
	prints(nodo)
	self.multiplayer.multiplayer_peer = nodo.server_custom



	#multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	#upnp_setup()
func _ready() -> void:
	pass
	#prints(multiplayer_api) 

func _on_join_button_pressed():
	main_menu.hide()
	hud.show()
	DisplayServer.window_set_title("fps test thot-p2p cliente : CLIENTNE")
	

	Thot.add_client(self ,"enet", address_entry.text,9999,"lobbyS")
	
	var dic = Thot.get_client_node()
	prints("mi dic " , dic)
	var nodo = null
	for entry in dic["enet"]:
		if entry.has("port") and entry["port"] == 9999:
			nodo = entry["node"]
			break
	multiplayer.multiplayer_peer = nodo.client_custom


	#enet_peer.create_client(address_entry.text, PORT)
	#multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)

	#player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func update_health_bar(health_value):
	health_bar.value = health_value

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
