extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../CollisionAttackArea"
@onready var attack_collision = $"../../CollisionAttackArea/CollisionShape2D"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").start('collision_attack')
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	pass
	
func Update(_delta:float):	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			#if body.get_script() == Player:
			if body.has_method('get_hit') and body != character_body and !body.is_in_group('Enemies'): # TODO: Add additional logic for destroying structures
				body.get_hit(character_body) 

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'collision_attack':
		state_transition.emit(self, 'idle')
