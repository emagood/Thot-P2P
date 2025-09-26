#Thot p2p
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
const SEND_INTERVAL := 3.0

signal client_connected(client_id)
signal client_disconnected(client_id)
signal data_received(client_id, data)



func _init(initial_host, initial_port := 4343) -> void:
	if initial_host != "":
		#prints("elip se establecio : ", initial_host)
		self.host = initial_host
	port = initial_port
	_connect()

func _process(delta: float) -> void:
	
	send_timer += delta
	
	if send_timer >= SEND_INTERVAL:
		send_timer = randf_range(0.2 , 1.0)
		send_pack("Heartbeat %d randi %f" % [Time.get_ticks_msec(),send_timer])  # Cambio clave aquí
		
	while udp.get_available_packet_count() > 0:
		var response = udp.get_packet().get_string_from_utf8()
		prints("Respuesta del servidor:", response)
		connected = true
		emit_signal("data_received","del server udp", response)

func send_pack(message: String) -> void:
	if !udp.is_socket_connected():
		emit_signal("client_disconnected", "udp_noname")
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
	if udp.is_socket_connected():
		emit_signal("client_connected", "udp_noname")
	else:
		emit_signal("client_disconnected", "udp_noname")



func lang():
	udp.close() if udp.is_bound() else null  # 如果已绑定则先关闭
											 # Close if already bound
	udp.bind(port)                    # 绑定到指定端口
											 # Bind to specified port
	udp.set_broadcast_enabled(true)          # 启用广播功能
											 # Enable broadcast functionality
# 广播UDP消息到指定端口 | Broadcast UDP Message to Specified Port
func broadcast(text, bcast_port):
	# 使用广播地址255.255.255.255向所有设备发送消息
	# Use broadcast address 255.255.255.255 to send message to all devices
	return send(text, "255.255.255.255", bcast_port) 


func send(text, ip, port):
	udp.set_dest_address(ip, port)  # 设置目标地址和端口
									# Set destination address and port
	return udp.put_packet(text.to_utf8_buffer())  # 发送UTF-8编码的文本
												  # Send UTF-8 encoded text


func _exit_tree() -> void:
	udp.close()
	
