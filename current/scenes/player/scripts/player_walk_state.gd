extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

var SPEED = 50.0

func Enter():
	animation_tree.get("parameters/playback").travel('walk')
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body._get_direction()
	character_body._handle_use_hitbox_direction()
	
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position", character_body.direction)
	if character_body.attack:
		state_transition.emit(self, 'attack')
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			character_body.velocity.x = character_body.movement.x * SPEED
			character_body.velocity.y = character_body.movement.y * SPEED
	else:
		state_transition.emit(self, 'idle')
	if character_body.use:
		character_body._use_objects()
