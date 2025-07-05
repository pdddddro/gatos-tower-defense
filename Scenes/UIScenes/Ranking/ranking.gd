extends Control

class_name Ranking

@export_category("Objects")
@export var _name: LineEdit = null
@export var _score_container: VBoxContainer = null
@export var _save_progress: Label = null
@export var _load_progress: Label = null
@export var _ranking: VBoxContainer = null
@export var _ranking_container: VBoxContainer = null
@onready var cat_sprite = $Cat

var time_in_game = format_time(GameData.time_in_game)
var is_view_only = false
var current_player_name: String = ""

func _ready() -> void:
	if is_view_only:
		_score_container.hide()
		_save_progress.hide()
		cat_sprite.hide()
		load_ranking_data()
	else:
		_score_container.show()
		cat_sprite.show()

func set_view_only_mode(view_only: bool) -> void:
	is_view_only = view_only

func load_ranking_data() -> void:
	_load_progress.show()
	
	var _sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	_load_progress.hide()
	_ranking_container.show()
	
	var _index: int = 0
	var player_found_in_top10: bool = false
	
	# Preencher os primeiros 10 slots
	for _slot in _ranking.get_children():
		if _slot is Label:
			continue
			
		# Parar no Slot11 (índice 10)
		if _index >= 10:
			break
		
		if _sw_result.scores.size() > _index:
			var player_name = _sw_result.scores[_index]["player_name"]
			
			# Verificar se o jogador atual está no top 10
			if player_name == current_player_name:
				player_found_in_top10 = true
			
			_slot.get_node("Name").text = player_name
			
			# Converter de volta: 1000000 - valor_salvo = tempo_real
			var real_time = 1000000 - int(_sw_result.scores[_index]["score"])
			_slot.get_node("Score").text = format_time(real_time)
			_slot.show()
		else:
			_slot.hide()
			
		_index += 1
	await setup_player_position_slot(player_found_in_top10)

func _on_send_button_pressed() -> void:
	# Salvar o nome do jogador atual
	current_player_name = _name.text
	
	# Inverter o tempo: usar um valor alto menos o tempo real
	# Exemplo: se o tempo for 5 segundos, salvar como 999995
	var inverted_time = 1000000 - int(GameData.time_in_game)
	
	# Salvar o tempo invertido
	SilentWolf.Scores.save_score(_name.text, inverted_time)
	
	_score_container.hide()
	_save_progress.show()
	cat_sprite.hide()
	_name.clear()
	
	await SilentWolf.Scores.sw_save_score_complete
	
	_save_progress.hide()
	load_ranking_data()

func setup_player_position_slot(player_in_top10: bool) -> void:
	var slot11 = _ranking.get_node("Slot11")
	
	if current_player_name == "":
		slot11.hide()
		return
	
	if player_in_top10:
		# Se o jogador está no top 10, mostrar sua posição atual
		var _sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
		
		for i in range(_sw_result.scores.size()):
			if _sw_result.scores[i]["player_name"] == current_player_name:
				slot11.get_node("Position").text = str(i + 1) + "."
				slot11.get_node("Name").text = current_player_name
				
				var real_time = 1000000 - int(_sw_result.scores[i]["score"])
				slot11.get_node("Score").text = format_time(real_time)
				slot11.show()
				break
	else:
		# Se não está no top 10, buscar a posição específica do jogador
		await get_player_specific_position()

func get_player_specific_position() -> void:
	var slot11 = _ranking.get_node("Slot11")
	
	# Buscar todos os scores do jogador atual
	var player_scores_result = await SilentWolf.Scores.get_scores_by_player(current_player_name, 1).sw_get_player_scores_complete
	
	if player_scores_result.scores.size() > 0:
		var player_best_score = player_scores_result.scores[0]
		
		# Buscar a posição deste score no ranking geral
		var inverted_score = int(player_best_score["score"])
		var position_result = await SilentWolf.Scores.get_score_position(inverted_score).sw_get_position_complete
		
		if position_result.has("position"):
			slot11.get_node("Position").text = str(position_result.position) + "."
			slot11.get_node("Name").text = current_player_name
			
			var real_time = 1000000 - inverted_score
			slot11.get_node("Score").text = format_time(real_time)
			slot11.show()
		else:
			slot11.hide()
	else:
		slot11.hide()

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_menu_pressed():
	if scene_handler:
		scene_handler.return_to_main_menu()

func _on_new_game_pressed() -> void:
	Analytics.add_event("Jogou Novamente")
	scene_handler.on_new_game_pressed()
