extends CanvasLayer

@onready var scene_instance = preload("res://scenes/game/game_manager.tscn").instantiate()
@onready var player_instance = preload("res://scenes/player/player.tscn").instantiate()

func _ready():
	var buttons = get_node('Panel/VBoxContainer').get_children()
	for button in buttons:
		button.pressed.connect(button_pressed.bind(button))
		
func custom_change_scene(scene):
	get_tree().root.add_child(scene_instance)
	get_tree().current_scene = scene_instance
	scene_instance.add_child(player_instance)
	scene_instance.player = player_instance
	
func button_pressed(button):
	match button.text:
		"New Game":
			print('TODO: Add warning that old save will be erased')
			custom_change_scene(scene_instance)
			queue_free()
			
		"Continue":
			custom_change_scene(scene_instance)
			Global.load_game("user://savegame.save")
			queue_free()
			
		"Exit To Deskop":
			get_tree().quit()
			
