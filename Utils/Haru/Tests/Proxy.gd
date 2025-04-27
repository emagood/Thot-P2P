extends RefCounted

class_name HaruProxy

var socket : PacketPeerUDP : set = _set_socket
var handshack : HaruHandshack

func _set_socket(stream : PacketPeerUDP) -> void:
	socket = stream
	
	if socket:
		handshack = HaruHandshack.new()
		handshack.streamPeer = socket

func _init() -> void:
	return

func create(address : String, port : int) -> void:
	socket = PacketPeerUDP.new()
	socket.connect_to_host(address, port)

func poll() -> void:
	if handshack:
		handshack.Handle()
