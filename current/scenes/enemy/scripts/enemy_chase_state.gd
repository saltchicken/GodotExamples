extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").travel('chase')
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(_delta:float):
	animation_tree.set("parameters/chase/BlendSpace2D/blend_position", character_body.direction_to_player)
	if character_body.distance_to_player < character_body.CHASE_DISTANCE:
		character_body.velocity.x = character_body.direction_to_player.x * character_body.CHASE_SPEED
		character_body.velocity.y = character_body.direction_to_player.y * character_body.CHASE_SPEED
	else:
		state_transition.emit(self, 'idle')
