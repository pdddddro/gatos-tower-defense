extends Node

var default_fish_quantity = 500
var fish_quantity: int = default_fish_quantity  # Valor inicial de moedas

## Fish
func reset_fish_quantity():
	fish_quantity = default_fish_quantity

## Cats
var cat_data = { ## "Plástico", "Metal", "Pilha", "Chiclete", "BossRadioativo"
	"Chicao": { ## Chicão não ataca slimes pilha pra não dar ainda mais energia pra eles
		"name": "Chicao",
		"sprite": "res://Assets/Cats/Chicao/Chicao.png",
		"damage": 15,
		"atkcooldown": 2,
		"range": 150,
		"cost": 230,
		"critical_chance": 0,
		"target_types": ["Plástico", "Metal", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Pele": { ## Apesar de afiada, as garras de Pelé não conseguem destruir o Slime Metal
		"name": "Pele",
		"sprite": "res://Assets/Cats/Pele/Pele.png",
		"damage": 7.5,
		"atkcooldown": .5,
		"range": 88,
		"cost": 250,
		"critical_chance": 1,
		"target_types": ["Plástico", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Nino": { ## Nino não consegue ver o slime de plástico com um olho só por conta da sua trasparência
		"name": "Nino",
		"sprite": "res://Assets/Cats/Nino/Nino.png",
		"damage": 15,
		"atkcooldown": 2,
		"range": 150,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Metal", "Chiclete", "Pilha", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Cartolina": { ## Cartolina não bate no slime de chiclete, seria horrivel ter chiclete em seus pelos
		"name": "Cartolina",
		"sprite": "res://Assets/Cats/Cartolina/Cartolina.png",
		"damage": 10,
		"atkcooldown": 1,
		"range": 108,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Plástico", "Metal", "Pilha", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Nut": { ## Os novelos de lã de nut não passam de carinhos no slime metal, então ele nem gasta sua lã com ele
		"name": "Nut",
		"sprite": "res://Assets/Cats/Nut/Nut.png",
		"damage": 7.5,
		"atkcooldown": 1.5,
		"range": 170,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plástico", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
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
		"damage": 8,
		"speed": 50,
		"hp": 35,
		"fish_reward": 13
	},
	"Chiclete": {
		"damage": 4,
		"speed": 40,
		"hp": 31,
		"fish_reward": 10
	},
	"Metal": {
		"damage": 20,
		"speed": 45,
		"hp": 50,
		"fish_reward": 15
	},
	"Pilha": {
		"damage": 10,
		"speed": 90,
		"hp": 50,
		"fish_reward": 10
	},
	"Radioativo": {
		"damage": 30,
		"speed": 50,
		"hp": 31,
		"fish_reward": 17
	},
	"Papel": {
		"damage": 6,
		"speed": 50,
		"hp": 15,
		"fish_reward": 7
	},
	"BossRadioativo": {
		"damage": 80,
		"speed": 35,
		"hp": 300,
		"fish_reward": 250
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
	"wave1": { ## Bem vindo
		"enemies": [
			["Papel", 2],
			["Papel", 2],
			["Papel", 2],
			["Papel", 2],
		],
		"text_box": {
			"show": true,
			"title": "Prontos para a batalha gatinhos?",
			"message": "Slimes Chiclete à vista! Eles grudam no chão e na natureza. Cartolina nem chega perto deles... imagina se gruda no rabo?"
		}
	},
	"wave2": { ## Frase sobre estar vindo MUITO papel
		"enemies": [
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
		]
	},
	"wave3": {
		"enemies": [
			["Papel", .2],
			["Papel", .2],
			["Papel", 4],
			["Papel", .2],
			["Papel", .2],
			["Papel", 4],
			["Papel", .2],
			["Papel", .2],
			["Papel", 4],
			["Papel", .2],
			["Papel", .2],
		]
	},
	"wave4": { 
		"enemies": [
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", 3],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Chiclete", 1],
			["Papel", 5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
		],
		"text_box": {
			"show": true,
			"title": "E não é que eles grudam mesmo?",
			"message": ""
		}
	},
	"wave5": { ## Frase sobre o chiclete
		"enemies": [
			["Papel", .5],
			["Papel", .5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Papel", 2],
			["Papel", .5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Papel", 2],
			["Papel", .5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Papel", 2],
			["Papel", .5],
			["Plastico", 6]
		],
		"text_box": {
			"show": true,
			"title": "Esse slime de metal?",
			"message": "Parece inofensivo, mas o alumínio demora até 500 anos pra sumir da natureza!"
		}
	},

	# FASE 2: DESENVOLVIMENTO (Ondas 6-10)
	"wave6": {
		"enemies": [
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Papel", 2],
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
			["Chiclete", .3],
			["Papel", .1],
			["Chiclete", .3],
			["Papel", .1],
			["Chiclete", .3],
			["Papel", .1],
			["Chiclete", .3],
			["Papel", .1],
			["Chiclete", .3],
			["Papel", .1],
			["Chiclete", .3],
			["Papel", .1],
		]
	}
}


## Efeitos
## damage_boost {"type": "damage_boost", "power": 40, "power_type": "percentage/absolute"}
## speed_boost {"type": "speed_boost", "power": 0.2, "power_type": "percentage/absolute"}
## range_boost
## critic_boost
## money_boost
## can_attack_target {"type": "target_expansion", "target_types": ["all", "Metal", Plastico, etc]}
## damage_vs_type {"type": "damage_vs_type", "target_type": "Metal", "power": 25, "power_type": "percentage/absolute"}


## Cards
var card_data = {
	"basic": [
		{
			"name": "Pelas tartarugas!",
			"description": "Este gato desenvolveu alergia a materiais sintéticos, 50% mais dano contra os slimes de Plástico",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 50, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Sou do Rock",
			"description": "Ouviu muito Heavy Metal e agora consegue matar slimes de Metal e Pilha, ainda da 35% de dano bônus",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["Metal", "Pilha"]},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 35, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 35, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Petisco sabor Whey l",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 30 de dano adicional",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_boost", "power": 30, "power_type": "absolute"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Treinamento Básico",
			"description": "Assistiu 'Como ser um Gato Guerreiro' no YouTube, aumenta todos os atributos em 7%",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_boost", "power": 7, "power_type": "percentage"},
				{"type": "speed_boost", "power": 7, "power_type": "percentage"},
				{"type": "range_boost", "power": 7, "power_type": "percentage"},
				{"type": "critic_boost", "power": 7, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar I",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +15% de velocidade de ataque",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 20, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do sachê I",
			"description": "Esse gato está ficando com fome, quer acabar com isso logo - Ganha 20% de alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "range_boost", "power": 15, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Pré-treino Radioativo I",
			"description": "Tomou uma substância verde esquisita que encontrou, agora tem 20% de chance de crítico",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "critic_boost", "power": 20, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Veterano de Guerra I",
			"description": "Você não quer saber o que esse gato ja viveu... - 20% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPlastico", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência I",
			"description": "Não aguenta mais, só quer que isso acabe logo, bate 20% mais rápido",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope I",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 40% mais rápido porém perde 30% de Alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"},
				{"type": "range_boost", "power": -30, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		],
		
	"medium": [
		{
			"name": "Mestrado no RU",
			"description": "Sobreviveu 4 anos comendo no restaurante universitário, agora tem estômago de ferro - 30% de dano no Slime Metal",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Metal", "power": 30, "power_type": "percentage"},
			],
			"sell_value": "50"
		}
		,{
			"name": "Pré-treino Radioativo II",
			"description": "Tomou uma substância verde esquisita que encontrou, agora tem mais 30% de chance de crítico",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "critic_boost", "power": 30, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar II",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +30% de velocidade de ataque",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 30, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do sachê II",
			"description": "Esse gato está com tanta fome que vai fazer de tudo para acabar a partida mais rápido, ganha 35% de alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "range_boost", "power": 25, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Miau Cast",
			"description": "Ouve o melhor podcast sobre vida felina, absorveu dicas valiosas - aumenta todos os atributos em 15%",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_boost", "power": 15, "power_type": "percentage"},
				{"type": "speed_boost", "power": 15, "power_type": "percentage"},
				{"type": "range_boost", "power": 15, "power_type": "percentage"},
				{"type": "critic_boost", "power": 15, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Petisco sabor Whey II",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 60 de dano adicional",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_boost", "power": 60, "power_type": "absolute"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Veterano de Guerra II",
			"description": "Você não quer saber o que esse gato ja viveu... - 30% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPlastico", "power": 30, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência II",
			"description": "Não aguenta mais, só quer que isso acabe logo, bate 40% mais rápido",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope II",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 60% mais rápido porém perde 40% de Alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 60, "power_type": "percentage"},
				{"type": "range_boost", "power": -40, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		],

	"rare": [
		{
			"name": "ASMR de Elevação Quantica",
			"description": "Este gato transcendeu as limitações físicas, aumenta todos os atributos em +30%",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["all"]},
				{"type": "damage_boost", "power": 30, "power_type": "percentage"},
				{"type": "speed_boost", "power": 30, "power_type": "percentage"},
				{"type": "range_boost", "power": 30, "power_type": "percentage"},
				{"type": "critic_boost", "power": 30, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Pré-treino Radioativo III",
			"description": "Tomou uma substância verde esquisita que encontrou, agora tem mais 50% de chance de crítico",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "critic_boost", "power": 50, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar III",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +40% de velocidade de ataque",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do sachê III",
			"description": "Esse gato está quer devorar tudo que vê pela frente, +50% de alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "range_boost", "power": 40, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "O gato mais forte de todos",
			"description": "EU SOU O MAIS FORTE DE TODOS!! Aumenta a chance de crítico em 99% mas perde 30% de velocidade de ataque",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "range_boost", "power": -30, "power_type": "percentage"},
				{"type": "critic_boost", "power": 99, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		#,{	
			#"name": "Trid lll",
			#"description": "Este gato teve aula com Paulo Sustentável, agora odeia plástico profundamente - 40% mais dano contra os slimes de Plástico",
			#"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			#"effects": [
				#{"type": "damage_vs_type", "target_type": "Plastico", "power": 40, "power_type": "percentage"}
			#],
			#"sell_value": "25"
		#}
		,{
			"name": "Veterano de Guerra III",
			"description": "Você não quer saber o que esse gato ja viveu... - 60% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPlastico", "power": 60, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência III",
			"description": "Não aguenta mais, só quer que isso acabe logo, bate 60% mais rápido",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 60, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope III",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 100% mais rápido porém perde 60% de Alcance",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "speed_boost", "power": 100, "power_type": "percentage"},
				{"type": "range_boost", "power": -60, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Petisco sabor Whey III",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 100 de dano adicional",
			"icon": "res://Assets/Icons/CardIconPlaceholder.png",
			"effects": [
				{"type": "damage_boost", "power": 100, "power_type": "absolute"}
			],
			"sell_value": "25"
		}
		],
}

## Cards
var card_collection = []

signal card_added_to_inventory(card_data)

func add_card_to_collection(card_data: Dictionary):
	card_collection.append(card_data.duplicate())
	
	card_added_to_inventory.emit(card_data)

func _ready():
	update_rarity_chances()
	load_game_data()

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

var tutorial_completed: bool = false
var save_file_path = "user://game_save.dat"

# Função para salvar dados
func save_game_data():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		var save_data = {
			"tutorial_completed": tutorial_completed
		}
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Dados salvos com sucesso")
	else:
		print("Erro ao salvar dados")

# Função para carregar dados
func load_game_data():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var save_data = json.data
				tutorial_completed = save_data.get("tutorial_completed", false)
				print("Dados carregados: tutorial_completed = ", tutorial_completed)
			else:
				print("Erro ao fazer parse do JSON")
		else:
			print("Erro ao abrir arquivo de save")
	else:
		print("Arquivo de save não existe, usando valores padrão")

# Função para marcar tutorial como completo
func mark_tutorial_completed():
	tutorial_completed = true
	save_game_data()
	print("Tutorial marcado como completo e salvo")

# NOVA FUNÇÃO: Para mostrar tutorial manualmente (botão de ajuda)
func show_tutorial_manually():
	print("Tutorial solicitado manualmente pelo jogador")
