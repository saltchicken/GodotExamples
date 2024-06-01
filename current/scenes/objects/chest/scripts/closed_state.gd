extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	print('Chest is in closed state')
	animation_tree.get("parameters/playback").travel('closed')	
	#animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
