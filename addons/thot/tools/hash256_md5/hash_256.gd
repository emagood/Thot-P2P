## Thot p2p TEST
extends Node
#
## Función para generar un hash SHA-256
#func generate_sha256(input: String) -> String:
	#var ctx = HashingContext.new()
	#ctx.start(HashingContext.HASH_SHA256)
	#ctx.update(input.to_utf8_buffer())
	#var result = ctx.finish()
	#return result.hex_encode()
#
## Ejemplo de uso
#func _ready():
	#var input = "Hola, Godot!"
	#var hash = generate_sha256(input)
	#print("Hash SHA-256: ", hash)
