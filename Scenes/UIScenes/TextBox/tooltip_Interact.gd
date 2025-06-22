extends Control

@onready var tooltip = $Tooltip

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	var parent_card = get_parent()
	var current_node_name = name
	
	if parent_card and parent_card.has_meta("card_data") or (current_node_name in ["Card1", "Card2", "Card3", "Card4"]):
		var data = parent_card.get_meta("card_data")
		
		tooltip.tooltip_content = data["description"]
		tooltip.tooltip_title = data["name"]
		var rarity_type = GameData.get_card_rarity_type(data["name"])
		
		tooltip.tooltip_rarity_texture = GameData.get_rarity_texture_path(rarity_type)
		
		tooltip.setup_content()
	tooltip.toggle(true)
	
func on_mouse_exited():
	tooltip.toggle(false)
