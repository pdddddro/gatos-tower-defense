extends Node2D

var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type

func _ready() -> void:
	map_node = get_node("Map1")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		#i.pressed.connect(self.initiate_build_mode, [i.get_name()])
		i.pressed.connect(Callable(self, "initiate_build_mode").bind(i.get_name()))
	
func _process(delta):
	if build_mode:
		update_cat_preview()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func initiate_build_mode(cat_type):
	build_type = cat_type
	build_mode = true
	get_node("UI").set_cat_preview(build_type, get_global_mouse_position())

func update_cat_preview():
	var mouse_position = get_global_mouse_position()
	var exclusion_layer = map_node.get_node("Exclusion")
	var scaled_mouse_position = exclusion_layer.to_local(mouse_position) / exclusion_layer.scale
	var current_tile = exclusion_layer.local_to_map(scaled_mouse_position)
	var tile_position = exclusion_layer.map_to_local(current_tile) * exclusion_layer.scale
	
	if exclusion_layer.get_cell_source_id(current_tile) == -1:
		get_node("UI").update_cat_preview(tile_position, "ad54ff")
		build_valid = true
		build_location = tile_position

	else:
		get_node("UI").update_cat_preview(tile_position, "adff45")
		build_valid = false
	
	print(build_valid)
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/CatPreview").queue_free()
	
func verify_and_build():
	if build_valid:
		var new_cat = load("res://Scenes/Cats/" + build_type + ".tscn").instantiate()
		new_cat.position = build_location
		map_node.get_node("Cats").add_child(new_cat, true)
