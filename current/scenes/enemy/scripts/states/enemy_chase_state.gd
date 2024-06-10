extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../CollisionAttackArea"

func Enter():
	animation_tree.get("parameters/playback").travel('chase')
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(_delta:float):
	#handle_attack_hitbox_direction()
	check_attack_range()
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	if character_body.distance_to_player < character_body.stats.chase_distance:
		character_body.velocity.x = character_body.direction_to_player.x * character_body.stats.chase_speed
		character_body.velocity.y = character_body.direction_to_player.y * character_body.stats.chase_speed
	else:
		state_transition.emit(self, 'idle')
		
#func handle_attack_hitbox_direction():
	#attack_hitbox.position = character_body.direction_to_player * character_body.stats.attack_reach
	
func check_attack_range():
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		#var closest_body = bodies.front() # TODO: Only interested in closest object?
		for obj in bodies:
			#print(obj)
			if obj.get_script() == Player:
				if obj.state_machine.current_state.name != 'hit' and obj.state_machine.current_state.name != 'death':
					state_transition.emit(self, 'collision_attack')
