extends Node


class_name  BlockRW



class BlockReaderWriter:
	var file: FileAccess
	var filename: String

	func _init(filename: String):
		self.filename = filename

	func open_file():
		if not FileAccess.file_exists(filename):
			# Crear el archivo vacío si no existe
			var temp_file = FileAccess.open(filename, FileAccess.WRITE)
			temp_file.close()

		# Abrir el archivo en modo lectura/escritura
		file = FileAccess.open(filename, FileAccess.READ_WRITE)
		if file:
			print("Archivo abierto correctamente.")
		else:
			print("Error al abrir el archivo.")

	func close_file():
		if file:
			file.close()
			print("Archivo cerrado.")

	func write_block(value, bit_size: int):
		if file == null:
			print("Error: Archivo no está abierto.")
			return

		match bit_size:
			8:
				file.store_8(value)
			16:
				file.store_16(value)
			32:
				file.store_32(value)
			64:
				file.store_64(value)
			_:
				print("Tamaño de bits no soportado.")

	func read_block(bit_size: int):
		if file == null:
			print("Error: Archivo no está abierto.")
			return null

		match bit_size:
			8:
				return file.get_8()
			16:
				return file.get_16()
			32:
				return file.get_32()
			64:
				return file.get_64()
			_:
				print("Tamaño de bits no soportado.")
				return null

	func read_string(length: int) -> String:
		if file == null:
			print("Error: Archivo no está abierto.")
			return ""
		
		var result = ""
		for i in range(length):
			var char_code = file.get_8()
			result += char(char_code)
		return result

	func write_string(text: String):
		if file == null:
			print("Error: Archivo no está abierto.")
			return
		
		for i in range(text.length()):
			file.store_8(text.unicode_at(i))

	func write_blocks(values: Array, bit_size: int):
		if file == null:
			print("Error: Archivo no está abierto.")
			return

		match bit_size:
			8:
				for value in values:
					file.store_8(value)
			16:
				for value in values:
					file.store_16(value)
			32:
				for value in values:
					file.store_32(value)
			64:
				for value in values:
					file.store_64(value)
			_:
				print("Tamaño de bits no soportado.")

	func read_blocks(count: int, bit_size: int) -> Array:
		if file == null:
			print("Error: Archivo no está abierto.")
			return []

		var values = []
		match bit_size:
			8:
				for i in range(count):
					values.append(file.get_8())
			16:
				for i in range(count):
					values.append(file.get_16())
			32:
				for i in range(count):
					values.append(file.get_32())
			64:
				for i in range(count):
					values.append(file.get_64())
			_:
				print("Tamaño de bits no soportado.")
		return values

	func write_data_with_flag(values: Array, bit_size: int):
		if file == null:
			print("Error: Archivo no está abierto.")
			return

		var flag = "*" + str(values.size()) + "*" + str(bit_size) + "?"
		write_string(flag)
		write_blocks(values, bit_size)
