extends Control

@onready var big_textbox = $VBoxContainer/VBoxContainer/BigTextBox
@onready var small_textbox = $VBoxContainer/VBoxContainer/SmallTextBox
@onready var close_button = $VBoxContainer/VBoxContainer/Close

@onready var big_title = $VBoxContainer/VBoxContainer/BigTextBox/MarginContainer/VBoxContainer/Title
@onready var big_content = $VBoxContainer/VBoxContainer/BigTextBox/MarginContainer/VBoxContainer/Content
@onready var small_title = $VBoxContainer/VBoxContainer/SmallTextBox/MarginContainer/VBoxContainer/Title
@onready var small_content = $VBoxContainer/VBoxContainer/SmallTextBox/MarginContainer/VBoxContainer/Content

var tween: Tween

signal textbox_closed

func _ready():
	# Conecta o botão de fechar
	close_button.pressed.connect(_on_close_pressed)
	
	# Esconde ambos os containers inicialmente
	big_textbox.visible = false
	small_textbox.visible = false
	
	# Aguarda um frame para garantir que o viewport esteja configurado
	await get_tree().process_frame
	
	# Configura posição inicial (fora da tela, embaixo)
	var screen_height = get_viewport().get_visible_rect().size.y
	position.y = screen_height

func show_textbox(text_data: Dictionary):
	# Determina qual container usar baseado no tamanho
	if text_data.size == "large":
		big_textbox.visible = true
		small_textbox.visible = false
		big_title.text = text_data.title
		big_content.text = text_data.message
	else:
		big_textbox.visible = false
		small_textbox.visible = true
		small_title.text = text_data.title
		small_content.text = text_data.message
	
	# Anima entrada de baixo para cima sem bounce
	animate_in()

func animate_in():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	
	# Usa get_visible_rect() para garantir o tamanho correto da tela
	var screen_height = get_viewport().get_visible_rect().size.y
	var target_y = screen_height - size.y
	
	tween.tween_property(self, "position:y", target_y, 0.5)

func animate_out():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUART)
	
	# Usa get_visible_rect() para garantir o tamanho correto da tela
	var screen_height = get_viewport().get_visible_rect().size.y
	tween.tween_property(self, "position:y", screen_height, 0.3)
	await tween.finished
	
	textbox_closed.emit()
	queue_free()

func _on_close_pressed():
	animate_out()
