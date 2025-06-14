extends Node

var fish_quantity: int = 300  # Valor inicial de moedas

## Cats
var cat_data = {
	"Chicao": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 800,
		"cost": 100
	},
	
	"Pele": {
		"damage": 20,
		"atkcooldown": 0.5,
		"range": 128,
		"cost": 100
	},
	
	"Nino": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 50
	},
	
	"Cartolina": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 96,
		"cost": 100
	},
	
	"Nut": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 100
	}
}

# Função para atualizar a UI (opcional, se precisar de um sinal)
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
	}
}

## round
var waves = {
	"wave1": [
		["Plastico", 1],
		["Plastico", 1],
		["Plastico", 1],
		["Plastico", 1],
	],
	"wave2": [
		["Metal", 1],
		["Metal", 1],
		["Metal", 1],
		["Metal", 1]
	],
	"wave3": [
		["Chiclete", 1],
		["Chiclete", 1],
		["Chiclete", 1],
		["Chiclete", 1]
	],
	"wave4": [
		["Pilha", 1],
		["Pilha", 1],
		["Pilha", 1],
		["Pilha", 1],
	]
}

## Efeitos
## damage_boost
## speed_boost
## range_boost
## critic_boost
## money_boost

## Cards
var card_data = {
	"basic": [
		{
			"name": "Agilidade Felina",
			"description": "Aumenta a velocidade de ataque em 0.2s",
			"icon": "res://Assets/Icons/Fish1.png",
			"rarity_color": Color("808080"), # Cinza para básica
			"effects": [
				{"type": "speed_boost", "power": 0.2}
			],
			"sell_value": "25"
		}],
		
	"medium": [
		{
			"name": "Predador Completo",
			"description": "Aumenta dano em 100",
			"icon": "res://Assets/Icons/Hearts.png",
			"rarity_color": Color("808080"), # Cinza para básica
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
			"rarity_color": Color("808080"), # Cinza para básica
			"effects": [
				{"type": "range_boost", "power": 128}
			],
			"sell_value": "100"
		}],
}

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

func update_rarity_chances():
	var max_round = rarity_table.keys().max()
	var round_to_use = min(current_round, max_round)
	card_rarity_chances = rarity_table[round_to_use].duplicate()
	print("Round ", current_round, " - Chances de raridade: ", card_rarity_chances)
	
	emit_signal("rarity_chances_updated") # <-- emite o sinal
