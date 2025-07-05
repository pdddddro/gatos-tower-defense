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
	for _slot in _ranking.get_children():
		if _slot is Label:
			continue
		if _sw_result.scores.size() > _index:
			#_slot.get_node("Position").text = str(_index + 1) + ". "
			_slot.get_node("Name").text = _sw_result.scores[_index]["player_name"]
			# Converter de volta: 1000000 - valor_salvo = tempo_real
			var real_time = 1000000 - int(_sw_result.scores[_index]["score"])
			_slot.get_node("Score").text = format_time(real_time)
			_slot.show()
		_index += 1

func _on_send_button_pressed() -> void:
	# Inverter o tempo: usar um valor alto menos o tempo real
	# Exemplo: se o tempo for 5 segundos, salvar como 999995
	var inverted_time = 1000000 - int(GameData.time_in_game)
	
	# Salvar o tempo invertido
	SilentWolf.Scores.save_score(_name.text, inverted_time)
	_score_container.hide()
	_save_progress.show()
	cat_sprite.show()
	_name.clear()
	await SilentWolf.Scores.sw_save_score_complete
	cat_sprite.hide()
	_save_progress.hide()
	load_ranking_data()

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_menu_pressed():
	if scene_handler:
		scene_handler.return_to_main_menu()
