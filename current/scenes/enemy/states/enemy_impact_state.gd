extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var close_attack_hitbox = $"../../CloseAttackArea"

var temp_state_name = "chase" # TODO: Make an animation for impact_state

func Enter():
	animation_tree.get("parameters/playback").travel(temp_state_name)
	animation_tree.set("parameters/" + temp_state_name + "/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(delta:float):
	animation_tree.set("parameters/" + temp_state_name + "/BlendSpace2D/blend_position", character_body.direction_to_player)
	if abs(character_body.impact_velocity.x) > 0.0 and abs(character_body.impact_velocity.y) > 0.0:
		character_body.impact_velocity.x = move_toward(character_body.impact_velocity.x, 0.0, 5.0)
		character_body.impact_velocity.y = move_toward(character_body.impact_velocity.y, 0.0, 5.0)
		character_body.velocity.x = character_body.impact_velocity.x
		character_body.velocity.y = character_body.impact_velocity.y
	else:
		if character_body.impact_velocity_initiating_body != null:
			print('Removing collision exception')
			character_body.remove_collision_exception_with(character_body.impact_velocity_initiating_body)
			character_body.impact_velocity_initiating_body = null
			state_transition.emit(self, 'idle')
