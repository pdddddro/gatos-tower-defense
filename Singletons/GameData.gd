extends Node

#  ██████╗ ██╗██╗    ██████╗  █████╗ ██████╗  █████╗     ██████╗ ███████╗
# ██╔═══██╗██║██║    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔════╝
# ██║   ██║██║██║    ██████╔╝███████║██████╔╝███████║    ██║  ██║█████╗  
# ██║   ██║██║██║    ██╔═══╝ ██╔══██║██╔══██╗██╔══██║    ██║  ██║██╔══╝  
# ╚██████╔╝██║██║    ██║     ██║  ██║██║  ██║██║  ██║    ██████╔╝███████╗
#  ╚═════╝ ╚═╝╚═╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═════╝ ╚══════╝
#
#          ██╗                   ██╗
  #                                      
# ██████╗  ██╗ ███████╗ ██████╗  ██╗ ██╗      ██╗  ██╗  ██████╗  ████████╗  █████╗  ██████╗ 
# ██╔══██╗ ██║ ██╔════╝ ██╔══██╗ ██║ ██║      ██║  ██║ ██╔═══██╗ ╚══██╔══╝ ██╔══██╗ ██╔══██╗
# ██████╔╝ ██║ ███████╗ ██████╔╝ ██║ ██║      ███████║ ██║   ██║    ██║    ███████║ ██████╔╝       
# ██╔══██╗ ██║ ╚════██║ ██╔══██╗ ██║ ██║      ██╔══██║ ██║   ██║    ██║    ██╔══██║ ██╔══██╗ 
# ██████╔╝ ██║ ███████║ ██████╔╝ ██║ ███████╗ ██║  ██║ ╚██████╔╝    ██║    ██║  ██║ ██║  ██║
# ╚═════╝  ╚═╝ ╚══════╝ ╚═════╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝  ╚═════╝     ╚═╝    ╚═╝  ╚═╝ ╚═╝  ╚═╝
## Brincadeira, se quiser ajudar no projeto, só chamar @joguegatinhos na DM


var default_fish_quantity = 600
var fish_quantity: int = default_fish_quantity  # Valor inicial de moedas

var default_health_quantity = 100
var health_quantity: int = default_health_quantity  # Valor inicial de moedas

var totalWaveNumber = 30

## Fish
func reset_fish_quantity():
	fish_quantity = default_fish_quantity

