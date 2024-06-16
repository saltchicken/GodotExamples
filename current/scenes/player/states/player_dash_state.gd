extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
#@onready var use_area_collision = $"../../UseArea/CollisionShape2D"

@onready var dash_speed = 200

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel('dash')
	animation_tree.set("parameters/dash/BlendSpace2D/blend_position", character_body.direction)
	character_body.dash_cooldown = 1.0
	# TODO: Possibly disable use_area_collision
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity = character_body.movement * dash_speed
	#character_body.get_direction()
	#character_body.handle_use_hitbox_direction()
	
	#animation_tree.set("parameters/run/BlendSpace2D/blend_position", character_body.direction)
	action_from_input(self, character_body)
	#if character_body.movement:
		#if !character_body.run:
			#state_transition.emit(self, 'walk')
		#else:
			#character_body.velocity.x = character_body.movement.x * character_body.stats.run_speed
			#character_body.velocity.y = character_body.movement.y * character_body.stats.run_speed
	#else:
		#state_transition.emit(self, 'idle')
		
func _on_animation_tree_animation_finished(anim_name):
	if anim_name in ["dash_left", "dash_right", "dash_up", "dash_down"]:
		state_transition.emit(self, 'idle')
