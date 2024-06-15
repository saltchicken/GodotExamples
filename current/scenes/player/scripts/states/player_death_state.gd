extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel('death')
	#animation_tree.set("parameters/death/BlendSpace2D/blend_position", character_body.direction_to_player) # TODO: Direction of death to be implemented here and in AnimationTree
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name in ["death_left", "death_right", "death_up", "death_down"]:
		print('Handle death properly. If use queue_free then enemy calculations error')
		#character_body.queue_free()
