extends Area2D

var enemy: Node
var type: String
var speed = 400
var damage: int

func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play(type)

func _process(delta):
	if is_instance_valid(enemy) and enemy.collision_shape:
		var direction = (enemy.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		rotation = direction.angle()
		
		# Destrói se estiver muito perto do alvo
		if global_position.distance_to(enemy.global_position) < 1:
			queue_free()
	else:
		queue_free()

var source_cat: Node = null

func _on_body_entered(body: Node):
	var hit_enemy = body.get_parent()
	
	if hit_enemy == enemy:
		# Verifica se o gato de origem pode atacar este tipo de inimigo
		if source_cat and source_cat.has_method("can_target_enemy"):
			if not source_cat.can_target_enemy(hit_enemy):
				print("Gato ", source_cat.type, " não pode atacar ", hit_enemy.type)
				queue_free()
				return
		
		var enemy_defeated = await hit_enemy.on_hit(damage)
		
		if source_cat and source_cat.has_method("add_damage"):
			source_cat.add_damage(damage)
			
			if enemy_defeated:
				var fish_reward = GameData.enemies_data[hit_enemy.type]["fish_reward"]
				source_cat.add_fish_earned(fish_reward)
				source_cat.add_enemy_defeated()
		
		queue_free()
