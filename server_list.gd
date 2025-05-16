extends Control
@export var port = 0
@export var ip = 0
@export var type = ""
@export var server = false
var network








func _ready() -> void:
	# Creamos una instancia del NetworkManager
	var network = Service.new()
	add_child(network)
	# Configuramos UPnP (si queremos que esté habilitado)
	network.enable_upnp()

	# Intentamos registrar un servidor UDP en el puerto 12345
	if server:
		var udp_server = network.add_server(type, port)
		if udp_server:
			print("Servidor UDP creado exitosamente en puerto 12345")
		else:
			print("Error: No se pudo crear el servidor UDP")
			network.queue_free()
			queue_free()


	if !server:
		network.add_client(type, ip,port)
		print("Error: No se pudo crear el servidor UDP")
		
	

	# Mostramos la lista de servidores activos
	#print("Servidores activos:", network.get_servers())
#
	## Mostramos la lista de clientes activos
	#print("Clientes conectados:", network.get_clients())
	$VBoxContainer/Label.text += " " + type
	# Cerramos el servidor UDP
	#network.remove_server("udp" , 12345)
	#network.remove_client("udp", "192.168.1.12", 5003)

# quitamos todo al salir 
func _on_button_pressed() -> void:
	if server:
		network.remove_server(type ,ip)
		queue_free()
	else:
		network.remove_client(type, ip,port)
	pass 


func _on_enviar_pressed() -> void:
	var smj = $"../../../../../edot_msj".text
	prints(smj)
	prints("funcion de enviar prueba port / type " , port , "  " , type)
	pass # Replace with function body.
