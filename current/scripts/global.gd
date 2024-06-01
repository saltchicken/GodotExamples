extends Node

func restart():
	# TODO: This doesn't work
	var scene_path = get_tree().current_scene.scene_file_path
	get_tree().unload_current_scene()
	get_tree().change_scene_to_file(scene_path)
	
func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
	
		var node_data = node.call("save")
		
		var json_string = JSON.stringify(node_data)
		
		save_game.store_line(json_string)
		
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		if i is Player:
			continue
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.get_data()
		var new_object
		# Check if loading player. Handle in custom player loading function
		if node_data["filename"] == "res://scenes/player/player.tscn":
			get_tree().get_nodes_in_group("Players")[0].load_player(node_data)
			continue
		else:
			new_object = load(node_data["filename"]).instantiate()
		
		# Handle StateMachine initialization
		if node_data.has('current_state'):
			new_object.initial_state = new_object.get_node('StateMachine').get_node(node_data['current_state'])
			node_data.erase('current_state')

		if node_data["filename"] == "res://scenes/player/player.tscn":
			pass
		else:
			get_node(node_data["parent"]).add_child(new_object)	
		
		
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if i == 'item':
				new_object.item = load(node_data[i])
			new_object.set(i, node_data[i])