## Cats
var cat_data = { ## "Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo"
	"Chicao": { ## Chicão não ataca slimes pilha pra não dar ainda mais energia pra eles
		"name": "Chicão",
		"sprite": "res://Assets/Cats/Chicao/Chicao.png",
		"damage": 10,
		"atkcooldown": 1,
		"range": 160,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Plástico", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Ninguém ignora Chicão. Com seu miado potente e uma carinha meiga, ele exige carinho na base do grito. Drama é sua linguagem!"
	},
	
	"Pele": { ## Apesar de afiada, as garras de Pelé não conseguem destruir o Slime Metal
		"name": "Pelé",
		"sprite": "res://Assets/Cats/Pele/Pele.png",
		"damage": 5,
		"atkcooldown": 0.5,
		"range": 90,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Idoso, elegante e tranquilo. Mas cuidado: por trás da fofura se esconde um guerreiro pronto pra dar patada se mexerem no lugar dele no sofá."
	},
	
	"Nino": { ## Nino não consegue ver o slime de plástico com um olho só por conta da sua trasparência
		"name": "Nino",
		"sprite": "res://Assets/Cats/Nino/Nino.png",
		"damage": 10,
		"atkcooldown": 1.2,
		"range": 200,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Ele só precisa de um olho pra te fulminar com um olhar. Um guerreirinho de bigodes que dispara indignação concentrada em forma de laser felino. "
	},
	
	"Cartolina": { ## Cartolina não bate no slime de chiclete, seria horrivel ter chiclete em seus pelos
		"name": "Cartolina",
		"sprite": "res://Assets/Cats/Cartolina/Cartolina.png",
		"damage": 20,
		"atkcooldown": 1,
		"range": 96,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Cartolina foi adotado e podia estar de boa no colo de alguém… mas escolheu voltar. Porque amigos não se deixam sozinhos diante de slimes. Especialmente quando se tem um rabo afiado."
	},
	
	"Nut": { ## Os novelos de lã de nut não passam de carinhos no slime metal, então ele nem gasta sua lã com ele
		"name": "Nut",
		"sprite": "res://Assets/Cats/Nut/Nut.png",
		"damage": 10,
		"atkcooldown": 1.8,
		"range": 300,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Ninguém sabe ao certo quantos anos Nut tem. Alguns dizem que ele já era velho quando os humanos ainda mandavam cartas. Só se sabe de uma coisa: esse ancião ainda sabe usar um novelo como poucos."
	},
	"Guile": {
		"name": "Guile",
		"sprite": "res://Assets/Cats/Guile/Guile.png",
		"damage": 10,
		"atkcooldown": 1.8,
		"range": 300,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Olhos lacrimejando, fungadas constantes e um espirro sempre prestes a acontecer. Guile é o terror dos slimes. Não pela força bruta, mas pela mira certeira de seu jato de catarro."
	},
	"Loirinha": {
		"name": "Loirinha",
		"sprite": "res://Assets/Cats/Loirinha/Loirinha.png",
		"damage": 10,
		"atkcooldown": 1.8,
		"range": 300,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo", "BossPneu"],
		"description": "Gata de personalidade forte e temperamento explosivo, Loirinha usa sua mordida como defesa e ataque, sempre pronta pra proteger seus amigos e mostrar quem manda no pedaço."
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
	"Papel": {
		"damage": 5,
		"speed": 45,
		"hp": 20,
		"fish_reward": 20
	},
	"Chiclete": {
		"damage": 8,
		"speed": 34,
		"hp": 45,
		"fish_reward": 22
	},
	"Plastico": {
		"damage": 15,
		"speed": 45,
		"hp": 70,
		"fish_reward": 25
	},
	"Metal": {
		"damage": 15,
		"speed": 30,
		"hp": 160,
		"fish_reward": 25
	},
	"Pilha": {
		"damage": 20,
		"speed": 70,
		"hp": 80,
		"fish_reward": 35
	},
	"Radioativo": {
		"damage": 25,
		"speed": 40,
		"hp": 150,
		"fish_reward": 40
	},
	"BossRadioativo": {
		"damage": 99,
		"speed": 26,
		"hp": 1000,
		"fish_reward": 600
	},
	"BossPneu": {
		"damage": 99,
		"speed": 55,
		"hp": 750,
		"fish_reward": 300
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
			"description": "Este gato desenvolveu alergia a materiais sintéticos, 100% mais dano contra os slimes de Plástico",
			"icon": "res://Assets/Icons/Cards/Tartaruga-icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 100, "power_type": "percentage"}
			],
			"sell_value": "50"
		}
		,{
			"name": "Sou do Rock",
			"description": "Ouviu muito Heavy Metal e agora causa 80% de dano bônus em Slimes Metal e Pilha",
			"icon": "res://Assets/Icons/Cards/rock-icon.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["Metal", "Pilha"]},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 80, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 80, "power_type": "percentage"}
			],
			"sell_value": "50"
		}
		,{
			"name": "Petisco sabor Whey l",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 15 de dano adicional",
			"icon": "res://Assets/Icons/Cards/biceps-icon.png",
			"effects": [
				{"type": "damage_boost", "power": 15, "power_type": "absolute"}
			],
			"sell_value": "50"
		}
		,{
			"name": "Treinamento Básico",
			"description": "Assistiu 'Como ser um Gato Guerreiro' no YouTube, aumenta o dano em 5, crítico em 20%, alcance em 10% e velocidade de ataque em 0.2s",
			"icon": "res://Assets/Icons/Cards/Treinanmeto-Basico-Icon.png",
			"effects": [
				{"type": "damage_boost", "power": 5, "power_type": "absolute"},
				{"type": "speed_boost", "power": .2, "power_type": "absolute"},
				{"type": "range_boost", "power": 10, "power_type": "percentage"},
				{"type": "critic_boost", "power": 20, "power_type": "absolute"}
			],
			"sell_value": "50"
		}
		,{
			"name": "Ritmo do Ronronar I",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha 0,5 de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 0.5, "power_type": "absolute"},
			],
			"sell_value": "50"
		}
		,{
			"name": "Hora do Patê I",
			"description": "Esse gato está ficando com fome, quer acabar com isso logo - Ganha 30% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
			"effects": [
				{"type": "range_boost", "power": 30, "power_type": "percentage"},
			],
			"sell_value": "50"
		}
		,{
			"name": "Química do Mal I",
			"description": "O gato tomou uma substância verde esquisita que encontrou, agora tem 25% de chance de crítico",
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 25, "power_type": "absolute"}
			],
			"sell_value": "50"
		}
		,{
			"name": "Veterano de Guerra I",
			"description": "Você não quer saber o que esse gato ja viveu... 50% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 50, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 50, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 50, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 50, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 50, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 50, "power_type": "percentage"}
		],
			"sell_value": "50"
		}
		,{
			"name": "Sem Paciência I",
			"description": "Não aguenta mais, só quer que isso acabe logo. Ganha 0,4s de velocidade de ataque e 15% de alcance",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 0.4, "power_type": "absolute"},
				{"type": "range_boost", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "50"
		}
		,{
			"name": "Gato Míope I",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 50% mais rápido porém perde 20% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
			"effects": [
				{"type": "speed_boost", "power": 50, "power_type": "percentage"},
				{"type": "range_boost", "power": -20, "power_type": "percentage"}
			],
			"sell_value": "50"
		}
		],
		
	"medium": [
		{
			"name": "Mestrado no RU",
			"description": "Sobreviveu 4 anos comendo no restaurante universitário, agora tem estômago de ferro - 150% de dano no Slime Metal e Pilha",
			"icon": "res://Assets/Icons/Cards/Mestrado-RU-Icxon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Metal", "power": 150, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Química do Mal II",
			"description": "O gato tomou uma substância verde esquisita que encontrou, agora tem mais 60% de chance de crítico",
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 60, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar II",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha 1s de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 1, "power_type": "absolute"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do Patê II",
			"description": "Esse gato está com tanta fome que vai fazer de tudo para acabar a partida mais rápido, ganha 45% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
			"effects": [
				{"type": "range_boost", "power": 25, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Miau Cast",
			"description": "Ouve o melhor podcast sobre vida felina, absorveu dicas valiosas - aumenta o dano em 10, crítico em 30%, alcance em 15% e velocidade de ataque em 0.4s",
			"icon": "res://Assets/Icons/Cards/Treinanmeto-Basico-Icon.png",
			"effects": [
				{"type": "damage_boost", "power": 10, "power_type": "absolute"},
				{"type": "speed_boost", "power": 0.4, "power_type": "absolute"},
				{"type": "range_boost", "power": 15, "power_type": "percentage"},
				{"type": "critic_boost", "power": 30, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Petisco sabor Whey II",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 30 de dano adicional",
			"icon": "res://Assets/Icons/Cards/biceps-icon.png",
			"effects": [
				{"type": "damage_boost", "power": 30, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Veterano de Guerra II",
			"description": "Você não quer saber o que esse gato ja viveu... 70% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 70, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 70, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 70, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 70, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 70, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 70, "power_type": "percentage"}
		],
			"sell_value": "100"
		}
		,{
			"name": "Sem Paciência II",
			"description": "Não aguenta mais, só quer que isso acabe logo. Ganha 0,6s de velocidade de ataque e 20% de alcance",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 0.6, "power_type": "absolute"},
				{"type": "range_boost", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "100"
		}
		,{
			"name": "Gato Míope II",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 60% mais rápido porém perde 35% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
			"effects": [
				{"type": "speed_boost", "power": 60, "power_type": "percentage"},
				{"type": "range_boost", "power": -35, "power_type": "percentage"}
			],
			"sell_value": "100"
		}
		],

	"rare": [
		{
			"name": "ASMR de Elevação quantica",
			"description": "Este gato transcendeu as limitações físicas, - aumenta o dano em 15, crítico em 40%, alcance em 20% e velocidade de ataque em 0.6s",
			"icon": "res://Assets/Icons/Cards/Treinanmeto-Basico-Icon.png",
			"effects": [
				{"type": "target_expansion", "target_types": ["all"]},
				{"type": "damage_boost", "power": 15, "power_type": "absolute"},
				{"type": "critic_boost", "power": 40, "power_type": "absolute"},
				{"type": "range_boost", "power": 20, "power_type": "percentage"},
				{"type": "speed_boost", "power": .6, "power_type": "absolute"}
			],
			"sell_value": "150"
		}
		,{
			"name": "Química do Mal III",
			"description": "O gato tomou uma substância verde esquisita que encontrou, agora tem mais 100% de chance de crítico",
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 100, "power_type": "absolute"}
			],
			"sell_value": "150"
		}
		,{
			"name": "Ritmo do Ronronar III",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha 2s de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 2, "power_type": "absolute"},
			],
			"sell_value": "150"
		}
		,{
			"name": "Hora do Patê III",
			"description": "Esse gato está quer devorar tudo que vê pela frente, +70% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
			"effects": [
				{"type": "range_boost", "power": 40, "power_type": "percentage"},
			],
			"sell_value": "150"
		}
		,{
			"name": "O gato mais forte de todos",
			"description": "EU SOU O MAIS FORTE DE TODOS!! Aumenta a chance de crítico em 60%, dano em 30 e aumente em a 30% de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/O-melhor-gato-icon.png",
			"effects": [
				{"type": "damage_boost", "power": 30, "power_type": "absolute"},
				{"type": "critic_boost", "power": 60, "power_type": "absolute"},
				{"type": "speed_boost", "power": 30, "power_type": "percentage"}
			],
			"sell_value": "150"
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
			"description": "Você não quer saber o que esse gato ja viveu... 100% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 100, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 100, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 100, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 100, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 100, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 100, "power_type": "percentage"}
		],
			"sell_value": "150"
		}
		,{
			"name": "Sem Paciência III",
			"description": "Não aguenta mais, só quer que isso acabe logo. Ganha 0,8s de velocidade de ataque e 25% de alcance",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 0.8, "power_type": "absolute"},
				{"type": "range_boost", "power": 25, "power_type": "percentage"}
		],
			"sell_value": "150"
		}
		,{
			"name": "Gato Míope III",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 100% mais rápido porém perde 50% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
			"effects": [
				{"type": "speed_boost", "power": 100, "power_type": "percentage"},
				{"type": "range_boost", "power": -50, "power_type": "percentage"}
			],
			"sell_value": "150"
		}
		,{
			"name": "Petisco sabor Whey III",
			"description": "Este gato descobriu os petiscos proteicos do dono - Cada ataque da 60 de dano adicional",
			"icon": "res://Assets/Icons/Cards/biceps-icon.png",
			"effects": [
				{"type": "damage_boost", "power": 60, "power_type": "absolute"}
			],
			"sell_value": "150"
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
	
	SilentWolf.configure({
		"api_key": "ptCcmwWz0r145MhzXbBEx9bNxMSnJtCo2V4mq3Hz",
		"game_id": "gatinhos12",
		"log_level": 1
	})

## Round Rarity
var card_rarity_chances = {
	"basic": 100,
	"medium": 0, 
	"rare": 0
}

## Rarity Table
var rarity_table = {
	1: {"basic": 100, "medium": 0, "rare": 0},
	2: {"basic": 100, "medium": 0, "rare": 0},
	3: {"basic": 99, "medium": 1, "rare": 0},
	4: {"basic": 95, "medium": 5, "rare": 0},
	5: {"basic": 95, "medium": 5, "rare": 0},
	6: {"basic": 90, "medium": 10, "rare": 0},
	7: {"basic": 90, "medium": 10, "rare": 0},
	8: {"basic": 85, "medium": 15, "rare": 0},
	9: {"basic": 85, "medium": 15, "rare": 0},
	10: {"basic": 80, "medium": 19, "rare": 1},
	11: {"basic": 80, "medium": 19, "rare": 1},
	12: {"basic": 75, "medium": 24, "rare": 1},
	13: {"basic": 75, "medium": 24, "rare": 1},
	14: {"basic": 70, "medium": 29, "rare": 1},
	15: {"basic": 60, "medium": 38, "rare": 2},
	16: {"basic": 50, "medium": 45, "rare": 5},
	17: {"basic": 40, "medium": 55, "rare": 5},
	18: {"basic": 20, "medium": 60, "rare": 10},
	19: {"basic": 5, "medium": 80, "rare": 15},
	20: {"basic": 0, "medium": 80, "rare": 20},
	21: {"basic": 0, "medium": 70, "rare": 30},
	22: {"basic": 0, "medium": 65, "rare": 35},
	23: {"basic": 0, "medium": 60, "rare": 40},
	24: {"basic": 0, "medium": 55, "rare": 45},
	25: {"basic": 0, "medium": 50, "rare": 50},
	26: {"basic": 0, "medium": 45, "rare": 55},
	27: {"basic": 0, "medium": 40, "rare": 60},
	28: {"basic": 0, "medium": 35, "rare": 65},
	29: {"basic": 0, "medium": 30, "rare": 70},
	30: {"basic": 0, "medium": 25, "rare": 75}   
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
			"tutorial_completed": tutorial_completed,
			"has_won_once": has_won_once,
			"music_volume": music_volume,
			"sfx_volume": sfx_volume,
		}
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Dados salvos com sucesso")
	else:
		print("Erro ao salvar dados")
		
var game_version = "1.0"  # Atualize conforme necessário

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
				var saved_version = save_data.get("game_version", "0.0")
				if saved_version != game_version:
					reset_all_game_data()
					print("Versão antiga detectada, dados resetados para nova versão: ", game_version)
				else:
					tutorial_completed = save_data.get("tutorial_completed", false)
					has_won_once = save_data.get("has_won_once", false)
					music_volume = save_data.get("music_volume", 1.0)
					sfx_volume = save_data.get("sfx_volume", 1.0)
					call_deferred("apply_saved_volumes")
					print("Dados carregados normalmente")
			else:
				print("Erro ao fazer parse do JSON")
		else:
			print("Erro ao abrir arquivo de save")
	else:
		reset_all_game_data()
		print("Arquivo de save não existe, dados resetados")

func apply_saved_volumes():
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))
		print("Volume da música aplicado: ", music_volume)
	else:
		print("Bus Music não encontrado")
		
	if sfx_bus != -1:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))
		print("Volume do SFX aplicado: ", sfx_volume)
	else:
		print("Bus SFX não encontrado")

