extends Node

var default_fish_quantity = 500
var fish_quantity: int = default_fish_quantity  # Valor inicial de moedas

## Fish
func reset_fish_quantity():
	fish_quantity = default_fish_quantity

## Cats
var cat_data = { ## "Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo"
	"Chicao": { ## Chicão não ataca slimes pilha pra não dar ainda mais energia pra eles
		"name": "Chicao",
		"sprite": "res://Assets/Cats/Chicao/Chicao.png",
		"damage": 30,
		"atkcooldown": 2,
		"range": 160,
		"cost": 50,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Pele": { ## Apesar de afiada, as garras de Pelé não conseguem destruir o Slime Metal
		"name": "Pele",
		"sprite": "res://Assets/Cats/Pele/Pele.png",
		"damage": 15,
		"atkcooldown": 1.5,
		"range": 96,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Nino": { ## Nino não consegue ver o slime de plástico com um olho só por conta da sua trasparência
		"name": "Nino",
		"sprite": "res://Assets/Cats/Nino/Nino.png",
		"damage": 35,
		"atkcooldown": 2.5,
		"range": 160,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Cartolina": { ## Cartolina não bate no slime de chiclete, seria horrivel ter chiclete em seus pelos
		"name": "Cartolina",
		"sprite": "res://Assets/Cats/Cartolina/Cartolina.png",
		"damage": 20,
		"atkcooldown": 1.8,
		"range": 96,
		"cost": 200,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
	},
	
	"Nut": { ## Os novelos de lã de nut não passam de carinhos no slime metal, então ele nem gasta sua lã com ele
		"name": "Nut",
		"sprite": "res://Assets/Cats/Nut/Nut.png",
		"damage": 15,
		"atkcooldown": 2,
		"range": 128,
		"cost": 250,
		"critical_chance": 0,
		"target_types": ["Plastico", "Metal", "Pilha", "Chiclete", "BossRadioativo", "Papel", "Radioativo"]
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
		"speed": 60,
		"hp": 15,
		"fish_reward": 8
	},
	"Chiclete": {
		"damage": 8,
		"speed": 48,
		"hp": 35,
		"fish_reward": 12
	},
	"Plastico": {
		"damage": 15,
		"speed": 64,
		"hp": 60,
		"fish_reward": 18
	},
	"Metal": {
		"damage": 15,
		"speed": 40,
		"hp": 80,
		"fish_reward": 25
	},
	"Pilha": {
		"damage": 20,
		"speed": 88,
		"hp": 45,
		"fish_reward": 30
	},
	"Radioativo": {
		"damage": 25,
		"speed": 56,
		"hp": 120,
		"fish_reward": 40
	},
	"BossRadioativo": {
		"damage": 80,
		"speed": 32,
		"hp": 500,
		"fish_reward": 200
	},
	"BossPneu": {
		"damage": 80,
		"speed": 68,
		"hp": 300,
		"fish_reward": 150
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
			"icon": "res://Assets/Icons/Cards/Tartaruga-icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 50, "power_type": "percentage"}
			],
			"sell_value": "25"
		}
		,{
			"name": "Sou do Rock",
			"description": "Ouviu muito Heavy Metal e agora causa 35% de dano bônus em Slimes Metal",
			"icon": "res://Assets/Icons/Cards/rock-icon.png",
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
			"name": "Ritmo do Ronronar II",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +15% de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 20, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do Patê I",
			"description": "Esse gato está ficando com fome, quer acabar com isso logo - Ganha 20% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
			"effects": [
				{"type": "range_boost", "power": 15, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Pré-treino Radioativo I",
			"description": "Tomou uma substância verde esquisita que encontrou, agora tem 20% de chance de crítico",
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 20, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Veterano de Guerra I",
			"description": "Você não quer saber o que esse gato ja viveu... - 20% mais dano contra todos os slimes comuns",
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 20, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência I",
			"description": "Não aguenta mais, só quer que isso acabe logo. Bate 20% mais rápido",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 20, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope I",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 40% mais rápido porém perde 30% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
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
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 30, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar II",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +30% de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 30, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do Patê II",
			"description": "Esse gato está com tanta fome que vai fazer de tudo para acabar a partida mais rápido, ganha 35% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
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
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 30, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 30, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência II",
			"description": "Não aguenta mais, só quer que isso acabe logo. Bate 40% mais rápido",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope II",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 60% mais rápido porém perde 40% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
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
			"icon": "res://Assets/Icons/Cards/Pre-Treino-icon.png",
			"effects": [
				{"type": "critic_boost", "power": 50, "power_type": "absolute"}
			],
			"sell_value": "100"
		}
		,{
			"name": "Ritmo do Ronronar III",
			"description": "Quanto mais ronrona, mais rápido bate! Ganha +40% de velocidade de ataque",
			"icon": "res://Assets/Icons/Cards/ronronar-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 40, "power_type": "percentage"},
			],
			"sell_value": "100"
		}
		,{
			"name": "Hora do Patê III",
			"description": "Esse gato está quer devorar tudo que vê pela frente, +50% de alcance",
			"icon": "res://Assets/Icons/Cards/Sache-Icon.png",
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
			"icon": "res://Assets/Icons/Cards/Veterano-Guerra-Icon.png",
			"effects": [
				{"type": "damage_vs_type", "target_type": "Plastico", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Metal", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Pilha", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "Chiclete", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossRadioativo", "power": 60, "power_type": "percentage"},
				{"type": "damage_vs_type", "target_type": "BossPneu", "power": 60, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Sem Paciência III",
			"description": "Não aguenta mais, só quer que isso acabe logo. Bate 60% mais rápido",
			"icon": "res://Assets/Icons/Cards/Sem paciencia-icon.png",
			"effects": [
				{"type": "speed_boost", "power": 60, "power_type": "percentage"}
		],
			"sell_value": "25"
		}
		,{
			"name": "Gato Míope III",
			"description": "Não enxerga longe mas compensa com ataques rápidos - Ataca 100% mais rápido porém perde 60% de Alcance",
			"icon": "res://Assets/Icons/Cards/GatoMiope-Icon.png",
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
			"tutorial_completed": tutorial_completed,
			"music_volume": music_volume,
			"sfx_volume": sfx_volume
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
				music_volume = save_data.get("music_volume", 1.0)
				sfx_volume = save_data.get("sfx_volume", 1.0)
				
				# Aplicar volumes salvos APENAS se os buses existirem
				call_deferred("apply_saved_volumes")
				
				print("Dados carregados: tutorial_completed = ", tutorial_completed)
				print("Volumes carregados - Música: ", music_volume, " SFX: ", sfx_volume)
			else:
				print("Erro ao fazer parse do JSON")
		else:
			print("Erro ao abrir arquivo de save")
	else:
		print("Arquivo de save não existe, usando valores padrão")

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
func mark_tutorial_completed():
	tutorial_completed = true
	save_game_data()
	print("Tutorial marcado como completo e salvo")

# NOVA FUNÇÃO: Para mostrar tutorial manualmente (botão de ajuda)
func show_tutorial_manually():
	print("Tutorial solicitado manualmente pelo jogador")

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
			"death": {"path": "", "volume": 0},
			"walk": {"path": "", "volume": 0}
		},
		"Radioativo": {
			"death": {"path": "", "volume": 0},
			"walk": {"path": "", "volume": 0}
		},
		"BossRadioativo": {
			"death": {"path": "", "volume": 0},
			"walk": {"path": "", "volume": 0}
		},
		"BossPneu": {
			"death": {"path": "", "volume": 0},
			"walk": {"path": "", "volume": 0}
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
			"click": {"path": "res://Audio/UI/593955__mincedbeats__mouse-button-click.ogg", "volume": 0},
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
			["Metal", 1.5],
		],
		"text_box": {
			"show": true,
			"title": "Prontos para a batalha gatinhos?",
			"message": "Slimes Chiclete à vista! Eles grudam no chão e na natureza. Cartolina nem chega perto deles... imagina se gruda no rabo?"
		}
	},
	
	"wave2": {
		"enemies": [
			["Papel", 1.2],
			["Papel", 1.2],
			["Papel", 1.2],
			["Papel", 1.2],
			["Papel", 2],
			["Papel", 1.2],
			["Papel", 1.2],
			["Papel", 1.2],
			["Papel", 1.2],
		],
	},
	
	"wave3": {
		"enemies": [
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", 2],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", .8],
			["Papel", 2],
			["Papel", 3],

		],
	},
	
	"wave4": {
		"enemies": [
			["Papel", 1],
			["Papel", 0.5],
			["Papel", 0.5],
			["Papel", 0.5],
			["Papel", 0.5],
			["Papel", 0.5],
			["Papel", 0.5],
			["Papel", 0.5],
			["Chiclete", .2],
			["Papel", .5],
			["Papel", 0.5],
			["Papel", .5],
			["Papel", .5],
		],
	},
	
	"wave5": { ## Introduz chiclete
		"enemies": [
			["Papel", 1.5],
			["Papel", 1.2],
			["Chiclete", 3],
			["Papel", 1],
			["Papel", 1.2],
			["Chiclete", 2.8],
			["Papel", 1.5],
			["Papel", 1.8],
		],
	},
	
	"wave6": { ## Chiclete com papel
		"enemies": [
			["Chiclete", 2],
			["Papel", 1],
			["Papel", 0.8],
			["Chiclete", 1.8],
			["Papel", 0.8],
			["Papel", 1],
			["Chiclete", 2.2],
			["Papel", 1.2],
			["Papel", 1],
			["Chiclete", 2.5],
		],
	},
	
	"wave7": { ## Mais chiclete
		"enemies": [
			["Papel", 0.8],
			["Chiclete", 1.5],
			["Papel", 0.6],
			["Chiclete", 1.2],
			["Papel", 0.8],
			["Chiclete", 1.5],
			["Papel", 0.6],
			["Chiclete", 1.8],
			["Papel", 1],
			["Chiclete", 2],
			["Papel", 1.2],
		],
	},
	
	"wave8": { ## Enxame misto
		"enemies": [
			["Chiclete", 1.2],
			["Papel", 0.6],
			["Chiclete", 1],
			["Papel", 0.6],
			["Chiclete", 1.2],
			["Papel", 0.5],
			["Chiclete", 1],
			["Papel", 0.6],
			["Chiclete", 1.5],
			["Papel", 0.8],
			["Chiclete", 1.2],
			["Papel", 1],
		],
	},
	
	"wave9": { ## Dominância chiclete
		"enemies": [
			["Chiclete", 1],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Chiclete", 1],
			["Chiclete", 0.8],
			["Papel", 0.5],
			["Chiclete", 1.2],
			["Chiclete", 1],
			["Papel", 0.8],
			["Chiclete", 1.5],
			["Chiclete", 1.2],
			["Papel", 1],
		],
	},
	
	"wave10": { ## Tsunami chiclete
		"enemies": [
			["Chiclete", 0.8],
			["Chiclete", 0.6],
			["Chiclete", 0.8],
			["Papel", 0.5],
			["Chiclete", 0.6],
			["Chiclete", 0.8],
			["Chiclete", 0.6],
			["Papel", 0.5],
			["Chiclete", 0.8],
			["Chiclete", 1],
			["Chiclete", 0.8],
			["Chiclete", 1.2],
			["Papel", 0.8],
		],
	},
	
	"wave11": { ## Preparação para novo inimigo
		"enemies": [
			["Papel", 0.8],
			["Chiclete", 1],
			["Papel", 0.6],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Chiclete", 1],
			["Papel", 0.8],
			["Chiclete", 1.2],
			["Papel", 0.6],
			["Chiclete", 1],
			["Papel", 0.8],
			["Chiclete", 1.5],
			["Papel", 1],
		],
	},
	
	"wave12": { ## Introduz plástico
		"enemies": [
			["Plastico", 4],
			["Papel", 1],
			["Chiclete", 1.2],
			["Plastico", 3.5],
			["Papel", 0.8],
			["Chiclete", 1],
			["Plastico", 4.2],
			["Chiclete", 1.5],
			["Papel", 1.2],
		],
	},
	
	"wave13": { ## Plástico com escolta
		"enemies": [
			["Papel", 0.8],
			["Chiclete", 1],
			["Plastico", 3],
			["Papel", 0.6],
			["Chiclete", 0.8],
			["Plastico", 2.8],
			["Papel", 0.8],
			["Chiclete", 1.2],
			["Plastico", 3.2],
			["Papel", 1],
			["Chiclete", 1.5],
		],
	},
	
	"wave14": { ## Mais plástico
		"enemies": [
			["Plastico", 2.5],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Plastico", 2.2],
			["Chiclete", 0.8],
			["Papel", 0.5],
			["Plastico", 2.8],
			["Chiclete", 1],
			["Papel", 0.8],
			["Plastico", 3],
			["Chiclete", 1.2],
			["Papel", 1],
		],
	},
	
	"wave15": { ## Trinca estabelecida
		"enemies": [
			["Plastico", 2],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Plastico", 1.8],
			["Chiclete", 0.6],
			["Papel", 0.5],
			["Plastico", 2.2],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Plastico", 2.5],
			["Chiclete", 1],
			["Papel", 0.8],
			["Plastico", 2.8],
		],
	},
	
	"wave16": { ## Enxame plástico
		"enemies": [
			["Plastico", 1.5],
			["Plastico", 1.2],
			["Chiclete", 0.8],
			["Plastico", 1],
			["Plastico", 1.2],
			["Papel", 0.6],
			["Plastico", 1.5],
			["Plastico", 1.8],
			["Chiclete", 1],
			["Plastico", 1.2],
			["Plastico", 1.5],
			["Papel", 0.8],
		],
	},
	
	"wave17": { ## Velocidade plástica
		"enemies": [
			["Plastico", 1.2],
			["Chiclete", 0.6],
			["Plastico", 1],
			["Papel", 0.5],
			["Plastico", 1.2],
			["Chiclete", 0.6],
			["Plastico", 1],
			["Papel", 0.5],
			["Plastico", 1.5],
			["Chiclete", 0.8],
			["Plastico", 1.2],
			["Papel", 0.6],
			["Plastico", 1.8],
		],
	},
	
	"wave18": { ## Tsunami plástico
		"enemies": [
			["Plastico", 1],
			["Plastico", 0.8],
			["Plastico", 1],
			["Chiclete", 0.6],
			["Plastico", 0.8],
			["Plastico", 1],
			["Plastico", 0.8],
			["Papel", 0.5],
			["Plastico", 1],
			["Plastico", 1.2],
			["Plastico", 1],
			["Chiclete", 0.8],
			["Plastico", 1.5],
		],
	},
	
	"wave19": { ## Preparação metal
		"enemies": [
			["Chiclete", 0.8],
			["Plastico", 1.2],
			["Papel", 0.6],
			["Chiclete", 0.6],
			["Plastico", 1],
			["Papel", 0.5],
			["Chiclete", 0.8],
			["Plastico", 1.5],
			["Papel", 0.6],
			["Chiclete", 1],
			["Plastico", 1.8],
			["Papel", 0.8],
			["Chiclete", 1.2],
		],
	},
	
	"wave20": { ## Introduz metal
		"enemies": [
			["Metal", 5],
			["Papel", 0.8],
			["Chiclete", 1],
			["Metal", 4.5],
			["Plastico", 1.5],
			["Metal", 5.2],
			["Chiclete", 1.2],
			["Metal", 4.8],
			["Papel", 1],
		],
	},
	
	"wave21": { ## Metal com proteção
		"enemies": [
			["Papel", 0.6],
			["Chiclete", 0.8],
			["Metal", 4],
			["Plastico", 1.2],
			["Papel", 0.6],
			["Metal", 3.8],
			["Chiclete", 1],
			["Plastico", 1.5],
			["Metal", 4.2],
			["Papel", 0.8],
			["Chiclete", 1.2],
		],
	},
	
	"wave22": { ## Mais metal
		"enemies": [
			["Metal", 3.5],
			["Plastico", 1],
			["Chiclete", 0.8],
			["Metal", 3.2],
			["Papel", 0.6],
			["Metal", 3.8],
			["Plastico", 1.2],
			["Chiclete", 1],
			["Metal", 4],
			["Papel", 0.8],
			["Metal", 4.5],
		],
	},
	
	"wave23": { ## Quarteto estabelecido
		"enemies": [
			["Metal", 3],
			["Plastico", 1],
			["Chiclete", 0.6],
			["Papel", 0.5],
			["Metal", 2.8],
			["Plastico", 1.2],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Metal", 3.2],
			["Plastico", 1.5],
			["Chiclete", 1],
			["Papel", 0.8],
			["Metal", 3.5],
		],
	},
	
	"wave24": { ## Resistência crescente
		"enemies": [
			["Metal", 2.5],
			["Metal", 2.2],
			["Plastico", 1],
			["Metal", 2.8],
			["Chiclete", 0.8],
			["Metal", 2.5],
			["Plastico", 1.2],
			["Metal", 3],
			["Chiclete", 1],
			["Metal", 2.8],
			["Papel", 0.6],
			["Metal", 3.2],
		],
	},
	
	"wave25": { ## Enxame metálico
		"enemies": [
			["Metal", 2],
			["Metal", 1.8],
			["Metal", 2.2],
			["Plastico", 1],
			["Metal", 1.8],
			["Metal", 2],
			["Chiclete", 0.8],
			["Metal", 2.5],
			["Metal", 2.2],
			["Papel", 0.6],
			["Metal", 2.8],
			["Metal", 3],
		],
	},
	
	"wave26": { ## Preparação surpresa
		"enemies": [
			["Plastico", 1.2],
			["Metal", 2.5],
			["Chiclete", 0.8],
			["Plastico", 1],
			["Metal", 2.2],
			["Papel", 0.6],
			["Plastico", 1.5],
			["Metal", 2.8],
			["Chiclete", 1],
			["Papel", 0.8],
			["Metal", 3],
			["Plastico", 1.8],
		],
	},
	
	"wave27": { ## SURPRESA! Primeira pilha
		"enemies": [
			["Metal", 2.5],
			["Plastico", 1.2],
			["Chiclete", 0.8],
			["Metal", 2.2],
			["Papel", 0.6],
			["Pilha", 8], ## SURPRESA! Delay longo para pegar desprevenido
			["Metal", 2.8],
			["Plastico", 1.5],
			["Chiclete", 1],
		],
	},
	
	"wave28": { ## Pilha com escolta
		"enemies": [
			["Papel", 0.6],
			["Chiclete", 0.8],
			["Pilha", 4.5],
			["Metal", 2.5],
			["Plastico", 1.2],
			["Pilha", 4.2],
			["Chiclete", 1],
			["Metal", 2.8],
			["Pilha", 4.8],
			["Papel", 0.8],
		],
	},
	
	"wave29": { ## Mais pilhas
		"enemies": [
			["Pilha", 3.5],
			["Metal", 2],
			["Plastico", 1],
			["Pilha", 3.2],
			["Chiclete", 0.8],
			["Metal", 2.5],
			["Pilha", 3.8],
			["Plastico", 1.2],
			["Chiclete", 1],
			["Pilha", 4],
			["Metal", 2.8],
		],
	},
	
	"wave30": { ## Quinteto completo
		"enemies": [
			["Pilha", 3],
			["Metal", 2],
			["Plastico", 1],
			["Chiclete", 0.6],
			["Papel", 0.5],
			["Pilha", 2.8],
			["Metal", 2.2],
			["Plastico", 1.2],
			["Chiclete", 0.8],
			["Papel", 0.6],
			["Pilha", 3.2],
			["Metal", 2.5],
			["Plastico", 1.5],
		],
	},
	
	"wave31": { ## Velocidade vs resistência
		"enemies": [
			["Pilha", 2.5],
			["Metal", 1.8],
			["Pilha", 2.2],
			["Plastico", 1],
			["Pilha", 2.8],
			["Metal", 2],
			["Pilha", 2.5],
			["Chiclete", 0.8],
			["Pilha", 3],
			["Metal", 2.2],
			["Pilha", 2.8],
			["Plastico", 1.2],
			["Pilha", 3.2],
		],
	},
	
	"wave32": { ## Enxame de pilhas
		"enemies": [
			["Pilha", 2],
			["Pilha", 1.8],
			["Metal", 2.5],
			["Pilha", 1.5],
			["Pilha", 1.8],
			["Plastico", 1],
			["Pilha", 2],
			["Pilha", 2.2],
			["Metal", 2.8],
			["Pilha", 1.8],
			["Pilha", 2],
			["Chiclete", 0.8],
			["Pilha", 2.5],
		],
	},
	
	"wave33": { ## Preparação radioativa
		"enemies": [
			["Metal", 2],
			["Pilha", 2.5],
			["Plastico", 1.2],
			["Metal", 1.8],
			["Pilha", 2.2],
			["Chiclete", 0.8],
			["Metal", 2.5],
			["Pilha", 2.8],
			["Plastico", 1.5],
			["Metal", 2.2],
			["Pilha", 3],
			["Papel", 0.6],
			["Metal", 2.8],
		],
	},
	
	"wave34": { ## Introduz radioativo
		"enemies": [
			["Radioativo", 6],
			["Metal", 2.5],
			["Pilha", 2],
			["Radioativo", 5.5],
			["Plastico", 1.5],
			["Metal", 2.8],
			["Radioativo", 6.2],
			["Pilha", 2.5],
			["Chiclete", 1.2],
		],
	},
	
	"wave35": { ## Radioativo com proteção
		"enemies": [
			["Pilha", 2],
			["Metal", 2.2],
			["Radioativo", 5],
			["Plastico", 1.2],
			["Pilha", 1.8],
			["Radioativo", 4.8],
			["Metal", 2.5],
			["Chiclete", 1],
			["Radioativo", 5.2],
			["Pilha", 2.2],
			["Metal", 2.8],
		],
	},
	
	"wave36": { ## Sexteto completo
		"enemies": [
			["Radioativo", 4.5],
			["Pilha", 1.8],
			["Metal", 2],
			["Plastico", 1],
			["Chiclete", 0.6],
			["Papel", 0.5],
			["Radioativo", 4.2],
			["Pilha", 2],
			["Metal", 2.2],
			["Plastico", 1.2],
			["Chiclete", 0.8],
			["Radioativo", 4.8],
			["Pilha", 2.5],
		],
	},
	
	"wave37": { ## Ameaça radioativa
		"enemies": [
			["Radioativo", 3.8],
			["Metal", 1.8],
			["Radioativo", 3.5],
			["Pilha", 2],
			["Radioativo", 4],
			["Plastico", 1.2],
			["Radioativo", 3.8],
			["Metal", 2.2],
			["Radioativo", 4.2],
			["Pilha", 2.5],
			["Radioativo", 4.5],
			["Chiclete", 1],
		],
	},
	
	"wave38": { ## SURPRESA! Pilha rápida no meio do caos
		"enemies": [
			["Radioativo", 3.5],
			["Metal", 2],
			["Pilha", 1.8],
			["Radioativo", 3.2],
			["Plastico", 1.2],
			["Pilha", 0.5], ## SURPRESA! Pilha super rápida
			["Metal", 2.5],
			["Radioativo", 3.8],
			["Pilha", 2.2],
			["Chiclete", 1],
			["Radioativo", 4],
		],
	},
	
	"wave39": { ## Preparação para boss
		"enemies": [
			["Pilha", 1.8],
			["Radioativo", 3.5],
			["Metal", 2],
			["Pilha", 1.5],
			["Radioativo", 3.2],
			["Plastico", 1.2],
			["Pilha", 2],
			["Metal", 2.5],
			["Radioativo", 3.8],
			["Pilha", 2.2],
			["Chiclete", 1],
			["Radioativo", 4],
			["Metal", 2.8],
		],
	},
	
	"wave40": { ## Primeiro boss - Boss Pneu
		"enemies": [
			["Papel", 0.6],
			["Chiclete", 0.8],
			["Plastico", 1.2],
			["Metal", 2],
			["BossPneu", 6],
			["Pilha", 2],
			["Radioativo", 3.5],
			["Metal", 2.5],
			["Pilha", 2.2],
			["Radioativo", 4],
		],
	},
	
	"wave41": { ## Pós-boss intenso
		"enemies": [
			["Radioativo", 3],
			["Pilha", 1.5],
			["Metal", 1.8],
			["Radioativo", 2.8],
			["Pilha", 1.2],
			["Plastico", 1],
			["Metal", 2],
			["Radioativo", 3.2],
			["Pilha", 1.8],
			["Metal", 2.2],
			["Radioativo", 3.5],
			["Pilha", 2],
			["Chiclete", 0.8],
		],
	},
	
	"wave42": { ## Escalada brutal
		"enemies": [
			["Pilha", 1.2],
			["Radioativo", 2.5],
			["Metal", 1.5],
			["Pilha", 1],
			["Radioativo", 2.2],
			["Plastico", 0.8],
			["Pilha", 1.5],
			["Metal", 1.8],
			["Radioativo", 2.8],
			["Pilha", 1.2],
			["Metal", 2],
			["Radioativo", 3],
			["Pilha", 1.8],
		],
	},
	
	"wave43": { ## Enxame radioativo
		"enemies": [
			["Radioativo", 2.2],
			["Radioativo", 2],
			["Pilha", 1.5],
			["Radioativo", 2.5],
			["Metal", 1.8],
			["Radioativo", 2.2],
			["Radioativo", 2.8],
			["Pilha", 1.2],
			["Radioativo", 2.5],
			["Metal", 2],
			["Radioativo", 3],
			["Pilha", 1.8],
			["Radioativo", 3.2],
		],
	},
	
	"wave44": { ## SURPRESA! Boss Radioativo aparece cedo
		"enemies": [
			["Pilha", 1.5],
			["Radioativo", 2.5],
			["Metal", 1.8],
			["BossRadioativo", 4], ## SURPRESA! Boss aparece no meio
			["Pilha", 1.2],
			["Radioativo", 2.8],
			["Metal", 2],
			["Pilha", 1.8],
			["Radioativo", 3],
		],
	},
	
	"wave45": { ## Dupla ameaça boss
		"enemies": [
			["BossPneu", 3.5],
			["Radioativo", 2.5],
			["Pilha", 1.2],
			["Metal", 1.8],
			["BossRadioativo", 4.5],
			["Pilha", 1.5],
			["Radioativo", 2.8],
			["Metal", 2],
			["Pilha", 1.8],
		],
	},
	
	"wave46": { ## Caos controlado
		"enemies": [
			["Pilha", 1],
			["Radioativo", 1.8],
			["Metal", 1.2],
			["Pilha", 0.8],
			["Radioativo", 1.5],
			["Plastico", 0.8],
			["Pilha", 1.2],
			["Metal", 1.5],
			["Radioativo", 2],
			["Pilha", 1],
			["BossPneu", 3],
			["Radioativo", 2.5],
			["Pilha", 1.5],
		],
	},
	
	"wave47": { ## Preparação final
		"enemies": [
			["BossRadioativo", 3.5],
			["Pilha", 1],
			["Radioativo", 1.8],
			["Metal", 1.2],
			["BossPneu", 3],
			["Pilha", 1.2],
			["Radioativo", 2],
			["Metal", 1.5],
			["Pilha", 1],
			["Radioativo", 2.2],
		],
	},
	
	"wave48": { ## Penúltimo inferno
		"enemies": [
			["Radioativo", 1.5],
			["Pilha", 0.8],
			["BossRadioativo", 2.5],
			["Metal", 1.2],
			["Pilha", 0.6],
			["Radioativo", 1.8],
			["BossPneu", 2.8],
			["Pilha", 1],
			["Metal", 1.5],
			["Radioativo", 2],
			["Pilha", 0.8],
		],
	},
	
	"wave49": { ## Teste supremo
		"enemies": [
			["BossPneu", 2],
			["BossRadioativo", 2.5],
			["Pilha", 0.6],
			["Radioativo", 1.2],
			["Metal", 1],
			["Pilha", 0.5],
			["BossRadioativo", 2.2],
			["Radioativo", 1.5],
			["BossPneu", 2.8],
			["Pilha", 0.8],
			["Radioativo", 1.8],
		],
	},
	
	"wave50": { ## Apocalipse final
		"enemies": [
			["BossRadioativo", 2],
			["BossPneu", 1.8],
			["Pilha", 0.4],
			["Radioativo", 1],
			["BossRadioativo", 1.5],
			["Metal", 0.8],
			["Pilha", 0.4],
			["BossPneu", 2],
			["Radioativo", 1.2],
			["BossRadioativo", 1.8],
			["Pilha", 0.6],
			["BossPneu", 2.2],
			["Radioativo", 1.5],
			["BossRadioativo", 2.5],
		],
	}
}
