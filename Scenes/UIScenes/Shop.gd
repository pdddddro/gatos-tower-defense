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

@onready var cats_control = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatsControl

## Nova seleção e compra de gatos
var selected_shop_cat: TextureButton = null
var selected_cat_type: String = ""
@onready var cat_buy_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatsControl/Buy
@onready var cat_details_button = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CatsControl/Details

func _ready():
	anchor_top = _down_anchor.x
	anchor_bottom = _down_anchor.y
	_target_anchor = _down_anchor
	open = false

	shop_container.visibility_layer = false
	close_button.visibility_layer = false
	
	GameData.card_added_to_inventory.connect(_on_card_added_to_inventory)
	GameData.fish_quantity_updated.connect(_on_fish_quantity_updated)
	GameData.rarity_chances_updated.connect(update_rarity_labels)
	update_rarity_labels()
	
	disable_sell_n_details_buttons()
	
	update_cat_shop_prices()
	
	sell_cat_button.pressed.connect(_on_sell_cat_button_pressed)
	
	setup_cat_shop_buttons()
	disable_cat_shop_buttons()


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
	close_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_target_anchor = _down_anchor
	close_cat_info()
	
	if selected_shop_cat and is_instance_valid(selected_shop_cat):
		selected_shop_cat.texture_normal = selected_shop_cat.get_meta("normal_texture") if selected_shop_cat.has_meta("normal_texture") else selected_shop_cat.texture_normal
	selected_shop_cat = null
	selected_cat_type = ""
	disable_cat_shop_buttons()

signal cat_shop_opened

func _on_cat_shop_pressed() -> void:
	if GameData.tutorial_active:
		var current_data = GameData.get_current_tutorial_data()
		var required_action = current_data.get("required_action", "")
		
		# Se tutorial requer colocar gato, PERMITE abrir loja de gatos
		if required_action == "place_cat":
			# Loja de gatos liberada durante tutorial_2
			pass
		elif required_action != "" and required_action != "place_cat":
			print("Loja de gatos bloqueada pelo tutorial")
			return
	
	cat_list.visible = true
	card_list.visible = false
	cards_control.visible = false
	cat_info.visible = false
	texture_rect.visible = true
	cats_control.visible = true
	
	var game_scene = get_tree().get_first_node_in_group("game_scene")
	if game_scene:
		game_scene.update_build_buttons()
	
	if current_cat_reference:
		current_cat_reference.hide_range()
		
	if !texture_rect:
		texture_rect.visible = true
			
	cat_shop_opened.emit()
	setup_cat_shop_buttons()
	
	if open == false:
		open_container()

func _on_cards_pressed() -> void:
	if GameData.tutorial_active:
		var current_data = GameData.get_current_tutorial_data()
		var required_action = current_data.get("required_action", "")
		
		# Se tutorial requer colocar gato, PERMITE abrir loja de gatos
		if required_action == "equip_card":
			# Loja de gatos liberada durante tutorial_2
			pass
		elif required_action != "" and required_action != "equip_card":
			print("Loja de cartas bloqueada pelo tutorial")
			return
			
	cat_list.visible = false
	cat_info.visible = false
	cats_control.visible = false
	texture_rect.visible = true
	
	if current_cat_reference:
		current_cat_reference.hide_range()
			
	card_list.visible = true
	cards_control.visible = true
	
	if open == false:
		open_container()
		

func open_container():
	shop_container.visibility_layer = true
	close_button.visibility_layer = true
	close_button.mouse_filter = Control.MOUSE_FILTER_PASS
	_target_anchor = _up_anchor

func open_cat_info():
	cat_list.visible = false
	card_list.visible = false
	cards_control.visible = false
	texture_rect.visible = false
	cat_info.visible = true
	cats_control.visible = false
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

