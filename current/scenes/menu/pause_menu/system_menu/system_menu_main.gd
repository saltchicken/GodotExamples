extends Node

@onready var pause_menu = get_owner()

func _ready():
	for button in get_node('SystemButtonContainer').get_children():
		button.pressed.connect(system_button_press.bind(button))
		
func system_button_press(button):
	match button.text:
		'Resume':
			pause_menu.close_pause_menu()
		'Restart':
			pause_menu.close_pause_menu()
			Global.restart()
		'Quit':
			pause_menu.close_pause_menu()
			get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
		'Load Last Save':
			Global.load_game()
