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
@onready var cat_info = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo
@onready var texture_rect = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect

@onready var sell_cat_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/Cat/Sell

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
	GameData.fish_quantity_updated.connect(_on_fish_quantity_updated)
	GameData.rarity_chances_updated.connect(update_rarity_labels)
	update_rarity_labels()
	
	disable_sell_n_details_buttons()
	
	sell_cat_button.pressed.connect(_on_sell_cat_button_pressed)

func _process(delta):
	anchor_top = lerp(anchor_top,_target_anchor.x,lerp_speed)
	anchor_bottom = lerp(anchor_bottom,_target_anchor.y,lerp_speed)
	if abs(anchor_top - _target_anchor.x) < 0.02 and abs(anchor_bottom - _target_anchor.y) < 0.02:
		if _target_anchor == _down_anchor and shop_container.visibility_layer:
			shop_container.visibility_layer = false

func _on_cat_clicked(cat_node):
	print("Gato clicado: ", cat_node.name)

func _on_close_pressed():
	close_button.visibility_layer = false
	_target_anchor = _down_anchor
	close_cat_info()
	

signal cat_shop_opened

func _on_cat_shop_pressed() -> void:
	cat_list.visible = true
	card_list.visible = false
	cards_control.visible = false
	cat_info.visible = false
	texture_rect.visible = true
	
	if current_cat_reference:
		current_cat_reference.hide_range()
		
	if !texture_rect:
		texture_rect.visible = true
	
	for child in cat_list.get_children():
		if child is TextureButton and not child.is_in_group("build_buttons"):
			child.add_to_group("build_buttons")
			
	cat_shop_opened.emit()
	
	if open == false:
		open_container()

func _on_cards_pressed() -> void:
	cat_list.visible = false
	cat_info.visible = false
	texture_rect.visible = true
	
	if current_cat_reference:
		current_cat_reference.hide_range()
	
	for child in cat_list.get_children():
		if child is TextureButton and child.is_in_group("build_buttons"):
			child.remove_from_group("build_buttons")
			
	card_list.visible = true
	cards_control.visible = true
	
	if open == false:
		open_container()

func open_container():
	shop_container.visibility_layer = true
	close_button.visibility_layer = true
	_target_anchor = _up_anchor

func open_cat_info():
	for child in cat_list.get_children():
		if child is TextureButton and child.is_in_group("build_buttons"):
			child.remove_from_group("build_buttons")
	cat_list.visible = false
	card_list.visible = false
	cards_control.visible = false
	texture_rect.visible = false
	cat_info.visible = true
	open_container()
	
## cat_data
@onready var cat_name = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/Cat/TextureRect/CatSprite/CatName
@onready var cat_sprite = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/Cat/TextureRect/CatSprite/Shadow/CatSprite
@onready var cat_damage = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row1/Damage/Number
@onready var cat_range = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row1/Range/Number
@onready var cat_attack_speed = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row1/AttackSpeed/Number
@onready var cat_critical_chance = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row2/CriticalChance/Number
@onready var cat_enemies_defeated = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row2/EnemiesDefeated/Number
@onready var cat_fish_collected = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/Status/Rows/Row2/FishsCollected/Number

@onready var cat_sell_price = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/Cat/Sell/HBoxContainer/SellPrice

## Falta adicionar o enemies_defeated e fish_collected
func update_cat_info(cat_type):
	print("Informações Atualizadas")
	if cat_type:
		cat_name.text = GameData.cat_data[cat_type]["name"]
		cat_sprite.texture = load(GameData.cat_data[cat_type]["sprite"])
		
		cat_damage.text = format_number_k(GameData.cat_data[cat_type]["damage"])
		cat_range.text = format_number_k(GameData.cat_data[cat_type]["range"])
		
		var cooldown = GameData.cat_data[cat_type]["atkcooldown"]
		var attacks_per_second = 1.0 / cooldown
		cat_attack_speed.text = "%.1f/s" % attacks_per_second
		
		cat_critical_chance.text = str(int(GameData.cat_data[cat_type]["critical_chance"])) + "%"
		
		#cat_enemies_defeated.text = format_number_k(GameData.cat_data[cat_type]["enemies_defeated"])
		#cat_fish_collected.text = format_number_k(GameData.cat_data[cat_type]["fish_collected"])
		
		var cat_cost = GameData.cat_data[cat_type]["cost"]
		var sell_value = int(cat_cost * 0.5)
		cat_sell_price.text = str(sell_value)
		
		update_equipped_cards_ui([])
		
