extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../Animation/AnimationTree"

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.get_direction()
	character_body.handle_use_hitbox_direction()
	
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction)
	action_from_input(self, character_body) # TODO: Probably shouldn't store this in the state class
	handle_movement_state(self, character_body)
		
		
func state_movement():
	character_body.velocity.x = character_body.movement.x * character_body.stats.walk_speed
	character_body.velocity.y = character_body.movement.y * character_body.stats.walk_speed
	
