extends Control

@onready var cat_name = $Container/CatContainer/Background/MarginContainer/HBoxContainer/HBoxContainer/CatSprite/CatName
@onready var description = $Container/CatContainer/Background/MarginContainer/HBoxContainer/HBoxContainer/CatSprite/Description
@onready var attack_damage = $Container/CatContainer/Background/MarginContainer/HBoxContainer/CatStats/AttackDamage/Number
@onready var attack_speed = $Container/CatContainer/Background/MarginContainer/HBoxContainer/CatStats/AttackSpeed/Number
@onready var range = $Container/CatContainer/Background/MarginContainer/HBoxContainer/CatStats/Range/Number
@onready var critical_chance = $Container/CatContainer/Background/MarginContainer/HBoxContainer/CatStats/CriticalChance/Number
@onready var sprite = $Container/CatContainer/Background/MarginContainer/HBoxContainer/HBoxContainer/Shadow/CatSprite

var can_attack_texture = preload("res://Assets/Icons/V-ICON.png")
var cannot_attack_texture = preload("res://Assets/Icons/X-ICON.png")

func setup_cat_details(cat_type):
	cat_name.text = GameData.cat_data[cat_type]["name"]
	description.text = GameData.cat_data[cat_type]["description"]
	attack_damage.text = format_number_k(GameData.cat_data[cat_type]["damage"])
	range.text = format_number_k(GameData.cat_data[cat_type]["range"])

	var cooldown = GameData.cat_data[cat_type]["atkcooldown"]
	var attacks_per_second = 1.0 / cooldown
	
	attack_speed.text = "%.1f/s" % attacks_per_second
	critical_chance.text = str(int(GameData.cat_data[cat_type]["critical_chance"])) + "%"
	sprite.texture = load(GameData.cat_data[cat_type]["sprite"])
	
	update_slime_relation(cat_type)

func format_number_k(value: float) -> String:
	if value >= 1000:
		var k_value = value / 1000.0
		return ("%.1fk" % k_value).replace(".0k", "k")
	else:
		return str(int(value))

func update_slime_relation(cat_type):
	var target_types = GameData.cat_data[cat_type]["target_types"]
	var hflow_container = $Container/CatContainer/Background/MarginContainer/HBoxContainer/SlimeRelation/HFlowContainer
	
	# Create mapping between displayed names and game data keys
	var slime_mapping = {
		"Papel": "Papel",
		"Chiclete": "Chiclete",
		"Pilha": "Pilha",
		"Metal": "Metal",
		"Plastico": "Plastico",
		"Radioativos": "Radioativo",
		"Pneu": "BossPneu"
	}
	
	for child in hflow_container.get_children():
		var label = child.get_node("Label")
		if label:
			var slime_name = label.text
			var status_texture = child.get_node("TextureRect")
			
			if slime_mapping.has(slime_name):
				var game_data_key = slime_mapping[slime_name]
				if game_data_key in target_types:
					status_texture.texture = can_attack_texture
				else:
					status_texture.texture = cannot_attack_texture


func _on_close_pressed() -> void:
	pass # Replace with function body.
