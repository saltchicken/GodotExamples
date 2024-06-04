extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter(params: Dictionary = {}):
	if params.has('attacking_body'):
		var attacking_body = params['attacking_body']
		var damage = attacking_body.attack_damage
		var knockback = attacking_body.attack_knockback
		Global.hit_indicator(self, str(damage), 0.0, 5.0)
		character_body.health -= damage
		if character_body.health <= 0:
			character_body.health = 0
			state_transition.emit(character_body.state_machine.current_state, 'death')
			return
		else:
			animation_tree.get("parameters/playback").start('hit')
			#animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
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
