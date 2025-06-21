extends Control
@onready var result_text_sprite = $VBoxContainer/Result
var victory_result = false

func set_result(result: bool):
	victory_result = result

func _ready() -> void:
	setup_result_ui()

func setup_result_ui():
	if victory_result:
		$VBoxContainer/Result.play("win")
	else:
		$VBoxContainer/Result.play("lose")
		
	update_stats_ui()

@onready var scene_handler = get_node("/root/SceneHandler")

func _on_menu_pressed():
	if scene_handler:
		scene_handler.return_to_main_menu()

func _on_new_game_pressed() -> void:
	if scene_handler:
		scene_handler.on_new_game_pressed()

func update_stats_ui():
	var enemies_defeated_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/EnemiesDefeated/Number
	var total_damage_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/TotalDamage/Number
	var fishs_collected_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/FishsCollected/Number
	var time_in_game_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/TimeInGame/Number
	var money_spent_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/MoneySpent/Number
	var number_of_cats = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/NumberOfCats/Number
	
	enemies_defeated_label.text = str(GameData.enemies_defeated)
	total_damage_label.text = str(GameData.total_damage)
	fishs_collected_label.text = str(GameData.fishs_collected)
	time_in_game_label.text = format_time(GameData.time_in_game)
	money_spent_label.text = str(GameData.money_spent)
	number_of_cats.text = str(GameData.number_of_cats)

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]
