extends Control

@onready var scene_handler = get_node("/root/SceneHandler")
@onready var music_slider = $VBoxContainer/BestCat/Background/MarginContainer/Container/MusicVolume/MusicSlider  # Ajuste o caminho conforme sua estrutura
@onready var sfx_slider = $VBoxContainer/BestCat/Background/MarginContainer/Container/SFXVolume/SFXSlider      # Ajuste o caminho conforme sua estrutura

# Índices dos buses de áudio
var music_bus_index: int
var sfx_bus_index: int

func _ready():
	# Verificar se os buses existem
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	print("Total de buses: ", AudioServer.get_bus_count())
	print("Music bus index: ", music_bus_index)
	print("SFX bus index: ", sfx_bus_index)
	
	# Verificar se os sliders existem
	if not music_slider:
		print("ERRO: MusicSlider não encontrado!")
		return
	if not sfx_slider:
		print("ERRO: SFXSlider não encontrado!")
		return
	
	# Configurar sliders
	setup_sliders()
	
	# Conectar sinais dos sliders
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	
	# Conectar sinais para perder foco quando o mouse sair
	music_slider.mouse_exited.connect(music_slider.release_focus)
	sfx_slider.mouse_exited.connect(sfx_slider.release_focus)

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_main_action_pressed()  # Usa a função existente para fechar

	
func setup_sliders():
	# Configurar propriedades dos sliders
	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.1
	
	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.1
	
	# USAR VALORES DO GAMEDATA (NÃO DOS BUSES)
	music_slider.value = GameData.music_volume
	sfx_slider.value = GameData.sfx_volume
	
	print("Sliders inicializados - Música: ", music_slider.value, " SFX: ", sfx_slider.value)

func _on_music_volume_changed(value: float):
	if music_bus_index != -1:
		print("Mudando volume da música para: ", value)
		AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))
		# SALVAR NO GAMEDATA
		GameData.music_volume = value
		GameData.save_game_data()

func _on_sfx_volume_changed(value: float):
	if sfx_bus_index != -1:
		print("Mudando volume do SFX para: ", value)
		AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
		# SALVAR NO GAMEDATA
		GameData.sfx_volume = value
		GameData.save_game_data()

func _on_main_action_pressed() -> void:
	queue_free()
	get_tree().paused = false

func _on_reset_pressed() -> void:
	scene_handler.on_new_game_pressed()
	GameData.current_round = 1

func _on_menu_pressed() -> void:
	if scene_handler:
		scene_handler.return_to_main_menu()
