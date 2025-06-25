extends Node

@onready var sfx_players: Array[AudioStreamPlayer] = []
@onready var music_player: AudioStreamPlayer
var current_sfx_index = 0
var max_sfx_players = 10

func _ready():
	# Criar múltiplos players para efeitos sonoros simultâneos
	for i in range(max_sfx_players):
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players.append(player)
	
	# Criar o player de música
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# IMPORTANTE: Iniciar música automaticamente quando o jogo abrir
	call_deferred("start_background_music")

func start_background_music():
	# Puxar música do GameData
	var background_music_path = GameData.sound_data["music"]["background"]
	play_background_music(background_music_path)

func play_background_music(music_path: String, volume_db: float = -15.0):
	if not ResourceLoader.exists(music_path):
		print("Arquivo de música não encontrado: ", music_path)
		return
	
	music_player.stream = load(music_path)
	music_player.volume_db = volume_db
	
	# Configurar para loop infinito
	if music_player.stream is AudioStreamOggVorbis:
		music_player.stream.loop = true
	
	music_player.play()
	print("Música de fundo iniciada: ", music_path)

func play_sfx(sound_path: String, volume_db: float = 0.0):
	if not ResourceLoader.exists(sound_path):
		print("Arquivo de som não encontrado: ", sound_path)
		return
	
	var player = sfx_players[current_sfx_index]
	player.stream = load(sound_path)
	player.volume_db = volume_db
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
