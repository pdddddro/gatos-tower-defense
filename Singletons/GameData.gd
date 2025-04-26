extends Node

var cat_data = {
	"Cat1": {
		"damage": 20,
		"atkcooldown": 2,
		"range": 256,
		"cost": 100
	},
	
	"Cat2": {
		"damage": 20,
		"atkcooldown": 0.5,
		"range": 128,
		"cost": 50
	}
}

var enemies_data = {
	"Slime1": {
		"damage": 1,
		"speed": 100,
		"hp": 40,
		"fish_reward": 50
	}
}

var waves = {
	"wave1": [
		["Slime1", 0.5],
	],
	
	"wave2": [
		["Slime1", 0.5],
		["Slime1", 0.5],
	],
	
		"wave3": [
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
	],
}
