extends TextureButton

func _ready():
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_click)

func _on_hover():
	if disabled:
		return
		
	GameData.play_sound("ui", "button", "hover")

func _on_click():
	if disabled:
		return
		
	GameData.play_sound("ui", "button", "click")
	
	
