extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/Margin/VBox/NovoJogo").pressed.connect(on_new_game_pressed)
	
#	get_node("MainMenu/Margin/VBox/Sair").pressed.connect(on_quit_pressed)

func on_new_game_pressed():
	GameData.reset_fish_quantity()
	
	# Remove a cena do jogo anterior se existir
	if has_node("GameScene"):
		get_node("GameScene").queue_free()
	
	# Remove o menu principal se estiver presente
	if has_node("MainMenu"):
		get_node("MainMenu").queue_free()
	
	# Remove a tela de resultado se estiver presente
	if has_node("Result"):
		get_node("Result").queue_free()
	
	# Cria a nova cena do jogo
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instantiate()
	add_child(game_scene)
	
	get_tree().paused = false
	game_scene.connect("game_finished", self.unload_game)
	
#func on_quit_pressed():
	#get_tree().quit()

## Vitória
func unload_game(result):
	# Não remova o GameScene ainda, só adicione a tela de resultado por cima
	var result_scene = load("res://Scenes/UIScenes/Result/Result.tscn").instantiate()
	result_scene.set_result(result)
	
	# Adiciona a tela de resultado como filha do GameScene ou da UI
	var game_scene = get_node("GameScene")
	var ui_node = game_scene.get_node("UI")
	ui_node.add_child(result_scene)
	
	get_tree().paused = true  # Pausa o jogo enquanto a tela de resultado está aberta

func return_to_main_menu():
	for child in get_children():
		if child.name != "MainMenu":  # Mantém o menu se já estiver presente
			child.queue_free()
	
	# Se o menu não estiver presente, carrega-o
	if !has_node("MainMenu"):
		var main_menu = load("res://Scenes/UIScenes/MainMenu.tscn").instantiate()
		add_child(main_menu)
		load_main_menu()  # Reconecta os botões
		get_tree().paused = false
