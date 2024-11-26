extends Node
class_name player


# Clase que representa un jugador
class Player:
	var player_id: String
	var ip: String
	var port: int
	var nombre: String
	var lobby: String
	var friends: Array = []

	func _init(id: String, ip: String, port: int, nombre: String = "", lobby: String = ""):
		player_id = id
		self.ip = ip
		self.port = port
		self.nombre = nombre
		self.lobby = lobby
		friends = []

	func get_friends() -> Array:
		return friends
