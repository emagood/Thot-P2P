class_name Client
extends BaseClient

var peer: WebRTCPeerConnection = WebRTCPeerConnection.new()
func _init() -> void:
	connected.connect(_connected)

	offer_received.connect(_offer_received)
	answer_received.connect(_answer_received)
	candidate_received.connect(_candidate_received)

	peer_connected.connect(_peer_connected)
	peer_disconnected.connect(_peer_disconnected)


func _connected(id: int, use_mesh := true):
	if use_mesh:
		rtc_mp.create_mesh(id)
	elif id == 1:
		rtc_mp.create_server()
	else:
		rtc_mp.create_client(id)

	multiplayer.multiplayer_peer = rtc_mp


func _create_peer(id):
	
	peer.initialize({
	"iceServers": [
		{ "urls": ["stun:stun.l.google.com:19302"] },
		{ "urls": ["stun:stun1.l.google.com:19302"] },
		{ "urls": ["stun:stun2.l.google.com:19302"] },
		{ "urls": ["stun:stun3.l.google.com:19302"] },
		{ "urls": ["stun:stun4.l.google.com:19302"] },
		{ "urls": ["stun:stun.ekiga.net"] },
		{ "urls": ["stun:stun.ideasip.com"] },
		{ "urls": ["stun:stun.schlund.de"] },
		{ "urls": ["stun:stun.stunprotocol.org:3478"] },
		{ "urls": ["stun:stun.voiparound.com"] },
		{ "urls": ["stun:stun.voipbuster.com"] },
		{ "urls": ["stun:stun.voipstunt.com"] },
		{ "urls": ["stun:stun.voxgratia.org"] },
		{ "urls": ["stun:numb.viagenie.ca"] }
	]
})

	peer.session_description_created.connect(_offer_created.bind(id))
	peer.ice_candidate_created.connect(_new_ice_candidate.bind(id))
	rtc_mp.add_peer(peer, id)
	if id < rtc_mp.get_unique_id():
		peer.create_offer()
	return peer


func _new_ice_candidate(mid_name, index_name, sdp_name, id):
	send_candidate(id, mid_name, index_name, sdp_name)


func _offer_created(type, data, id):
	if not rtc_mp.has_peer(id):
		return
	rtc_mp.get_peer(id).connection.set_local_description(type, data)
	if type == "offer": send_offer(id, data)
	else: send_answer(id, data)


func _peer_connected(id):
	_create_peer(id)


func _peer_disconnected(id):
	if rtc_mp.has_peer(id): rtc_mp.remove_peer(id)


func _offer_received(id, offer):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.set_remote_description("offer", offer)


func _answer_received(id, answer):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.set_remote_description("answer", answer)


func _candidate_received(id, mid, index, sdp):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.add_ice_candidate(mid, index, sdp)
