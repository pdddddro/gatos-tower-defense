extends Node

func _ready():
	#load_main_menu() ## Desativei isso pra parar de dar um erro no console, mas ele nao tava afetando em nada, qualquer coisa ativa dnv
	pass

func load_main_menu():
	get_node("MainMenu/Margin/VBox/NewGame").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/Margin/VBox/About").pressed.connect(on_about_pressed)

func on_new_game_pressed():
	GameData.reset_fish_quantity()
	GameData.reset_statistics()
	
	# Remove a cena do jogo anterior se existir
	if has_node("GameScene"):
		get_node("GameScene").queue_free()
		await get_tree().process_frame
	
	# Remove o menu principal se estiver presente
	if has_node("MainMenu"):
		get_node("MainMenu").queue_free()
	
	# Remove a tela de resultado se estiver presente
	if has_node("Result"):
		get_node("Result").queue_free()
	
	# Cria a nova cena do jogo
	
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instantiate()
	game_scene.name = "GameScene"
	add_child(game_scene)
	get_tree().paused = false
	game_scene.connect("game_finished", self.unload_game)
	
	# Verifica se deve mostrar o tutorial automaticamente
	if not GameData.tutorial_completed:
		show_tutorial_overlay(game_scene, false) # false = automático
		
	Analytics.add_event("Jogos Iniciados")

func show_tutorial_overlay(game_scene, is_manual: bool = false):
	# Carrega e instancia a cena de tutorial
	var tutorial_scene = load("res://Scenes/UIScenes/Tutorial/tutorial.tscn").instantiate()
	tutorial_scene.name = "TutorialOverlay"
	
	# Adiciona como overlay na UI do jogo
	var ui_node = game_scene.get_node("UI")
	ui_node.add_child(tutorial_scene)
	
	# Define z_index alto para ficar por cima
	tutorial_scene.z_index = 1000
	
	# Passa informação se é manual para o tutorial
	if tutorial_scene.has_method("set_manual_mode"):
		tutorial_scene.set_manual_mode(is_manual)
	
	# Conecta sinais do tutorial se existirem
	if tutorial_scene.has_signal("tutorial_completed"):
		tutorial_scene.connect("tutorial_completed", _on_tutorial_completed.bind(is_manual))
	if tutorial_scene.has_signal("tutorial_skipped"):
		tutorial_scene.connect("tutorial_skipped", _on_tutorial_skipped.bind(is_manual))
		Analytics.add_event("Tutorial Pulado")
	
	print("Tutorial overlay adicionado - Manual: ", is_manual)

func _on_tutorial_completed(is_manual: bool = false):
	if not is_manual:
		GameData.mark_tutorial_completed()
	print("Tutorial finalizado - Manual: ", is_manual)

func _on_tutorial_skipped(is_manual: bool = false):
	if not is_manual:
		GameData.mark_tutorial_completed()
	print("Tutorial pulado - Manual: ", is_manual)

func show_tutorial_from_game():
	var game_scene = get_node_or_null("GameScene")
	if game_scene:
		show_tutorial_overlay(game_scene, true) # true = manual
	else:
		print("GameScene não encontrada para mostrar tutorial")

func on_about_pressed():
	var about_scene = load("res://Scenes/MainScenes/About.tscn").instantiate()
	add_child(about_scene)
	Analytics.add_event("Sobre")

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
