extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@onready var coins_node = preload("res://scenes/objects/coins/coins.tscn")


#signal enemy_slain


func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel('death')
	animation_tree.set("parameters/death/BlendSpace2D/blend_position", character_body.direction_to_player)
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	#enemy_slain.emit(character_body)
	player.killed_enemy(character_body)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'death':
		drop_coins()
		character_body.queue_free()
		
func drop_coins():
	var coins = coins_node.instantiate()
	coins.position = character_body.position
	character_body.get_parent().add_child(coins)