func update_music_volume_from_ui(volume_percentage: float):
	# Converte porcentagem (0-100) para decibéis (-80 a 0)
	var volume_db = linear_to_db(volume_percentage / 100.0)
	set_global_music_volume_offset(volume_db)
	
	# Salva a configuração
	music_volume = volume_percentage / 100.0
	save_game_data()

# Função para marcar tutorial como completo
func mark_victory():
	has_won_once = true
	tutorial_completed = true  # Agora marca o tutorial como completo
	print("Primeira vitória alcançada! Tutorial completo.")
	save_game_data()

func reset_all_game_data():
	fish_quantity = default_fish_quantity
	health_quantity = default_health_quantity
	current_round = 1
	reset_statistics()
	card_collection.clear()
	tutorial_completed = false
	has_won_once = false
	music_volume = 1.0
	sfx_volume = 1.0
	delete_save_file()
	save_game_data()
	print("Todos os dados do jogo foram resetados!")

func delete_save_file():
	if FileAccess.file_exists(save_file_path):
		var dir = DirAccess.open("user://")
		if dir:
			var result = dir.remove(save_file_path.get_file())
			if result == OK:
				print("Arquivo de save deletado com sucesso")
			else:
				print("Erro ao deletar arquivo de save: ", result)
		else:
			print("Erro ao acessar diretório user://")
	else:
		print("Arquivo de save não existe")

