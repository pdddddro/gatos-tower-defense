extends Control

func _ready() -> void:
	get_parent().load_main_menu()

func _on_logo_mouse_entered() -> void:
	pass # Replace with function body.

func _on_reset_pressed() -> void:
	# Reseta todos os dados do jogo
	GameData.reset_all_game_data()
	print("Dados do jogo resetados!")

func _on_feedback_pressed() -> void:
	Analytics.add_event("Feedback Clicado")
