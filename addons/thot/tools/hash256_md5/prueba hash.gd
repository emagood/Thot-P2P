#Thot p2p
extends Node
#
## Diccionario para almacenar los identificadores comunes y sus hashes únicos
#var id_dict = {}
#
## Lista de identificadores reutilizables
#var reusable_ids = []
#
## Función para generar un hash único
#func generate_unique_hash() -> String:
	#var random_value = str(randi())
	#var unix_time = str(Time.get_unix_time_from_system())
	#return random_value.md5_text() + unix_time
#
## Función para generar un hash único y su identificador común
#func generate_id() -> String:
	#var identifier = 0
	#if reusable_ids.size() > 0:
		#identifier = reusable_ids.pop_front()
	#else:
		#identifier = id_dict.size() + 1
		#if identifier > 65435:
			#push_error("Se alcanzó el límite de identificadores comunes (16 bits).")
			#return ""
#
	#var unique_hash = generate_unique_hash()
	#while unique_hash in id_dict.values():
		#unique_hash = generate_unique_hash()
#
	#id_dict[identifier] = unique_hash
	#return unique_hash
#
## Función para eliminar un ID y reutilizar su identificador común
#func delete_id(identifier: int) -> void:
	#if identifier in id_dict:
		#reusable_ids.append(identifier)
		#id_dict.erase(identifier)
	#else:
		#push_warning("El identificador no existe en el diccionario.")
#
## Función para buscar un identificador común por su hash
#func identifier_hash(unique_hash: String) -> int:
	#for identifier in id_dict.keys():
		#if id_dict[identifier] == unique_hash:
			#return identifier
	#return -1  # Retorna -1 si no se encuentra el hash
#
## Ejemplo de uso
#func _ready():
	#randomize()  # Para garantizar la aleatoriedad de los hashes
#
	## Generar hashes únicos y sus identificadores comunes
	#var hash1 = generate_id()
	#var hash2 = generate_id()
	#var hash3 = generate_id()
	#print("Hashes generados: ", hash1, ", ", hash2, ", ", hash3)
#
	## Buscar identificador por hash
	#var found_identifier = identifier_hash(hash2)
	#print("Identificador encontrado: ", found_identifier)
#
	## Eliminar un ID y reutilizar su identificador común
	#delete_id(found_identifier)
	#print("Identificador eliminado: ", found_identifier)
#
	## Generar un nuevo hash y verificar la reutilización del identificador común
	#var hash4 = generate_id()
	#print("Nuevo hash generado: ", hash4)
	#print("Diccionario de IDs: ", id_dict)
	#print("Identificadores reutilizables: ", reusable_ids)