func update_cat_info(cat_type):
	print("Informações Atualizadas")
	
	if cat_type and current_cat_reference:
		cat_name.text = current_cat_reference.individual_stats["name"]
		cat_sprite.texture = load(GameData.cat_data[cat_type]["sprite"])
		cat_damage.text = format_number_k(current_cat_reference.individual_stats["damage"])
		cat_range.text = format_number_k(current_cat_reference.individual_stats["range"])
		
		var cooldown = current_cat_reference.individual_stats["atkcooldown"]
		var attacks_per_second = 1.0 / cooldown
		cat_attack_speed.text = "%.1f/s" % attacks_per_second
		
		cat_critical_chance.text = str(int(current_cat_reference.individual_stats["critical_chance"])) + "%"
		cat_enemies_defeated.text = format_number_k(current_cat_reference.individual_stats["enemies_defeated"])
		cat_fish_collected.text = format_number_k(current_cat_reference.individual_stats["fish_collected"])
		
		# Atualizar preço do botão de venda
		update_sell_cat_button_price()
		
		# Resto do código existente...
		var new_range = current_cat_reference.individual_stats["range"]
		if current_cat_reference.has_node("Range/CollisionShape2D"):
			current_cat_reference.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * new_range
		
		if current_cat_reference.showing_range:
			current_cat_reference.queue_redraw()
		
		update_equipped_cards_ui(current_cat_reference.equipped_cards)
		
func format_number_k(value: float) -> String:
	if value >= 1000:
		var k_value = value / 1000.0
		return ("%.1fk" % k_value).replace(".0k", "k")
	else:
		return str(int(value))

func update_cat_shop_prices():
	var cat_list_node = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CatList
	for child in cat_list_node.get_children():
		var vbox = child.get_node_or_null("VBoxContainer")
		if vbox:
			var hbox = vbox.get_node_or_null("HBoxContainer")
			if hbox:
				var price_label = hbox.get_node_or_null("CatPrice")
				if price_label:
					var cat_type = child.name
					if GameData.cat_data.has(cat_type):
						var cat_cost = GameData.cat_data[cat_type]["cost"]
						price_label.text = str(cat_cost)
						# Desativa botão se não tiver dinheiro
						child.disabled = GameData.fish_quantity < cat_cost
						# Feedback visual
						if child.disabled:
							child.modulate = Color("d0ab89")
						else:
							child.modulate = Color.WHITE

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
	
	if cat_node:
		call_deferred("update_cat_info", cat_node.type)
		
		if cat_node.showing_range:
			var new_range = cat_node.individual_stats["range"]
			if cat_node.has_node("Range/CollisionShape2D"):
				cat_node.queue_redraw()

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
			# Desconectar sinais anteriores se existirem
			if card_slots[i].is_connected("pressed", _on_cat_card_selected):
				card_slots[i].disconnect("pressed", _on_cat_card_selected)
	
	for i in range(min(equipped_cards.size(), 4)):
		if card_slots[i]:
			setup_card_slot(card_slots[i], equipped_cards[i])
			# Conectar sinal de seleção para cada carta
			card_slots[i].pressed.connect(_on_cat_card_selected.bind(card_slots[i]))

func _on_cat_card_selected(card_slot: TextureButton):
	if not current_cat_reference:
		return
	
	var card_data = card_slot.get_meta("card_data")
	if not card_data:
		return
	
	# Se a carta clicada já está selecionada, desseleciona
	if selected_cat_card == card_slot:
		card_slot.texture_normal = card_slot.get_meta("normal_texture")
		selected_cat_card = null
		cat_card_sell_mode = false
		print("Carta do gato desselecionada")
		update_sell_cat_button_price()
	else:
		# Desmarca a carta anterior, se houver
		if selected_cat_card and is_instance_valid(selected_cat_card):
			selected_cat_card.texture_normal = selected_cat_card.get_meta("normal_texture")
		
		# Marca a nova carta selecionada
		selected_cat_card = card_slot
		selected_cat_card.texture_normal = selected_cat_card.texture_pressed
		cat_card_sell_mode = true
		print("Carta do gato selecionada: ", card_data.name)
		update_sell_cat_button_price()

func setup_card_slot(slot_node, card_data: Dictionary):
	var card_icon = slot_node.get_node("CardIcon")
	if card_icon:
		if ResourceLoader.exists(card_data.icon):
			card_icon.texture = load(card_data.icon)
			card_icon.visible = true
			slot_node.set_meta("card_data", card_data)
			# Salvar textura normal para poder restaurar
			slot_node.set_meta("normal_texture", slot_node.texture_normal)
		else:
			print("ERRO: Arquivo de ícone não encontrado: ", card_data.icon)
	else:
		print("ERRO: CardIcon não encontrado no slot")

