extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	print('open now')
	animation_tree.get("parameters/playback").travel('open')
	#animation_tree.set("parameters/open/BlendSpace2D/blend_position", Vector2(0.0, 1.0))
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
