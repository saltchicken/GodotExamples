extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var game_scene = character_body.get_owner()

func Enter():
	animation_tree.get("parameters/playback").travel('idle')	
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.get_direction()
	character_body.handle_use_hitbox_direction()
	
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", character_body.direction)
	if character_body.cast:
		#state_transtion.emit(self, 'cast') # TODO: Create a cast state
		var current_spell = character_body.current_spell.instantiate()
		current_spell.position = character_body.position
		game_scene.add_child(current_spell)
	if character_body.attack:
		state_transition.emit(self, 'attack')
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'walk')
	else:
		#character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
		#character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
		character_body.velocity = Vector2(0.0, 0.0)
	if character_body.use:
		character_body.use_objects()
