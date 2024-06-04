extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter(params: Dictionary = {}):
	if params.has('attacking_body'):
		if take_damage_check_death(character_body, params['attacking_body']):
			state_transition.emit(character_body.state_machine.current_state, 'death')
			return
		else:
			animation_tree.get("parameters/playback").start('hit')
			#animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
			var knockback = params['attacking_body'].attack_knockback
			character_body.velocity = -character_body.direction_to_player * (knockback / character_body.knockback_protection)
	else:
		print("Hit shouldn't be called without an attacking body")
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'hit':
		state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle
