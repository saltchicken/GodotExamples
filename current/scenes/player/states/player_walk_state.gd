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
	if handle_movement_remain_in_state(self, character_body):
		character_body.velocity.x = character_body.movement.x * character_body.stats.walk_speed
		character_body.velocity.y = character_body.movement.y * character_body.stats.walk_speed
	
