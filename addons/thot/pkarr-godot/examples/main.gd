extends Node2D


func _ready() -> void:
	var peer = Peerinfo.new()

	prints(peer.get_secret_bytes())
	peer.info_ips()
	prints("creando key ", peer.key_rand())

	var key = [
		199, 133, 251, 69, 66, 206, 61, 213, 151, 163, 166, 14, 142, 46, 94, 231,
		66, 126, 8, 67, 114, 56, 186, 37, 12, 18, 111, 207, 0, 223, 229, 145,
	]

	var packed_key = PackedByteArray()
	for byte in key:
		packed_key.append(byte)

	prints("public key",peer.public_key(packed_key))
	#prints(peer.prepare_packet("emagorgrod","fffrood",peer.key_rand()))
