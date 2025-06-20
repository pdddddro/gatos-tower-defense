extends Control
@onready var result_text_sprite = $VBoxContainer/Result
var victory_result = false

func set_result(result: bool):
	victory_result = result

func _ready() -> void:
	setup_result_ui()

func setup_result_ui():
	if victory_result:
		$VBoxContainer/Result.play("win")
	else: ## mudar annimaçãop 2d
		$VBoxContainer/Result.play("lose")

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_menu_pressed():
	if scene_handler:
		scene_handler.return_to_main_menu()

func _on_new_game_pressed() -> void:
	if scene_handler:
		scene_handler.on_new_game_pressed()
