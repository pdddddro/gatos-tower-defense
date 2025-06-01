extends TextureButton

@export var normal_texture: Texture2D  # Textura padrão (não selecionado)
@export var selected_texture: Texture2D  # Textura quando selecionado

signal card_selected(card_node)

func _ready():
	pressed.connect(_on_pressed)
	texture_normal = normal_texture if normal_texture else texture_normal
	
func _on_pressed():
	emit_signal("card_selected", self)
