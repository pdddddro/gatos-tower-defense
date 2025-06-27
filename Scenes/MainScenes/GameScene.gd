extends Node2D

signal game_finished(result)

# Map
var map_node

var cat_preview = null

@onready var play_button = get_node("UI/HUD/MarginContainer/GameControls/Play")

# Build
var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile

## Building Functions
var drag_mode = false
var drag_start_pos = Vector2.ZERO
var drag_threshold = 20  # pixels para considerar arrasto

## Card Drag and Drop
var card_drag_mode = false
var card_drag_valid = false
var card_drag_location
var card_drag_type
var card_preview = null
var dragged_card = null

# Wave
var current_wave = 1
var enemies_in_wave = 0
@onready var WaveCount = get_node("UI/HUD/MarginContainer/WaveContainer/WaveCount")

# Status
var base_health = GameData.default_health_quantity

@onready var fish_label = get_node("UI/HUD/MarginContainer/Status/FishContainer/FishLabel")

@onready var shop = get_node("UI/HUD/MarginContainer/Control/Control")

func _ready() -> void:
	add_to_group("game_scene")
	map_node = get_node("Map1")
	get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)
	
	WaveCount.text = str(current_wave) + "/" + str(GameData.totalWaveNumber)
	
	#GameData.next_round()
	GameData.fish_quantity_updated.connect(_on_fish_quantity_updated)
	update_fish_label()
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(Callable(self, "initiate_build_mode").bind(i.get_name()))
	
	connect_card_signals()
	
	get_node("UI/HUD/MarginContainer/WaveContainer/Navegation/Back").pressed.connect(_on_back_pressed)
	get_node("UI/HUD/MarginContainer/WaveContainer/Navegation/Next").pressed.connect(_on_next_pressed)

func _process(delta):
	if build_mode:
		update_cat_preview()
	
	if card_drag_mode:
		update_card_preview()
	GameData.time_in_game += delta
	
	update_build_buttons()

func connect_card_signals():
	# Esta função deve ser chamada quando novas cartas são adicionadas ao inventário
	for card in get_tree().get_nodes_in_group("inventory_cards"):
		if not card.card_drag_started.is_connected(_on_card_drag_started):
			card.card_drag_started.connect(_on_card_drag_started)
			card.card_dropped.connect(_on_card_dropped)

func _on_card_drag_started(card_node):
	print("Drag iniciado para carta: ", card_node.get_node("MarginContainer/VBoxContainer/CardName").text)
	
	if card_drag_mode:
		cancel_card_drag_mode()
	
	dragged_card = card_node
	card_drag_mode = true
	card_drag_type = card_node.get_meta("card_data")
	
	# Cria preview da carta usando o ícone
	create_card_preview()
	
	if shop:
		shop._on_close_pressed()

func create_card_preview():
	if card_preview:
		card_preview.queue_free()
	
	card_preview = TextureRect.new()
	card_preview.texture = load(card_drag_type.icon)
	card_preview.size = Vector2(32, 32)  # Tamanho do preview
	card_preview.modulate = Color(1, 1, 1, .9)  # Semi-transparente
	
	get_node("UI").add_child(card_preview)
	card_preview.z_index = 100

func update_card_preview():
	if not card_preview:
		return
		
	var mouse_position = get_global_mouse_position()
	card_preview.global_position = mouse_position - card_preview.size / 2
	
	# Verifica se pode aplicar a carta em um gato
	var target_cat = get_cat_at_position(mouse_position)
	
	if target_cat and can_apply_card_to_cat(target_cat) and target_cat.can_equip_card():
		card_preview.modulate = Color(0, 1, 0, 1)
		card_drag_valid = true
		card_drag_location = target_cat
	else:
		card_preview.modulate = Color(1, 0, 0, 1)
		card_drag_valid = false
		card_drag_location = null

