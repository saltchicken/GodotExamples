extends Node

@export var Player: PackedScene
@export var Enemy: PackedScene

var rng = RandomNumberGenerator.new()

const SPAWN_MIN = -500
const SPAWN_MAX = 500

const PLAYER_SPAWN_POSITION = Vector2(0, 0)

const MAX_NUMBER_OF_ENEMIES = 5

func _ready():
	var player = Player.instantiate()
	get_tree().current_scene.add_child(player)
	
	for i in MAX_NUMBER_OF_ENEMIES:
		var new_enemy = Enemy.instantiate()
		get_tree().current_scene.add_child(new_enemy)
		var position_x = rng.randi_range(SPAWN_MIN, SPAWN_MAX)
		var position_y = rng.randi_range(SPAWN_MIN, SPAWN_MAX)
		new_enemy.position = Vector2(position_x, position_y)
