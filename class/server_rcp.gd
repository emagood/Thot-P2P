
''' probablemente esto solo se use en el servidor prinipal'''

extends Node

class_name server_id




var Player = load("res://class/player.gd").Player
#var room = load("res://room_player_ipl.gd").Room  no se usa 

class RpcHandler:
	var players = []   # es un arrayu de los  jugadores 
	var player_ids = {}  # Diccionario para mapear unique_id a Player
	var player_id_map = {}  # Diccionario para mapear player_id a unique_id
	var safe_id_map = {}  # Diccionario para mapear safe_unique_id a player_id

	func _init():
		players = []
		player_ids = {}
		player_id_map = {}
		safe_id_map = {}

	func generate_unique_id(player) -> String:
		var unique_id = str(hash(player.player_id + player.ip + str(player.port)))
		while unique_id in player_ids:
			unique_id = str(hash(unique_id + str(Time.get_ticks_usec())))
		return unique_id

	func add_player(player) -> String:
		var unique_id = generate_unique_id(player)
		player_ids[unique_id] = player
		player_id_map[player.player_id] = unique_id
		players.append(player)
		return unique_id

	func remove_player(unique_id: String) -> void:
		if unique_id in player_ids:
			var player = player_ids[unique_id]
			players.erase(player)
			player_id_map.erase(player.player_id)
			player_ids.erase(unique_id)
   		 # También elimina cualquier safe_unique_id asociado
			var safe_ids_to_remove = []
			for safe_id in safe_id_map:
				if safe_id_map[safe_id] == player.player_id:
					safe_ids_to_remove.append(safe_id)
			for safe_id in safe_ids_to_remove:
				safe_id_map.erase(safe_id)
			print("Jugador y sus Safe Unique IDs asociados eliminados correctamente.")


	func get_player(unique_id: String):
		if unique_id in player_ids:
			return player_ids[unique_id]
		return null

	func get_unique_id_by_player_id(player_id: String) -> String:
		if player_id in player_id_map:
			return player_id_map[player_id]
		return ""

	func generate_safe_unique_id(player_id: String) -> String:
		var safe_unique_id = str(hash(player_id + str(Time.get_unix_time_from_system())))
		while safe_unique_id in safe_id_map:
			safe_unique_id = str(hash(safe_unique_id + str(Time.get_unix_time_from_system())))
		safe_id_map[safe_unique_id] = player_id
		return safe_unique_id

	func get_player_id_by_safe_id(safe_unique_id: String) -> String:
		if safe_unique_id in safe_id_map:
			return safe_id_map[safe_unique_id]
		return ""

	func add_friend(player_id: String, friend_id: String) -> void:
		var player = get_player(get_unique_id_by_player_id(player_id))
		var friend = get_player(get_unique_id_by_player_id(friend_id))
		if player and friend:
			var friend_data = {"id": friend_id, "nombre": friend.nombre}
			if not player.friends.has(friend_data):
				player.friends.append(friend_data)
				print(friend.nombre + " ha sido agregado a la lista de amigos de " + player.nombre)

	func remove_friend(player_id: String, friend_id: String) -> void:
		var player = get_player(get_unique_id_by_player_id(player_id))
		if player:
			var friend_to_remove = null
			for friend in player.friends:
				if friend["id"] == friend_id:
					friend_to_remove = friend
					break
			if friend_to_remove:
				player.friends.erase(friend_to_remove)
				print(friend_to_remove["nombre"] + " ha sido eliminado de la lista de amigos de " + player.nombre)
			else:
				print("Amigo no encontrado en la lista de " + player.nombre)

	func list_friends(player_id: String) -> void:
		var player = get_player(get_unique_id_by_player_id(player_id))
		if player:
			print("Lista de amigos de " + player.nombre + ":")
			for friend in player.get_friends():
				print("- " + friend["nombre"] + " (ID: " + friend["id"] + ")")
		else:
			print("Jugador no encontrado.")

	func remove_safe_unique_id(safe_unique_id: String) -> void:
		if safe_unique_id in safe_id_map:
			var player_id = safe_id_map[safe_unique_id]
			safe_id_map.erase(safe_unique_id)
			print("Safe Unique ID " + safe_unique_id + " eliminado para el jugador con ID " + player_id)
		else:
			print("Safe Unique ID no encontrado.")






func _ready() -> void:
	
	# Ejemplo de jugadores
	var player1 = Player.new("Jugador1", "192.168.1.1", 1234, "Juan", "")
	var player2 = Player.new("Jugador2", "192.168.1.2", 1235, "Ana", "")
	var player3 = Player.new("Jugador3", "192.168.1.3", 1236, "Luis", "")

	# Crear una instancia de RpcHandler
	var rpc_handler = RpcHandler.new()

	# Agregar jugadores y obtener sus identificadores únicos
	var id1 = rpc_handler.add_player(player1)
	var id2 = rpc_handler.add_player(player2)
	var id3 = rpc_handler.add_player(player3)

	print("ID de Jugador1: " + id1)
	print("ID de Jugador2: " + id2)
	print("ID de Jugador3: " + id3)

	print("Amigos de " + player1.nombre + " después de eliminar: " + str(player1.friends))
	# Obtener un jugador por su identificador único
	var retrieved_player = rpc_handler.get_player(id1)
	print("Jugador recuperado: " + retrieved_player.player_id , "  nombre " ,retrieved_player.nombre )

	# Eliminar un jugador


	print("Amigos de " + player1.nombre + " después de eliminar: " + str(player1.friends))

	# Agregar amigos
	rpc_handler.add_friend(id1, id2)
	rpc_handler.add_friend(id1, id3)

	# Mostrar amigos de Juan
	print("Amigos de " + player1.nombre + ": " + str(player1.friends))

	# Eliminar amigo
	rpc_handler.remove_friend(id1, id2)

   # Mostrar amigos de Juan después de eliminar
	print("Amigos de " + player1.nombre + " después de eliminar: " + str(player1.friends))

	rpc_handler.list_friends(id1)
	# Obtener un jugador por su identificador único
	retrieved_player = rpc_handler.get_player(id1)
	print("Jugador recuperado: " + retrieved_player.player_id)
	rpc_handler.remove_friend(id1, id2)
	rpc_handler.remove_friend(id1, id3)
	# Eliminar un jugador
	rpc_handler.remove_player(id2)
	print("Amigos de " + player1.nombre + " después de eliminar: " + str(player1.friends))
	rpc_handler.remove_player(id2)
	
	var unique_id = rpc_handler.get_unique_id_by_player_id("Jugador1")
	if unique_id != "":
		print("Identificador único recuperado para Jugador1: " + unique_id)



	# Generar un safe_unique_id para un jugador
	var safe_id = rpc_handler.generate_safe_unique_id("Jugador1")
	print("Safe Unique ID generado para Jugador1: " + safe_id)

	# Obtener player_id usando el safe_unique_id
	var original_id = rpc_handler.get_player_id_by_safe_id(safe_id)
	if original_id != "":
		print("Player ID original recuperado a partir del Safe Unique ID: " + original_id)
	rpc_handler.remove_player(id3)
	# Listar amigos de Juan
	rpc_handler.list_friends("Jugador1")
	rpc_handler.remove_safe_unique_id(safe_id)
