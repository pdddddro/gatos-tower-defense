extends Control

var menu_size = 0.30
var lerp_speed = .3

var open = false
var _up_anchor = Vector2(1-menu_size,1)
var _down_anchor = Vector2(1,1+.38)
var _target_anchor = _down_anchor

@onready var shop_container = $MarginContainer/VBoxContainer/ShopContainer
@onready var close_button = $MarginContainer/VBoxContainer/ActionContainer/Close
@onready var cat_list = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CatList
@onready var card_list = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CardList
@onready var cards_control = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl

var card_selection_scene = preload("res://Scenes/UIScenes/PackOpened.tscn")
var card_detail_scene = preload("res://Scenes/UIScenes/CardDetail.tscn")
@export var card_scene: PackedScene = preload("res://Scenes/UIScenes/CardPack.tscn")
@export var inventory_card_scene: PackedScene = preload("res://Scenes/UIScenes/InventoryCard.tscn")

@onready var buy_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Buy
@onready var buy_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Buy/HBoxContainer/Label
@onready var sell_price_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Buy/HBoxContainer/SellPrice
@onready var details_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Details
@onready var details_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Details/Label
@onready var sell_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Sell
@onready var sell_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Sell/HBoxContainer/Vender
@onready var sell_price = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/Sell/HBoxContainer/SellPrice

# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_top = _down_anchor.x
	anchor_bottom = _down_anchor.y
	_target_anchor = _down_anchor
	open = false
	
	shop_container.visibility_layer = false
	close_button.visibility_layer = false

	for child in cat_list.get_children():
		if child is TextureButton:
			child.pressed.connect(_on_close_pressed)
	
	GameData.card_added_to_inventory.connect(_on_card_added_to_inventory)
	
	GameData.rarity_chances_updated.connect(update_rarity_labels)
	update_rarity_labels() # Atualiza ao abrir a loja também
	
	disable_sell_n_details_buttons()

func _on_cat_clicked(cat_node):
	print("Gato clicado: ", cat_node.name)
	# Aqui você pode abrir o inventário, mostrar detalhes, etc.abrir_inventario_gato(cat_node)

func disable_sell_n_details_buttons():
	details_button.disabled = true
	sell_button.disabled = true
	details_label.self_modulate = Color("42272464")
	sell_label.self_modulate = Color("42272464")
	sell_price.self_modulate = Color("42272464")

func enable_sell_n_details_buttons():
	details_button.disabled = false
	sell_button.disabled = false
	details_label.self_modulate = Color.WHITE
	sell_label.self_modulate = Color.WHITE
	sell_price.self_modulate = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anchor_top = lerp(anchor_top,_target_anchor.x,lerp_speed)
	anchor_bottom = lerp(anchor_bottom,_target_anchor.y,lerp_speed)
	if abs(anchor_top - _target_anchor.x) < 0.02 and abs(anchor_bottom - _target_anchor.y) < 0.02:
		if _target_anchor == _down_anchor and shop_container.visibility_layer:
			shop_container.visibility_layer = false

func _on_close_pressed():
	close_button.visibility_layer = false
	_target_anchor = _down_anchor

func _on_cat_shop_pressed() -> void:
	cat_list.show()
	card_list.hide()
	cards_control.hide()
	
	if open == false:
		open_container()

func _on_cards_pressed() -> void:
	cat_list.hide()
	card_list.show()
	cards_control.show()
	
	if open == false:
		open_container()

func open_container():
	shop_container.visibility_layer = true
	close_button.visibility_layer = true
	_target_anchor = _up_anchor
	
func _on_buy_pressed() -> void:
	var pack_cost = 300
	if GameData.fish_quantity >= pack_cost:
		var card_selection = card_selection_scene.instantiate()
		# Sobe 3 níveis: Control -> MarginContainer -> HUD -> UI (CanvasLayer)
		get_parent().get_parent().get_parent().add_child(card_selection)
		get_tree().paused = true
		buy_button.disabled = true
		buy_label.self_modulate = Color("42272464")
		sell_price_label.self_modulate = Color("42272464")
		
		GameData.update_fish_quantity(int(-pack_cost))
		
		

func _on_details_pressed() -> void:
	if selected_inventory_card:
		var card_data = selected_inventory_card.get_meta("card_data")
		if card_data:
			var card_detail = card_detail_scene.instantiate()
			get_parent().get_parent().get_parent().add_child(card_detail)
			card_detail.setup_card_detail(card_data)
			get_tree().paused = true

