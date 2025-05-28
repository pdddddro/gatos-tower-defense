extends Node

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
		"atkcooldown": 1,
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
		"range": 160,
		"cost": 100
	},
	
	"Nut": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 100
	}
}

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

## Waves
var waves = {
	"wave1": [
		["Pilha", 1],
		["Plastico", 1],
		["Chiclete", 1],
		["Metal", 1]
	],
}

## Cards
var card_data = {
	"basic": [
		{
			"name": "Agilidade Felina",
			"description": "Este gato tem um pé de coelho por isso produz 10% a mais de dinheiro... espera, isso não faz sentido - exclusivo para Odin",
			"icon": "res://Assets/Icons/strength_basic.png",
			"rarity_color": Color("808080"), # Cinza para básica
			"effects": {"damage": 5}
		},{
			"name": "Basica2", 
			"description": "Este gato tem um pé de coelho por isso produz 10% a mais de dinheiro... espera, isso não faz sentido - exclusivo para Odin",
			"icon": "res://Assets/Icons/speed_basic.png",
			"rarity_color": Color("808080"),
			"effects": {"speed": 0.1}
		}],
		
	"medium": [
		{
			"name": "Media1",
			"description": "Aumenta o dano em 5 pontos",
			"icon": "res://Assets/Icons/strength_basic.png",
			"rarity_color": Color("808080"), # Cinza para básica
			"effects": {"damage": 5}
		},{
			"name": "Media2", 
			"description": "Aumenta a velocidade em 10%",
			"icon": "res://Assets/Icons/speed_basic.png",
			"rarity_color": Color("808080"),
			"effects": {"speed": 0.1}
		}],
		
	"rare": [
		{
			"name": "Rara1",
			"description": "Aumenta o dano em 5 pontos",
			"icon": "res://Assets/Icons/strength_basic.png",
			"rarity_color": Color("808080"), # Cinza para básica
			"effects": {"damage": 5}
		},{
			"name": "Rara2", 
			"description": "Aumenta a velocidade em 10%",
			"icon": "res://Assets/Icons/speed_basic.png",
			"rarity_color": Color("808080"),
			"effects": {"speed": 0.1}
		}],
}

## Rarity
var card_rarity_chances = {
	"basic": 60,
	"medium": 30, 
	"rare": 10
}

var card_collection = []

signal card_added_to_inventory(card_data)

func add_card_to_collection(card_data: Dictionary):
	card_collection.append(card_data.duplicate())
	
	card_added_to_inventory.emit(card_data)
