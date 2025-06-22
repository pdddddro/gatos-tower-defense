extends Control

@onready var tooltip = $Tooltip

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	var parent_card = get_parent()
	var current_node_name = parent_card.name if parent_card else name
	
	# Verifica se é um card slot e se tem dados de carta
	if parent_card and parent_card.has_meta("card_data"):
		var data = parent_card.get_meta("card_data")
		
		# Só mostra tooltip se houver dados da carta
		if data and "name" in data and "description" in data:
			tooltip.tooltip_content = data["description"]
			tooltip.tooltip_title = data["name"]
			tooltip.setup_content()
			
	tooltip.toggle(true)
	
func on_mouse_exited():
	tooltip.toggle(false)
