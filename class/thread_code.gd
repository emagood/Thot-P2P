extends Node
class_name class_thread

var data_thread = {
	"hola": "emanuel",
	"genio": "servidor"
}

var thread: Thread
var thread2: Thread
var timer_local = 0
var timer_local2 = 0

func _ready():
	thread = Thread.new()
	thread2 = Thread.new()
	timer_local = Time.get_ticks_msec()
	timer_local2 = timer_local
	prints("Tiempo inicial: " + str(Time.get_ticks_msec()))

	# Iniciar threads con datos vinculados
	if not thread.is_alive():
		thread.start(_thread_function.bind(data_thread))
	if not thread2.is_alive():
		thread2.start(_thread_function.bind(data_thread))

# Función que ejecutará cada thread
func _thread_function(userdata):
	var a = 1000
	while a:
		prints("abuelo")
		if userdata.has("hola"):
			prints("ema")
		a -= 1

	prints("Soy un thread! Los datos de usuario son: ", userdata)
	timer_local = Time.get_ticks_msec()
	prints("El tiempo pasó: " + str(timer_local - timer_local2) + " ms")

func _exit_tree():
	prints("Esperando a que los threads terminen")
	thread.wait_to_finish()
	thread2.wait_to_finish()
	prints("Threads terminados")

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_W):
		if not thread.is_alive():
			thread.wait_to_finish()
			thread = Thread.new()
			thread.start(_thread_function.bind({"mensaje": "soy-yo"}))

		if not thread2.is_alive():
			thread2.wait_to_finish()
			thread2 = Thread.new()
			thread2.start(_thread_function.bind({"mensaje": "momo"}))
