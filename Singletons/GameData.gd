extends Node

var default_fish_quantity = 100000
var fish_quantity: int = default_fish_quantity  # Valor inicial de moedas

## Fish
func reset_fish_quantity():
	fish_quantity = 100000

## Cats
var cat_data = {
	"Chicao": {
		"name": "Chicao",
		"sprite": "res://Assets/Cats/Chicao/Chicao.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 800,
		"cost": 100,
		"critical_chance": 10,
		"target_types": ["BossRadioativo"]
	},
	
	"Pele": {
		"name": "Pele",
		"sprite": "res://Assets/Cats/Pele/Pele.png",
		"damage": 20,
		"atkcooldown": 0.5,
		"range": 128,
		"cost": 100,
		"critical_chance": 10
	},
	
	"Nino": {
		"name": "Nino",
		"sprite": "res://Assets/Cats/Nino/Nino.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 50,
		"critical_chance": 10
	},
	
	"Cartolina": {
		"name": "Cartolina",
		"sprite": "res://Assets/Cats/Cartolina/Cartolina.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 96,
		"cost": 100,
		"critical_chance": 10
	},
	
	"Nut": {
		"name": "Nut",
		"sprite": "res://Assets/Cats/Nut/Nut.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 100,
		"critical_chance": 10
	}
}

## Cat Damage
var cat_damage_by_type := {} 

# Função para atualizar a UI
signal fish_quantity_updated(new_amount)

func update_fish_quantity(amount: int):
	fish_quantity += amount
	emit_signal("fish_quantity_updated", fish_quantity)
	print("Moeda total agora: ", fish_quantity)

## Enemies
var enemies_data = {
	"Plastico": {
		"damage": 1,
		"speed": 60,
		"hp": 40,
		"fish_reward": 50
	},
	"Chiclete": {
		"damage": 1,
		"speed": 60,
		"hp": 40,
		"fish_reward": 50
	},
	"Metal": {
		"damage": 1,
		"speed": 60,
		"hp": 40,
		"fish_reward": 50
	},
	"Pilha": {
		"damage": 1,
		"speed": 60,
		"hp": 40,
		"fish_reward": 50
	},
	"BossRadioativo": {
		"damage": 1,
		"speed": 20,
		"hp": 400,
		"fish_reward": 400
	}
}

## round
## Rich Text Label
## [b][font_size=11]Texto[/font_size][/b]  - Font Retro Gaming 
## [shake rate=5 level=10] Texto Tremendo [/shake]
## [rainbow]Texto arco-íris[/rainbow]
## [pulse freq=1.0 color=#ffffff40 ease=-2.0]Texto pulsante[/pulse]
## [wave amp=50 freq=2]Texto ondulado[/wave]
## [tornado radius=5 freq=10]Texto ondulado[/tornado]
## [color=#hex]trocar a cor[/color]

var waves = {
	"wave1": {
		"enemies": [
			["Metal", 1],
			["BossRadioativo", 1]
		],
		"text_box": {
			"show": true,
			"title": "Primeira Onda!",
			"message": "Cuidado em boy"
		}
	},
	
	"wave2": {
		"enemies": [
			["Metal", 1]
		],
		"text_box": {
			"show": true,
			"title": "Segunda Onda!",
			"message": "Os primeiros inimigos estão chegando."
		}
	}
}

## Efeitos
## damage_boost {"type": "damage_boost", "power": 40, "power_type": "percentage" (Opcional)}
## speed_boost {"type": "speed_boost", "power": 0.2, "power_type": "percentage" (Opcional)}
## range_boost
## critic_boost
## money_boost
## {"type": "target_expansion", "target_types": ["all"]}