func format_number_k(value: float) -> String:
	if value >= 1000:
		var k_value = value / 1000.0
		return ("%.1fk" % k_value).replace(".0k", "k")
	else:
		return str(int(value))

### Cat Cards
@onready var card_slot_1 = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/EquippedCards/Cards/Card1
@onready var card_slot_2 = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/EquippedCards/Cards/Card2
@onready var card_slot_3 = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/EquippedCards/Cards/Card3
@onready var card_slot_4 = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatInfo/TextureRect/MarginContainer/Info/EquippedCards/Cards/Card4

var current_cat_reference = null

func set_current_cat(cat_node):
	print("Gato recebido: ", cat_node)
	print("Gato tem cartas equipadas? ", cat_node.equipped_cards.size() if cat_node else "Gato é null")
	
	current_cat_reference = cat_node

	print("Atualizando UI com ", cat_node.equipped_cards.size(), " cartas")
	update_equipped_cards_ui(cat_node.equipped_cards)

	if sell_cat_button:
		sell_cat_button.disabled = false

func update_equipped_cards_ui(equipped_cards: Array):
	print("Número de cartas para mostrar: ", equipped_cards.size())
	
	var card_slots = [card_slot_1, card_slot_2, card_slot_3, card_slot_4]
	
	for i in range(4):
		if card_slots[i]:
			clear_card_slot(card_slots[i])

	for i in range(min(equipped_cards.size(), 4)):
		if card_slots[i]:
			setup_card_slot(card_slots[i], equipped_cards[i])

func setup_card_slot(slot_node, card_data: Dictionary):
	
	var card_icon = slot_node.get_node("CardIcon")
	
	if card_icon:
		if ResourceLoader.exists(card_data.icon):
			card_icon.texture = load(card_data.icon)
			card_icon.visible = true
			
			slot_node.set_meta("card_data", card_data)
			
		else:
			print("ERRO: Arquivo de ícone não encontrado: ", card_data.icon)
	else:
		print("ERRO: CardIcon não encontrado no slot")
	
func clear_card_slot(slot_node):
	var card_icon = slot_node.get_node("CardIcon")
	if card_icon:
		card_icon.texture = null
		card_icon.visible = false
		
	if slot_node.has_meta("card_data"):
		slot_node.remove_meta("card_data")

func _on_sell_cat_button_pressed():
	sell_cat(current_cat_reference)

func sell_cat(cat_node):
	var cat_cost = GameData.cat_data[cat_node.type]["cost"]
	var sell_value = int(cat_cost * 0.5)
	
	GameData.update_fish_quantity(sell_value)
	print("Gato vendido por ", sell_value, " peixes")
	
	remove_cat_from_exclusion(cat_node)
	
	cat_node.queue_free()
	
	close_cat_info() 
	_on_close_pressed()
	
	print("Gato vendido")

func remove_cat_from_exclusion(cat_node):
	var game_scene = get_tree().get_first_node_in_group("game_scene")
	if game_scene:
		var map_node = game_scene.get_node("Map1")
		var exclusion_layer = map_node.get_node("Exclusion")
		
		var tile_pos = exclusion_layer.local_to_map(cat_node.position)
		
		exclusion_layer.set_cell(tile_pos, -1)

func close_cat_info():
	cat_info.visible = false
	texture_rect.visible = true
	
	if current_cat_reference:
		current_cat_reference.hide_range()
		
	current_cat_reference = null
	
	if sell_cat_button:
		sell_cat_button.disabled = true

### Inventory and Pack
var pack_cost = 300

