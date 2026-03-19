extends ZombieBase

## BasicZombie - Standard zombie with balanced stats.

func _ready() -> void:
	speed = 35.0
	max_health = 100
	attack_damage = 10
	attack_rate = 1.0
	score_value = 50
	zombie_color = Color(0.58, 0.68, 0.48)
	super._ready()
