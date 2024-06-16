extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var use_area_collision = $"../../UseArea/CollisionShape2D"

func Enter():
	animation_tree.get("parameters/playback").travel('run')
	animation_tree.set("parameters/run/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.get_direction()
	character_body.handle_use_hitbox_direction()
	
	animation_tree.set("parameters/run/BlendSpace2D/blend_position", character_body.direction)
	action_from_input(self, character_body)
	handle_movement(self, character_body)
		
func state_movement():
	character_body.velocity.x = character_body.movement.x * character_body.stats.run_speed
	character_body.velocity.y = character_body.movement.y * character_body.stats.run_speed
	
