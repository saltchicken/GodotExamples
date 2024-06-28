extends Node

#var chest = preload("res://objects/chest/chest.tscn")
#var bow = preload("res://scenes/inventory/item/bow.tres")

#var rng = RandomNumberGenerator.new()
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
@onready var tile_map_layer = get_node('TileMapLayer')
@onready var placement_highlight_layer = get_node('PlacementHighlightMapLayer')
@onready var current_highlighted_tile_coords = Vector2i(0,0)

func _ready():
	# TODO: Put this in a better place
	# Fix for ugly cursors in inventory
	var can_drop_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	var forbidden_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	Input.set_custom_mouse_cursor(can_drop_cursor_img, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(forbidden_cursor_img, Input.CURSOR_FORBIDDEN)
	
	#var chest = chest.instantiate()
	#chest.init(bow)
	#chest.global_position = Vector2(100.0, 10.0)
	#add_child(chest)
	
# TODO: These are just for testing remove both '1' and '2'
func _process(_delta):
	tile_highlight()
	if Input.is_action_just_pressed('rightclick'):
		#set_tile_at_mouse_position(0, Vector2i(0,1))
		
		 #Best for setting in front of player
		
		var source_id = get_tile_source_id_player_facing()
		if source_id == -1:
			set_tile_player_facing(0, Vector2i(0,0), 1)
		else:
			reset_tile_source_id_player_facing()
		
		
		
		
		#print(tile_map_layer.get_cell_atlas_coords(Vector2(10,0)))
		#var pattern = tile_map_layer.get_pattern([Vector2(0,0)])
		
		#tile_map_layer.set_pattern(Vector2i(0,0), pattern)
		
		
		#print(tile_map_layer.tile_set)
		#print(tile_map_layer.tile_set.get_patterns_count())
		#print(tile_map_layer.tile_map_data)
		
		
		#var pattern = tile_map_layer.tile_set.get_pattern(0)
		#tile_map_layer.set_pattern(Vector2(15,0), pattern)
		
	pass		
	#if Input.is_action_just_pressed('TESTTESTTEST'):
		#var dialogue = get_node('DialogueLayer')
		#dialogue.set_text(['hello'])
		#dialogue.main()
	#if Input.is_action_just_pressed('1'):
		#print('saving game')
		#SceneManager.save_game()
	#
	#if Input.is_action_just_pressed('2'):
		#print('loading game')
		#SceneManager.load_game()
		
func tile_highlight():
	var tile_map_coords = placement_highlight_layer.local_to_map(player.global_position)
	tile_map_coords += Vector2i(player.direction)
	if tile_map_coords != current_highlighted_tile_coords:
		placement_highlight_layer.set_cell(current_highlighted_tile_coords, -1, Vector2i(-1,-1), -1)
		placement_highlight_layer.set_cell(tile_map_coords, 0, Vector2i(0,0), 0)
		current_highlighted_tile_coords = tile_map_coords
	else:
		pass

func set_tile_at_mouse_position(source_id: int, atlas_coords: Vector2i, alternative_tile: int = 0):
	var mouse_pos = tile_map_layer.get_global_mouse_position()
	var tile_map_coords = tile_map_layer.local_to_map(mouse_pos)
	tile_map_layer.set_cell(tile_map_coords, source_id, atlas_coords, 0)
	
func set_tile_player_facing(source_id: int, atlas_coords: Vector2i, alternative_tile: int = 0):
	var tile_map_coords = tile_map_layer.local_to_map(player.global_position)
	tile_map_coords += Vector2i(player.direction)
	tile_map_layer.set_cell(tile_map_coords, source_id, atlas_coords, alternative_tile)
	
func get_tile_source_id_player_facing():
	var tile_map_coords = tile_map_layer.local_to_map(player.global_position)
	tile_map_coords += Vector2i(player.direction)
	var tile_data = tile_map_layer.get_cell_source_id(tile_map_coords)
	return tile_data
	
func reset_tile_source_id_player_facing() -> void:
	var tile_map_coords = tile_map_layer.local_to_map(player.global_position)
	tile_map_coords += Vector2i(player.direction)
	tile_map_layer.set_cell(tile_map_coords, -1, Vector2i(-1,-1), -1)
	
	
