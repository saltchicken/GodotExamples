extends Node

var dialogue_node = preload("res://scenes/dialogue/dialogue_panel.tscn")
var hit_indicator_node = preload("res://scenes/dialogue/hit_indicator.tscn")
var slime_node = preload("res://scenes/enemy/slime/slime.tscn")

func dialogue(parent_node, text_array: Array):
	var dialogue_instance = dialogue_node.instantiate()
	parent_node.add_child(dialogue_instance)
	dialogue_instance.set_text(text_array)
	dialogue_instance.main()
	
func hit_indicator(parent_node, text_info: String, x_offset: float = 0.0, y_offset: float = 10.0):
	var hit_indicator_instance = hit_indicator_node.instantiate()
	parent_node.add_child(hit_indicator_instance)
	hit_indicator_instance.set_text(text_info)
	hit_indicator_instance.x_offset = x_offset
	hit_indicator_instance.y_offset = y_offset
	hit_indicator_instance.main()
	
func spawn_enemy(parent_node, position):
	var slime_instance = slime_node.instantiate()
	slime_instance.position = position
	parent_node.add_child(slime_instance)
	
func check_if_space_occupied(parent_node, position: Vector2):
	pass
	#var sensor = sensor_node.instantiate()
	#sensor.position = position
	#parent_node.add_child(sensor)
	#if sensor.check_for_bodies():
		#print('found')
	
	
func restart():
	# TODO: This doesn't work
	var scene_path = get_tree().current_scene.scene_file_path
	get_tree().unload_current_scene()
	get_tree().change_scene_to_file(scene_path)
	
func save_game():
	var save_game_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
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
		
		save_game_file.store_line(json_string)
		
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
	var save_game_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game_file.get_position() < save_game_file.get_length():
		var json_string = save_game_file.get_line()
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
		
		get_node(node_data["parent"]).add_child(new_object)	
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if i == 'item':
				new_object.item = load(node_data[i])
			new_object.set(i, node_data[i])
