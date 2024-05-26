extends State

@onready var character_body = self.get_owner()
@onready var attack_hitbox = $"../../AttackArea"

var DECELERATION_SPEED = 25.0

func Enter():
	character_body._attack()
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		#var useable_object = useable_objects.front()
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				if body.hitable:
					#body._hit()
					#body.state_machine.current_state.state_transition.emit(self, 'test')
					#body.hitable = false
					print('Hit ' + body.name)
			#if obj.get_script() == Chest:
				#obj.use()

func _on_animation_player_animation_finished(anim_name):
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'walk')
	else:
		state_transition.emit(self, 'idle')