## Audio

var music_volume: float = 1.0
var sfx_volume: float = 1.0

var music_data = {
	"background": { "path": "res://Audio/Music/[no copyright music] 'soho cat' background music [80L2EWOCaT4].mp3","volume": -25},
	"menu": { "path": "res://Assets/Audio/Music/menu_music.ogg", "volume": -8 },
	"victory": { "path": "res://Assets/Audio/Music/victory_music.ogg", "volume": -3 },
	"game_over": { "path": "res://Assets/Audio/Music/game_over_music.ogg", "volume": -10 }
}

var sound_data = {
	"enemies": {
		"Papel": {
			"death": {"path": "res://Audio/Enemies/Papel/Death.ogg", "volume": -5},
			"walk": {"path": "res://Audio/Enemies/Papel/Walk.ogg", "volume": -5}
		},
		"Chiclete": {
			"death": {"path": "res://Audio/Enemies/Chiclete/439186__fourthwoods__pop-5.ogg", "volume": -15},
			"walk": {"path": "res://Audio/Enemies/Chiclete/167075__drminky__slime-land.wav", "volume": -25}
		},
		"Plastico": {
			"death": {"path": "res://Audio/Enemies/Plastico/Death.ogg", "volume": -4},
			"walk": {"path": "res://Audio/Enemies/Plastico/Walk.ogg", "volume": -15}
		},
		"Metal": {
			"death": {"path": "res://Audio/Enemies/Metal/Death.ogg", "volume": -7},
			"walk": {"path": "res://Audio/Enemies/Metal/Walk.ogg", "volume": -10}
		},
		"Pilha": {
			"death": {"path": "res://Audio/Enemies/Pilha/Dead.ogg", "volume": -10},
			"walk": {"path": "res://Audio/Enemies/Pilha/Walk.ogg", "volume": -10}
		},
		"Radioativo": {
			"death": {"path": "res://Audio/Enemies/Radioativo/Death.ogg", "volume": 0},
			"walk": {"path": "res://Audio/Enemies/Radioativo/Walk.ogg", "volume": -8}
		},
		"BossRadioativo": {
			"death": {"path": "res://Audio/Enemies/BossPneu/792520__modusmogulus__retro-small-bomb-explosion.wav", "volume": -10},
			"walk": {"path": "res://Audio/Enemies/Radioativo/Walk.ogg", "volume": -10}
		},
		"BossPneu": {
			"death": {"path": "res://Audio/Enemies/BossPneu/792520__modusmogulus__retro-small-bomb-explosion.wav", "volume": -10},
			"walk": {"path": "res://Audio/Enemies/BossPneu/Walk.ogg", "volume": -7}
		}
	},
	"cats": {
		"Chicao": {
			"attack": {"path": "res://Audio/Cats/Chicao/Attack.ogg", "volume": -13},
			"place": {"path": "res://Audio/Cats/Chicao/Place.ogg", "volume": -10}
		},
		"Pele": {
			"attack": {"path": "res://Audio/Cats/Pele/Attack.ogg", "volume": -5.0},
			"place": {"path": "res://Audio/Cats/Pele/Place.ogg", "volume": -5}
		},
		"Nino": {
			"attack": {"path": "res://Audio/Cats/Nino/Attack.ogg", "volume": 0},
			"place": {"path": "res://Audio/Cats/Nino/Place.ogg", "volume": -5}
		},
		"Cartolina": {
			"attack": {"path": "res://Audio/Cats/Cartolina/Attack.ogg", "volume": -4},
			"place": {"path": "res://Audio/Cats/Cartolina/Place.ogg", "volume": -5}
		},
		"Nut": {
			"attack": {"path": "res://Audio/Cats/Nut/Attack.ogg", "volume": 0},
			"place": {"path": "res://Audio/Cats/Nut/Place.ogg", "volume": -5}
		}
	},
	"ui": {
		"button": {
			"click": {"path": "res://Audio/UI/593955__mincedbeats__mouse-button-click.ogg", "volume": -5},
			"hover": {"path": "res://Audio/UI/166186__drminky__menu-screen-mouse-over.ogg", "volume": 0},	
		},
		"card_equip": {"path": "", "volume": 0},
		"purchase": {"path": "", "volume": 0},
		"error": {"path": "", "volume": 0}
	},
	"game": {
		"wave_start": {"path": "", "volume": 0},
		"wave_complete": {"path": "", "volume": 0},
		"game_over": {"path": "", "volume": 0},
		"victory": {"path": "", "volume": 0.0}
	}
}

