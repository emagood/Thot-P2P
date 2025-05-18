
'''
second
# Tiempo desde el inicio del juego (en segundos)
var game_time = Time.get_ticks_msec() / 1000.0

# Fecha y hora actual del sistema
var datetime = Time.get_datetime_dict_from_system()

# Tiempo UNIX (segundos desde 1970)
var unix_time = Time.get_unix_time_from_system()

'''
class_name Client_udp
extends Node

var udp := PacketPeerUDP.new()
var connected := false
var host := "127.0.0.1"
var port := 4343
var send_timer := 0.0
const SEND_INTERVAL := 1.0

func _init(initial_host := "127.0.0.1", initial_port := 4343) -> void:
	host = initial_host
	port = initial_port
	_connect()

func _process(delta: float) -> void:
	send_timer += delta
	
	if send_timer >= SEND_INTERVAL:
		send_timer = 0.0
		send_pack("Heartbeat %d" % Time.get_ticks_msec())  # Cambio clave aquí
		
	while udp.get_available_packet_count() > 0:
		var response = udp.get_packet().get_string_from_utf8()
		prints("Respuesta del servidor:", response)
		connected = true

func send_pack(message: String) -> void:
	if !udp.is_socket_connected():
		_connect()
		if !udp.is_socket_connected():
			return
	
	var err := udp.put_packet(message.to_utf8_buffer())
	prints("Cliente enviando:", message, "| Error:", err)

func _connect() -> void:
	udp.close()
	var err := udp.connect_to_host(host, port)
	prints("Intentando conectar a", host, port, "| Error:", err)
	connected = err == OK

func _exit_tree() -> void:
	udp.close()
