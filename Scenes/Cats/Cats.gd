extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var attack_ready = true
var status = "Idle"
var direction = Vector2.ZERO 

var individual_stats = {}
var damage_bonuses_vs_type = {}

## Coletar as estatísticas do gato
var total_damage_dealt: int = 0
var total_fish_earned: int = 0
var enemies_defeated: int = 0

func add_damage(amount: int):
	total_damage_dealt += amount
	individual_stats["total_damage_dealt"] = total_damage_dealt
	GameData.total_damage += amount

func add_fish_earned(fish_amount):
	total_fish_earned += fish_amount
	individual_stats["fish_collected"] = total_fish_earned
	GameData.fishs_collected += fish_amount

func add_enemy_defeated():
	enemies_defeated += 1
	individual_stats["enemies_defeated"] = enemies_defeated
	GameData.enemies_defeated += 1
	
func get_equipped_cards():
	return equipped_cards

func _ready():
	if built:
		initialize_individual_stats()
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

func initialize_individual_stats():
	individual_stats = GameData.cat_data[type].duplicate(true)
	individual_stats["enemies_defeated"] = 0
	individual_stats["fish_collected"] = 0
	individual_stats["total_damage_dealt"] = 0
	print("Estatísticas individuais inicializadas para ", type, ": ", individual_stats)

var showing_range = false

### Desenhar Range, depois preciso modificar o preview de colocar o gato
func _draw():
	# Desenha o range apenas se deve mostrar e o gato está construído
	if showing_range and built:
		var radius = individual_stats["range"]/2
		draw_circle(Vector2.ZERO, radius, Color(0, 0.7, 1, 0.3))  # Círculo preenchido azul semi-transparente
		draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color(0, 0.7, 1, 0.8), 1)  # Borda azul

func show_range():
	showing_range = true
	queue_redraw()
	print("Mostrando range do gato: ", individual_stats["range"])

func hide_range():
	showing_range = false
	queue_redraw()

func select_enemy():
	var valid_enemies = []
	var valid_progress_array = []
	
	# Filtra apenas inimigos que este gato pode atacar
	for enemy in enemy_array:
		if can_target_enemy(enemy):
			valid_enemies.append(enemy)
			valid_progress_array.append(enemy.progress)
	
	if valid_enemies.size() == 0:
		enemy = null
		return
	
	var max_offset = valid_progress_array.max()
	var enemy_index = valid_progress_array.find(max_offset)
	enemy = valid_enemies[enemy_index]

func can_target_enemy(target_enemy) -> bool:
	var allowed_targets = individual_stats.get("target_types", [])
	
	if allowed_targets.size() == 0:
		return true
	
	# Verifica se o tipo do inimigo está na lista permitida
	return target_enemy.type in allowed_targets

