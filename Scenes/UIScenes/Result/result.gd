extends Control
@onready var result_text_sprite = $VBoxContainer/Result
var victory_result = false

func set_result(result: bool):
	victory_result = result

func _ready() -> void:
	setup_result_ui()

func setup_result_ui():
	# Configure a interface baseada em vitória ou derrota
	if victory_result:
		result_text_sprite.texture = load("res://Assets/UI/Results/vitoria.png")
		print("Configurando tela de VITÓRIA")
		# Configure elementos de vitória (textos, cores, etc.)
	else:
		result_text_sprite.texture = load("res://Assets/UI/Results/derrota.png")
		print("Configurando tela de DERROTA")
		# Configure elementos de derrota

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_menu_pressed():
	if scene_handler:
		scene_handler.return_to_main_menu()

func _on_new_game_pressed() -> void:
	if scene_handler:
		scene_handler.on_new_game_pressed()
