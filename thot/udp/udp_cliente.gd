class_name Client_udp
extends Node

var udp = PacketPeerUDP.new()
var connected = false

func _init(host = "127.0.0.1" , port = 4242) -> void:
	udp.connect_to_host(host, port)
func _ready() -> void:
	udp.put_packet("hello".to_utf8_buffer())
func _process(delta):
	#udp.put_packet("The answer is... 42!".to_utf8_buffer())
	if !connected:
		# Try to contact server
		udp.put_packet("The answer is... 42!".to_utf8_buffer())
	if udp.get_available_packet_count() > 0:
		print("Connected: %s" % udp.get_packet().get_string_from_utf8())
		connected = true
