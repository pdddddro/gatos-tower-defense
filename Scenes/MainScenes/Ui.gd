extends CanvasLayer

func set_cat_preview(cat_type, mouse_position):
	
	var drag_cat = load("res://Scenes/Cats/" + cat_type + ".tscn").instantiate()
	drag_cat.set_name("DragCat")
	drag_cat.modulate = Color("ad54ff")
	
	var control = Control.new()
	control.add_child(drag_cat, true)
	control.position = mouse_position
	control.set_name("CatPreview")
	add_child(control, true)
	drag_cat.scale = Vector2(2, 2)

	move_child(get_node("CatPreview"), 0)

func update_cat_preview(new_position, color):
	#na 4.0 o rect.position virou position apenas
	get_node("CatPreview").position = new_position * 2
	if get_node("CatPreview/DragCat").modulate != Color(color):
		get_node("CatPreview/DragCat").modulate = Color(color)
