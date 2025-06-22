extends Control

## Rich Text Label
## [b][font_size=11]Texto[/font_size][/b]  - Font Retro Gaming 
## [shake rate=5 level=10] Texto Tremendo [/shake]
## [rainbow]Texto arco-íris[/rainbow]
## [pulse freq=1.0 color=#ffffff40 ease=-2.0]Texto pulsante[/pulse]
## [wave amp=50 freq=2]Texto ondulado[/wave]
## [tornado radius=5 freq=10]Texto ondulado[/tornado]
## [color=#hex]trocar a cor[/color]

const OFFSET: Vector2 = Vector2.ONE * 4
var opacity_tween: Tween = null

@onready var background = $Background
@onready var margin_container = $MarginContainer
@onready var vbox = $MarginContainer/VBoxContainer
@onready var title = $MarginContainer/VBoxContainer/Title
@onready var content = $MarginContainer/VBoxContainer/Content
@onready var rarity = $MarginContainer/VBoxContainer/CardRarity

@export_multiline var tooltip_title: String = "Título"
@export_multiline var tooltip_content: String = "Conteúdo"
@export var auto_setup: bool = true
@export var show_title: bool = true
@export var tooltip_rarity_texture: String = ""
@export var show_rarity: bool = true

func _ready() -> void:
	if auto_setup:
		setup_content()

	hide()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		adjust_tooltip_size()
		_adjust_position_to_viewport()

func setup_content():
	if title:
		if show_title and tooltip_title != "":
			title.text = tooltip_title
			title.visible = true
		else:
			title.visible = false
			
	if content and content is RichTextLabel:
		content.text = tooltip_content
		content.fit_content = true
		
		var plain_text = content.get_parsed_text()
		if plain_text.length() > 25:
			content.custom_minimum_size = Vector2(192, 0)
		elif plain_text.length() > 20 and plain_text.length() < 25:
			content.custom_minimum_size = Vector2(120, 0)
		elif plain_text.length() > 12 and plain_text.length() < 20:
			content.custom_minimum_size = Vector2(96, 0)
		else:
			content.custom_minimum_size = Vector2(64, 0)
			
	if  rarity and show_rarity and tooltip_rarity_texture != "":
		if ResourceLoader.exists(tooltip_rarity_texture):
			rarity.texture = load(tooltip_rarity_texture)
			rarity.visible = true
		else:
			rarity.visible = false
	elif  rarity:
		rarity.visible = false

func tween_opacity(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.1)
	return opacity_tween
	
func toggle(show_tooltip: bool):
	if show_tooltip:
		visible = true
		# Mantém o tween de animação existente
		tween_opacity(1.0)
		# Ajusta a posição para evitar corte na tela
		call_deferred("_adjust_position_to_viewport")
	else:
		# Mantém o tween de animação para ocultar
		var fade_tween = tween_opacity(0.0)
		fade_tween.tween_callback(func(): visible = false)
		
func _adjust_position_to_viewport():
	var viewport_size = get_viewport().get_visible_rect().size
	var tooltip_size = size
	var mouse_pos = get_global_mouse_position()

	# Usa o OFFSET existente como posição padrão
	var new_position = mouse_pos + OFFSET

	# Verifica se a tooltip vai sair da tela na parte inferior
	if new_position.y + tooltip_size.y > viewport_size.y:
		# Posiciona acima do mouse ao invés de abaixo
		new_position.y = mouse_pos.y - tooltip_size.y - OFFSET.y

	# Verifica se vai sair da tela na direita
	if new_position.x + tooltip_size.x > viewport_size.x:
		new_position.x = viewport_size.x - tooltip_size.x - OFFSET.x

	# Verifica se vai sair da tela na esquerda
	if new_position.x < 0:
		new_position.x = OFFSET.x

	# Verifica se vai sair da tela no topo (caso tenha movido para cima)
	if new_position.y < 0:
		new_position.y = mouse_pos.y + OFFSET.y

	global_position = new_position
	
func adjust_tooltip_size():
	# Força o recálculo do layout múltiplas vezes
	margin_container.reset_size()
	vbox.reset_size()
	
	# Aguarda o próximo frame após forçar o reset
	await get_tree().process_frame
	
	# Força uma atualização do layout
	margin_container.queue_sort()
	await get_tree().process_frame
	
	# Agora pega o tamanho correto
	var content_size = margin_container.size
	custom_minimum_size = content_size
	size = content_size
	background.size = content_size
