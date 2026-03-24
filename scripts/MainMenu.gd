extends Node

## MainMenu - handles the main menu screen.

func _ready() -> void:
	$VBoxContainer/StartBtn.pressed.connect(_on_start_pressed)
	$VBoxContainer/QuitBtn.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
