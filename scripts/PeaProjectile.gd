extends Area2D

## PeaProjectile - Fired by PeaShooter, moves right, damages zombies.

var speed: float = 350.0
var damage: int = 25
var row_y: float = 0.0   # Set by PeaShooter so pea stays on row

func _ready() -> void:
	# Listen for body (CharacterBody2D = zombie) collisions
	body_entered.connect(_on_body_entered)
	# Auto-destroy after 5 seconds (in case it misses everything)
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _process(delta: float) -> void:
	position.x += speed * delta
	# Destroy if off right side of screen
	if position.x > 1200.0:
		queue_free()

## Deal damage when hitting a zombie body.
func _on_body_entered(body: Node) -> void:
	if body is ZombieBase:
		body.take_damage(damage)
		queue_free()

## Draw pea as a small green circle.
func _draw() -> void:
	draw_circle(Vector2.ZERO, 9, Color(0.15, 0.7, 0.15))
	draw_circle(Vector2.ZERO, 9, Color(0.05, 0.45, 0.05), false, 2.0)
