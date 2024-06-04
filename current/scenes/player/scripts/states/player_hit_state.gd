extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter(params: Dictionary = {}):
	#print('Player has been hit. Health remaining: ' + str(character_body.stats.health)) # TODO: Implement way of monitoring health
	if params.has('attacking_body'):
		var attacking_body = params['attacking_body']
		var damage = attacking_body.attack_damage
		var knockback = attacking_body.attack_knockback
		Global.hit_indicator(self, str(damage), 3.0, 20.0)
		character_body.health -= damage
		if character_body.health <= 0:
			character_body.health = 0
			state_transition.emit(character_body.state_machine.current_state, 'death')
			return
		else:
			animation_tree.get("parameters/playback").start('hit')
			#animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
			var direction_from_enemy = attacking_body.direction_to_player
			character_body.velocity = direction_from_enemy * (knockback / character_body.knockback_protection)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, 5.0)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, 5.0)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'hit':
		state_transition.emit(self, 'idle')
