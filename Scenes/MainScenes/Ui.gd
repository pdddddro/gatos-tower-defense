extends CanvasLayer

func set_cat_preview(cat_type, mouse_position):
	
	var drag_cat = load("res://Scenes/Cats/" + cat_type + "/" + cat_type + ".tscn").instantiate()
	drag_cat.set_name("DragCat")
	drag_cat.modulate = Color("ad54ff")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(0, 0)
	
	#
	var scaling = GameData.cat_data[cat_type]["range"] / 128.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/Range.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ff5439d9")
	
	var control = Control.new()
	control.add_child(drag_cat, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("CatPreview")
	add_child(control, true)

	move_child(get_node("CatPreview"), 0)

func update_cat_preview(new_position, color):
	#na 4.0 o rect.position virou position apenas
	get_node("CatPreview").position = new_position
	if get_node("CatPreview/DragCat").modulate != Color(color):
		get_node("CatPreview/DragCat").modulate = Color(color)
		
		get_node("CatPreview/Sprite2D").modulate = Color(color)
