#class_name Server_udp
#extends Node
#
#var server = UDPServer.new()
#var peers = []
#
#func _init(port, adress = "*") -> void:
	#server.listen( port , adress)
	#prints("udp classs")
#
#func _process(delta):
	#server.poll() # Important!
	#if server.is_connection_available():
		#var peer = server.take_connection()
		#var packet = peer.get_packet()
		#print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		#print("Received data: %s" % [packet.get_string_from_utf8()])
		## Reply so it knows we received the message.
		#peer.put_packet(packet)
		## Keep a reference so we can keep contacting the remote peer.
		#peers.append(peer)
#
	#for i in range(0, peers.size()):
		#pass # Do something with the connected peers.


class_name Server_udp
extends Node

var server = UDPServer.new()
var peers := {}  # Diccionario que almacena peers por { ip:puerto => { "peer": instancia, "last_packet_time": tiempo } }
var TIMEOUT = 5.0  # Tiempo máximo sin recibir datos antes de eliminar cliente

func _init(port, address = "*") -> void:
	server.listen(port, address)
	print("Servidor UDP iniciado en puerto:", port)

func _process(delta):
	server.poll()  # Importante para procesar paquetes
	var current_time = Time.get_ticks_msec() / 1000.0  # Tiempo actual en segundos

	# Manejar nuevas conexiones
	if server.is_connection_available():
		var peer = server.take_connection()
		var ip = peer.get_packet_ip()
		var port = peer.get_packet_port()
		var packet = peer.get_packet()

		print("Nueva conexión: %s:%s" % [ip, port])
		print("Datos recibidos: %s" % [packet.get_string_from_utf8()])

		# Enviar respuesta al cliente
		peer.put_packet(packet)

		# Registrar peer en el diccionario con tiempo de último paquete
		var peer_key = "%s:%s" % [ip, port]
		peers[peer_key] = { "peer": peer, "last_packet_time": current_time }

	# Verificar y eliminar clientes desconectados por timeout
	for peer_key in peers.keys():
		var peer_data = peers[peer_key]
		if current_time - peer_data["last_packet_time"] > TIMEOUT:
			print("Cliente desconectado por inactividad:", peer_key)
			peers.erase(peer_key)  # Eliminar del diccionario
