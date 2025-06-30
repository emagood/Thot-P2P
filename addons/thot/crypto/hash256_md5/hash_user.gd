extends Node

var file_path = "res://registro_hash.txt"

func read_entries():
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error al abrir el archivo")
		return []
	
	var entries = []
	while not file.eof_reached():
		var data = file.get_buffer(48)
		if data.is_empty():
			continue
		entries.append(data)
	
	file.close()
	return entries

func write_entry(user_data: String, user_hash: String):
	#prints(user_data, user_hash)
	if user_data.length() != 16 or user_hash.length() != 32:
		prints("Datos inválidos", user_data.length(), "  ", user_hash.length())
		return

	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	
	# Verificar si hay un espacio vacío sin leer todo el archivo
	var position = -1
	var index = 0
	
	while not file.eof_reached():
		var data = file.get_buffer(48)
		if data.get_string_from_utf8().strip_edges().is_empty():
			position = index * 48
			break
		index += 1

	if position >= 0:
		file.seek(position)
	else:
		file.seek_end()

	file.store_string(user_data + user_hash)
	file.close()


func delete_entry(user_data: String, user_hash: String):
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	
	var index = 0
	while not file.eof_reached():
		var data = file.get_buffer(48)
		var entry = data.get_string_from_utf8()  # Convertir a String
		
		if entry.substr(0, 16) == user_data and entry.substr(16, 32) == user_hash:
			file.seek(index * 48)
			file.store_string(" ".repeat(48))  # Vaciar espacio con 48 espacios en blanco
			file.close()
			return
		
		index += 1

	print("Registro no encontrado")




func _ready():

	
	# Verificar si el archivo existe, si no, crearlo
	if not FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		file.close()  # Cierra inmediatamente para asegurarse de que se crea correctamente

	var user1 = "Usuario123456780"  # 16 bytes
	var hash1 = "HashCorrespondienteParaUsu".md5_text()  # 32 bytes
	
	var user2 = "UsuarioABCDEF123"
	var hash2 = "HashCorrespondienteParaUsuarF12".md5_text()

	print(">>> Agregando registros")
	write_entry(user1, hash1)
	write_entry(user2, hash2)

	print(">>> Leyendo registros iniciales")
	var entries = read_entries()
	for entry in entries:
		print("Registro:", entry)

	print(">>> Eliminando un registro")
	delete_entry(user1, hash1)
	prints("este hash es eliminado " , hash1 , " longitud : ", hash1.length())

	print(">>> Leyendo registros después de la eliminación")
	entries = read_entries()
	for entry in entries:
		print("Registro:", entry)
