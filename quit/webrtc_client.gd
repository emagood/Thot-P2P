extends Node

var webrtc_client = webrtc.new()

func _ready():
	webrtc_client._init("localhost", 9080) # Replace with your signaling server IP and port
