extends Node

func _ready():
	get_node("MainMenu/Margin/VBox/NovoJogo").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/Margin/VBox/Sair").pressed.connect(on_quit_pressed)

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instantiate()
	add_child(game_scene)
	
func on_quit_pressed():
	get_tree().quit()
