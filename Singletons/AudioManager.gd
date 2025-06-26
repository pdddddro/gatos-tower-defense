extends Node

@onready var sfx_players: Array[AudioStreamPlayer] = []
@onready var music_player: AudioStreamPlayer

var current_sfx_index = 0
var max_sfx_players = 10

func _ready():
	# Criar múltiplos players para efeitos sonoros
	for i in range(max_sfx_players):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"  # Definir bus para efeitos sonoros
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(player)
		sfx_players.append(player)

	# Criar o player de música
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"  # Definir bus para música
	music_player.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(music_player)

	call_deferred("start_background_music")

func start_background_music():
	var music_info = GameData.music_data.get("background", {})
	
	if music_info.has("path"):
		var music_path = music_info["path"]
		var volume = music_info.get("volume", 0)
		
		print("Tentando tocar música: ", music_path, " com volume: ", volume)
		
		if ResourceLoader.exists(music_path):
			music_player.stream = load(music_path)
			music_player.volume_db = volume
			music_player.play()
			print("Música de fundo iniciada com sucesso!")
		else:
			print("ERRO: Arquivo de música não encontrado: ", music_path)
	else:
		print("ERRO: Dados de música de fundo não encontrados")

# Nova função para aplicar volume específico
func set_music_volume_from_data(music_type: String):
	if GameData.music_data.has(music_type):
		var volume = GameData.music_data[music_type].get("volume", 0)
		music_player.volume_db = volume

func play_sfx(sound_path: String, volume_db: float = 0.0, pitch_variation: float = 0.2):
	if not ResourceLoader.exists(sound_path):
		print("Arquivo de som não encontrado: ", sound_path)
		return

	var player = sfx_players[current_sfx_index]
	player.stream = load(sound_path)
	player.volume_db = volume_db
	
	# Variação de pitch
	var min_pitch = 1.0 - pitch_variation
	var max_pitch = 1.0 + pitch_variation
	player.pitch_scale = randf_range(min_pitch, max_pitch)
	
	player.play()
	current_sfx_index = (current_sfx_index + 1) % max_sfx_players

# Nova função para trocar música usando GameData
func change_music(music_type: String):
	GameData.change_background_music(music_type)

func stop_music():
	music_player.stop()

func pause_music():
	music_player.stream_paused = true

func resume_music():
	music_player.stream_paused = false

func set_music_volume(volume_db: float):
	music_player.volume_db = clamp(volume_db, -80.0, 24.0)
