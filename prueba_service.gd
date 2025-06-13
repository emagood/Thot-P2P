extends Control
''' solo para prueba de la clase servicio '''
	#
#func _ready() -> void:
	## Creamos una instancia del NetworkManager
	#var network = Service.new()
	#add_child(network)
	## Configuramos UPnP (si queremos que esté habilitado)
	#network.enable_upnp()
#
	## Intentamos registrar un servidor UDP en el puerto 12345
	#var udp_server = network.add_server("udp", 12345)
	#if udp_server:
		#print("Servidor UDP creado exitosamente en puerto 12345")
	#else:
		#print("Error: No se pudo crear el servidor UDP")
#
	## Agregamos algunos clientes UDP
## Agregamos algunos clientes UDP con IP y puerto
	#network.add_client("udp", "127.0.0.1", 12345)
	#network.add_client("udp", "192.168.1.11", 12345)
	#network.add_client("udp", "192.168.1.12", 12345)
	#network.add_client("udp", "192.168.1.12", 5003)
	#
	#
		## Intentamos agregar un servidor ENet (pero ya tenemos UDP, así que puede generar un conflicto)
	#var enet_server = network.add_server("enet", 54321)
	#if enet_server:
		#print("Servidor ENet creado en puerto 54321")
	#else:
		#print("Error: Ya hay un servidor UDP, no se puede iniciar ENet simultáneamente")
#
	## Mostramos la lista de servidores activos
	#print("Servidores activos:", network.get_servers())
#
	## Mostramos la lista de clientes activos
	#print("Clientes conectados:", network.get_clients())
#
	## Cerramos el servidor UDP
	##network.remove_server("udp" , 12345)
	#network.remove_client("udp", "192.168.1.12", 5003)
	## Intentamos abrir un puerto UPnP
	#network.register_upnp_port(5000)
	#if network.is_upnp_port_open(5000):
		#print("Puerto 5000 está abierto con UPnP")
	#else:
		#print("El puerto 5000 no está habilitado en UPnP")
	#network.register_upnp_port(5000)
	#if network.is_upnp_port_open(5000):
		#print("Puerto 5000 está abierto con UPnP")
	#else:
		#print("El puerto 5000 no está habilitado en UPnP")
#
#
#
#
	## Mostramos el estado final de servidores y clientes
	#print("Estado final de servidores:", network.get_servers())
	#print("Estado final de clientes:", network.get_clients())
