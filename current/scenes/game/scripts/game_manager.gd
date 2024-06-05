extends Node

@export var Player: PackedScene
@export var Enemy: PackedScene

@onready var player = Player.instantiate()

var rng = RandomNumberGenerator.new()

@onready var camera = player.get_node('Camera2D')
@onready var timer = get_node('Timer')
#@onready var spawner_node = preload("res://scenes/util/spawner/spawner.tscn")

#const SPAWN_MIN = -100
#const SPAWN_MAX = 100

const PLAYER_SPAWN_POSITION = Vector2(0, 0)

const MAX_NUMBER_OF_ENEMIES = 5

func _ready():
	#var player = Player.instantiate()
	get_tree().current_scene.add_child(player)
	await get_tree().create_timer(2.0).timeout
	timer.start()
	
	#for i in MAX_NUMBER_OF_ENEMIES:
		#var new_enemy = Enemy.instantiate()
		#get_tree().current_scene.add_child(new_enemy)
		#var position_x = rng.randi_range(SPAWN_MIN, SPAWN_MAX)
		#var position_y = rng.randi_range(SPAWN_MIN, SPAWN_MAX)
		#new_enemy.position = Vector2(position_x, position_y)
		
func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		#print(camera.get_target_position())
		print(camera.get_screen_center_position())
		print(get_viewport().get_mouse_position())
		#print(DisplayServer.window_get_size())
		var screen_width = get_viewport().get_visible_rect().size.x
		var screen_height = get_viewport().get_visible_rect().size.y
		var screen_center = Vector2(screen_width / 2, screen_height / 2)
		
		print(get_viewport().get_mouse_position() - screen_center)
		
		print(get_viewport().get_mouse_position() / screen_center)
		
		
		
		#print(get_viewport().get_visible_rect().size.x)
		
		pass
		#var spawner = spawner_node.instantiate()
		#get_tree().current_scene.add_child(spawner)
		
		
		#var enemy_position = Vector2(100.0, 100.0) 
		##Global.check_if_space_occupied(self, enemy_position)
		#Global.spawn_enemy(self, enemy_position)


func _on_timer_timeout():
	var player_position = camera.get_screen_center_position()
	var new_enemy = Enemy.instantiate()
	var position_x = rng.randi_range(50, 200)
	var position_y = rng.randi_range(50, 200)
	var rand_flip_x = rng.randi_range(0, 1) * 2 - 1
	var rand_flip_y = rng.randi_range(0, 1) * 2 - 1
	position_x *= rand_flip_x
	position_y *= rand_flip_y
	position_x += player_position.x
	position_y += player_position.y
	new_enemy.position = Vector2(position_x, position_y)
	get_tree().current_scene.add_child(new_enemy)
	
	
