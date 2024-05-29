extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_load_game_pressed():
	print('Not implemented yet')


func _on_exit_to_desktop_pressed():
	get_tree().quit()
