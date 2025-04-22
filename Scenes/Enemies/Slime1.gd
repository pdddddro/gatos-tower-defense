extends PathFollow2D

signal base_damage(damage)
signal enemy_defeated

var speed = 100
var hp = 40

var base_damage_value = 21

func _physics_process(delta: float) -> void:
	if progress_ratio == 1.0:
		emit_signal("base_damage", base_damage_value)
		queue_free()
	
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )

func on_hit(damage):
	hp -= damage
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	emit_signal("enemy_defeated")
	queue_free()
