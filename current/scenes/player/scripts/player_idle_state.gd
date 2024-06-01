extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"


var DECELERATION_SPEED = 25.0

func Enter():
	#character_body._idle()
	animation_tree.get("parameters/playback").travel('idle')	
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.get_direction()
	character_body.handle_use_hitbox_direction()
	
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.direction)
	if character_body.attack:
		state_transition.emit(self, 'attack')
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'walk')
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
		character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	if character_body.use:
		character_body.use_objects()
