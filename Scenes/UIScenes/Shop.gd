extends Control

var menu_size = 0.30
var lerp_speed = .3

var open = false
var _up_anchor = Vector2(1-menu_size,1)
var _down_anchor = Vector2(1,1+.365)
var _target_anchor = _down_anchor

@onready var shop_container = $MarginContainer/VBoxContainer/ShopContainer
@onready var close_button = $MarginContainer/VBoxContainer/ActionContainer/Close
@onready var cat_list = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/ScrollContainer/CatList
@onready var card_list = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/ScrollContainer/CardList
@onready var cards_control = $MarginContainer/VBoxContainer/ShopContainer/Background/MarginContainer/HBoxContainer/CardsControl

var card_selection_scene = preload("res://Scenes/UIScenes/PackOpened.tscn")

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
