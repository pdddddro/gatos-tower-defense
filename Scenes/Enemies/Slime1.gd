extends PathFollow2D

var speed = 100
var hp = 40

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )

func on_hit(damage):
	hp -= damage
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	queue_free()
