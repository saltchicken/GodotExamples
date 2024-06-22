extends Node

@onready var pause_menu = get_owner()

func _ready():
	for button in get_node('SystemButtonContainer').get_children():
		button.pressed.connect(system_button_press.bind(button))
		
func system_button_press(button):
	match button.text:
		'Resume':
			pause_menu.close_pause_menu()
		'Save':
			SceneManager.save_game(self)
		'Quit':
			pause_menu.close_pause_menu()
			var reference_to_gameplay = get_node("/root/Gameplay")
			print(reference_to_gameplay)
			SceneManager.swap_scenes("res://scenes/menu/main_menu/main_menu.tscn",get_tree().root,reference_to_gameplay,"fade_to_black")
			#get_tree().change_scene_to_file()
