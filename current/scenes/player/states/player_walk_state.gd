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
	action_from_input(self, character_body) # TODO: Probably shouldn't store this in the state class
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			if character_body.dodge and character_body.dodge_cooldown <= 0.0:
				state_transition.emit(self, 'dodge')
				character_body.dodge_cooldown = 1.0
			else:
				character_body.velocity.x = character_body.movement.x * character_body.stats.walk_speed
				character_body.velocity.y = character_body.movement.y * character_body.stats.walk_speed
	else:
		state_transition.emit(self, 'idle')
	
