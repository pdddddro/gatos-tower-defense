extends PathFollow2D

var speed = 100

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta )
