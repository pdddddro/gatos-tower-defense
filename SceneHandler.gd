extends Node

func _ready():
	pass
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/Margin/VBox/NovoJogo").pressed.connect(on_new_game_pressed)
#	get_node("MainMenu/Margin/VBox/Sair").pressed.connect(on_quit_pressed)

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instantiate()
	game_scene.connect("game_finished", self.unload_game)
	add_child(game_scene)
	
#func on_quit_pressed():
	#get_tree().quit()

## Vitória
func unload_game(result):
	get_node("GameScene").queue_free()
	var result_scene = load("res://Scenes/UIScenes/Result/Result.tscn").instantiate()
	result_scene.set_result(result)
	add_child(result_scene)
