extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../CollisionAttackArea"
@onready var close_attack_hitbox = $"../../CloseAttackArea"

@onready var close_attack_duration: float = 0.0
@onready var close_attack_direction

func Enter():
	print('close attack')
	animation_tree.get("parameters/playback").travel('chase') # TODO Make a state for close_attack
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	close_attack_duration = 0.0
	close_attack_direction = character_body.direction_to_player
	print(close_attack_direction)
	
	#character_body.velocity.x = character_body.direction_to_player.x * 10000
	#character_body.velocity.y = character_body.direction_to_player.y * 10000
	
func Exit():
	print('leaving close attack')
	character_body.idle_direction = character_body.direction_to_player
	
func Update(delta:float):
	if close_attack_duration < 0.5:
		close_attack_duration += delta
		print('speed')
		character_body.velocity.x = close_attack_direction.x * 150
		character_body.velocity.y = close_attack_direction.y * 150
		
		# # This will add some tracking towards the player
		#character_body.velocity.x = character_body.direction_to_player.x * 150
		#character_body.velocity.y = character_body.direction_to_player.y * 150
	else:
		#state_transition.emit(self, 'idle')
		character_body.velocity.x = move_toward(character_body.velocity.x, 0.0, 2.0)
		character_body.velocity.y = move_toward(character_body.velocity.y, 0.0, 2.0)
		if character_body.velocity.x == 0 and character_body.velocity.y == 0:
			state_transition.emit(self, 'idle')
	#print(character_body.velocity)
	#handle_attack_hitbox_direction()
	#handle_close_attack_hitbox_direction()
	
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	
	character_body.handle_collision_with_player()
	
	
	
	
	#if character_body.velocity <= Vector2(0.25, 0.25):
		#print("why")
		#state_transition.emit(self, 'idle')
		
#func handle_attack_hitbox_direction():
	#attack_hitbox.position = character_body.direction_to_player * character_body.stats.attack_reach
	
func handle_close_attack_hitbox_direction():
	close_attack_hitbox.position = character_body.direction_to_player * character_body.stats.attack_reach
