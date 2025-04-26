extends PathFollow2D

@export var type: String = ""

signal base_damage(damage)
signal enemy_defeated(enemy_type)
signal enemy_escaped()

var speed = 0
var hp = 0
var enemy_damage = 0

func _ready() -> void:
	init_status()

func init_status():
	speed = GameData.enemies_data[type]["speed"]
	hp = GameData.enemies_data[type]["hp"]
	enemy_damage = GameData.enemies_data[type]["damage"]

func _physics_process(delta: float) -> void:
	
	if progress_ratio == 1.0:
		emit_signal("base_damage", enemy_damage)

		if dead == false:
			emit_signal("enemy_escaped", type)
			dead = true
			queue_free()
	
	move(delta)

func move(delta):
	set_progress(get_progress() + speed * delta )

var dead = false

func on_hit(damage):
	hp -= damage
	
	if hp <= 0 and dead == false:
		dead = true
		emit_signal("enemy_defeated", type)
		queue_free()
		
