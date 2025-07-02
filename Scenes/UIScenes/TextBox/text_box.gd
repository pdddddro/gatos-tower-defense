extends Control

@onready var big_textbox = $VBoxContainer/VBoxContainer/BigTextBox
@onready var small_textbox = $VBoxContainer/VBoxContainer/SmallTextBox
@onready var close_button = $VBoxContainer/VBoxContainer/Close

@onready var title = $VBoxContainer/VBoxContainer/TextBox/MarginContainer/VBoxContainer/VBoxContainer/Title
@onready var content = $VBoxContainer/VBoxContainer/TextBox/MarginContainer/VBoxContainer/VBoxContainer/Content

@onready var next_button = $VBoxContainer/VBoxContainer/TextBox/MarginContainer/VBoxContainer/Next
@onready var next_label = $VBoxContainer/VBoxContainer/TextBox/MarginContainer/VBoxContainer/Next/Label

var tween: Tween

signal textbox_closed
signal textbox_opened

var is_tutorial_mode: bool = false

func _ready():
	# Conecta o botão de fechar
	#close_button.pressed.connect(_on_close_pressed)
	
	# Aguarda um frame para garantir que o viewport esteja configurado
	await get_tree().process_frame
	
	# Configura posição inicial (fora da tela, embaixo)
	var screen_height = get_viewport().get_visible_rect().size.y
	position.y = screen_height
	
	next_button.pressed.connect(_on_next_pressed)

func show_textbox(text_data: Dictionary):
	title.bbcode_text = text_data.get("title", "")
	content.bbcode_text = text_data.get("message", "")
	
	# Verifica se é tutorial
	is_tutorial_mode = GameData.tutorial_active
	var show_close = text_data.get("show_close", true)
	var button_text = text_data.get("button_text", "Próximo")
	
	# Configura visibilidade dos botões
	close_button.visible = show_close and not is_tutorial_mode
	next_button.visible = true
	next_label.text = button_text
	
	textbox_opened.emit()
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
	if is_tutorial_mode:
		var current_data = GameData.get_current_tutorial_data()
		var tutorial_type = current_data.get("type", "info")
		
		if tutorial_type == "action_required" and not GameData.tutorial_step_completed:
			# Não fecha se ação ainda não foi completada
			return
	
	animate_out()

func _on_next_pressed():
	if is_tutorial_mode:
		var current_data = GameData.get_current_tutorial_data()
		var tutorial_type = current_data.get("type", "info")
	
	animate_out()
