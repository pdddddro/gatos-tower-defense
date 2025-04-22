extends Node2D

signal game_finished(result)

var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile

var current_wave = 0
var enemies_in_wave = 0

var base_health = 100

@onready var pause_play_button = get_node("UI/HUD/MarginContainer/GameControls/PausePlay")

func _ready() -> void:
	map_node = get_node("Map1")
	get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)
	
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

##
## Wave Functions
##

func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout ## Delay entre uma wave e outra
	spawn_enemies(wave_data)
	
func retrieve_wave_data():
	# Ta com um bug que quando o slime tira vida ele nao ve como uma wave finalizada
	
	var wave_data = GameData.waves["wave" + str(current_wave)]
	#current_wave += 1 #Isso tava aqui, movi para _on_pause_play_pressed()
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		
		new_enemy.connect("base_damage", self.on_base_damage)
		new_enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
		
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
		
		print(enemies_in_wave)

func _on_enemy_defeated():
	enemies_in_wave -= 1
	
	print(enemies_in_wave)
	if enemies_in_wave <= 0:
		print("Wave finalizada!")
		
		pause_play_button.button_pressed = false

##
## Building Functions
##

func initiate_build_mode(cat_type):
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
	if build_valid:
		var new_cat = load("res://Scenes/Cats/" + build_type + ".tscn").instantiate()
		new_cat.position = build_location
		new_cat.built = true
		new_cat.type = build_type
		map_node.get_node("Cats").add_child(new_cat, true)
		#Adicionar um tile de Exclusion para impedir 2 gatos no mesmo lugar
		map_node.get_node("Exclusion").set_cell(build_tile, 5, Vector2i(0, 0))

##
## Updates Health Bar
##

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
		
	else:
		get_node("UI/HUD/MarginContainer/Status/HeartContainer/HeartLabel").text = str(base_health)

##
## Game Control Functions
##

func _on_pause_play_pressed():
	if build_mode:
		cancel_build_mode()

	# Se o botão está pressionado, vamos dar play na próxima wave
	if pause_play_button.button_pressed:
		# Só inicia wave se nenhuma estiver ativa
		if enemies_in_wave <= 0:
			current_wave += 1 #Antes isso nao tava aqui, espero que nao de nenhum bug
			print("Iniciando wave " + str(current_wave))
			start_next_wave()
		else:
			# Apenas despausa o jogo se ele estiver pausado
			get_tree().paused = false
	else:
		# Botão despressionado → Pausar o jogo
		get_tree().paused = true

func _on_speed_up_pressed() -> void:
	
	if build_mode:
		cancel_build_mode()
	
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
