extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var attack_ready = true
var status = "Idle"
var direction = Vector2.ZERO 

## Coletar as estatísticas do gato
var total_damage_dealt: int = 0
var total_fish_earned: int = 0
var enemies_defeated: int = 0

func add_damage(amount: int):
	total_damage_dealt += amount

func add_fish_earned(fish_amount):
	total_fish_earned += fish_amount

func add_enemy_defeated():
	enemies_defeated += 1
	
func get_equipped_cards():
	return equipped_cards

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
		
	add_to_group("active_cats")

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

var showing_range = false

### Desenhar Range, depois preciso modificar o preview de colocar o gato
func _draw():
	# Desenha o range apenas se deve mostrar e o gato está construído
	if showing_range and built:
		var radius = GameData.cat_data[type]["range"]/2
		draw_circle(Vector2.ZERO, radius, Color(0, 0.7, 1, 0.3))  # Círculo preenchido azul semi-transparente
		draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color(0, 0.7, 1, 0.8), 1)  # Borda azul

func show_range():
	showing_range = true
	queue_redraw()
	print("Mostrando range do gato: ", GameData.cat_data[type]["range"])

func hide_range():
	showing_range = false
	queue_redraw()

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
		projectile.source_cat = self
		
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
			shop.set_current_cat(self) 
			
			hide_all_cat_ranges()
			show_range()

func hide_all_cat_ranges():
	var cats_node = get_parent()
	for cat in cats_node.get_children():
		if cat.has_method("hide_range"):
			cat.hide_range()

## Gato salvar cartas equipadas
var equipped_cards = []
var max_cards = 4

func can_equip_card() -> bool:
	return equipped_cards.size() < max_cards

func equip_card(card_data: Dictionary) -> bool:
	print("Pode equipar? ", can_equip_card())
	print("Cartas atuais: ", equipped_cards.size(), "/", max_cards)
	
	if can_equip_card():
		equipped_cards.append(card_data)
		print("Carta equipada com sucesso: ", card_data.name)
		print("Total de cartas agora: ", equipped_cards.size())
		
		apply_card_effect(card_data.effects[0].type, card_data.effects[0].power)
		
		# Debug da loja
		if shop:
			shop.update_equipped_cards_ui(equipped_cards)
		
		return true
	else:
		return false
