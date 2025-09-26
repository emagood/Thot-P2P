#Thot p2p
'''
esto esta loco
'''
class_name Server_udp
extends Node

var server := UDPServer.new()
var peers := {}  # { "ip:port": { "peer": PacketPeerUDP, "last_active": float } }
const TIMEOUT := 5.0

signal client_connected(client_id)
signal client_disconnected(client_id)
signal data_received(client_id, data)

func _init(port: int, address := "*") -> void:
	if server.listen(port, address) != OK:
		push_error("Error al iniciar servidor UDP en puerto %d" % port)
	else:
		print("Servidor UDP iniciado en puerto %d" % port)

func _process(delta: float) -> void:
	server.poll()
	var current_time := Time.get_ticks_msec() / 1000.0
	
	# Manejar nuevas conexiones
	while server.is_connection_available():
		var peer := server.take_connection()
		var ip := peer.get_packet_ip()
		var port := peer.get_packet_port()
		var peer_key := "%s:%s" % [ip, port]
		var packet := peer.get_packet()
		var message := packet.get_string_from_utf8()
		
		print("Nueva conexión de %s: %s" % [peer_key, message])
		emit_signal("client_connected",peer_key )
		peers[peer_key] = {
			"peer": peer,
			"last_active": current_time
		}
		
		_send_response(peer, message)
	
	# Verificar mensajes de clientes existentes
	for peer_key in peers.keys():
		var peer_data = peers[peer_key]
		var peer: PacketPeerUDP = peer_data["peer"]
		
		while peer.get_available_packet_count() > 0:
			var packet = peer.get_packet()
			var message = packet.get_string_from_utf8()
			print("Mensaje de %s: %s" % [peer_key, message])
			peers[peer_key]["last_active"] = current_time
			_send_response(peer, message)
	
	# Limpieza de peers inactivos
	var to_remove := []
	for peer_key in peers:
		if current_time - peers[peer_key]["last_active"] > TIMEOUT:
			to_remove.append(peer_key)
			emit_signal("client_disconnected",peer_key )
	
	for peer_key in to_remove:
		print("Cliente desconectado: ", peer_key)
		emit_signal("client_disconnected",peer_key )
		peers.erase(peer_key)

func _send_response(peer: PacketPeerUDP, message: String) -> void:
	var response := "Server received: %s" % message
	emit_signal("data_received",peer.get_packet_ip(), response)
	var err := peer.put_packet(response.to_utf8_buffer())
	prints("Server enviando respuesta a", peer.get_packet_ip(), peer.get_packet_port(), "|", response, "| Error:", err)
	if err != OK:
		print("Error al enviar respuesta:", err)

func send_pack(message: String) -> void:
	var packet := message.to_utf8_buffer()
	for peer_data in peers.values():
		peer_data["peer"].put_packet(packet)
