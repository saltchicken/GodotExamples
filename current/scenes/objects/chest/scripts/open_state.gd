extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	print('open now')
	animation_tree.get("parameters/playback").travel('open')
	if character_body.item:
		character_body.player.inventory._collect_item(character_body.item.resource_path)
	else:
		print('no item')
	#animation_tree.set("parameters/open/BlendSpace2D/blend_position", Vector2(0.0, 1.0))
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
