extends CanvasLayer

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	#if get_tree().paused:
		#get_tree().paused = !get_tree().paused

func _on_load_game_pressed():
	print('Not implemented yet')

func _on_exit_to_desktop_pressed():
	get_tree().quit()
