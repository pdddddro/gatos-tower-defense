extends TextureButton



func _ready():
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_click)

func _on_hover():
	var sound_path = GameData.sound_data["ui"]["button_hover"]
	AudioManager.play_sfx(sound_path)

func _on_click():
	var sound_path = GameData.sound_data["ui"]["button_click"]
	AudioManager.play_sfx(sound_path)
	
