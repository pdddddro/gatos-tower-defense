extends AnimatedSprite2D

var tween: Tween
var min_opacity: float = .6
var max_opacity: float = .1
var pulse_duration: float = .5

func _ready():
	tween = create_tween()
	pulse_opacity()

func pulse_opacity():
	# Vai para opacidade mínima
	tween.tween_property(self, "modulate:a", min_opacity, pulse_duration)
	# Volta para opacidade máxima
	tween.tween_property(self, "modulate:a", max_opacity, pulse_duration)
	# Repete infinitamente
	tween.set_loops()
	# Usa easing para transição mais suave
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
