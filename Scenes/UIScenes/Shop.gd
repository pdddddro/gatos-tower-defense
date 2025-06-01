extends Control

var menu_size = 0.30
var lerp_speed = .3

var open = false
var _up_anchor = Vector2(1-menu_size,1)
var _down_anchor = Vector2(1,1+.365)
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

# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_top = _down_anchor.x
	anchor_bottom = _down_anchor.y
	_target_anchor = _down_anchor
	open = false
	
	shop_container.visibility_layer = false
	close_button.visibility_layer = false
	print(cat_list)
	for child in cat_list.get_children():
		if child is TextureButton:
			child.pressed.connect(_on_close_pressed)
	
	GameData.card_added_to_inventory.connect(_on_card_added_to_inventory)
	
	GameData.rarity_chances_updated.connect(update_rarity_labels)
	update_rarity_labels() # Atualiza ao abrir a loja também
	
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
	var card_selection = card_selection_scene.instantiate()
	# Sobe 3 níveis: Control -> MarginContainer -> HUD -> UI (CanvasLayer)
	get_parent().get_parent().get_parent().add_child(card_selection)
	get_tree().paused = true

func _on_card_added_to_inventory(card_data: Dictionary):
	# Cria uma nova carta para o inventário visual
	var inventory_card = inventory_card_scene.instantiate()
	
	# Configura apenas os elementos do modelo simplificado
	setup_inventory_card(inventory_card, card_data)
	
	# Adiciona ao CardList
	card_list.add_child(inventory_card)
	
	card_list.move_child(inventory_card, 0)
	
	print("Carta adicionada ao inventário: ", card_data.name)
	
	update_empty_inventory_label()
	
func setup_inventory_card(card_node, card_data):
	card_node.get_node("MarginContainer/VBoxContainer/CardName").text = card_data.name

@onready var empty_inventory_label = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/TextureRect/MarginContainer/ScrollContainer/CardList/EmptyLabel

func update_empty_inventory_label():
	# Se tem pelo menos 1 carta, esconde a label
	if card_list.get_child_count() > 0:
		empty_inventory_label.hide()
	else:
		empty_inventory_label.show()

func update_rarity_labels():
	# Acesse as labels pelo caminho mostrado na sua árvore
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Basic/BasicRarity.text = str(GameData.card_rarity_chances.basic) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Common/ComumRarity.text = str(GameData.card_rarity_chances.medium) + "%"
	$MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl/CardRarity/Rare/RareRarity.text = str(GameData.card_rarity_chances.rare) + "%"

func _on_details_pressed() -> void:
	var card_detail = card_detail_scene.instantiate()
	# Sobe 3 níveis: Control -> MarginContainer -> HUD -> UI (CanvasLayer)
	get_parent().get_parent().get_parent().add_child(card_detail)
	get_tree().paused = true
	print("a")
