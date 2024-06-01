extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	#print('opening now')
	animation_tree.get("parameters/playback").travel('opening')
	if character_body.item and !character_body.item_taken:
		character_body.player.inventory._collect_item(character_body.item.resource_path)
		character_body.item_taken = true
	else:
		print('no item')
		
		

	#animation_tree.set("parameters/open/BlendSpace2D/blend_position", Vector2(0.0, 1.0)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'opening':
		state_transition.emit(self, 'open')
