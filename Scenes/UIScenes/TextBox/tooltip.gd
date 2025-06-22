extends Control

const OFFSET: Vector2 = Vector2.ONE * 4
var opacity_tween: Tween = null

@onready var background = $Background
@onready var margin_container = $MarginContainer
@onready var vbox = $MarginContainer/VBoxContainer
@onready var title = $MarginContainer/VBoxContainer/Title
@onready var content = $MarginContainer/VBoxContainer/Content

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func tween_opacity(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.3)
	return opacity_tween
	
func toggle(on: bool):
	if on:
		show()  # Mostra primeiro para forçar o cálculo do layout
		modulate.a = 0.0
		
		# Aguarda múltiplos frames para garantir que o layout seja calculado
		await get_tree().process_frame
		await get_tree().process_frame
		
		adjust_tooltip_size()
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()

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
