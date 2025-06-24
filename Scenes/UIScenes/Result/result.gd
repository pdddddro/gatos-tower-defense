extends Control
@onready var result_text_sprite = $VBoxContainer/Result
var victory_result = false

@onready var statistics_container = $VBoxContainer/Statistics
@onready var best_cat = $VBoxContainer/BestCat

func set_result(result: bool):
	victory_result = result

func _ready() -> void:
	setup_result_ui()
	statistics_container.visible = true
	best_cat.visible = false

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

var screen_step = 0

func _on_main_action_pressed() -> void:
	if screen_step == 0:
		$VBoxContainer/ActionButtons/MainAction/HBoxContainer/Label.text = "Novo Jogo"
		$VBoxContainer/ActionButtons/MainAction/HBoxContainer/PlayIcon.visible = true
		statistics_container.visible = false
		best_cat.visible = true
		
		screen_step += 1
		return
		
	if screen_step == 1:
		if scene_handler:
			scene_handler.on_new_game_pressed()
			screen_step += 1  # (opcional, se quiser evitar múltiplos cliques)
			return

## Melhor Gato
func get_best_cat():
	var best_cat = null
	var best_damage = -1
	var cats = get_tree().get_nodes_in_group("active_cats")
	
	for cat in cats:
		var cat_damage = cat.individual_stats.get("total_damage_dealt", 0)
		if cat_damage > best_damage:
			best_damage = cat_damage
			best_cat = cat
	
	if best_cat:
		return {
			"cat": best_cat,
			"damage": best_damage,
			"fish_earned": best_cat.individual_stats.get("fish_collected", 0),
			"enemies_defeated": best_cat.individual_stats.get("enemies_defeated", 0),
			"equipped_cards": best_cat.get_equipped_cards()
		}
	return null
	
	#return [best_cat, best_damage]

func get_best_cat_stats():
	var best_cat = null
	var best_damage = -1
	var cats = get_tree().get_nodes_in_group("active_cats")
	
	for cat in cats:
		if cat.total_damage_dealt > best_damage:
			best_damage = cat.total_damage_dealt
			best_cat = cat
	
	if best_cat:
		return {
			"cat": best_cat,
			"damage": best_damage,
			"fish_earned": best_cat.total_fish_earned,
			"enemies_defeated": best_cat.enemies_defeated,
			"equipped_cards": best_cat.get_equipped_cards()
		}
	return null

## Estatísticas
func update_stats_ui():
	var enemies_defeated_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/EnemiesDefeated/Number
	var total_damage_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/TotalDamage/Number
	var fishs_collected_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/FishsCollected/Number
	var time_in_game_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/TimeInGame/Number
	var money_spent_label = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/MoneySpent/Number
	var number_of_cats = $VBoxContainer/Statistics/Background/MarginContainer/HBoxContainer/Statistics/NumberOfCats/Number
	
	var total_stats = collect_all_cats_stats()
	
	enemies_defeated_label.text = format_number(total_stats.enemies_defeated)
	total_damage_label.text = format_number(total_stats.total_damage)
	fishs_collected_label.text = format_number(total_stats.fishs_collected)
	time_in_game_label.text = format_time(GameData.time_in_game)
	money_spent_label.text = format_number(GameData.money_spent)
	number_of_cats.text = format_number(GameData.number_of_cats)
	
	var best_stats = get_best_cat_stats()
	
	if best_stats:
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/CatSprite/CatName.text = best_stats.cat.type
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/TotalDamage/Number.text = format_number(best_stats.damage)
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/CatSprite/Shadow/CatSprite.texture = load(GameData.cat_data[best_stats.cat.type]["sprite"])
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/EnemiesDefeated/Number.text = format_number(best_stats.enemies_defeated)
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/FishsCollected/Number.text = format_number(best_stats.fish_earned)
		display_equipped_cards(best_stats.equipped_cards)

func collect_all_cats_stats() -> Dictionary:
	return {
		"enemies_defeated": GameData.enemies_defeated,
		"total_damage": GameData.total_damage,
		"fishs_collected": GameData.fishs_collected
	}

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]

func format_number(value: int) -> String:
	if value < 1000:
		return str(value)
	elif value < 10000:
		return "%.1fk" % (value / 1000.0)
	else:
		# Para valores >= 10000, remove a casa decimal
		return "%dk" % int(round(value / 1000.0))

func display_equipped_cards(cards_data):
	# Referências para os 4 slots de carta já existentes
	var card_slots = [
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/Cards/Card1,
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/Cards/Card2,
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/Cards/Card3,
		$VBoxContainer/BestCat/Background/MarginContainer/HBoxContainer/Cards/Card4
	]
	
	# Limpar todos os slots primeiro
	for slot in card_slots:
		clear_card_slot(slot)
	
	# Preencher com as cartas equipadas
	for i in range(min(cards_data.size(), card_slots.size())):
		var card_data = cards_data[i]
		setup_card_slot(card_slots[i], card_data)

func setup_card_slot(slot_node, card_data: Dictionary):
	var card_icon = slot_node.get_node("CardIcon")
	if card_icon:
		if ResourceLoader.exists(card_data["icon"]):
			card_icon.texture = load(card_data["icon"])
			card_icon.visible = true
		
		# Configura os meta dados para a tooltip - IGUAL NA LOJA
		slot_node.set_meta("card_data", card_data)
	else:
		print("ERRO: CardIcon não encontrado no slot")

func clear_card_slot(slot_node):
	var card_icon = slot_node.get_node("CardIcon")
	if card_icon:
		card_icon.texture = null
		card_icon.visible = false
	
	# Remove os meta dados
	if slot_node.has_meta("card_data"):
		slot_node.remove_meta("card_data")
