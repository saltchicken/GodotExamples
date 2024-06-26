extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").travel('opening')
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'opening':
		if character_body.item and !character_body.item_taken:
			Global.dialogue(self, [character_body.item.name])
			character_body.player.inventory.collect_item(character_body.item.resource_path)
			character_body.item_taken = true
		else:
			
			print('no item')
		state_transition.emit(self, 'open')
