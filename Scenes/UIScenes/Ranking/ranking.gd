extends Control
class_name Ranking

@export_category("Objects")
@export var _name: LineEdit = null
@export var _score: LineEdit = null
@export var _score_container: VBoxContainer = null

@export var _save_progress: Label = null
@export var _load_progress: Label = null

@export var _ranking: VBoxContainer = null
@export var _ranking_container: VBoxContainer = null

func _on_send_button_pressed() -> void:
	SilentWolf.Scores.save_score(_name.text, int(_score.text))
	_score_container.hide()
	_save_progress.show()
	_score.clear()
	_name.clear()
	
	await SilentWolf.Scores.sw_save_score_complete
	
	_score_container.show()
	_save_progress.hide()
	
	## Puxar infos pro ranking
	_score_container.hide()
	_load_progress.show()
	
	var _sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	print("Scores: " + str(_sw_result.scores))
	
	_load_progress.hide()
	_ranking_container.show()
	
	var _index: int = 0
	
	for _slot in _ranking.get_children():
		if _slot is Label:
			continue
	
	for _slot in _ranking.get_children():
		if _slot is Label:
			continue
		
		if _sw_result.scores.size() > _index:
			_slot.get_node("Position").text = str(_index + 1) + ". " 
			_slot.get_node("Score").text = str(_sw_result.scores[_index]["score"])
			_slot.get_node("Name").text = _sw_result.scores[_index]["player_name"]
			_slot.show()
			
		_index += 1
