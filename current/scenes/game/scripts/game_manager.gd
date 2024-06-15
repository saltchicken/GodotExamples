extends Node2D

@export var Player: PackedScene
@export var Enemy: PackedScene

@onready var player = Player.instantiate()

var rng = RandomNumberGenerator.new()

func _ready():
	get_tree().current_scene.add_child(player)

func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		spawn_enemy(calculate_random_position_at_range(150))
		
func spawn_enemy(global_position):
	var enemy = Enemy.instantiate()
	enemy.global_position = player.global_position + global_position
	get_tree().current_scene.add_child(enemy)
	
func calculate_random_position_at_range(range_magnitude):
	var direction = rng.randf_range(0.0, 6.283)
	var x = range_magnitude * cos(direction)
	var y = range_magnitude * sin(direction)
	return Vector2(x, y)
