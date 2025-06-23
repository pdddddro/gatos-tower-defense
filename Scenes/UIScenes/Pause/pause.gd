extends Control

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_main_action_pressed() -> void:
	queue_free()
	get_tree().paused = false


func _on_reset_pressed() -> void:
	scene_handler.on_new_game_pressed()


func _on_menu_pressed() -> void:
	if scene_handler:
		scene_handler.return_to_main_menu()
	