func apply_card_effect(effect_data: Dictionary):
	var effect_type = effect_data["type"]
	var power = effect_data.get("power", 0)
	var power_type = effect_data.get("power_type", "absolute")
	
	match effect_type:
		"damage_vs_type":
			var target_type = effect_data.get("target_type", "")
			if target_type != "":
				var current_bonus = damage_bonuses_vs_type.get(target_type, 0)
				if power_type == "percentage":
					var base_damage = individual_stats["damage"]  # Usa stats individuais
					var bonus_damage = base_damage * (power / 100.0)
					damage_bonuses_vs_type[target_type] = current_bonus + bonus_damage
				else:
					damage_bonuses_vs_type[target_type] = current_bonus + power
				print("Bônus de dano contra ", target_type, ": +", damage_bonuses_vs_type[target_type])
		
		"damage_boost":
			if power_type == "percentage":
				var damage_increase = individual_stats["damage"] * (power / 100.0)  # Usa stats individuais
				individual_stats["damage"] += damage_increase  # Modifica apenas este gato
				print("Dano aumentado em ", power, "% (", damage_increase, "). Novo dano: ", individual_stats["damage"])
			else:
				individual_stats["damage"] += power  # Modifica apenas este gato
				print("Dano aumentado em ", power, ". Novo dano: ", individual_stats["damage"])
		
		"speed_boost":
			if power_type == "percentage":
				var cooldown_reduction = individual_stats["atkcooldown"] * (power / 100.0)  # Usa stats individuais
				individual_stats["atkcooldown"] = max(0.1, individual_stats["atkcooldown"] - cooldown_reduction)
				print("Velocidade aumentada em ", power, "% (", cooldown_reduction, "s). Novo cooldown: ", individual_stats["atkcooldown"])
			else:
				individual_stats["atkcooldown"] = max(0.1, individual_stats["atkcooldown"] - power)
				print("Velocidade aumentada em ", power, "s. Novo cooldown: ", individual_stats["atkcooldown"])
		
		"range_boost":
			if power_type == "percentage":
				var range_increase = individual_stats["range"] * (power / 100.0)  # Usa stats individuais
				individual_stats["range"] += range_increase
				print("Alcance aumentado em ", power, "% (", range_increase, "). Novo alcance: ", individual_stats["range"])
			else:
				individual_stats["range"] += power
				print("Alcance aumentado em ", power, ". Novo alcance: ", individual_stats["range"])
			
			# Atualiza o range visual usando stats individuais
			if built:
				get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * individual_stats["range"]
				
			queue_redraw()
		
		"target_expansion":
			var new_targets = effect_data.get("target_types", [])
			if "all" in new_targets:
				individual_stats["target_types"] = []  # Modifica apenas este gato
			else:
				var current_targets = individual_stats.get("target_types", [])  # ✅ Usa stats individuais
				for target_type in new_targets:
					if target_type not in current_targets:
						current_targets.append(target_type)
				individual_stats["target_types"] = current_targets
			print("Tipos de alvo atualizados para ", type, ": ", individual_stats["target_types"])
		
		"critic_boost":
			if power_type == "percentage":
				var crit_increase = individual_stats["critical_chance"] * (power / 100.0)
				individual_stats["critical_chance"] += crit_increase
				print("Chance crítica aumentada em ", power, "% (", crit_increase, "). Nova chance: ", individual_stats["critical_chance"])
			else:
				individual_stats["critical_chance"] += power
				print("Chance crítica aumentada em ", power, ". Nova chance: ", individual_stats["critical_chance"])

func calculate_damage_against_enemy(enemy_type: String) -> int:
	var base_damage = individual_stats["damage"]
	var total_damage = base_damage
	
	# Verifica bônus específico contra o tipo
	if damage_bonuses_vs_type.has(enemy_type):
		total_damage += damage_bonuses_vs_type[enemy_type]
		print("Aplicando bônus vs ", enemy_type, ": +", damage_bonuses_vs_type[enemy_type])
		
	return int(total_damage)

func turn():
	if enemy != null and is_instance_valid(enemy):
		var direction = (enemy.position - self.position).normalized()
		update_animation(direction)
	else:
		# Comportamento quando não há inimigo válido
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
	
	if enemy_array.size() > 0 and enemy != null and can_target_enemy(enemy):
		var projectile = projectile_scene.instantiate()
		projectile.type = str(type)
		projectile.enemy = enemy
		
		var base_damage = calculate_damage_against_enemy(enemy.type)
		var damage_result = calculate_final_damage(base_damage)
		
		projectile.damage = damage_result["damage"]
		projectile.is_critical = damage_result["is_critical"]
		projectile.source_cat = self
		
		var aim_position = $Aim.global_position
		projectile.global_position = aim_position
		get_parent().add_child(projectile)
		
		await get_tree().create_timer(individual_stats["atkcooldown"]).timeout
		attack_ready = true
	else:
		status = "Idle"
		attack_ready = true

func calculate_final_damage(base_damage: int) -> Dictionary:
	var crit_chance = individual_stats["critical_chance"]
	var is_critical = randf() * 100 < crit_chance
	
	var final_damage = base_damage
	var damage_multiplier = 1.5  # 50% de dano extra (padrão em muitos jogos)
	
	if is_critical:
		final_damage = int(base_damage * damage_multiplier)
		print("CRÍTICO! Dano: ", final_damage, " (", base_damage, " x ", damage_multiplier, ")")
	
	return {
		"damage": final_damage,
		"is_critical": is_critical,
		"multiplier": damage_multiplier if is_critical else 1.0
	}


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
			shop.set_current_cat(self)
			shop.update_cat_info(type)  
			
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
		
		for effect in card_data.effects:
			apply_card_effect(effect)
			print("Efeito aplicado: ", effect)
		
		# Debug da loja
		if shop:
			shop.update_equipped_cards_ui(equipped_cards)
		
		return true
	else:
		return false
