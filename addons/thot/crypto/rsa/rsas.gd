extends Control

const PRIVATE_KEY_FILE = "res://private_key.rsa"
const PUBLIC_KEY_FILE = "res://public_key.rsa"

var rsa = Crypto.new()
var private_key: CryptoKey
var public_key: CryptoKey
var message = "Hello, Godot!"
var decrypted_message
var encrypted_message

func _ready():



	pass
	#encrypted_message = encrypt_message(message)
	#decrypted_message = decrypt_message(encrypted_message)

# Generar claves RSA
func generate_keys():
	private_key = rsa.generate_rsa(2048)
	public_key = private_key

# Guardar claves RSA en archivos
func save_keys():
	var err = private_key.save(PRIVATE_KEY_FILE)
	if err != OK:
		print("Error saving private key: ", err)

	err = public_key.save(PUBLIC_KEY_FILE, true)
	if err != OK:
		print("Error saving public key: ", err)

# Cargar claves RSA desde archivos
func load_keys():
	private_key = CryptoKey.new()
	var err = private_key.load(PRIVATE_KEY_FILE)
	if err != OK:
		print("Error loading private key: ", err)

	public_key = CryptoKey.new()
	err = public_key.load(PUBLIC_KEY_FILE, true)
	if err != OK:
		print("Error loading public key: ", err)

# Cifrar un mensaje usando la clave pública
func encrypt_message(message: String) -> PackedByteArray:
	var message_bytes = message.to_utf8_buffer()
	var encrypted_message = rsa.encrypt(public_key, message_bytes)
	return encrypted_message

# Descifrar un mensaje usando la clave privada
func decrypt_message(encrypted_message: PackedByteArray) -> String:
	var decrypted_message = rsa.decrypt(private_key, encrypted_message)
	return decrypted_message.get_string_from_utf8()


func _on_salir_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_send_mensaje_pressed() -> void:
	encrypted_message = encrypt_message($panel_text/mensaje.text)
	decrypted_message = decrypt_message(encrypted_message)
	$panel_text/descrip.text = decrypted_message
	$big_panel_text/encript_mensaje.text = str(encrypted_message.hex_encode())
	pass # Replace with function body.


func _on_load_key_pressed() -> void:
	load_keys()
	pass # Replace with function body.


func _on_key_gen_pressed() -> void:
	generate_keys()
	pass # Replace with function body.


func _on_save_key_pressed() -> void:
	save_keys()
	pass # Replace with function body.
