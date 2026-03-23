extends ZombieBase

## TankZombie - Slow, heavily armored zombie.
## Takes many hits to defeat. High score reward.

func _ready() -> void:
	speed = 18.0
	max_health = 400
	attack_damage = 20
	attack_rate = 0.6
	score_value = 150
	zombie_color = Color(0.35, 0.42, 0.32)
	super._ready()
