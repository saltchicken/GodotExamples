extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").travel('walk')
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.get_direction()
	character_body.handle_use_hitbox_direction()
	
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position", character_body.direction)
	if character_body.attack:
		state_transition.emit(self, 'attack')
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			character_body.velocity.x = character_body.movement.x * character_body.stats.walk_speed
			character_body.velocity.y = character_body.movement.y * character_body.stats.walk_speed
	else:
		state_transition.emit(self, 'idle')
	if character_body.use:
		character_body.use_objects()
