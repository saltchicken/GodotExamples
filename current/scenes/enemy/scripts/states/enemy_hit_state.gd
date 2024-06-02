extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").start('hit')
	animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
	character_body.velocity = -character_body.direction_to_player * (100.0 / character_body.stats.knockback_protection)
	
func Exit():
	pass
	
func Update(_delta:float):
	#print('still hit')
	# TODO: Implement taking damage
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'hit':
		state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle
