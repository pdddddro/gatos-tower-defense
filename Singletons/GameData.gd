extends Node

var cat_data = {
	"Cat1": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 256
	},
	
	"Cat2": {
		"damage": 20,
		"atkcooldown": 1,
		"range": 128
	}
}

var enemies_data = {
	"Slime1": {
		"damage": 1,
		"speed": 10
	}
}

var waves = {
	"wave1": [
		["Slime1", 0.5],
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
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
		["Slime1", 0.1],
	],
}
