extends Node

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

var waves = {
	"wave1": [
		["Pilha", 1],
		["Plastico", 1],
		["Chiclete", 1],
		["Metal", 1]
	],
}