@onready var empty_inventory_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CardList/EmptyLabel
var card_count = 0

func _on_buy_pressed() -> void:
	if GameData.fish_quantity >= pack_cost:
		var card_selection = card_selection_scene.instantiate()
		# Sobe 3 níveis: Control -> MarginContainer -> HUD -> UI (CanvasLayer)
		get_parent().get_parent().get_parent().add_child(card_selection)
		get_tree().paused = true
		
		GameData.money_spent += pack_cost
		GameData.update_fish_quantity(int(-pack_cost))
		
		update_buy_button()

func _on_fish_quantity_updated(new_amount: int):
	update_buy_button()

func update_buy_button():
	if GameData.fish_quantity >= pack_cost:
		buy_button.disabled = false
		buy_label.self_modulate = Color("WHITE")
		sell_price_label.self_modulate = Color("WHITE")
		
	else:
		buy_button.disabled = true
		buy_label.self_modulate = Color("42272464")
		sell_price_label.self_modulate = Color("42272464")

func _on_details_pressed() -> void:
	if selected_inventory_card:
		var card_data = selected_inventory_card.get_meta("card_data")
		if card_data:
			var card_detail = card_detail_scene.instantiate()
			get_parent().get_parent().get_parent().add_child(card_detail)
			card_detail.setup_card_detail(card_data)
			get_tree().paused = true

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

func _on_card_added_to_inventory(card_data: Dictionary):
	# Cria uma nova carta para o inventário visual
	var inventory_card = inventory_card_scene.instantiate()
	
	# Configura apenas os elementos do modelo simplificado
	setup_inventory_card(inventory_card, card_data)
	
	# Adiciona ao CardList
	card_list.add_child(inventory_card)
	
	card_list.move_child(inventory_card, 0)
	
	update_empty_inventory_label()
	
	# Conecta o sinal de seleção
	inventory_card.card_selected.connect(_on_inventory_card_selected)
	
	var game_scene = get_tree().get_first_node_in_group("game_scene")

	inventory_card.card_drag_started.connect(game_scene._on_card_drag_started)
	inventory_card.card_dropped.connect(game_scene._on_card_dropped)
		
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
	
	GameData.apply_card_rarity_texture(card_node, card_data.name)
	
	card_node.set_meta("card_data", card_data) # GUARDA TUDO

func update_empty_inventory_label():
	if card_list.get_children()[0] != empty_inventory_label:  # Exclui a label da contagem
		card_count += 1
	
	if card_list.get_children()[0] == empty_inventory_label:  # Exclui a label da contagem
		card_count -= 1
	
	if card_count > 0:
		empty_inventory_label.visible = false
	else:
		empty_inventory_label.visible = true

func update_rarity_labels():
	# Acesse as labels pelo caminho mostrado na sua árvore
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Basic/BasicRarity.text = str(GameData.card_rarity_chances.basic) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Common/ComumRarity.text = str(GameData.card_rarity_chances.medium) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Rare/RareRarity.text = str(GameData.card_rarity_chances.rare) + "%"

# Sell Card
func _on_sell_pressed() -> void:
	if selected_inventory_card:
		var card_data = selected_inventory_card.get_meta("card_data")
		if card_data and "sell_value" in card_data:
			var sell_value = card_data["sell_value"]
			# Adiciona o valor de venda à moeda do jogador usando a função do GameData
			GameData.update_fish_quantity(int(sell_value))
			print("Carta vendida por ", sell_value, " moedas. Moeda total agora: ", GameData.fish_quantity)
			
			#game_scene.update_build_buttons
			
			selected_inventory_card.queue_free()
			
			#GameScene.update_build_buttons()
			
			GameData.card_collection.erase(card_data)
			
			selected_inventory_card = null
			
			await get_tree().process_frame
			update_empty_inventory_label()
			
			disable_sell_n_details_buttons()
			
		else:
			print("Erro: Valor de venda não encontrado nos dados da carta.")
	else:
		print("Erro: Nenhuma carta selecionada para vender.")
