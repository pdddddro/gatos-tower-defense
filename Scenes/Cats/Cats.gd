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
		update_animation(Vector2.ZERO)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
		
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	
	# Seleciona o inimigo que estiver mais perto do final
	enemy = enemy_array[enemy_index]
	

func turn():
	var direction = (enemy.position - self.position).normalized()
	update_animation(direction)

func update_animation(direction):
	var dir = ""
	
	if direction.y < 0:
		dir += "Up"
	else:
		dir += "Down"

	if direction.x < 0:
		dir += "Left"
	else:
		dir += "Right"
	
	$AnimatedSprite2D.play(status + dir)

var projectile_scene = preload("res://Scenes/Cats/Projectile.tscn")

func attack():
		
	attack_ready = false

	if enemy_array.size() > 0:
		print(attack_ready)
		
		var projectile = projectile_scene.instantiate()
		
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.enemy = enemy
		enemy.on_hit(GameData.cat_data[type]["damage"])
		await get_tree().create_timer(GameData.cat_data[type]["atkcooldown"]).timeout
		attack_ready = true
		
	else:
		status = "Idle"
		attack_ready = true

func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
