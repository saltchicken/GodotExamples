extends Node
class_name State

signal state_transition

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func take_damage_check_death(receiving_body, attacking_body):
	var damage = attacking_body.stats.attack_damage
	Global.hit_indicator(self, str(damage), receiving_body.hit_indicator_offset.x, receiving_body.hit_indicator_offset.y)
	receiving_body.stats.health -= damage
	if receiving_body.stats.health <= 0:
		receiving_body.stats.health = 0
		return true
	else:
		return false
		
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
		
func handle_movement_transition(calling_node, character_body):
	match calling_node.name:
		'idle':
			if character_body.movement:
				if character_body.walk:
					state_transition.emit(calling_node, 'walk')
				else:
					state_transition.emit(calling_node, 'run')
			else:
				return true
		'walk':
			if character_body.movement:
				if character_body.walk:
					return true
				else:
					state_transition.emit(calling_node, 'run')
			else:
				state_transition.emit(calling_node, 'idle')
		'run':
			if character_body.dash:
				state_transition.emit(calling_node, 'dash')
			if character_body.movement:
				if character_body.walk:
					state_transition.emit(calling_node, 'walk')
				else:
					return true
			else:
				state_transition.emit(calling_node, 'idle')
		_:
			print('Error: Movement transition not handled')
