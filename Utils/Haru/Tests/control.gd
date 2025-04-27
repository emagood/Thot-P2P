extends Control

var s = HaruServer.new()
var c = HaruProxy.new()

var tr = Thread.new()

func _ready() -> void:
	s.listen(8081)
	s.sceneTree = get_tree()
	
	c.create("127.0.0.1", 8081)
	c.handshack.readPacketCallback = func(packet : PackedByteArray):
		print("[Client] %s" % packet.get_string_from_utf8())
	c.handshack.sceneTree = get_tree()
	
	for i in range(10):
		c.handshack.SendPacket(("%s" % i).to_utf8_buffer())
	
	for i in range(4):
		c.handshack.SendPacket(("%s" % i).to_utf8_buffer())

func _process(delta: float) -> void:
	s.poll()
	c.poll()

func _exit_tree() -> void:
	c.socket.close()
	s.socket.stop()
