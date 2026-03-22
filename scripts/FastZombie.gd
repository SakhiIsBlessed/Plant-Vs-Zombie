extends ZombieBase

## FastZombie - Speedy but fragile zombie.
## Moves quickly but has low health. Worth more score.

func _ready() -> void:
	speed = 75.0
	max_health = 50
	attack_damage = 8
	attack_rate = 1.2
	score_value = 75
	zombie_color = Color(0.7, 0.85, 0.6)
	super._ready()