func update_sell_cat_button_price():
	if not current_cat_reference:
		return
	
	if cat_card_sell_mode and selected_cat_card:
		# Modo venda de carta - mostra preço da carta
		var card_data = selected_cat_card.get_meta("card_data")
		if card_data and "sell_value" in card_data:
			cat_sell_price.text = str(card_data.sell_value)
		else:
			cat_sell_price.text = "0"
	else:
		# Modo venda de gato - mostra preço do gato
		var cat_cost = GameData.cat_data[current_cat_reference.type]["cost"]
		var sell_value = int(cat_cost * 0.5)
		cat_sell_price.text = str(sell_value)

func clear_card_slot(slot_node):
	var card_icon = slot_node.get_node("CardIcon")
	if card_icon:
		card_icon.texture = null
		card_icon.visible = false
	
	# IMPORTANTE: Limpar TODOS os metadados relacionados à carta
	if slot_node.has_meta("card_data"):
		slot_node.remove_meta("card_data")
	if slot_node.has_meta("normal_texture"):
		slot_node.remove_meta("normal_texture")
	
	# FORÇA o reset da textura para o estado normal padrão
	slot_node.texture_normal = load("res://Assets/UI/Equipped_card_background.png")

func _on_sell_cat_button_pressed():
	if cat_card_sell_mode and selected_cat_card:
		sell_cat_card()
	else:
		sell_cat(current_cat_reference)

func sell_cat_card():
	if not selected_cat_card or not current_cat_reference:
		return
	
	var card_data = selected_cat_card.get_meta("card_data")
	if not card_data:
		return
	
	var sell_value = int(card_data.get("sell_value", 0))
	
	# Remove a carta do gato (isso já chama remove_card_effects)
	current_cat_reference.remove_equipped_card(card_data)
	
	# Adiciona o dinheiro
	GameData.update_fish_quantity(sell_value)
	
	print("Carta vendida por ", sell_value, " peixes")
	
	# IMPORTANTE: Reset do modo de seleção ANTES de atualizar a UI
	selected_cat_card = null
	cat_card_sell_mode = false
	
	# Atualiza a UI
	update_equipped_cards_ui(current_cat_reference.equipped_cards)
	
	# Atualiza as informações do gato para refletir os novos stats
	update_cat_info(current_cat_reference.type)
	
	# Atualiza o preço do botão
	update_sell_cat_button_price()

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
	
	# Reset do modo de seleção de cartas
	selected_cat_card = null
	cat_card_sell_mode = false
	
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
		card_node.texture_normal = card_node.normal_texture # Usa a propriedade exportada
		selected_inventory_card = null
		print("Carta desselecionada: ", card_node.get_node("MarginContainer/VBoxContainer/CardName").text)
		disable_sell_n_details_buttons()
	else:
		# Desmarca a carta anterior, se houver
		if selected_inventory_card and is_instance_valid(selected_inventory_card):
			selected_inventory_card.texture_normal = selected_inventory_card.normal_texture # Usa a propriedade exportada
		
		# Marca a nova carta selecionada
		selected_inventory_card = card_node
		selected_inventory_card.texture_normal = selected_inventory_card.selected_texture # Usa a propriedade exportada
		
		var card_data = card_node.get_meta("card_data")
		if card_data and "sell_value" in card_data:
			sell_price.text = str(card_data["sell_value"])
		else:
			sell_price.text = "0" # Valor padrão se não houver sell_value
		
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
			
			selected_inventory_card.queue_free()
			
			GameData.card_collection.erase(card_data)
			
			selected_inventory_card = null
			
			await get_tree().process_frame
			update_empty_inventory_label()
			
			disable_sell_n_details_buttons()
			
		else:
			print("Erro: Valor de venda não encontrado nos dados da carta.")
	else:
		print("Erro: Nenhuma carta selecionada para vender.")

var selected_cat_card: TextureButton = null
var cat_card_sell_mode = false

