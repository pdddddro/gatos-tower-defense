extends Node2D

var enemy = null
var target_status = null
var speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # tem que mudar a forma de detecção, o slime fica dead antes de morrer mesmo
	if is_instance_valid(enemy) and not enemy.dead:
		var direction = (enemy.global_position - global_position).normalized()
		global_position += direction * speed * delta
		# Quando chegar perto do inimigo, some
		
		if global_position.distance_to(enemy.global_position) <= 0.5:
			queue_free()
	else:
		queue_free()
