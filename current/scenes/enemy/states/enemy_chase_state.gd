extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../CollisionAttackArea"
@onready var close_attack_hitbox = $"../../CloseAttackArea"
@onready var player_exists: bool = false
@onready var player_exists_duration: float = 0.0

func Enter():
	animation_tree.get("parameters/playback").travel('chase')
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(delta:float):
	#handle_attack_hitbox_direction()
	handle_close_attack_hitbox_direction()
	check_close_attack_range(delta)
	check_attack_range()
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	if character_body.distance_to_player < character_body.stats.chase_distance:
		character_body.velocity.x = character_body.direction_to_player.x * character_body.stats.chase_speed
		character_body.velocity.y = character_body.direction_to_player.y * character_body.stats.chase_speed
	else:
		state_transition.emit(self, 'idle')
		
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
	if player_exists:
		player_exists_duration += delta
	else:
		player_exists_duration = 0.0
	if player_exists_duration > 1.0:
		player_exists_duration = 0.0
		state_transition.emit(self, 'close_attack')
				
				
	
func check_attack_range():
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		#var closest_body = bodies.front() # TODO: Only interested in closest object?
		for obj in bodies:
			#print(obj)
			if obj.get_script() == Player:
				if obj.state_machine.current_state.name != 'hit' and obj.state_machine.current_state.name != 'death':
					state_transition.emit(self, 'collision_attack')
