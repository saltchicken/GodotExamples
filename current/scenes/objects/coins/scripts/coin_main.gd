class_name Coins
extends Node

var rng = RandomNumberGenerator.new()
@onready var value
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('Creating coin')
	var choice = weighted_random()
	match choice:
		0:
			get_node('Sprite2D').frame_coords = Vector2i(0,0)
			value = 5
		1:
			get_node('Sprite2D').frame_coords = Vector2i(1,0)
			value = 10
		2:
			get_node('Sprite2D').frame_coords = Vector2i(2,0)
			value = 20
		_:
			print('ERROR: not implemented')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func collected():
	queue_free()
	
func weighted_random():
	var weights = [75, 20, 5]
	var sum_of_weight = 0
	for choice in range(weights.size()):
		sum_of_weight += weights[choice]
	var random_choice = rng.randi_range(0, sum_of_weight)
	for choice in range(weights.size()):
		if random_choice < weights[choice]:
			return choice
		random_choice -= weights[choice]
	print('something bad happend')
	
