extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var attack_ready = true
var status = "Idle"
var direction = Vector2.ZERO 

func _ready():
	if built:
		get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.cat_data[type]["range"]

	if has_node("ClickableArea"):
		var clickable = get_node("ClickableArea")
		clickable.collision_layer = 1  # Layer 1 para gatos
		clickable.collision_mask = 0   # Não precisa detectar nada
		clickable.monitoring = false   # Não monitora outros objetos
		clickable.monitorable = true   # Pode ser detectado por outros
		print("ClickableArea configurado para gato: ", type)

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		
		select_enemy()
		turn()
		
		if attack_ready:
			status = "Attack"
			attack()
			
	elif built:
		status = "Idle"
		enemy = null
		update_animation(Vector2(-1 if last_flip_h else 1, 0))

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
		
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	
	# Seleciona o inimigo que estiver mais perto do final
	enemy = enemy_array[enemy_index]
	
func apply_card_effect(effect_type: String, power: float):
	match effect_type:
		"damage_boost":
			# Aumenta o dano base do gato
			GameData.cat_data[type]["damage"] += power
			print("Dano aumentado em ", power, ". Novo dano: ", GameData.cat_data[type]["damage"])
			
		"speed_boost":
			# Reduz o cooldown de ataque
			GameData.cat_data[type]["atkcooldown"] = max(0.1, GameData.cat_data[type]["atkcooldown"] - power)
			print("Velocidade aumentada. Novo cooldown: ", GameData.cat_data[type]["atkcooldown"])
			
		"range_boost":
			# Aumenta o alcance
			GameData.cat_data[type]["range"] += power
			# Atualiza o range visual
			if built:
				get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.cat_data[type]["range"]
				print("Alcance aumentado em ", power, ". Novo alcance: ", GameData.cat_data[type]["range"])
		_:
			print("Efeito desconhecido: ", effect_type)

func turn():
	var direction = (enemy.position - self.position).normalized()
	update_animation(direction)

var last_flip_h = false

func update_animation(direction):
	var dir = ""
	
	if direction.y < -0.6:
		dir += "Up"
	else:
		dir += "Down"

	# Só atualiza o flip se houver direção horizontal
	if direction.x < 0:
		dir += "Right"
		$AnimatedSprite2D.flip_h = true
		last_flip_h = true
	elif direction.x > 0:
		dir += "Right"
		$AnimatedSprite2D.flip_h = false
		last_flip_h = false
	else:
		# Se não houver movimento horizontal, mantém o último flip
		$AnimatedSprite2D.flip_h = last_flip_h

	$AnimatedSprite2D.play(status + dir)

var projectile_scene = preload("res://Scenes/Cats/Projectile.tscn")

func attack():
		
	attack_ready = false

	if enemy_array.size() > 0:
		var projectile = projectile_scene.instantiate()
		
		projectile.type = str(type)
		
		projectile.enemy = enemy
		projectile.type = type
		projectile.damage = GameData.cat_data[type]["damage"]  # Passe o dano para o projétil
		
		var aim_position = $Aim.global_position
		projectile.global_position = aim_position
		
		get_parent().add_child(projectile)
		
		await get_tree().create_timer(GameData.cat_data[type]["atkcooldown"]).timeout
		attack_ready = true
		
	else:
		status = "Idle"
		attack_ready = true

func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())

@onready var shop = get_node("../../../UI/HUD/MarginContainer/Control/Control")

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Gato clicado!")
		print(shop)
		if shop and built:
			shop.open_cat_info()
			shop.update_cat_info(type)