## Cards
var card_data = {
	"basic": [
		{
			"name": "Destruidor de Plástico",
			"description": "Este gato desenvolveu alergia a materiais sintéticos e agora os odeia profundamente, causa 40 a mais dano contra os slimes de Plástico",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 40}
			],
			"sell_value": "25"
		},{
			"name": "Garras Venenosas",
			"description": "Lambe as garras antes de atacar. Ninguém sabe por quê ataques causam 20 de dano a mais nos inimigos",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 20}
			],
			"sell_value": "25"
		},{
			"name": "Fúria do Predador",
			"description": "Lambe as garras antes de atacar. Ninguém sabe por quê ataques causam 1000% de dano a mais nos inimigos",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 1000, "power_type": "percentage"}
			],
			"sell_value": "25"
		},{
			"name": "METAAAAAAAAAAAL",
			"description": "Lambe as garras antes de atacar. Ninguém sabe por quê ataques causam 1000% de dano a mais nos inimigos",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["Metal"]}
			],
			"sell_value": "25"
		}
		],
		
	"medium": [
		{
			"name": "Predador Completo",
			"description": "Aumenta dano em 100",
			"icon": "res://Assets/Icons/Heart.png",
			"effects": [
				{"type": "damage_boost", "power": 100}
			],
			"sell_value": "50"
		}],
		
	"rare": [
		{
			"name": "Olhos de Leão",
			"description": "Aumenta range em 128",
			"icon": "res://Assets/Icons/Cards2.png",
			"effects": [
				{"type": "range_boost", "power": 128}
			],
			"sell_value": "100"
		}],
}

## Cards
var card_collection = []

signal card_added_to_inventory(card_data)

func add_card_to_collection(card_data: Dictionary):
	card_collection.append(card_data.duplicate())
	
	card_added_to_inventory.emit(card_data)

func _ready():
	update_rarity_chances()

## Round Rarity
var card_rarity_chances = {
	"basic": 60,
	"medium": 30, 
	"rare": 10
}

## Rarity Table
var rarity_table = {
	1: {"basic": 60, "medium": 30, "rare": 10},
	2: {"basic": 55, "medium": 32, "rare": 13},
	3: {"basic": 50, "medium": 34, "rare": 16},
	4: {"basic": 45, "medium": 35, "rare": 20},
	5: {"basic": 40, "medium": 35, "rare": 25},
	6: {"basic": 35, "medium": 35, "rare": 30},
	7: {"basic": 30, "medium": 35, "rare": 35},
	8: {"basic": 25, "medium": 35, "rare": 40},
	9: {"basic": 20, "medium": 35, "rare": 45},
	10: {"basic": 15, "medium": 35, "rare": 50}
}

var current_round: int = 1

signal rarity_chances_updated

## Rarity
func update_rarity_chances():
	var max_round = rarity_table.keys().max()
	var round_to_use = min(current_round, max_round)
	card_rarity_chances = rarity_table[round_to_use].duplicate()
	print("Round ", current_round, " - Chances de raridade: ", card_rarity_chances)
	
	emit_signal("rarity_chances_updated") # <-- emite o sinal

## Rariry Logic
func get_card_rarity_type(card_name: String) -> String:
	for rarity_type in card_data:
		for card in card_data[rarity_type]:
			if card["name"] == card_name:
				return rarity_type
	return "basic"

func apply_card_rarity_texture(card_node: Node, card_name: String):
	var rarity = get_card_rarity_type(card_name)
	var rarity_node = card_node.get_node("MarginContainer/VBoxContainer/CardRarity")
	
	if rarity_node:
		var texture_path = get_rarity_texture_path(rarity)
		if texture_path != "":
			rarity_node.texture = load(texture_path)

func get_rarity_texture_path(rarity: String) -> String:
	match rarity:
		"basic":
			return "res://Assets/UI/Rarity/Comum.png"
		"medium":
			return "res://Assets/UI/Rarity/Incomum.png"
		"rare":
			return "res://Assets/UI/Rarity/Rara.png"
		_:
			return ""

## Statistics
var enemies_defeated: int = 0
var total_damage: int = 0
var fishs_collected: int = 0
var time_in_game: float = 0.0  # Em segundos
var money_spent: int = 0
var number_of_cats: int = 0

func reset_statistics():
	enemies_defeated = 0
	total_damage = 0
	fishs_collected = 0
	time_in_game = 0.0  # Em segundos
	money_spent = 0
	number_of_cats = 0
