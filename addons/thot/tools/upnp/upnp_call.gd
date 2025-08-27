# thotp2p upnp seting
extends Node
class_name ThotUPNPCall

@export var port: int = 1024
var thread = null
var upnp = UPNP.new()
func _ready():
	
	thread = Thread.new()
	thread.start(_upnp_setup.bind(port))
	print("ThotUPNPCall iniciado en el árbol")
	
	#var upnp := UPNP.new()
	#var err := upnp.discover()
	#if err != OK:
		#push_error("UPNP discovery failed: " + str(err))
		#queue_free()
		#return
	#
	#var gateway := upnp.get_gateway()
	#if gateway == null or not gateway.is_valid_gateway():
		#push_error("No se detectó gateway UPnP válido")
		#queue_free()
		#return
	#
	#var app_name := ProjectSettings.get_setting("application/config/name", "GodotApp")
	#var udp_result := upnp.add_port_mapping(port, port, app_name, "UDP")
	#var tcp_result := upnp.add_port_mapping(port, port, app_name, "TCP")
	#
	#if udp_result != UPNP.UPNP_RESULT_SUCCESS or tcp_result != UPNP.UPNP_RESULT_SUCCESS:
		#push_error("Fallo al mapear puertos: UDP=%s, TCP=%s" % [udp_result, tcp_result])
		#queue_free()
		#return
	#
	#var external_ip := upnp.query_external_address()
	#if external_ip == "":
		#push_error("No se pudo obtener la IP externa")
		#queue_free()
		#return
	#
	#if not Thot.upnp_ports.has(port):
		#Thot.upnp_ports[port] = external_ip
	#
	#print("Success! Join Address: %s" % external_ip)
	#print("Puerto UPnP registrado: ", Thot.upnp_ports[port])
	#
	#queue_free() # Limpieza automática del nodo auxiliar



func _upnp_setup(server_port):
	prints("upnp setup iniciando desde el hilo ")
	var upnp := UPNP.new()
	var err := upnp.discover()
	if err != OK:
		push_error("UPNP discovery failed: " + str(err))
		queue_free()
		return
	
	var gateway := upnp.get_gateway()
	if gateway == null or not gateway.is_valid_gateway():
		push_error("No se detectó gateway UPnP válido")
		queue_free()
		return
	
	var app_name := ProjectSettings.get_setting("application/config/name", "GodotApp")
	var udp_result := upnp.add_port_mapping(port, port, app_name, "UDP")
	var tcp_result := upnp.add_port_mapping(port, port, app_name, "TCP")
	
	if udp_result != UPNP.UPNP_RESULT_SUCCESS or tcp_result != UPNP.UPNP_RESULT_SUCCESS:
		push_error("Fallo al mapear puertos: UDP=%s, TCP=%s" % [udp_result, tcp_result])
		queue_free()
		return
	
	var external_ip := upnp.query_external_address()
	if external_ip == "":
		push_error("No se pudo obtener la IP externa")
		queue_free()
		return
	
	if not Thot.upnp_ports.has(port):
		Thot.upnp_ports[port] = external_ip
	
	print("Success! Join Address: %s" % external_ip)
	print("Puerto UPnP registrado: ", Thot.upnp_ports[port])
	

func _exit_tree():
	prints("exit script")
	thread.wait_to_finish()
	upnp.delete_port_mapping(port)
