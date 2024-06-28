extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

@onready var temp_state_name = "chase" # TODO: Make an animation for run

func Enter():
	animation_tree.get("parameters/playback").travel(temp_state_name)
	if character_body.direction_to_player == null:
		print("Error: direction_to_player was null")
	else:
		animation_tree.set("parameters/" + temp_state_name + "/BlendSpace2D/blend_position", -character_body.direction_to_player)
	
	#var visible_on_screen_notifier_2d = VisibleOnScreenEnabler2D.new()
	#character_body.add_child(visible_on_screen_notifier_2d)
	character_body.get_node('VisibleOnScreenNotifier2D').screen_exited.connect(character_body.despawn.bind(0.0))
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(delta:float):
	animation_tree.set("parameters/" + temp_state_name + "/BlendSpace2D/blend_position", -character_body.direction_to_player)
	character_body.velocity.x = -character_body.direction_to_player.x * character_body.stats.chase_speed * 2
	character_body.velocity.y = -character_body.direction_to_player.y * character_body.stats.chase_speed * 2
	#if character_body.impact_velocity_initiating_body != null:
		#for body in character_body.get_collision_exceptions():
			## TODO: May be necessary for having multiple initiating bodies
			#if body == character_body.impact_velocity_initiating_body:
				#character_body.remove_collision_exception_with(character_body.impact_velocity_initiating_body)
				#character_body.impact_velocity_initiating_body = null
				#print('Removing collision exception')
	#character_body.handle_collision()
		
