extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

@onready var coins_node = preload("res://scenes/objects/coins/coins.tscn")

@onready var death_animation_finished = false

func Enter():
	animation_tree.get("parameters/playback").travel('death')
	animation_tree.set("parameters/death/BlendSpace2D/blend_position", character_body.direction_to_player)
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	# TODO: Why is death getting called multiple times
	if anim_name == 'death' and !death_animation_finished:
		death_animation_finished = true
		drop_coins()
		character_body.queue_free()
		
func drop_coins():
	var coins = coins_node.instantiate()
	coins.position = character_body.position
	get_tree().current_scene.add_child(coins)
	print('making coins')