func change_background_music(music_type: String):
	if music_data.has(music_type):
		var music_info = music_data[music_type]
		var music_path = music_info["path"]
		var volume = music_info["volume"]
		
		print("Tentando trocar música para: ", music_type, " - ", music_path, " volume: ", volume)
		
		if ResourceLoader.exists(music_path):
			AudioManager.music_player.stream = load(music_path)
			AudioManager.music_player.volume_db = volume
			AudioManager.music_player.play()
			print("Música alterada com sucesso!")
		else:
			print("ERRO: Arquivo de música não encontrado: ", music_path)
	else:
		print("ERRO: Tipo de música não encontrado: ", music_type)
		print("Tipos disponíveis: ", music_data.keys())
# Função para tocar sons
func play_sound(category: String, type: String, action: String):
	if sound_data.has(category) and sound_data[category].has(type) and sound_data[category][type].has(action):
		var sound_info = sound_data[category][type][action]
		
		# Verifica se é o formato novo (dicionário) ou antigo (string)
		if typeof(sound_info) == TYPE_DICTIONARY:
			var sound_path = sound_info.get("path", "")
			var volume = sound_info.get("volume", 0.0)
			
			if sound_path != "":
				AudioManager.play_sfx(sound_path, volume)
				return true
			else:
				print("Caminho de som vazio: ", category, "/", type, "/", action)
				return false
		else:
			# Compatibilidade com formato antigo (string direta)
			AudioManager.play_sfx(sound_info)
			return true
	else:
		print("Som não encontrado: ", category, "/", type, "/", action)
		return false
		
# Variável para controle global do volume da música
var global_music_volume_offset: float = 0.0

func set_global_music_volume_offset(offset_db: float):
	global_music_volume_offset = offset_db
	# Aplica o novo volume à música atual
	if AudioManager.music_player.playing:
		var current_music_type = get_current_music_type()
		if current_music_type != "":
			apply_volume_to_current_music(current_music_type)

func apply_volume_to_current_music(music_type: String):
	if music_data.has(music_type):
		var base_volume = music_data[music_type]["volume"]
		var final_volume = base_volume + global_music_volume_offset
		AudioManager.music_player.volume_db = final_volume

# Função auxiliar para identificar a música atual (você pode implementar conforme sua necessidade)
func get_current_music_type() -> String:
	# Implementar lógica para identificar qual música está tocando
	return "background" # placeholder

## round
## Rich Text Label
## [b][font_size=11]Texto[/font_size][/b]  - Font Retro Gaming 
## [shake rate=5 level=10] Texto Tremendo [/shake]
## [rainbow]Texto arco-íris[/rainbow]
## [pulse freq=1.0 color=#ffffff40 ease=-2.0]Texto pulsante[/pulse]
## [wave amp=50 freq=2]Texto ondulado[/wave]
## [tornado radius=5 freq=10]Texto ondulado[/tornado]
## [color=#hex]trocar a cor[/color]

		#"text_box": {
			#"show": true,
			#"title": "Prontos para a batalha gatinhos?",
			#"message": "Slimes Chiclete à vista! Eles grudam no chão e na natureza. Cartolina nem chega perto deles... imagina se gruda no rabo?"
		#}

