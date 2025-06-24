extends Node

var default_fish_quantity = 100000
var fish_quantity: int = default_fish_quantity  # Valor inicial de moedas

## Fish
func reset_fish_quantity():
	fish_quantity = 100000

## Cats
var cat_data = { ## "Plástico", "Metal", "Pilha", "Chiclete", "BossRadioativo"
	"Chicao": { ## Chicão não ataca slimes pilha pra não dar ainda mais energia pra eles
		"name": "Chicao",
		"sprite": "res://Assets/Cats/Chicao/Chicao.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 800,
		"cost": 100,
		"critical_chance": 100,
		"target_types": ["Plástico", "Metal", "Chiclete", "BossRadioativo"]
	},
	
	"Pele": { ## Apesar de afiada, as garras de Pelé não conseguem destruir o Slime Metal
		"name": "Pele",
		"sprite": "res://Assets/Cats/Pele/Pele.png",
		"damage": 20,
		"atkcooldown": 0.5,
		"range": 128,
		"cost": 100,
		"critical_chance": 10,
		"target_types": ["Plástico", "Pilha", "Chiclete", "BossRadioativo"]
	},
	
	"Nino": { ## Nino não consegue ver o slime de plástico com um olho só por conta da sua trasparência
		"name": "Nino",
		"sprite": "res://Assets/Cats/Nino/Nino.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 50,
		"critical_chance": 10,
		"target_types": ["Metal", "Chiclete", "Pilha", "BossRadioativo"]
	},
	
	"Cartolina": { ## Cartolina não bate no slime de chiclete, seria horrivel ter chiclete em seus pelos
		"name": "Cartolina",
		"sprite": "res://Assets/Cats/Cartolina/Cartolina.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 96,
		"cost": 100,
		"critical_chance": 10,
		"target_types": ["Plástico", "Metal", "Pilha", "BossRadioativo"]
	},
	
	"Nut": { ## Os novelos de lã de nut não passam de carinhos no slime metal, então ele nem gasta sua lã com ele
		"name": "Nut",
		"sprite": "res://Assets/Cats/Nut/Nut.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 160,
		"cost": 100,
		"critical_chance": 10,
		"target_types": ["Plástico", "Pilha", "Chiclete", "BossRadioativo"]
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
		"hp": 10,
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
			"description": "Este gato desenvolveu alergia a materiais sintéticos, 15% mais dano contra os slimes de Plástico",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 15, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Garras Venenosas",
			"description": "Lambe as garras antes de atacar. Ninguém sabe por quê, mas seus ataques causam 8% de dano a mais nos inimigos",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 8, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Sou do Rock",
			"description": "Ouviu muito Heavy Metal e agora consegue matar slimes de Metal e Pilha, ainda da 15% de dano bônus",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["Metal", "Pilha"]},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 15, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 15, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Petisco sabor Whey l",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 20 de dano adicional",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 20, "power_type": "absolute"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Treinamento Básico",
			"description": "Assistiu 'Como ser um Gato Guerreiro' no YouTube, aumenta todos os atributos em 5%",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 5, "power_type": "percentage"},
				{"type": "speed_boost", "power": 5, "power_type": "percentage"},
				{"type": "range_boost", "power": 5, "power_type": "percentage"},
				{"type": "critic_boost", "power": 5, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Gato Míope",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 20% mais rápido porém perde 15% de Alcance",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "speed_boost", "power": 20, "power_type": "percentage"},
				{"type": "range_boost", "power": -15, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +12% de velocidade de ataque",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "speed_boost", "power": 12, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do sachê l",
			"description": "Esse gato está ficando com fome, quer acabar com isso logo - Ganha 10% de Range",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "range_boost", "power": 10, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		],
		
	"medium": [
		{
			"name": "Mestrado no RU",
			"description": "Sobreviveu 4 anos comendo no restaurante universitário, agora tem estômago de ferro - 15% de dano no Slime Metal",
			"icon": "res://Assets/Icons/Heart.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Metal", "power": 15, "power_type": "percentage"},
			],
			"sell_value": "50"
		}
		,{
			"name": "Hora do sachê ll",
			"description": "EEsse gato está com tanta fome que vai fazer de tudo para acabar a partida mais rápido, ganha 20% de alcance",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "range_boost", "power": 20, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Miau Cast",
			"description": "Ouve o melhor podcast sobre vida felina, absorveu dicas valiosas - aumenta todos os atributos em 10%",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 10, "power_type": "percentage"},
				{"type": "speed_boost", "power": 10, "power_type": "percentage"},
				{"type": "range_boost", "power": 10, "power_type": "percentage"},
				{"type": "critic_boost", "power": 10, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Pré-treino Radioativo",
			"description": "Tomou uma substância verde esquisita que encontrou, agora ataca 10% mais rápido e tem 50% de chance de crítico",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "speed_boost", "power": 10, "power_type": "percentage"},
				{"type": "critic_boost", "power": 50, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Pelos Anti-Colates",
			"description": "Nasceu com pelos tão macios que nada consegue grudar nele - Consegue atacar o Slime Chiclete e da 15% de dano a mais neles",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["Chiclete"]},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 15, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Petisco sabor Whey",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 50 de dano adicional",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_boost", "power": 50, "power_type": "absolute"}
			],
			"sell_value": "25"
		}
		],

	"rare": [
		{
			"name": "ASMR de Elevação Quântica",
			"description": "Este gato transcendeu as limitações físicas, aumenta todos os atributos em +25%",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["all"]},
				{"type": "damage_boost", "power": 25, "power_type": "percentage"},
				{"type": "speed_boost", "power": 25, "power_type": "percentage"},
				{"type": "range_boost", "power": 25, "power_type": "percentage"},
				{"type": "critic_boost", "power": 25, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do sachê lll",
			"description": "Esse gato está quer devorar tudo que vê pela frente, +40% de alcance",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "range_boost", "power": 40, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "O gato mais forte de todosl",
			"description": "EU SOU O MAIS FORTE DE TODOS!! (Pelo menos na minha cabeça) Aumenta a chance de crítico em 99% mas perde 30% do range",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "range_boost", "power": -30, "power_type": "percentage"},
				{"type": "critic_boost", "power": 99, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		#,{	
			#"name": "Trid lll",
			#"description": "Este gato teve aula com Paulo Sustentável, agora odeia plástico profundamente - 40% mais dano contra os slimes de Plástico",
			#"icon": "res://Assets/Icons/Fish1.png",
			#"effects": [
				#{"type": "damage_vs_type", "target_type": "Plastico", "power": 40, "power_type": "percentage"}
			#],
			#"sell_value": "25"
		#}
		,{
			"name": "Veterano de Guerra",
			"description": "Você não quer saber o que esse gato ja viveu... - 40% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 40, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 40, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 40, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 40, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 40, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPlastico", "power": 40, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência",
			"description": "Não aguenta mais, só quer que isso acabe logo, bate 40% mais rápido",
			"icon": "res://Assets/Icons/Fish1.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"}
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
