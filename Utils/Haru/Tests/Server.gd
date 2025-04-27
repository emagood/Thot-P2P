extends RefCounted

class_name HaruServer

var socket : UDPServer
var proxys : Array[HaruProxy]

var sceneTree : SceneTree

func listen(port : int) -> void:
	socket = UDPServer.new()
	socket.listen(port)

func poll() -> void:
	socket.poll()
	
	if socket.is_connection_available():
		var proxy = HaruProxy.new()
		proxy.socket = socket.take_connection()
		proxy.handshack.readPacketCallback = func(packet : PackedByteArray):
			print("[Server] %s" % packet.get_string_from_utf8())
		proxy.handshack.sceneTree = sceneTree
		proxys.append(proxy)
	
	for proxy in proxys:
		proxy.poll()
