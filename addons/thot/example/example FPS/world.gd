extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar


const player = preload("res://addons/thot/example/example FPS/player.tscn")
const PORT = 9999
var type = "enet"
#var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	DisplayServer.window_set_title("fps test thot-p2p servidor : SERVIDOR MODO :" + str(type))

	main_menu.hide()
	hud.show()

	Thot.add_server(self ,type, 9999, "lobby")
	prints(Thot.get_servers())
	
	
	await get_tree().create_timer(3.0).timeout
	var peer = Thot.server_thot(type,9999)
	self.multiplayer.multiplayer_peer = peer


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
	DisplayServer.window_set_title("fps test thot-p2p cliente : CLIENTE MODO :" + str(type))
	

	Thot.add_client(self ,type, address_entry.text,9999,$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/link_iroh.text)
	prints($CanvasLayer/MainMenu/MarginContainer/VBoxContainer/link_iroh.text)
	await get_tree().create_timer(1.0).timeout

	var peer = Thot.client_thot(type , 9999 )
	multiplayer.multiplayer_peer = peer


func add_player(peer_id):
	var player = player.instantiate()
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


func _on_enet___websocket_pressed() -> void:
	prints("cambio")
	if type == "webs":
		type = "enet"
	else:
		type = "webs"
	$"CanvasLayer/MainMenu/MarginContainer/VBoxContainer/enet _ websocket".text = type
	pass # Replace with function body.


func _on_iroh_enter_or_host_pressed() -> void:

	
	prints("cambio", type)
	if type == "webr":
		type = "iroh"
	else:
		type = "webr"
	$"CanvasLayer/MainMenu/MarginContainer/VBoxContainer/iroh enter or host".text = type
	pass # Replace with function body.
