extends TextureButton

var card_data: Dictionary

func _ready():
	connect("pressed", _on_card_selected)

func _on_card_selected():
	print("Carta selecionada: ", card_data.name)
	# Aqui você pode adicionar a lógica para quando o jogador escolher esta carta
	# Por exemplo: adicionar ao inventário, fechar o pack, etc.
