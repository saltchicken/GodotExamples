extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../Animation/AnimationTree"
@onready var attack_hitbox = $"../../AttackArea"
@onready var use_area_collision = $"../../UseArea/CollisionShape2D"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	animation_tree.set("parameters/" + self.name + "/BlendSpace2D/blend_position", character_body.direction)
	use_area_collision.disabled = true
	
func Exit():
	use_area_collision.disabled = false
	
func Update(_delta:float):
	#character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	#character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	#character_body.velocity = Vector2(0.0, 0.0)
	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.has_method('get_hit') and body != character_body:
			#if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				if body.get_hit(character_body):
					print('TODO: Can add functionality for when player successfully hits')

func _on_animation_tree_animation_finished(anim_name):
	if anim_name in [self.name + "_left", self.name + "_right", self.name + "_up", self.name + "_down"]:
		handle_movement_state(self, character_body)
