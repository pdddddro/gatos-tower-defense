extends Control

signal tutorial_completed
signal tutorial_skipped

var is_manual_mode: bool = false

func _ready():
	# Conecta os botões existentes aos sinais
	if has_node("MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Buy"):
		$"MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Buy".pressed.connect(_on_next_pressed)
	
	if has_node("MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Pular Tutorial"):
		$"MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Pular Tutorial".pressed.connect(_on_skip_pressed)

# NOVA FUNÇÃO: Para definir se é modo manual
func set_manual_mode(manual: bool):
	is_manual_mode = manual
	if manual:
		# Pode alterar texto dos botões para modo manual
		if has_node("MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Buy/HBoxContainer/Label"):
			$"MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Buy/HBoxContainer/Label".text = "Fechar"
		if has_node("MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Pular Tutorial/Label"):
			$"MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Controls/Pular Tutorial/Label".text = "Fechar Tutorial"

func _on_next_pressed():
	emit_signal("tutorial_completed")
	queue_free()

func _on_skip_pressed():
	emit_signal("tutorial_skipped")
	queue_free()
