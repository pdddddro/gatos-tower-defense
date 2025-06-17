extends Control

var victory_result = false

func set_result(result: bool):
	victory_result = result

func _ready() -> void:
	setup_result_ui()

func setup_result_ui():
	# Configure a interface baseada em vitória ou derrota
	if victory_result:
		print("Configurando tela de VITÓRIA")
		# Configure elementos de vitória (textos, cores, etc.)
	else:
		print("Configurando tela de DERROTA")
		# Configure elementos de derrota

func _on_menu_pressed():
	queue_free()  # Remove a tela de resultado
	# Carrega o menu principal
	var main_menu = load("res://Scenes/UIScenes/MainMenu.tscn").instantiate()
	get_parent().add_child(main_menu)
	
	# Reconecta os botões do menu
	get_parent().load_main_menu()
