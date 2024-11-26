extends Node
class_name aes_tool

var aes = AESContext.new()

#region : test
'''retorna si es un multiplo de 16'''
#endregion


func is_multiple_of_16(length: int) -> bool:
	return length % 16 == 0

#region
''' retorna siempre un multiplo de 16 al string'''
#endregion


func string_to_multiple_of_16(input_string: String) -> String:
	var length := input_string.length()
	if is_multiple_of_16(length):
		return input_string
	
	var characters := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var random := RandomNumberGenerator.new()
	random.randomize()
	
	while !is_multiple_of_16(length):
		input_string += characters[random.randi_range(0, characters.length() - 1)]
		length = input_string.length()
	
	return input_string



#region
''' cortamos un string para un largo expeifico'''
#endregion


func string_to_length(input_string: String, max_length: int) -> String:
	if input_string.length() > max_length:
		return input_string.substr(0, max_length)
	return input_string


#region
'''hacemos el encriptado y retorna u packetbytearray'''
#endregion



func encrypt_aes_ecb(key: String, text: String) -> PackedByteArray:
	''' relleno del string '''
	var texto = string_to_multiple_of_16(text)
	
	aes.start(AESContext.MODE_ECB_ENCRYPT, key.to_utf8_buffer()) #AES en modo ECB (Electronic Codebook)
	var encrypted = aes.update(texto.to_utf8_buffer())
	#prints(encrypted , "  encripted data ecb")
	aes.finish()
	
	
	return encrypted
	pass

#region
''' desenripta el paquetbytearray y devuelve un packetbytearray'''
#endregion


func decrypt_aes_ecb(key: String, encrypted: PackedByteArray) -> PackedByteArray:
	aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8_buffer())
	var decrypted = aes.update(encrypted)
	#prints(decrypted.get_string_from_utf8() , "   decripted data ecb")
	aes.finish()

	return decrypted

func string_to_aes_ecb(key: String, encrypted: PackedByteArray , length: int) -> String:
	aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8_buffer())
	var decrypted = aes.update(encrypted)
	var texto: String = string_to_length(decrypted.get_string_from_utf8() ,length)
	#texto = string_to_length(decrypted.get_string_from_utf8() ,length)
	aes.finish()

	return texto


#
#func _ready() -> void:
	#var original_string := "Hola, soy una cadena de prueba"
	#var padded_string := string_to_multiple_of_16(original_string)
	#print("Cadena original: ", original_string)
	#print("Cadena origina tamañol: ", original_string.length())
	#print("Cadena rellenada: ", padded_string)
	#print("Longitud de la cadena rellenada: ", padded_string.length())
	#
	#
	#
	#original_string = "Este es un ejemplo de una cadena larga que necesita ser recortada."
	#var max_length := 16
	#var trimmed_string := string_to_length(original_string, max_length)
	#
	#print("Cadena original: ", original_string)
	#print("Cadena recortada: ", trimmed_string)
	#print("Longitud de la cadena recortada: ", trimmed_string.length())
