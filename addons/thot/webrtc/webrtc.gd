

class_name webrtc

extends BaseClient
 
var lobby_id = ""
var hosts : bool
const names = [
	"John", "Paul", "Gaylord", "Adalbert", "Oli",
	"Elena", "Marta", "Leo", "Nina", "Samuel",
	"Aisha", "Ravi", "Chloe", "Hector", "Yasmin",
	"Boris", "Luna", "Anastasia", "Kenji", "Freya"
]

var _peers_in_list := {}
var _is_connected := false
var nam =""

func _init(ip , port ,lobby_idd: String, host_tt: bool) -> void:
	self.lobby_id = lobby_idd
	hosts = host_tt
	self.server_address = "ws://localhost:9080" #"ws://" + ip + ":" + str(port)
	lobby_joined.connect(_id_connected)
	connection_timeout.connect(_off_time)
	lobby_joined.connect(_lobby_join)
	connected.connect(_connected)
	offer_received.connect(_offer_received)
	answer_received.connect(_answer_received)
	candidate_received.connect(_candidate_received)
	prints(hosts ," hosts " ,lobby_id , "lobby" )
	#multiplayer.peer_connected.connect(_id_peer_connected)
	#multiplayer.peer_disconnected.connect(_id_peer_disconnected)
	peer_connected.connect(_peer_connected)
	peer_disconnected.connect(_peer_disconnected)

func _ready() -> void:
	randomize()
	nam = names.pick_random()
	if lobby_id == "":
		prints("error de lobby " , lobby_id)
		lobby_id = "webrtc_godot_4.4.dev3"
	if hosts:
		prints(lobby_id)
		start(lobby_id, hosts)
	else:
		start(lobby_id, hosts)
		pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("txt"):
		send_text("texthola")

func _connected(id: int, use_mesh := true):
	if use_mesh:
		rtc_mp.create_mesh(id)
	elif id == 1:
		rtc_mp.create_server()
	else:
		rtc_mp.create_client(id)

	multiplayer.multiplayer_peer = rtc_mp


func _create_peer(id):
	var peer: WebRTCPeerConnection = WebRTCPeerConnection.new()
	peer.initialize({
	"iceServers": [
		{ "urls": ["stun:stun.l.google.com:19302"] },
		{ "urls": ["stun:stun1.l.google.com:19302"] },
		{ "urls": ["stun:stun2.l.google.com:19302"] },
		{ "urls": ["stun:stun3.l.google.com:19302"] },
		{ "urls": ["stun:stun4.l.google.com:19302"] },
		{ "urls": ["stun:stun.ekiga.net:3478"] },
		{ "urls": ["stun:stun.ideasip.com:3478"] },
		{ "urls": ["stun:stun.iptel.org:3478"] },
		{ "urls": ["stun:stun.schlund.de:3478"] },
		{ "urls": ["stun:stun.voiparound.com:3478"] },
		{ "urls": ["stun:stun.voipbuster.com:3478"] },
		{ "urls": ["stun:stun.voipstunt.com:3478"] },
		{ "urls": ["stun:stun.xten.com:3478"] }
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
	prints("se conecto : " , id)
	_create_peer(id)
	if id == multiplayer.get_unique_id():
		return
	rpc_id(id, "request_name")


func _peer_disconnected(id):
	if rtc_mp.has_peer(id): rtc_mp.remove_peer(id)
	if not _peers_in_list.has(id):
		return
	_peers_in_list.erase(id)

func _offer_received(id, offer):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.set_remote_description("offer", offer)


func _answer_received(id, answer):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.set_remote_description("answer", answer)


func _candidate_received(id, mid, index, sdp):
	if rtc_mp.has_peer(id):
		rtc_mp.get_peer(id).connection.add_ice_candidate(mid, index, sdp)


func _send_msg(type: int, id: int, data:="") -> int:
	return ws.send_text(JSON.stringify({
		"type": type,
		"id": id,
		"data": data,
		"lobby_id": lobby_id
	}))
func _off_time():
	prints("fuera tiempo")

func _lobby_join(lobby):
	prints(lobby , "es el lobby ")



@rpc("any_peer", "call_local")
func send_text(text):
	prints("mensaje de" , text)


@rpc("any_peer", "call_remote", "reliable")
func request_name() -> void:
	rpc_id(multiplayer.get_remote_sender_id(), "set_nickname",nam)


@rpc("any_peer", "call_local", "reliable")
func set_nickname(nickname: String) -> void:
	var peer = multiplayer.get_remote_sender_id()
	if peer in _peers_in_list:
		return

	_peers_in_list[peer] = nickname
	#%PlayerList.add_item(nickname)



func _id_connected(lobby: String) -> void:
	prints(lobby)

	_is_connected = true


func _id_peer_connected(id) -> void:
	if id == multiplayer.get_unique_id():
		return
	rpc_id(id, "request_name")
	prints("request_name")


func _id_peer_disconnected(id) -> void:
	if not _peers_in_list.has(id):
		return
	_peers_in_list.erase(id)
