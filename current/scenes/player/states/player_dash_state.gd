extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../Animation/AnimationTree"
#@onready var animation_player = $"../../AnimationPlayer"
#@onready var use_area_collision = $"../../UseArea/CollisionShape2D"

var dash_direction

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction)
	
	dash_direction = character_body.movement
	character_body.dash_cooldown = 1.0
	# TODO: Possibly disable use_area_collision
	
func Exit():
	pass
	
func Update(_delta:float):
	#character_body.velocity = character_body.movement * character_body.stats.dash_speed
	character_body.velocity = dash_direction * character_body.stats.dash_speed
	#character_body.get_direction()
	#character_body.handle_use_hitbox_direction()
	
	#animation_tree.set("parameters/run/BlendSpace2D/blend_position", character_body.direction)
	action_from_input(self, character_body)
		
func _on_animation_tree_animation_finished(anim_name):
	if anim_name in [self.name + "_left", self.name + "_right", self.name + "_up", self.name + "_down"]:
		print('dash complete')
		handle_movement_state(self, character_body)
