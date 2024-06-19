extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
#@onready var attack_hitbox = $"../../CollisionAttackArea"
@onready var close_attack_hitbox = $"../../CloseAttackArea"
@onready var player_exists: bool = false
@onready var player_exists_duration: float = 0.0

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(delta:float):
	#handle_attack_hitbox_direction()
	handle_close_attack_hitbox_direction()
	check_close_attack_range(delta)
	#check_attack_range()
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction_to_player)
	if character_body.distance_to_player < character_body.stats.chase_distance:
		if abs(character_body.impact_velocity.x) > 0.0 and abs(character_body.impact_velocity.y) > 0.0:
			character_body.impact_velocity.x = move_toward(character_body.impact_velocity.x, 0.0, 5.0)
			character_body.impact_velocity.y = move_toward(character_body.impact_velocity.y, 0.0, 5.0)
			character_body.velocity.x = character_body.impact_velocity.x
			character_body.velocity.y = character_body.impact_velocity.y
		else:
			character_body.velocity.x = character_body.direction_to_player.x * character_body.stats.chase_speed
			character_body.velocity.y = character_body.direction_to_player.y * character_body.stats.chase_speed
			if character_body.impact_velocity_initiating_body != null:
				for body in character_body.get_collision_exceptions():
					if body == character_body.impact_velocity_initiating_body:
						character_body.remove_collision_exception_with(character_body.impact_velocity_initiating_body)
						character_body.impact_velocity_initiating_body = null
						print('Removing collision exception')
				
				
	else:
		state_transition.emit(self, 'idle')
		
	character_body.handle_collision()
		
#func handle_attack_hitbox_direction():
	#attack_hitbox.position = character_body.direction_to_player * character_body.stats.attack_reach
	
func handle_close_attack_hitbox_direction():
	close_attack_hitbox.position = character_body.direction_to_player * character_body.stats.attack_reach
	
func check_close_attack_range(delta):
	var bodies = close_attack_hitbox.get_overlapping_bodies()
	player_exists = false
	if bodies:
		for obj in bodies:
			if obj.get_script() == Player:
				player_exists = true
	if player_exists and (abs(character_body.impact_velocity.x) <= 1.0 and abs(character_body.impact_velocity.y) <= 1.0): # TODO: Better check for when enemy has impact velocity and remove magic number of 1.0
		player_exists_duration += delta
	else:
		player_exists_duration = 0.0
	if player_exists_duration > 1.0:
		player_exists_duration = 0.0
		state_transition.emit(self, 'close_attack')
				
				
	
#func check_attack_range():
	#var bodies = attack_hitbox.get_overlapping_bodies()
	#if bodies:
		##var closest_body = bodies.front() # TODO: Only interested in closest object?
		#for obj in bodies:
			##print(obj)
			#if obj.get_script() == Player:
				#if obj.state_machine.current_state.name != 'hit' and obj.state_machine.current_state.name != 'death':
					#state_transition.emit(self, 'collision_attack')
