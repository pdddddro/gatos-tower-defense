extends TextureButton

var card_data: Dictionary
signal card_selected(selected_card_data)

func _on_pressed() -> void:
	card_selected.emit(card_data)
	pass
