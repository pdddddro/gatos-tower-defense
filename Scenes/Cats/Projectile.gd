extends Area2D

var enemy: Node
var type: String
var speed = 400
var damage: int

var is_critical = false 

func _ready():
	#body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play(type)

func _process(delta):
	if is_instance_valid(enemy) and enemy.collision_shape:
		var direction = (enemy.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		rotation = direction.angle()
		
		# Destrói se estiver muito perto do alvo
		if global_position.distance_to(enemy.global_position) < 15:
			_on_body_entered(enemy.get_node("CharacterBody2D"))
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
		
		# Calcula dano específico contra este tipo de inimigo
		var final_damage = damage
		if source_cat and source_cat.has_method("calculate_damage_against_enemy"):
			final_damage = source_cat.calculate_damage_against_enemy(hit_enemy.type)
			print("Dano calculado contra ", hit_enemy.type, ": ", final_damage)
			
		var enemy_defeated = await hit_enemy.on_hit(final_damage, source_cat)
		
		queue_free()
