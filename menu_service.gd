extends Control


var network 
var ip = "127.0.0.1"
var port = 4343
@onready var conteiner = $"../PanelContainer/HBoxContainer/ScrollContainer/VBoxContainer2"
func _ready() -> void:
	network = Service.new()



func add_socket(format, dir , n_name):
	var data_exten = load("res://server_list.tscn").instantiate()
	data_exten.format = format
	data_exten.file_dir = dir
	data_exten.nname = n_name

	add_child(data_exten)
	prints("⭐️ DATOS AL NODO INSTANCIADO ⭐️" ,format , "  ", dir  , "  " , n_name)


func _on_server_pressed() -> void:
	var data_exten = load("res://server_list.tscn").instantiate()
	data_exten.ip = ip
	data_exten.port = port
	data_exten.type = $LineEdit.text
	data_exten.server = true

	conteiner.add_child(data_exten)
	prints("⭐️ DATOS AL NODO INSTANCIADO ⭐️" )
	pass # Replace with function body.


func _on_cliente_pressed() -> void:
	var data_exten = load("res://server_list.tscn").instantiate()
	data_exten.ip = ip
	data_exten.port = port
	data_exten.type = $LineEdit.text
	conteiner.add_child(data_exten)
	prints("⭐️ DATOS AL NODO INSTANCIADO ⭐️" )
	pass # Replace with function body.