var waves = {
	"wave1": {
		"enemies": [
			["Papel", 2],
			["Papel", 2],
			["Papel", 2],
			["Papel", 2],
		]
	},
	
	"wave2": {
		"enemies": [
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
			["Papel", 4],
			["Papel", 1],
			["Papel", 1],
			["Papel", 1],
		],
	},
	
	"wave3": {
		"enemies": [
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", 2],
			["Chiclete", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
		],
	},
	
	"wave4": {
		"enemies": [
			["Chiclete", 1],
			["Papel", 1.5],
			["Chiclete", 1],
			["Papel", 1.5],
			["Chiclete", 1],
			["Papel", 1.5],
			["Chiclete", 1],
			["Papel", 1.5],
			["Chiclete", 1],
		],
		"text_box": {
			"show": true,
			"title": "O que foi essa coisa rosa que passou aqui?",
			"message": "Acho que foi um Slime Chiclete... Cartolina vai ficar longe, vai que gruda no rabo dele..."
		}
	},
	
	"wave5": {
		"enemies": [
			["Chiclete", .4],
			["Chiclete", .4],
			["Papel", 1.5],
			["Chiclete", .4],
			["Chiclete", .4],
			["Papel", 1.5],
			["Chiclete", .4],
			["Chiclete", .4],
			["Papel", 1.5],
		],
	},
	
	"wave6": {
		"enemies": [
			["Chiclete", .2],
			["Chiclete", .2],
			["Chiclete", .2],
			["Chiclete", .2],
			["Chiclete", .2],
			["Chiclete", .2],
		],
	},
	
	"wave7": {
		"enemies": [
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Chiclete", .3],
			["Pilha", 0],
		],
		"text_box": {
			"show": true,
			"title": "E nao é que eles grudam mesmo??",
			"message": "Mas algo pior está vindo, o Slime Pilha. Melhor Chicão não gritar perto deles para não energiza-los ainda mais!"
		}
	},
	
	"wave8": {
		"enemies": [
			["Pilha", 0],
			["Chiclete", 1],
			["Papel", 1.5],
			["Pilha", 0],
			["Chiclete", 1],
			["Papel", 1.5],
			["Pilha", 0],
			["Chiclete", 1],
			["Papel", 1.5],
			["Chiclete", .4],
		],
	},
	
	"wave9": {
		"enemies": [
			["Pilha", 2],
			["Pilha", 2],
			["Pilha", 2],
			["Pilha", 2],
			["Papel", 1],
			["Pilha", 2],
			["Pilha", 2],
			["Pilha", 2],
			["Pilha", 2],
		],
	},
	
	"wave10": { 
		"enemies": [
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Pilha", 3],
		],
	},
	
	"wave11": { 
		"enemies": [
			["Plastico", 0.5],
			["Plastico", 0.5],
			["Pilha", .5],
			["Plastico", 0.5],
			["Plastico", 0.5],
			["Pilha", .5],
			["Plastico", 0.5],
			["Plastico", 0.5],
			["Pilha", .5],
			["Plastico", 0.5],
			["Plastico", 0.5],

		],
	},
	
	"wave12": { ## Água e eletricidade não combinam! 
		"enemies": [
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
			["Plastico", 0.2],
		],
			"text_box": {
			"show": true,
			"title": "Água e eletricidade não combinam!",
			"message": "Não sei o que é pior, isso ou um tsunami de Slime Plástico!"
		}
	},
	
	"wave13": { ##
		"enemies": [
			["Papel", 0.5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Plastico", .5],
			["Plastico", .5],
			["Papel", 0.5],
			["Pilha", 4],
			["Papel", 0.5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Plastico", .5],
			["Plastico", .5],
			["Papel", 0.5],
			["Pilha", 3],
			["Papel", 0.5],
			["Chiclete", 1],
			["Chiclete", .5],
			["Plastico", .5],
			["Plastico", .5],
			["Papel", 0.5],
			["Pilha", 1],
		],
	},
	
	"wave14": {
		"enemies": [
			["Metal", 1],
			["Metal", 1],
			["Metal", 1],
			["Metal", 1],
			["Metal", 1],
			["Metal", 1],
			["Metal", 1],
			["Pilha", 2],

		],
	},
	
	"wave15": {
		"enemies": [
			["Metal", .5],
			["Metal", .5],
			["Metal", .5],
			["Metal", .5],
			["Metal", .5],
			["Metal", .5],
			["Metal", .5],
			["Pilha", 2],
		],
			"text_box": {
			"show": true,
			"title": "Ferro velho ambulante à vista!",
			"message": "O Slime Metal pode parecer durão, mas todo metal pode ser derretido... ou arranhado até virar pó!"
		}
	},
	
	"wave16": {
		"enemies": [
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
			["Papel", .5],
			["Metal", .5],
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
			["Papel", .5],
		],
	},
	
	"wave17": {  
		"enemies": [
			["Metal", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["Metal", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["Metal", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["Metal", .5],
		],
			"text_box": {
			"show": true,
			"title": "Estou começando a me sentir estranho...",
			"message": "Culpa do o Slime Radioativo! Pelé odeia radiação, ele nem vai chegar perto!"
		}
	},
	
	"wave18": { ##  Olha quem chegou... Maldito Slime Radioativo!
		"enemies": [
			["Radioativo", .5],
			["Radioativo", .5],
			["Pilha", 3],
			["Radioativo", .5],
			["Radioativo", .5],
			["Pilha", 3],
			["Radioativo", .5],
			["Radioativo", .5],
			["Pilha", 3],
			["Radioativo", .5],
			["Radioativo", .5],
			["Pilha", 3],
		]
	},
	
	"wave19": {
		"enemies": [
			["Radioativo", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["Metal", .5],
			["Metal", .5],
			["Metal", 2],
			["Plastico", .5],
			["Plastico", .5],
			["Plastico", .5],
			["Plastico", 2],
			["Chiclete", .5],
			["Chiclete", .5],
			["Chiclete", .5],
			["Chiclete", 2],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", 5],
			["Pilha", .5],
			["Pilha", .5],

		],
	},
	
	"wave20": {  
		"enemies": [
			["Radioativo", 4],
			["BossPneu", .5],
			["BossRadioativo", 2],
		],
		"text_box": {
			"show": true,
			"title": "[shake rate=20 level=10] Das profundezas do lixão, ele surge... [/shake]",
			"message": "Revestido de borracha e sede de destruição.  [b][font_size=11][shake rate=20 level=10]O Chefão Pneu[/shake][/font_size][/b] desafia até os mais corajosos!"
		}
	},
	
	"wave21": {
		"enemies": [
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 3],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
			["Plastico", 1],
			["Radioativo", 1],
		],
	},
	
	"wave22": {
		"enemies": [
			["Papel", 1],
			["Pilha", .2],
			["Chiclete", .5],
			["Pilha", .2],
			["Pilha", .2],
			["Radioativo", .2],
			["Radioativo", .2],
			["Radioativo", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Chiclete", .5],
			["Pilha", .2],
			["Pilha", .2],
		],
	},
	
	"wave23": {
		"enemies": [
			["BossPneu", 2],
			["Metal", 10],
			["BossPneu", 2],
			["Metal", 1],
		],
	},
	
	"wave24": { 
		"enemies": [
			["Radioativo", .5],
			["Radioativo", 1],
			["Radioativo", 1.5],
			["Metal", 1],
			["Chiclete", .5],
			["Papel", .5],
			["Chiclete", .5],
			["Metal", 1],
			["Chiclete", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Papel", .5],
			["Chiclete", .5],
			["Metal", 1],
			["Chiclete", .5],
			["Papel", .5],
			["Chiclete", .5],
			["Metal", 1],
			["Radioativo", .5],
			["Radioativo", 1],
			["Radioativo", 1.5],
		],
	},
	
	"wave25": { ## Boss Radioativo ## To me sentindo meio estranho... Tem algo vindo... que t-t-temos um problema Gatinhos!
		"enemies": [
			["BossRadioativo", .5],
		],
			"text_box": {
			"show": true,
			"title": "[wave rate=20 level=10][color=#14a02e]Atenção: níveis de radiação subindo! [/color][/wave]",
			"message": "To me sentindo meio estranho... Preparem os EPI’s e as garras, [b][font_size=11][wave rate=20 level=10][color=#14a02e]Chefão Radioativo[/color][/wave][/font_size][/b] chegando!"
		}
	},
	
	"wave26": {
		"enemies": [
			["BossRadioativo", 5],
			["Radioativo", 1],
			["Radioativo", 1],
			["Radioativo", 1],
			["Radioativo", 1],
			["Radioativo", 1],
			["Radioativo", 1],
		],
	},
	
	"wave27": {
		"enemies": [
			["Chiclete", 1.5],
			["Chiclete", 1.5],
			["Chiclete", .1],
			["BossPneu", 2],
			["Pilha", 1.5],
			["Chiclete", 1.5],
			["Chiclete", 1.5],
			["Chiclete", 1.5],
		],
	},
	
	"wave28": {
		"enemies": [
			["BossRadioativo", 5],
			["Papel", .2],
			["Papel", .2],
			["Papel", .2],
			["Papel", .2],
			["Plastico", .2],
			["Plastico", .2],
			["Plastico", .2],
			["Plastico", 5],
			["BossRadioativo", 5],
			["Papel", .2],
			["Papel", .2],
			["Papel", .2],
			["Papel", .2],
			["Plastico", .2],
			["Plastico", .2],
			["Plastico", .2],
			["Plastico", .2],
		],
	},
	
	"wave29": {
		"enemies": [
			["Pilha", .2],
			["Pilha", 5],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", 5],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", 5],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", .2],
			["Pilha", 5],
		],
			"text_box": {
			"show": true,
			"title": "Meu Deus, que perigo!",
			"message": "Dois [b][font_size=11][wave rate=20 level=10][color=#14a02e]Chefões Radioativos[/color][/wave][/font_size][/b] foi de mais pra mim... imagina se aparecem 2 de cada Chefão..."
		}
	},
	
	"wave30": { ## Boss Radioativo ## To me sentindo meio estranho... Tem algo vindo... que t-t-temos um problema Gatinhos!
		"enemies": [
			["BossPneu", 3],
			["BossPneu", 3],
			["Radioativo", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["Radioativo", .5],
			["BossRadioativo", 3],
			["BossRadioativo", 5],
			["Pilha", 1],
			["Pilha", 1],
			["Pilha", 1],
			["Pilha", 1],
		],
			"text_box": {
			"show": true,
			"title": "Atenção, tropas felinas!",
			"message": "Vamos tirar esse lixo do mapa de uma vez por todas. Últimos inimigos chegando, força máxima!"
		}
	},
}

var random_phrases = {
	"phrase1": {
		"title": "1 milhão de sacolas por minuto. Socorro!",
		"message": "É isso mesmo. E muitas vão parar em rios e oceanos. Tá na hora de mudar isso aí.",
		"show_close": true
	},
	"phrase2": {
		"title": "400 anos de preguiça? Nem eu aguento!",
		"message": "Um pedaço de plástico pode demorar até 400 anos pra desaparecer da natureza. Nem eu, com sete vidas, esperaria tudo isso.",
		"show_close": true
	},
	"phrase3": {
		"title": "Quer reciclar? Dá um banho primeiro.",
		"message": "Tampinhas e potes limpos podem ser reciclados e reaproveitados. Mas sujos? Acabam indo pro lixo comum e viram slime fedido.",
		"show_close": true
	},
	"phrase4": {
		"title": "Plástico no chão não vira brinquedo",
		"message": "Se for pro lugar certo, o plástico vira coisa útil. No chão, vira vergonha e sujeira.",
		"show_close": true
	},
	"phrase5": {
		"title": "Uma latinha, três horas de sofá!", ## Arrumar
		"message": "Reciclar uma lata de alumínio economiza energia suficiente para manter uma TV ligada por 3 horas!",
		"show_close": true
	},
	"phrase7": {
		"title": "Papel bom é papel com sete vidas",
		"message": "O papel pode ser reciclado até 7 vezes, é quase um gato de papel!",
		"show_close": true
	},
	"phrase8": {
		"title": "Árvores em pé, gatinhos felizes",
		"message": "Reciclar papel evita o corte de árvores. E eu amo árvores. Especialmente pra subir nelas.",
		"show_close": true
	},
	"phrase9": {
		"title": "Sete anos de azar e ainda machuca",
		"message": "Vidro quebrado no lixo comum é perigoso, depois alguem se machuca querem reclamar comigo por dar azar!",
		"show_close": true
	},
	"phrase10": {
		"title": "As vezes ",
		"message": "Vidro quebrado no lixo comum é perigoso, depois alguem se machuca querem reclamar comigo por dar azar!",
		"show_close": true
	},
	"phrase11": {
		"title": "O lixo não some, ele só troca de cenário",
		"message": "Cada coisa no lugar certo evita que o lixo vá parar no lugar errado. Tipo dentro de um peixinho",
		"show_close": true
	},
	"phrase12": {
		"title": "Reciclar é evoluir, tipo Pokémon!",
		"message": "Quando recicla, o material pode virar algo novo. Evolução pura, sem precisar de pedra da lua.",
		"show_close": true
	},
	"phrase13": {
		"title": "Você Sabia?",
		"message": "G.A.T.I.N.H.O.S. significa Grupo Acadêmico de Táticas Inteligentes para Neutralizar Horríveis Objetos Sujos, legal né?",
		"show_close": true
	},
	"phrase14": {
		"title": "Você Sabia?",
		"message": "Reciclando, uma latinha vira outra em até 60 dias. Sem reciclagem, ela só enferruja e atrapalha.",
		"show_close": true
	}
}

var has_won_once: bool = false

var tutorial_data = {
	"tutorial_1": {
		"title": "Seja bem-vind@!",
		"message": "Nós cansamos da inércia humana e vamos resolver o problema do lixo com nossas patinhas!",
		"type": "info",
		"required_action": "start",
		"button_text": "Eu posso ajudar?",
		"show_close": false,
		"next_step": "tutorial_2"
	},
	"tutorial_2": {
		"title": "Pode, mas cuidado!",
		"message": "Os slimes de lixo estão vindo pela estrada à esquerda! Prepare-se para defender nosso planeta!",
		"type": "info",
		"required_action": "start",
		"button_text": "O que eu faço?",
		"show_close": false,
		"next_step": "tutorial_3"
	},
	"tutorial_3": {
		"title": "Recrute um gatinho!",
		"message": "Clique no ícone da Loja de Gato, clique em um gato, veja seus detalhes, compre e posicione-o perto do caminho!",
		"type": "action_required",
		"required_action": "place_cat",
		"button_text": "Certo!",
		"show_close": false,
		"next_step": "tutorial_4"
	},
	"tutorial_4": {
		"title": "Perfeito! Chegou a hora de fortaleçer seus guerreiros!",
		"message": "Clique no ícone da Loja de Cartas, abra um pacote, arraste-a para o gato, clique nele e veja ele se tornando mais forte!",
		"type": "action_required",
		"required_action": "equip_card",
		"button_text": "Beleza!",
		"show_close": false,
		"next_step": "tutorial_5"
	},
	"tutorial_5": {
		"title": "Ótimo, Agora inicie a batalha!",
		"message": "Clique no ícone Play no canto superior direito para começar a primeira onda de inimigos!",
		"type": "action_required",
		"required_action": "start_wave",
		"button_text": "Vamos lá!",
		"show_close": false,
		"next_step": "tutorial_complete"
	}
}

# Adicione estas variáveis de controle do tutorial:
var tutorial_active: bool = false
var current_tutorial_step: String = ""
var tutorial_step_completed: bool = false

func should_start_tutorial() -> bool:
	return not has_won_once

func should_show_textbox(wave_number: int) -> bool:
	if tutorial_active:
		return false
	
	if not has_won_once:
		return false
	
	var wave_key = "wave" + str(wave_number)
	var wave_data = waves.get(wave_key, {})
	return wave_data.has("text_box") and wave_data["text_box"].get("show", false)
	
func start_tutorial():
	tutorial_active = true
	current_tutorial_step = "tutorial_1"
	tutorial_step_completed = false

func get_current_tutorial_data() -> Dictionary:
	return tutorial_data.get(current_tutorial_step, {})

func advance_tutorial():
	var current_data = get_current_tutorial_data()
	var next_step = current_data.get("next_step", "")
	
	if next_step == "tutorial_complete":
		complete_tutorial()
	else:
		current_tutorial_step = next_step
		tutorial_step_completed = false

func complete_tutorial_action(action: String):
	# Não desativar o tutorial aqui, apenas marcar como completo
	tutorial_step_completed = true



func complete_tutorial():
	tutorial_active = false
	tutorial_completed = true
	save_game_data()

func is_tutorial_blocking_action(action: String) -> bool:
	if not tutorial_active:
		return false
	
	var current_data = get_current_tutorial_data()
	var required_action = current_data.get("required_action", "")
	
	# Se há uma ação requerida e não é a ação atual, bloqueia
	if required_action != "" and required_action != action:
		return true
	
	return false

func get_textbox_data(wave_number: int) -> Dictionary:
	# Se não venceu ainda, retorna vazio
	if not has_won_once:
		return {}
	
	var wave_key = "wave" + str(wave_number)
	var wave_data = waves.get(wave_key, {})
	
	# Se a wave tem textbox configurado, usa ele
	if wave_data.has("text_box") and wave_data["text_box"].get("show", false):
		return wave_data["text_box"]
	
	# Senão, usa uma frase aleatória ocasionalmente
	if randf() < 0.3: # 30% de chance de mostrar frase aleatória
		var phrase_keys = random_phrases.keys()
		var random_key = phrase_keys[randi() % phrase_keys.size()]
		return random_phrases[random_key]
	
	return {}
