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
			load_game("user://savegame.save")
			queue_free()
			
		"Exit To Deskop":
			get_tree().quit()
			
func load_game(save_file):
	if not FileAccess.file_exists(save_file):
		print("Error: There is no saved game.")
		return # TODO: Implement better logic for this case
	var persisting_nodes = {}
	for node in get_tree().get_nodes_in_group("Persist"):
		persisting_nodes[node.name] = node
		
	var save_game_file = FileAccess.open(save_file, FileAccess.READ)
	while save_game_file.get_position() < save_game_file.get_length():
		var json_string = save_game_file.get_line()
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
			
		var node_data = json.get_data()
		if not node_data.has('node_name'):
			print('Improperly saved node. Skipping')
		else:
			match node_data['node_name']:
				'InventoryMenu':
					var node = persisting_nodes[node_data['node_name']]
					node.load(node_data)
				'SpellsMenu':
					var node = persisting_nodes[node_data['node_name']]
					node.load(node_data)
				_:
					print("%s not handled." % node_data['node_name'])
