class_name Coins
extends Node

@onready var value
var Random = RANDOM.new()

func _ready() -> void:
	var choice = Random.weighted_random()
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


func _process(_delta: float) -> void:
	pass
	
func collected():
	queue_free()
	

	
