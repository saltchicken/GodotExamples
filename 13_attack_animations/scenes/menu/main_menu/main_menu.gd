extends CanvasLayer

func _ready():
	var buttons = get_node('Panel/VBoxContainer').get_children()
	for button in buttons:
		button.pressed.connect(button_pressed.bind(button))

func button_pressed(button):
	match button.text:
		"Start Game":
			get_tree().change_scene_to_file("res://scenes/game/game_manager.tscn")
		"Load Game":
			print('Not implemented yet')
		"Exit To Deskop":
			get_tree().quit()	