func get_cat_at_position(position: Vector2):
	var space_state = get_world_2d().direct_space_state
	if not space_state:
		return null
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collision_mask = 1
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var result = space_state.intersect_point(query)
	
	for collision in result:
		var collider = collision.collider
		
		if collider.name == "ClickableArea":
			var parent = collider.get_parent()
			if parent.has_method("apply_card_effect"):
				print("Gato encontrado para aplicar carta: ", parent.type if "type" in parent else "gato")
				return parent
	
	return null

func can_apply_card_to_cat(cat_node) -> bool:
	return cat_node != null and cat_node.built

func apply_card_to_cat(card_node, target_cat):
	var card_data = card_node.get_meta("card_data")
	
	var success = target_cat.equip_card(card_data)
	card_node.queue_free()
	GameData.card_collection.erase(card_data)
	print("Carta removida do inventário")
		
func cancel_card_drag_mode():
	card_drag_mode = false
	card_drag_valid = false
	dragged_card = null
	
	if card_preview:
		card_preview.queue_free()
		card_preview = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Verifica clique nos botões de construção
				for button in get_tree().get_nodes_in_group("build_buttons"):
					if button.get_global_rect().has_point(event.global_position):
						initiate_build_mode(button.get_name())
						drag_start_pos = event.position
						drag_mode = false  # Resetar estado de arrasto
						break
			else:
				if drag_mode:  # Só constrói se houve arrasto
					verify_and_build()

				if build_mode:
					cancel_build_mode()

	elif event is InputEventMouseMotion and build_mode:
		# Atualiza preview durante arrasto
		update_cat_preview()
		
		# Ativa modo drag se mover além do threshold
		if event.position.distance_to(drag_start_pos) > drag_threshold:
			drag_mode = true

	elif event is InputEventMouseMotion and build_mode:
		# Atualiza preview durante arrasto/clique
		update_cat_preview()
		
		# Ativa modo drag se mover além do threshold
		if event.position.distance_to(drag_start_pos) > drag_threshold:
			drag_mode = true
	
	# Cancela drag de carta com clique direito
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if card_drag_mode:
			cancel_card_drag_mode()

var cat_cost

func update_build_buttons():
	for button in get_tree().get_nodes_in_group("build_buttons"):
		var cat_type = button.get_name()
		cat_cost = GameData.cat_data[cat_type]["cost"]
		
		button.disabled = GameData.fish_quantity < cat_cost
		
		if button.disabled:
			button.modulate = Color("d0ab89")

		else:
			button.modulate = Color("FFFFFF")

func initiate_build_mode(cat_type):
	# Função original mantida
	print("Building Mode Iniciado")
	if build_mode:
		cancel_build_mode()
		
	build_type = cat_type
	build_mode = true
	get_node("UI").set_cat_preview(build_type, get_global_mouse_position())
	
	if shop:
		shop._on_close_pressed()

func update_cat_preview():
	# Função original mantida com adição de drag
	var mouse_position = get_global_mouse_position()
	var exclusion_layer = map_node.get_node("Exclusion")
	var current_tile = exclusion_layer.local_to_map(mouse_position)
	var tile_position = exclusion_layer.map_to_local(current_tile)
	
	var current_cat_cost = GameData.cat_data[build_type]["cost"]
	
	if exclusion_layer.get_cell_source_id(current_tile) == -1 and GameData.fish_quantity >= current_cat_cost:
		get_node("UI").update_cat_preview(tile_position, "00bcf4dd")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
		
	else:
		get_node("UI").update_cat_preview(tile_position, "ff826fdd")
		build_valid = false

	# Atualiza posição do preview durante arrasto
	if drag_mode:
		get_node("UI/CatPreview").global_position = tile_position

func cancel_build_mode():
	# Função original mantida
	build_mode = false
	drag_mode = false
	build_valid = false
	if get_node("UI/CatPreview"):
		get_node("UI/CatPreview").free()

