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
	
	GameData.apply_card_rarity_texture(card_node, card_data.name)
	
	# Armazena os dados para uso posterior (quando o jogador clicar)
	card_node.card_data = card_data

func generate_3_random_cards():
	var selected_cards = []
	var max_attempts = 50  # Evita loop infinito
	var attempts = 0
	
	while selected_cards.size() < 3 and attempts < max_attempts:
		var new_card = get_random_card()
		
		# Verifica se a carta já foi selecionada
		var is_duplicate = false
		for existing_card in selected_cards:
			if existing_card.name == new_card.name:
				is_duplicate = true
				break
		
		# Se não é duplicata, adiciona à lista
		if not is_duplicate:
			selected_cards.append(new_card)
		
		attempts += 1
	
	# Se por algum motivo não conseguiu 3 cartas diferentes, completa com cartas aleatórias
	while selected_cards.size() < 3:
		selected_cards.append(get_random_card())
	
	return selected_cards

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
	#Analytics.add_event("Carta escolhidas no Pack", {"Carta": "TESTE"})
	#await Analytics
	
	var game_scene = get_tree().get_first_node_in_group("game_scene")
	if game_scene:
		game_scene.update_build_buttons()
	
	queue_free()
