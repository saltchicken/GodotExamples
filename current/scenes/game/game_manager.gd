extends Node2D

@export var player_scene: PackedScene
#@export var enemy_scene: PackedScene

@onready var player = player_scene.instantiate()
@onready var enemy_scenes: Array[PackedScene] = [ preload('res://scenes/enemy/enemies/red_slime/red_slime.tscn'),
											preload('res://scenes/enemy/enemies/green_slime/green_slime.tscn') ]

var rng = RandomNumberGenerator.new()

func _ready():
	get_tree().current_scene.add_child(player)

func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		spawn_enemy(calculate_random_position_at_range(150))
		
func spawn_enemy(spawn_global_position):
	var enemy_type = rng.randi_range(0, 1)
	var enemy = enemy_scenes[enemy_type].instantiate()
	enemy.global_position = player.global_position + spawn_global_position
	#enemy.get_node('StateMachine/death').enemy_slain.connect(on_enemy_killed)
	get_tree().current_scene.add_child(enemy)
	
func calculate_random_position_at_range(range_magnitude):
	var direction = rng.randf_range(0.0, 6.283)
	var x = range_magnitude * cos(direction)
	var y = range_magnitude * sin(direction)
	return Vector2(x, y)
	
#func on_enemy_killed(body):
	#print(body)