func verify_and_build():
	# Função original mantida
	if build_valid:
		var cat_cost = GameData.cat_data[build_type]["cost"]
		if GameData.fish_quantity >= cat_cost:
			GameData.update_fish_quantity(-cat_cost)
			
			var new_cat = load("res://Scenes/Cats/" + build_type + "/" + build_type + ".tscn").instantiate()
			new_cat.position = build_location
			new_cat.built = true
			new_cat.type = build_type
			map_node.get_node("Cats").add_child(new_cat)
			map_node.get_node("Exclusion").set_cell(build_tile, 5, Vector2i(0, 0))
			
			GameData.play_sound("cats", build_type, "place")
			
			GameData.money_spent += cat_cost
			GameData.number_of_cats += 1
		
		cancel_build_mode()
		
## Wave Functions e TextBox
@onready var textbox_scene = preload("res://Scenes/UIScenes/TextBox/text_box.tscn")
var current_textbox = null

func start_next_wave():
	var wave_data = retrieve_wave_data()
	
	# Verifica se deve mostrar textbox
	if GameData.should_show_textbox(current_wave):
		var text_data = GameData.get_textbox_data(current_wave)
		
		if not text_data.is_empty():
			show_wave_textbox(text_data)
			return # Não inicia a wave ainda
	
	# Se não tem textbox, inicia a wave normalmente
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)

func show_wave_textbox(text_data: Dictionary):
	# Remove textbox anterior se existir
	if current_textbox:
		current_textbox.queue_free()
	
	# Instancia nova textbox
	current_textbox = textbox_scene.instantiate()
	get_node("UI").add_child(current_textbox)
	
	# Conecta os sinais
	current_textbox.textbox_opened.connect(_on_textbox_opened)
	current_textbox.textbox_closed.connect(_on_textbox_closed)
	
	# Mostra a textbox com os dados
	current_textbox.show_textbox(text_data)

func _on_textbox_closed():
	current_textbox = null
	
	# Agora inicia a wave após fechar o textbox
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)

func _on_textbox_opened():
	if shop:
		shop._on_close_pressed()

func retrieve_wave_data():
	var wave_key = "wave" + str(current_wave)
	var wave_data = GameData.waves.get(wave_key, {
		"enemies": [["Metal", 1]], ## Se nao tiver wave, ele bota isso pra substitutir
	})
	
	enemies_in_wave = wave_data["enemies"].size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data["enemies"]:
		
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + "/" + i[0] + ".tscn").instantiate()
		
		new_enemy.type = i[0]

		new_enemy.connect("base_damage", self.on_base_damage)
		
		new_enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
		new_enemy.connect("enemy_escaped", Callable(self, "_on_enemy_escaped"))
		
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout

func _on_enemy_defeated(slime_type):
	var fish_reward = GameData.enemies_data[slime_type]["fish_reward"]
	GameData.update_fish_quantity(fish_reward)
	#GameData.fishs_collected += fish_reward
	
	update_fish_label()
	
	enemies_in_wave -= 1
	check_wave_end()

func _on_enemy_escaped(type):
	enemies_in_wave -= 1
	check_wave_end()

func check_wave_end():
	if enemies_in_wave <= 0:
		print("Wave finalizada!")
		current_wave += 1
		WaveCount.text = str(current_wave) + "/" + str(GameData.totalWaveNumber)
		
		## Vitória
		if current_wave > GameData.totalWaveNumber and base_health > 0:
			await get_tree().create_timer(1.0).timeout
			GameData.mark_victory()
			emit_signal("game_finished", true)
			return
		
		GameData.current_round = current_wave
		GameData.update_rarity_chances()
		
		play_button.texture_normal = play
		
		if fast_mode:
			fast_mode = false
		else:
			fast_mode = true

## Updates Health Bar
func on_base_damage(damage):
	base_health -= damage
	
	get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)
	
	## Derrota
	if base_health <= 0:
		await get_tree().create_timer(1.0).timeout
		emit_signal("game_finished", false)
		

## Fish Control
func update_fish_label():
	fish_label.text = str(GameData.fish_quantity)
	update_build_buttons()
	
func _on_fish_quantity_updated(new_amount: int):
	fish_label.text = str(new_amount)
	update_build_buttons()

## Game Control Functions

