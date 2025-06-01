extends Node2D

signal game_finished(result)

# Map
var map_node

# Controls
var is_dragging = false
var drag_start_pos = Vector2.ZERO
var drag_threshold = 30 # pixels

var cat_preview = null

@onready var play_button = get_node("UI/HUD/MarginContainer/GameControls/Play")

# Build
var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile

# Wave
var current_wave = 1
var enemies_in_wave = 0
@onready var WaveCount = get_node("UI/HUD/MarginContainer/WaveContainer/WaveCount")

# Status
var base_health = 100
var fish_quantity = 100

@onready var fish_label = get_node("UI/HUD/MarginContainer/Status/FishContainer/FishLabel")

func _ready() -> void:
	
	map_node = get_node("Map1")
	get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)
	
	WaveCount.text = str(current_wave) + "/50"
	
	#GameData.next_round()
	
	update_fish_label()
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(Callable(self, "initiate_build_mode").bind(i.get_name()))
			
func _process(delta):

	if build_mode:
		update_cat_preview()
	
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
		
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func update_build_buttons():
	for button in get_tree().get_nodes_in_group("build_buttons"):
		var cat_type = button.get_name()
		var cat_cost = GameData.cat_data[cat_type]["cost"]
		
		button.disabled = fish_quantity < cat_cost
		
		if button.disabled:
			button.modulate = Color("d0ab89")

		else:
			button.modulate = Color("FFFFFF")
		
## Wave Functions
func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout ## Delay entre uma wave e outra
	spawn_enemies(wave_data)
	
func retrieve_wave_data():
	#current_wave += 1 #Isso tava aqui, movi para _on_pause_play_pressed()
	var wave_data = GameData.waves["wave" + str(current_wave)]
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + "/" + i[0] + ".tscn").instantiate()
		
		new_enemy.type = i[0]

		new_enemy.connect("base_damage", self.on_base_damage)
		
		new_enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
		new_enemy.connect("enemy_escaped", Callable(self, "_on_enemy_escaped"))
		
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout

func _on_enemy_defeated(slime_type):
	var fish_reward = GameData.enemies_data[slime_type]["fish_reward"]
	fish_quantity += fish_reward
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
		WaveCount.text = str(current_wave) + "/50"
		
		GameData.current_round = current_wave
		GameData.update_rarity_chances()
		
		play_button.texture_normal = play
		
		if fast_mode:
			fast_mode = false
		else:
			fast_mode = true

## Building Functions
func initiate_build_mode(cat_type):
	print("Building Mode Iniciado")
	if build_mode:
		cancel_build_mode()
		
	build_type = cat_type
	build_mode = true
	get_node("UI").set_cat_preview(build_type, get_global_mouse_position())

func update_cat_preview():
	var mouse_position = get_global_mouse_position()
	var exclusion_layer = map_node.get_node("Exclusion")
	var current_tile = exclusion_layer.local_to_map(mouse_position)
	var tile_position = exclusion_layer.map_to_local(current_tile)
	
	if exclusion_layer.get_cell_source_id(current_tile) == -1:
		get_node("UI").update_cat_preview(tile_position, "00bcf4dd")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile

	else:
		get_node("UI").update_cat_preview(tile_position, "ff826fdd")
		build_valid = false
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	
	get_node("UI/CatPreview").free()
	
func verify_and_build():
	print("Antes de verificar")
	if build_valid:
		print("Berificou")
		var cat_cost = GameData.cat_data[build_type]["cost"]
		if fish_quantity >= cat_cost:
			fish_quantity -= cat_cost
			update_fish_label()
			
			var new_cat = load("res://Scenes/Cats/" + build_type + "/" + build_type + ".tscn").instantiate()
			new_cat.position = build_location
			new_cat.built = true
			new_cat.type = build_type
			map_node.get_node("Cats").add_child(new_cat, true)
			
			#Adicionar um tile de Exclusion para impedir 2 gatos no mesmo lugar
			map_node.get_node("Exclusion").set_cell(build_tile, 5, Vector2i(0, 0))
			
## Updates Health Bar
func on_base_damage(damage):
	base_health -= damage
	
	if base_health <= 0:
		emit_signal("game_finished", false)
		
	else:
		get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)

## Fish Control
func update_fish_label():
	fish_label.text = str(fish_quantity)
	update_build_buttons()

## Game Control Functions

@onready var speed_up = preload("res://Assets/Icons/SpeedUp.png")
@onready var normal_speed = preload("res://Assets/Icons/NormalSpeed.png")
@onready var play = preload("res://Assets/Icons/Play.png")

var fast_mode = true

func _on_play_pressed() -> void:
	if build_mode:
		cancel_build_mode()

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
	
