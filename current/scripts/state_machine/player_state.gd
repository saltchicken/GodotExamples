extends State
class_name PlayerState

func state_movement():
	pass

func action_from_input(calling_node, character_body): # TODO: Probably shouldn't store this in the state class
	if character_body.cast:
		state_transition.emit(calling_node, 'cast')
	if character_body.attack:
		var current_weapon = character_body.inventory.current_weapon
		if current_weapon:
			var attack_type = current_weapon.AttackType.keys()[current_weapon.attack_type]
			if attack_type == 'SWORD':
				state_transition.emit(calling_node, 'sword_attack')
			elif attack_type == 'BOW':
				state_transition.emit(calling_node, 'bow_attack')
			else:
				print('Error with calling the proper attack function for %s' % attack_type)
		else:
			print('Player does not have a weapon equipped')
			
		
	if character_body.use:
		character_body.use_objects()
		
func handle_movement_state(calling_node, character_body):
	match calling_node.name:
		'idle':
			if character_body.movement:
				if character_body.walk:
					state_transition.emit(calling_node, 'walk')
				else:
					state_transition.emit(calling_node, 'run')
			else:
				calling_node.state_movement()
		'walk':
			if character_body.movement:
				if character_body.walk:
					calling_node.state_movement()
				else:
					state_transition.emit(calling_node, 'run')
			else:
				state_transition.emit(calling_node, 'idle')
		'run':
			if character_body.dash and character_body.dash_cooldown <= 0.0:
				state_transition.emit(calling_node, 'dash')
			if character_body.movement:
				if character_body.walk:
					state_transition.emit(calling_node, 'walk')
				else:
					calling_node.state_movement()
			else:
				state_transition.emit(calling_node, 'idle')
		_:
			if character_body.movement:
				if character_body.walk:
					state_transition.emit(calling_node, 'walk')
				else:
					state_transition.emit(calling_node, 'run')
			else:
				state_transition.emit(calling_node, 'idle')
