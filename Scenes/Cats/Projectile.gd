extends Area2D

var enemy: Node
var type: String
var speed = 400
var damage: int

func _ready():
	body_entered.connect(_on_body_entered) ## Desativei isso pra parar de dar um erro no console, mas ele nao tava afetando em nada, qualquer coisa ativa dnv
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
	var hit_enemy = body.get_parent()  # Acessa o PathFollow2D
	if hit_enemy == enemy:
		hit_enemy.on_hit(damage)
		
		if source_cat and source_cat.has_method("add_damage"):
			source_cat.add_damage(damage)
		
		queue_free()