@onready var speed_up = preload("res://Assets/Icons/SpeedUp.png")
@onready var normal_speed = preload("res://Assets/Icons/NormalSpeed.png")
@onready var play = preload("res://Assets/Icons/Play.png")

var fast_mode = true

func _on_play_pressed() -> void:
	if build_mode:
		cancel_build_mode()

	if current_textbox:
		return
		
	# Inicia a wave se nenhuma estiver ativa
	if enemies_in_wave <= 0:
		print("Iniciando wave " + str(current_wave))
		start_next_wave()

# Alterna velocidade e textura
	if fast_mode:
		Engine.set_time_scale(1.0)
		play_button.texture_normal = normal_speed
		fast_mode = false
		
	else:
		Engine.set_time_scale(2.0)
		play_button.texture_normal = speed_up
		fast_mode = true

@onready var CatShopScene = preload("res://Scenes/UIScenes/Shop.tscn")

var cat_shop_instance: Control = null

func _on_cat_shop_pressed() -> void:
	if not cat_shop_instance:
		cat_shop_instance = CatShopScene.instantiate()
		$UI/HUD/MarginContainer.add_child(cat_shop_instance)
		cat_shop_instance.visible = true
		
func _on_card_dropped(card_node, target_position):
	if card_drag_valid and card_drag_location:
		# Verifica se o gato pode receber mais cartas
		if card_drag_location.has_method("can_equip_card") and card_drag_location.can_equip_card():
			apply_card_to_cat(card_node, card_drag_location)
		else:
			print("Este gato já tem o máximo de cartas equipadas!")
			show_max_cards_message()
	
	cancel_card_drag_mode()
			
func show_max_cards_message():
	# Implementar uma mensagem visual para o jogador
	print("Máximo de 4 cartas por gato!")

## Pause Menu
func _on_pause_pressed() -> void:
	var pause_scene = preload("res://Scenes/UIScenes/Pause/pause.tscn")
	var pause_instance = pause_scene.instantiate()
	var ui_node = get_node("UI")
	ui_node.add_child(pause_instance)
	
	pause_instance.z_index = 1000
	get_tree().paused = true

func show_tutorial_help():
	var scene_handler = get_node("/root/SceneHandler")
	if scene_handler:
		scene_handler.show_tutorial_from_game()
	else:
		print("SceneHandler não encontrado")

## Wave Control

func _on_back_pressed() -> void:
	if current_wave > 1:
		navigate_to_wave(current_wave - 1)

func _on_next_pressed() -> void:
	if current_wave < GameData.totalWaveNumber: 
		navigate_to_wave(current_wave + 1)

func navigate_to_wave(target_wave: int):
	# Limpar inimigos atuais
	clear_current_enemies()
	
	# Parar qualquer textbox ativa
	if current_textbox:
		current_textbox.queue_free()
		current_textbox = null
	
	# Atualizar wave atual
	current_wave = target_wave
	enemies_in_wave = 0
	
	# Atualizar UI
	WaveCount.text = str(current_wave) + "/" + str(GameData.totalWaveNumber)
	GameData.current_round = current_wave
	GameData.update_rarity_chances()
	
	# Resetar botão de play
	Engine.set_time_scale(1.0)
	play_button.texture_normal = play
	fast_mode = true
	
	print("Navegado para wave ", current_wave)

func clear_current_enemies():
	# Remove todos os inimigos ativos
	var path_node = map_node.get_node("Path")
	for child in path_node.get_children():
		if child.has_method("queue_free"):
			child.queue_free()
	
	# Reseta contador de inimigos
	enemies_in_wave = 0
	
	print("Inimigos da wave atual removidos")


func _on_question_mark_pressed() -> void:
	var tutorial_scene = preload("res://Scenes/UIScenes/Tutorial/tutorial.tscn")
	var tutorial_instance = tutorial_scene.instantiate()
	var ui_node = get_node("UI")
	ui_node.add_child(tutorial_instance)
	
	tutorial_instance.z_index = 1000
	get_tree().paused = true
