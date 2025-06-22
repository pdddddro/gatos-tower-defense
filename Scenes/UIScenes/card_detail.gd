extends Control

@export var card_scene: PackedScene = preload("res://Scenes/UIScenes/CardPack.tscn")

func setup_card_detail(card_data: Dictionary):
	var card_instance = card_scene.instantiate()
	# Configura os dados da carta instanciada
	var vbox = card_instance.get_node("MarginContainer/VBoxContainer")
	vbox.get_node("CardName").text = card_data["name"]
	vbox.get_node("CardIcon").texture = load(card_data["icon"])
	vbox.get_node("CardDescription").text = card_data["description"]

	GameData.apply_card_rarity_texture(card_instance, card_data["name"])

	# Adiciona a carta ao HBoxContainer correto
	var hbox = $VBoxContainer/HBoxContainer
	hbox.add_child(card_instance)
	
func _on_close_pressed():
	get_tree().paused = false
	queue_free()
