extends Control

@export var card_scene: PackedScene = preload("res://Scenes/UIScenes/CardPack.tscn")
var container: Container

func _ready():
	# Pega o container onde as cartas serão adicionadas
	container = $VBoxContainer/HBoxContainer  # Ajuste o caminho conforme sua estrutura
	
	# Gera 3 cartas aleatórias
	var random_cards = generate_3_random_cards()
	
	# Instancia e configura cada carta
	for i in range(3):
		create_and_setup_card(random_cards[i])

func create_and_setup_card(card_data):
	# Instancia a cena da carta
	var card_instance = card_scene.instantiate()
	
	# Adiciona ao container
	container.add_child(card_instance)
	
	# Configura os dados da carta
	setup_card_data(card_instance, card_data)
	
	card_instance.card_selected.connect(_on_card_selected)

func setup_card_data(card_node, card_data):
	# Configura os elementos visuais da carta
	card_node.get_node("MarginContainer/VBoxContainer/CardIcon").texture = load(card_data.icon)
	card_node.get_node("MarginContainer/VBoxContainer/CardName").text = card_data.name
	card_node.get_node("MarginContainer/VBoxContainer/CardDescription").text = card_data.description
	
	# Armazena os dados para uso posterior (quando o jogador clicar)
	card_node.card_data = card_data

func generate_3_random_cards():
	var cards = []
	for i in 3:
		cards.append(get_random_card())
	return cards

func get_random_card():
	# Calcula total de chances
	var total_rarity = 0
	for rarity_chance in GameData.card_rarity_chances.values():
		total_rarity += rarity_chance
	
	# Rola um número aleatório
	var roll = randi() % total_rarity
	var current_rarity = 0
	
	# Seleciona a raridade baseada nas chances
	var selected_rarity = ""
	for rarity in GameData.card_rarity_chances:
		current_rarity += GameData.card_rarity_chances[rarity]
		if roll < current_rarity:
			selected_rarity = rarity
			break
	
	# Seleciona uma carta aleatória da raridade escolhida
	var cards_of_rarity = GameData.card_data[selected_rarity]
	var random_card = cards_of_rarity[randi() % cards_of_rarity.size()]
	
	return random_card

func _on_card_selected(selected_card_data):
	GameData.add_card_to_collection(selected_card_data)
	get_tree().paused = false
	print(GameData.card_collection)
	queue_free()
