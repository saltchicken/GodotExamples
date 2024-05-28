extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").travel('idle')
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.idle_direction)
	
func Exit():
	character_body.idle_direction = character_body.direction_to_player
	
func Update(_delta:float):
	if character_body.distance_to_player < character_body.CHASE_DISTANCE:
		state_transition.emit(self, 'chase')
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, character_body.DECELERATION_SPEED)
		character_body.velocity.y = move_toward(character_body.velocity.y, 0, character_body.DECELERATION_SPEED)
