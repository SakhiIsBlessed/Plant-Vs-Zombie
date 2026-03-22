extends Node

## GameOver - handles the Game Over screen.

func _ready() -> void:
	$VBoxContainer/ScoreLabel.text = "Final Score: " + str(GameManager.score)
	$VBoxContainer/RestartBtn.pressed.connect(_on_restart_pressed)
	$VBoxContainer/MenuBtn.pressed.connect(_on_menu_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
