
class_name Service
extends Node

const ConnectionType = {
	UDP = "udp",
	TCP = "tcp",
	WEBSOCKET = "webs",
	WEBRTC = "webr",
	ENET = "enet"
}

# Diccionarios para registrar servidores y clientes por tipo de conexión
var servers := {}  # Ahora almacena { puerto: { "type": tipo, "node": instancia } } Registra servidores por tipo (ej. "UDP", "TCP", "ENet")
var clients := {}  # Registra clientes por tipo (ej. "UDP", "TCP")

# Para el upnp seting , configuracion
var upnp = UPNP.new()
var thread = null


# Arrays que almacenan nodos activos
var server_nodes := {}  # Guarda las instancias de servidores
var client_nodes := {}  # Guarda las instancias de clientes

# Lista de puertos abiertos
var open_ports := {}

# Estado de UPnP
var upnp_enabled := false
var upnp_ports := {}


func _ready() -> void:
	print("hola init")
#
	#var url = "htp://forum.godotengine.org/t/validate-if-a-string-is-a-url/37448/3"
	#var urlRegex = RegEx.new()
	#var compile_result = urlRegex.compile('^(ftp|http|https)://[^ "]+$')
	#if compile_result != OK:
		#print("Error al compilar el patrón RegEx: ", compile_result)
		#return
#
	#var result = urlRegex.search(url)
	#if result:
		#print("URL válida:", result.get_string())
	#else:
		#print("URL inválida.")

	thread = Thread.new()

# Agregar servidor con tipo y puerto
func add_server(type: String, port: int) -> bool:
	if !port > 0 and port <= 65535:
		return false
	if type not in ConnectionType.values():
		print("Tipo no válido para un socket:", type)
		return false

	if type not in servers:
		servers[type] = {}  # Inicializar diccionario si es la primera vez

	if port in servers[type]:
		print("Ya existe un servidor de tipo", type, "en el puerto:", port)
		return false

	var server = null

	match type:
		ConnectionType.UDP:
			server = Server_udp.new(port)
		ConnectionType.TCP:
			server = NetworkServer.new("*", port)
		ConnectionType.WEBSOCKET:
			server = WebServer.new("*", port)
		ConnectionType.WEBRTC:
			server = webrtc.new("*", port ,true)
		ConnectionType.ENET:
			server = Eserver.new("*", port)

	if server == null:
		print("Error: No se pudo instanciar el servidor de tipo", type)
		return false

	add_child(server)

	# Guardar el servidor en el diccionario por tipo y puerto
	servers[type][port] = server

	print("Servidor agregado:", type, "en puerto:", port)
	return true


# Eliminar servidor con tipo y puerto
func remove_server(type: String, port: int):
	if type in servers and port in servers[type]:
		var server_node = servers[type][port]
		
		# Liberar el nodo del servidor
		server_node.queue_free()
		
		# Eliminar del registro
		servers[type].erase(port)

		print("Servidor eliminado: ", type, " en puerto: ", port)

		# Si no quedan más servidores de ese tipo, eliminar la clave
		if servers[type].is_empty():
			servers.erase(type)
	else:
		print("No existe un servidor de tipo ", type, "en el puerto: ", port)





# Agregar cliente con IP, tipo y puerto
func add_client(type: String, ip: String, port: int):
	if !port > 0 and port <= 65535:
		return false
	if type not in ConnectionType.values():
		print("Tipo no válido para un socket: ", type)
		return false

	if type not in clients:
		clients[type] = []

	var client_info = {"ip": ip, "port": port}

	# Verificar si el cliente ya está registrado
	for client in clients[type]:
		if client["ip"] == ip and client["port"] == port:
			print("El cliente ya está registrado: ", ip, ":", port)
			return false

	# Instanciar la clase correspondiente al tipo de cliente
	var client = null

	match type:
		ConnectionType.UDP:
			client = Client_udp.new(ip, port)
		ConnectionType.TCP:
			client = NetworkClient.new(ip, port)
		ConnectionType.WEBSOCKET:
			client = WebClient.new(ip, port)
		ConnectionType.WEBRTC:
			client = webrtc.new("*", port )
		ConnectionType.ENET:
			client = Eclient.new(ip, port)

	# Verificar si la instancia se creó correctamente
	if client == null:
		print("Error: No se pudo instanciar el cliente de tipo ", type)
		return false

	add_child(client)

	# Guardar nodo del cliente en el registro con IP y puerto
	if type not in client_nodes:
		client_nodes[type] = []
	client_nodes[type].append({"node": client, "ip": ip, "port": port})

	# Agregar cliente al registro
	clients[type].append(client_info)
	print("Cliente agregado: ", ip, " : ", port, " al tipo ", type)

	return true


