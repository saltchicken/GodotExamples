class_name Gameplay extends Node2D

@onready var level_holder: Node2D = $LevelHolder
@onready var hud: Control = $HUD
var current_level:Level

var player: Player

func _ready() -> void:
	print("Gameplay loaded")
	SceneManager.load_complete.connect(_on_level_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_level_added)
	#current_level = level_holder.get_child(0) as Level
	
	load_player()
	
	var game_manager = load("res://scenes/game/game_manager.tscn").instantiate()
	level_holder.add_child(game_manager)
	current_level = level_holder.get_child(0) as Level
	
func load_player() -> void:
	player = preload("res://scenes/player/player.tscn").instantiate()
	add_child(player)

func _on_level_loaded(level) -> void:
	if level is Level:
		current_level = level

func _on_level_added(_level, _loading_screen) -> void:
	if is_instance_valid(_loading_screen):
		var loading_parent: Node = _loading_screen.get_parent() as Node
		loading_parent.move_child(_loading_screen, loading_parent.get_child_count()-1)
	# HUD example
	move_child(hud, get_child_count()-1) # uncomment to keep the HUD above the loading screen (like how it stays put in OG Zelda dungeons)

# shows how we can play with the HUD ordering to customize results, regardless of where SceneManager puts the loading screen
func _on_load_start(_loading_screen):
	pass
	# keep HUD on top of loading screen - uncomment below to keep HUD up top (see above)
#	_loading_screen.reparent(self)
#	move_child(_loading_screen,hud.get_index())
