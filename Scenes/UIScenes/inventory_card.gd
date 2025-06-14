extends TextureButton

@export var normal_texture: Texture2D
@export var selected_texture: Texture2D

signal card_selected(card_node)
signal card_drag_started(card_node)
signal card_dropped(card_node, target_position)

var drag_mode = false
var drag_start_pos = Vector2.ZERO
var drag_threshold = 5
var card_data: Dictionary

func _ready():
	pressed.connect(_on_pressed)
	texture_normal = normal_texture if normal_texture else texture_normal

func _on_pressed():
	emit_signal("card_selected", self)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start_pos = event.position
				drag_mode = false
			else:
				if drag_mode:
					# Finaliza o drag and drop
					var global_pos = get_global_mouse_position()
					emit_signal("card_dropped", self, global_pos)
					cancel_drag_mode()

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.distance_to(drag_start_pos) > drag_threshold and not drag_mode:
			# Inicia o modo drag
			drag_mode = true
			emit_signal("card_drag_started", self)

func cancel_drag_mode():
	drag_mode = false