# Eliminar cliente por IP y puerto
func remove_client(type: String, ip: String, port: int):
	if type in clients:
		# Buscar en client_nodes
		if type in client_nodes:
			for client_data in client_nodes[type]:
				if client_data["ip"] == ip and client_data["port"] == port:
					var client_node = client_data["node"]  # Obtener referencia del nodo
					client_node.queue_free()  # Liberar nodo

					client_nodes[type].erase(client_data)  # Eliminar del registro
					break
		
		# Eliminar del registro general
		for client in clients[type]:
			if client["ip"] == ip and client["port"] == port:
				clients[type].erase(client)
				print("Cliente eliminado: ", ip, " : ", port , " de tipo: " , type)
				return
	
	print("No se encontró el cliente: ", ip, " : ", port)


# Obtener lista de servidores y clientes
func get_servers() -> Dictionary:
	return servers

func get_clients() -> Dictionary:
	return clients



func send(type , ip , port, pack):
	if type in clients:
		# Buscar en client_nodes
		if type in client_nodes:
			for client_data in client_nodes[type]:
				if client_data["ip"] == ip and client_data["port"] == port:
					var client_node = client_data["node"]  # Obtener referencia del nodo
					if client_node.has_method("send_pack"):
						client_node.send_pack(pack)
						return
					else:
						prints("Error: Network 'send_pack'")

	if type in servers and port in servers[type]:
		var server_node = servers[type][port]

		if server_node.has_method("send_pack"):
			server_node.send_pack(pack)
			return
		else:
			prints("Error: Network 'send_pack'")
	prints("Error: Network service no esta iniciado")



# Registrar UPnP
func enable_upnp(port):
	#if upnp_enabled == true:
		#return
	thread.start(register_upnp_port.bind(port))
	upnp_enabled = true
	print("UPnP habilitado")
	thread.wait_to_finish()

func disable_upnp(port):
	if upnp_ports.has(port):
		#print("El puerto UPnP ya está registrado: ", port)
		upnp.delete_port_mapping(port)
		upnp_enabled = false
	else:
		print("El puerto UPnP no está registrado: ", port)
		return

	print("UPnP deshabilitado")

func register_upnp_port(port: int):
	if not Thot.upnp_enabled:
		print("No se puede registrar UPnP, está deshabilitado.")
		return
	
	if Thot.upnp_ports.has(port):
		print("El puerto UPnP ya está registrado: ", upnp_ports[port])
		return
	prints("upnp setup iniciando")
	
	var err = upnp.discover()
	if err != OK:
		push_error(str(err))
		return
	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		upnp.add_port_mapping(port, port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(port, port, ProjectSettings.get_setting("application/config/name"), "TCP")
		#upnp.add_port_mapping(port, port, ProjectSettings.get_setting("applicationname"), "TCP")
		#if map_result != UPNP.UPNP_RESULT_SUCCESS:
			#push_error("Fallo al mapear el puerto: %s" % map_result)
			#
		var external_ip = upnp.query_external_address()
		print("Success! Join Address: %s" % external_ip)
		Thot.upnp_ports[port] = external_ip

	# Si UPnP está habilitado y el puerto no está registrado, se agrega
	#upnp_ports[port] = external_ip
	print("Puerto UPnP registrado: ",Thot.upnp_ports[port])

func is_upnp_port_open(port: int) -> bool:
	return upnp_ports.get(port, false)



func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	thread.wait_to_finish()