func _on_card_added_to_inventory(card_data: Dictionary):
	# Cria uma nova carta para o inventário visual
	var inventory_card = inventory_card_scene.instantiate()
	
	# Configura apenas os elementos do modelo simplificado
	setup_inventory_card(inventory_card, card_data)
	
	# Adiciona ao CardList
	card_list.add_child(inventory_card)
	
	card_list.move_child(inventory_card, 0)
	
	update_empty_inventory_label()
	
	inventory_card.card_selected.connect(_on_inventory_card_selected)

	# Conecta o sinal de seleção
	inventory_card.card_selected.connect(_on_inventory_card_selected)
	print("Carta adicionada ao inventário: ", card_data.name)

var selected_inventory_card: TextureButton = null

func _on_inventory_card_selected(card_node):
	# Se a carta clicada já está selecionada, desseleciona
	if selected_inventory_card == card_node:
		card_node.texture_normal = card_node.normal_texture  # Volta para textura padrão
		selected_inventory_card = null
		print("Carta desselecionada: ", card_node.get_node("MarginContainer/VBoxContainer/CardName").text)
		
		disable_sell_n_details_buttons()
		
	else:
		# Desmarca a carta anterior, se houver
		if selected_inventory_card and is_instance_valid(selected_inventory_card):
			selected_inventory_card.texture_normal = selected_inventory_card.normal_texture  # Remove destaque da anterior

		# Marca a nova carta selecionada
		selected_inventory_card = card_node
		selected_inventory_card.texture_normal = selected_inventory_card.selected_texture  # Aplica textura de selecionado
		
		var card_data = card_node.get_meta("card_data")
		if card_data and "sell_value" in card_data:
			sell_price.text = str(card_data["sell_value"])
		else:
			sell_price.text = "0"  # Valor padrão se não houver sell_value
			
		enable_sell_n_details_buttons()
		
		print("Carta selecionada: ", selected_inventory_card.get_node("MarginContainer/VBoxContainer/CardName").text)

func setup_inventory_card(card_node, card_data):
	card_node.get_node("MarginContainer/VBoxContainer/CardName").text = card_data.name
	card_node.get_node("MarginContainer/VBoxContainer/CardIcon").texture = load(card_data.icon)
	card_node.set_meta("card_data", card_data) # GUARDA TUDO

@onready var empty_inventory_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CardList/EmptyLabel

var card_count = 0

func update_empty_inventory_label():
	if card_list.get_children()[0] != empty_inventory_label:  # Exclui a label da contagem
		card_count += 1
	
	if card_list.get_children()[0] == empty_inventory_label:  # Exclui a label da contagem
		card_count -= 1
	
	if card_count > 0:
		empty_inventory_label.hide()
	else:
		empty_inventory_label.show()

func update_rarity_labels():
	# Acesse as labels pelo caminho mostrado na sua árvore
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Basic/BasicRarity.text = str(GameData.card_rarity_chances.basic) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Common/ComumRarity.text = str(GameData.card_rarity_chances.medium) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Rare/RareRarity.text = str(GameData.card_rarity_chances.rare) + "%"

func _on_sell_pressed() -> void:
	if selected_inventory_card:
		var card_data = selected_inventory_card.get_meta("card_data")
		if card_data and "sell_value" in card_data:
			var sell_value = card_data["sell_value"]
			# Adiciona o valor de venda à moeda do jogador usando a função do GameData
			GameData.update_fish_quantity(int(sell_value))
			print("Carta vendida por ", sell_value, " moedas. Moeda total agora: ", GameData.fish_quantity)
			
			# Remove a carta do inventário (da UI)
			selected_inventory_card.queue_free()
			
			# Remove a carta da coleção do jogador (se necessário)
			GameData.card_collection.erase(card_data)
			
			# Limpa a seleção
			selected_inventory_card = null
			
			await get_tree().process_frame
			update_empty_inventory_label()
			
			# Atualiza a UI (desativa botões e verifica se o inventário está vazio)
			disable_sell_n_details_buttons()
			
		else:
			print("Erro: Valor de venda não encontrado nos dados da carta.")
	else:
		print("Erro: Nenhuma carta selecionada para vender.")
