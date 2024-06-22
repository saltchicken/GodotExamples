class_name Level extends Node2D

## This class is not part of [class SceneManager], it's just here to make the sample
## project do something. All levels (i.e. the game content) extend from this class. 
## You will note that because Levels "want" to pass data between them, they implement
## the optional methods [method get_data] and [method receive_data]

@onready var enemy_scenes: Array[PackedScene] = [ preload('res://scenes/enemy/enemies/red_slime/red_slime.tscn'),
											preload('res://scenes/enemy/enemies/green_slime/green_slime.tscn') ]

var rng = RandomNumberGenerator.new()

var MAX_ENEMIES = 1000
var ENEMIES_COUNT = 0

var player:Player
@onready var doors = find_children("*", "Door")
var data:LevelDataHandoff

@onready var gameplay = get_parent().get_parent() # TODO: Better way to reference or not need this at all

@onready var red_slime_timer = Timer.new()
@onready var green_slime_timer = Timer.new()

func _ready() -> void:
	print('Level is ready')
	player = gameplay.player
	add_child(player)
	player.disable()
	player.visible = false
	
	register_bonfires()
	add_child(red_slime_timer)
	add_child(green_slime_timer)
	red_slime_timer.wait_time = 0.25
	green_slime_timer.wait_time = 1.0
	red_slime_timer.timeout.connect(spawn_red_slime)
	red_slime_timer.start()
	green_slime_timer.timeout.connect(spawn_green_slime)
	green_slime_timer.start()
	
	# This block is here to allow us to test current scene without needing the SceneManager to call these :) 
	if data == null: 
		init_scene()
		start_scene()
		

## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to receive this data and pass it to the next scene
func get_data():
	return data
	
## 1) emitted at the beginning of SceneManager.on_content_finished_loading
## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to insert data received from the previous scene into this one	
func receive_data(_data):
	# implementing class should do some basic checks to make sure it only acts on data it's prepared to accept
	# if previous scene sends data this scene doesn't need, simple logic as follows ensures no crash occurs
	# act only on the data you want to receive and process :) 
	if _data is LevelDataHandoff:
		data = _data
		# process data here if need be, for this we just need to receive it but only if it's of the correct data type
	else:
		push_warning("Level %s is receiving data it cannot process" % name)

# Emitted in the middle of SceneManager.on_content_finished_loading
func init_scene() -> void:
	print("Init scene")
	#init_player_location()

# Emitted at end of SceneManager.on_content_finished_loading
func start_scene() -> void:
	player.enable()
	print("Start scene")
	_connect_to_doors()

# signal emitted by Door, # disables doors and players, create handoff data to pass to the new scene (if new scene is a Level)
func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.disable()
	#data = LevelDataHandoff.new()
	#data.entry_door_name = door.entry_door_name
	#data.move_dir = door.get_move_dir()
		

# connects to all door signals in level
func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

# disconnect from all door signals in level			
func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
			
func register_bonfires():
	for bonfire in get_tree().get_nodes_in_group("Bonfires"):
		bonfire.area_2d.body_entered.connect(bonfire_body_entered.bind(bonfire))
		bonfire.area_2d.body_exited.connect(bonfire_body_exited)


# TODO: Better way of handling timers. Add to group or something
func bonfire_body_entered(body, bonfire):
	if body.get_script() == Player:
		if bonfire.state_machine.current_state.name == 'on':
			red_slime_timer.stop()
			green_slime_timer.stop()
	
	
func bonfire_body_exited(body):
	if body.get_script() == Player:
		red_slime_timer.start()
		green_slime_timer.start()
		
		
func spawn_red_slime():
	var mob = preload('res://scenes/enemy/enemies/red_slime/red_slime.tscn')
	if ENEMIES_COUNT < MAX_ENEMIES:
		spawn_mob(mob)
	
func spawn_green_slime():
	var mob = preload('res://scenes/enemy/enemies/green_slime/green_slime.tscn')
	if ENEMIES_COUNT < MAX_ENEMIES:
		spawn_mob(mob)

#func _process(_delta):
	#if Input.is_action_just_pressed("rightclick"):
		##spawn_enemy(calculate_random_position_at_range(150))
		#spawn_mob()
		
#func spawn_enemy(spawn_global_position):
	#var enemy_type = rng.randi_range(0, 1)
	#var enemy = enemy_scenes[enemy_type].instantiate()
	#enemy.global_position = player.global_position + spawn_global_position
	##enemy.get_node('StateMachine/death').enemy_slain.connect(on_enemy_killed)
	#add_child(enemy)
	
func spawn_mob(mob):
	#var enemy_type = rng.randi_range(0, 1)
	#var enemy = enemy_scenes[enemy_type].instantiate()
	ENEMIES_COUNT += 1
	var mob_instance = mob.instantiate()
	player.path_follow.progress_ratio = randf()
	mob_instance.global_position = player.path_follow.global_position
	add_child(mob_instance)
	mob_instance.add_to_group("Enemies")
	
# TODO: Not being used. Move to utility or something
func calculate_random_position_at_range(range_magnitude):
	var direction = rng.randf_range(0.0, 6.283)
	var x = range_magnitude * cos(direction)
	var y = range_magnitude * sin(direction)
	return Vector2(x, y)
			
