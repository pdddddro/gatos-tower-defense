extends Control

var menu_size = 0.30
var lerp_speed = .3

var _popped_up = false
var _up_anchor = Vector2(1-menu_size,1)
var _down_anchor = Vector2(1,1+.365)
var _target_anchor = _down_anchor

@onready var cat_shop_container = $MarginContainer/VBoxContainer/CatShopContainer
@onready var close_button = $MarginContainer/VBoxContainer/ActionContainer/Close
@onready var cat_list = $MarginContainer/VBoxContainer/CatShopContainer/Background/MarginContainer/ScrollContainer/CatList

# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_top = _down_anchor.x
	anchor_bottom = _down_anchor.y
	_target_anchor = _down_anchor
	_popped_up = false
	
	cat_shop_container.visibility_layer = false
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
		if _target_anchor == _down_anchor and cat_shop_container.visibility_layer:
			cat_shop_container.visibility_layer = false

func _on_close_pressed():
	if !_popped_up:
		_target_anchor = _up_anchor
		cat_shop_container.visibility_layer = true
		close_button.visibility_layer = true

	else:
		close_button.visibility_layer = false
		_target_anchor = _down_anchor
		
	_popped_up = !_popped_up


func _on_cat_shop_pressed() -> void:
	if !_popped_up:
		cat_shop_container.visibility_layer = true
		close_button.visibility_layer = true
		_target_anchor = _up_anchor
		
	else:
		close_button.visibility_layer = false
		_target_anchor = _down_anchor
	_popped_up = !_popped_up
	


func _on_chicao_pressed() -> void:
	pass # Replace with function body.
