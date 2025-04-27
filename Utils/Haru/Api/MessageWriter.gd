extends RefCounted

class_name HaruMessageWriter

var MessageID : int
var MessageData : PackedByteArray

func _init() -> void:
	MessageID = -1

func Serialize() -> PackedByteArray:
	var serializedPacket = ("%s.%s" % [MessageID, MessageData]).to_utf8_buffer()
	return serializedPacket

func Deserialize(data : PackedByteArray) -> void:
	var bytesToString := data.get_string_from_utf8() as String
	var splitedSerial := bytesToString.split(".", true, 1)
	
	if splitedSerial.size() == 2:
		MessageID = int(splitedSerial[0])
		MessageData = str_to_var(splitedSerial[1])