func setup_cat_shop_buttons():
	# Conecta os sinais dos botões de gatos
	if cat_buy_button:
		cat_buy_button.pressed.connect(_on_cat_buy_pressed)
	if cat_details_button:
		cat_details_button.pressed.connect(_on_cat_details_pressed)
	
	# Conecta os sinais de clique para cada gato na loja
	for child in cat_list.get_children():
		if child is TextureButton:
			# Desconecta o sinal antigo que iniciava build_mode diretamente
			if child.is_connected("pressed", _on_close_pressed):
				child.disconnect("pressed", _on_close_pressed)
			
			# Desconecta sinais anteriores de seleção se existirem
			if child.is_connected("pressed", _on_shop_cat_selected):
				child.disconnect("pressed", _on_shop_cat_selected)
			
			# Conecta apenas o novo sinal de seleção
			child.pressed.connect(_on_shop_cat_selected.bind(child))
			
	

func disable_cat_shop_buttons():
	if cat_buy_button:
		cat_buy_button.disabled = true
	if cat_details_button:
		cat_details_button.disabled = true

func enable_cat_shop_buttons():
	if cat_buy_button:
		cat_buy_button.disabled = false
	if cat_details_button:
		cat_details_button.disabled = false

func _on_shop_cat_selected(cat_button: TextureButton):
	var cat_type = cat_button.name
	
	# Force o reset de hover em todos os botões primeiro (importante para mobile)
	for child in cat_list.get_children():
		if child is TextureButton and child != cat_button:
			# Remove hover de outros botões
			child.texture_hover = child.texture_normal
			# Força reset da textura atual
			if child.has_meta("normal_texture"):
				child.texture_normal = child.get_meta("normal_texture")
	
	# Se o gato clicado já está selecionado, desseleciona
	if selected_shop_cat == cat_button:
		cat_button.texture_normal = cat_button.get_meta("normal_texture") if cat_button.has_meta("normal_texture") else cat_button.texture_normal
		# Remove hover também
		cat_button.texture_hover = cat_button.texture_normal
		selected_shop_cat = null
		selected_cat_type = ""
		disable_cat_shop_buttons()
		print("Gato da loja desselecionado: ", cat_type)
	else:
		# Desmarca o gato anterior, se houver
		if selected_shop_cat and is_instance_valid(selected_shop_cat):
			var old_normal = selected_shop_cat.get_meta("normal_texture") if selected_shop_cat.has_meta("normal_texture") else selected_shop_cat.texture_normal
			selected_shop_cat.texture_normal = old_normal
			selected_shop_cat.texture_hover = old_normal
		
		# Salva a textura normal se ainda não foi salva
		if not cat_button.has_meta("normal_texture"):
			cat_button.set_meta("normal_texture", cat_button.texture_normal)
		
		# Marca o novo gato selecionado
		selected_shop_cat = cat_button
		selected_cat_type = cat_type
		selected_shop_cat.texture_normal = selected_shop_cat.texture_pressed
		# Define hover como pressed também para evitar conflitos
		selected_shop_cat.texture_hover = selected_shop_cat.texture_pressed
		enable_cat_shop_buttons()
		print("Gato da loja selecionado: ", cat_type)

func _on_cat_buy_pressed():
	if selected_cat_type == "":
		return
	
	print("Comprando gato: ", selected_cat_type)
	
	# Obtém referência para a cena do jogo
	var game_scene = get_tree().get_first_node_in_group("game_scene")
	if game_scene:
		# Inicia o modo de construção como se o usuário tivesse clicado no botão do gato
		game_scene.initiate_build_mode(selected_cat_type)
		
		# Fecha a loja
		_on_close_pressed()
	else:
		print("ERRO: Cena do jogo não encontrada")

func _on_cat_details_pressed():
	if selected_cat_type == "":
		return
	
	print("Mostrando detalhes do gato: ", selected_cat_type)
	
	# Placeholder para a cena de detalhes - você pode ajustar o caminho depois
	placeholder_show_cat_details(selected_cat_type)

func placeholder_show_cat_details(cat_type: String):
	var details_scene = preload("res://Scenes/Cats/CatDetails.tscn")
	var details_instance = details_scene.instantiate()
	get_parent().get_parent().get_parent().add_child(details_instance)
	details_instance.setup_cat_details(cat_type)
	get_tree().paused = true
