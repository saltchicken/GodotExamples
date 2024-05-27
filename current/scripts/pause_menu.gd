extends Control

@onready var game = $"../../.."

func _on_resume_pressed():
	game.pauseMenu()

func _on_restart_pressed():
	game.pauseMenu()
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_quit_pressed():
	get_tree().quit()
